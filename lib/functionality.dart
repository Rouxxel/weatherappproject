import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:http/http.dart' as http; //For http resources
import 'package:url_launcher/url_launcher.dart'; //To launch URLs
import 'package:icons_flutter/icons_flutter.dart'; //For icon import
import 'dart:convert' as conv; //For JSON parsing
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:intl/intl.dart'; //For data formatting import
import 'package:flutter_dotenv/flutter_dotenv.dart'; //To access API key .env

//GPS information (controller variable)
bool _gps_access = false;

//API key and other variables
String _OWeather_api_key = use_api_key();

//To get API data with city name Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&exclude=minutely,alerts&appid=$apikey)'
//To get API data with latitude and longitude Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apikey)'

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//GPS related
//Request GPS permission and get it if given (MUST BE EXECUTED FIRST)
void get_gps_permissions(BuildContext context) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------get_gps_permission function executed------]");

  //Check if device has location active and prevent execution if disabled
  bool location_service_active = await Geolocator.isLocationServiceEnabled();
  if (!location_service_active) {
    //Show user their location is disabled
    show_location_disable(context);
    _gps_access=false;

    print("Error: Location-GPS function is disabled in the device");
    return Future.error("Location service is disabled");
  }

  //Permission variable
  LocationPermission permission = await Geolocator.checkPermission();

  //Ask the user for permission if currently denied
  if(permission == LocationPermission.denied || permission==LocationPermission.deniedForever){
    show_gps_access_necessary(context);
    permission = await Geolocator.requestPermission();

    //Handle several possible scenarios after permission asked
    switch(permission){
      case LocationPermission.unableToDetermine:
        //Handle when permission status couldn't be determined
        print("Unable to determine GPS permission status");
        show_gps_unable_to_determine(context);
        _gps_access=false;
        return Future.error("Unable to determine GPS permission status");

      case LocationPermission.denied:
        //Handle denied permission
        print("GPS Permission denied");
        show_gps_access_denied(context);
        _gps_access=false;
        return Future.error("GPS permissions denied");

      case LocationPermission.deniedForever:
        //Handle permanently denied permission
        print("GPS Permission denied permanently");
        show_gps_access_denied(context);
        _gps_access=false;
        return Future.error("GPS permissions permanently denied");

      case LocationPermission.always:
      case LocationPermission.whileInUse:
        print("GPS Permission granted");
        _gps_access = true;
        break;
    }
  }
}

//Function to get GPS location and return as a list
//MUST BE CALLED AFTER get_gps_permission
Future<List<double>> get_gps_location(BuildContext context) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------get_gps_location function executed------]");
  //Create empty list for latitude and longitude
  List<double> c_coordinates = [];

  try {
    //Get the current position with low accuracy
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    //Assign the latitude and longitude to the list
    c_coordinates = [position.latitude, position.longitude];

    print("Latitude and Longitude from get_gps_location: $c_coordinates");
    //Return the list of coordinates
    return c_coordinates;

  } catch (er) {
    //Handle error situation
    show_generic_error(context);
    print("Error getting location: $er");
    return c_coordinates;
  }
}

/////////////////////////////////////////////////////////////////////////////

//API and data extraction
//Get current weather data by either latitude and longitude or city name, 2 calls
Future<Map<String, dynamic>> get_current_weather_datas({
  required BuildContext context,
  String? city_name, List<double>? lat_lon,}) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------get_current_weather_data function executed------]");

  //Determine the type of request
  String url="";

  //Both or neither
  if (city_name != null && lat_lon != null) {
    //Both city_name and lat_lon are provided, throw an error
    show_location_not_found(context); //Show the error to the user
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  } else if (city_name == null && lat_lon == null){
    //Neither city_name or lat_lon are provided, throw an error
    show_location_not_found(context); //Show the error to the user
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  }

  //Latitude and longitude URL or with city name
  if (lat_lon != null) {
    //Use latitude and longitude to build the URL
    url ='https://api.openweathermap.org/data/2.5/weather?lat=${lat_lon[0]}'
        '&lon=${lat_lon[1]}&exclude=minutely&appid=$_OWeather_api_key';
  } else if (city_name != null) {
    //Check city_name is valid (at least is not empty)
    if (city_name.isEmpty){
      show_no_city_or_postalcode_provided(context);
      throw Exception("--------User has entered an invalid city name--------");
    } else{
      //Use city_name to build the URL
      url ='https://api.openweathermap.org/data/2.5/weather?q=$city_name'
          '&exclude=minutely&appid=$_OWeather_api_key';
    }
  }

  //Map to store the extracted weather data
  Map<String, dynamic> current_weather_data = {};

  //Try to obtain API call from URL
  try {
    //Make API call
    final response = url.isEmpty ?
      throw Exception("URL cannot be Empty")
      : await http.get(Uri.parse(url));

    //Check response success
    if (response.statusCode == 200) {
      //Parse response if response is successful
      Map<String, dynamic> API_data = conv.jsonDecode(response.body);

      //Validate API response (sanitize)
      if (!validate_current_weather_data(API_data)) {

        //Handle if API response is weird
        show_api_error(context);
        print("---API response is invalid, Stopping---");
        throw Exception('Invalid API response structure');
      }
      print("---API response is valid, proceeding---");

      //

      //Extract coordinates in case the input used is city name
      //Extract longitude and latitude
      List<double> coord = [API_data['coord']['lat'], API_data['coord']['lon']];

      //Extract icon code
      String icon_str = API_data['weather'][0]['icon'];

      //Extract timezone
      //Convert the time stamp API_data['dt'] to a DateTime object
      DateTime utc_time = DateTime.fromMillisecondsSinceEpoch(API_data['dt'] * 1000, isUtc: true);
      //Apply the timezone offset API_data['timezone'] to get the local time
      DateTime local_time = utc_time.add(Duration(seconds: API_data['timezone']));
      //Format the local time to a readable string
      String format_local_time = DateFormat('EEEE d, MMMM HH:mm').format(local_time);

      //Extract city and country
      String current_city_name = API_data['name'];
      String current_country_code = API_data['sys']['country'];

      //Extract and store CURRENT weather data
      //Current Temperature
      double Ktemp = (API_data['main']['temp'] as num).toDouble();

      //Feels like temperature
      double Kfeels = (API_data['main']['feels_like'] as num).toDouble();

      //Extract and convert temp_min and temp_max
      double Ktemp_min = (API_data['main']['temp_min'] as num).toDouble();
      double Ktemp_max = (API_data['main']['temp_max'] as num).toDouble();

      //Weather condition
      String W_condition = API_data['weather'][0]['description'];
      double HPA_pressure = (API_data['main']['pressure'] as num).toDouble();
      int cloud_coverage =
        API_data.containsKey('clouds') ? API_data['clouds']['all'] : 0;

      //Possible alerts, requires a different URL than the 2 before and a new API call
      String event="No alerts today!!!";

      if (lat_lon != null) { //If latitud and longitud are provided
        ////////---------------------------------------------------------------
        final alert_URL = Uri.parse(
            'https://api.openweathermap.org/data/3.0/onecall?lat=${lat_lon[0]}&lon=${lat_lon[1]}'
                '&exclude=current,minutely,hourly,daily&lang=en&appid=$_OWeather_api_key');
        try { //Same treatment as first call
          final alert_response = await http.get(alert_URL);
          if (alert_response.statusCode == 200) {
            final alert_data = conv.jsonDecode(alert_response.body);
            //Remove latitude and longitude
            alert_data.remove('lat');
            alert_data.remove('lon');

            //Validate second API response
            if (!validate_current_weather_alerts(alert_data)){
              //Handle if API second response is weird
              print("---Second API response is invalid, Stopping---");
              show_api_error(context);
              throw Exception('Invalid weather alerts data');
            }
            print("---Second API response is valid, proceeding---");

            if (alert_data['alerts'] != null && (alert_data['alerts'] as List).isNotEmpty) {
              event = alert_data['alerts'][0]['event'];
            }
          } else {
            show_api_error(context);
            throw Exception('Failed to load weather alerts');
          }
        } catch (er) {
          show_generic_error(context);
          print('Error fetching alerts: $er');
        }
        ////////---------------------------------------------------------------
      } else if (city_name != null && city_name.isNotEmpty) { //If city name is provided
        ////////---------------------------------------------------------------
        final alert_URL = Uri.parse(
            'https://api.openweathermap.org/data/3.0/onecall?lat=${coord[0]}&lon=${coord[1]}'
                '&exclude=current,minutely,hourly,daily&lang=en&appid=$_OWeather_api_key');
        try {
          final alert_response = await http.get(alert_URL);
          if (alert_response.statusCode == 200) {
            final alert_data = conv.jsonDecode(alert_response.body);
            //Remove latitude and longitude
            alert_data.remove('lat');
            alert_data.remove('lon');

            //Validate second API response
            if (!validate_current_weather_alerts(alert_data)){
              //Handle if API second response is weird
              print("---Second API response is invalid, Stopping---");
              show_api_error(context);
              throw Exception('Invalid weather alerts data');
            }
            print("---Second API response is valid, proceeding---");

            if (alert_data['alerts'] != null && (alert_data['alerts'] as List).isNotEmpty) {
              event = alert_data['alerts'][0]['event'];
            }
          } else {
            show_api_error(context);
            throw Exception('Failed to load weather alerts');
          }
        } catch (er) {
          show_generic_error(context);
          print('Error fetching alerts: $er');
        }
        ////////---------------------------------------------------------------
      }


      //Wind information
      double MPH_windspeed = (API_data['wind']['speed'] as num).toDouble();
      double wind_gust_MPH = API_data['wind'].containsKey('gust') ?
        (API_data['wind']['gust'] as num).toDouble() : 0.0;
      int wind_direction = API_data['wind']['deg'];

      //Water related things
      int humidity = API_data['main']['humidity'];

      //Precipitation
      double MM_precipitation = 0.0;
      //Check if there's precipitation data
      if (API_data.containsKey('rain') && API_data['rain'].containsKey('1h')) {
        MM_precipitation = MM_precipitation + (API_data['rain']['1h'] as num).toDouble();
      }
      //Check if there's snow data and add it to precipitation
      if (API_data.containsKey('snow') && API_data['snow'].containsKey('1h')) {
        MM_precipitation = MM_precipitation + (API_data['snow']['1h'] as num).toDouble();
      }

      //UV index
      double UV_index = API_data.containsKey('uvi') ?
        (API_data['uvi'] as num).toDouble() : 0.0;

      //Extract sunrise and sunset timestamps and convert to hour and minute
      //Convert API_data['sys']['sunrise'] and API_data['sys']['sunset'] to DateTime format
      DateTime sunrise_time = DateTime.fromMillisecondsSinceEpoch(API_data['sys']['sunrise'] * 1000, isUtc: true);
      DateTime sunset_time = DateTime.fromMillisecondsSinceEpoch(API_data['sys']['sunset'] * 1000, isUtc: true);
      //Convert to string
      String sunrise_Hr_Min = '${sunrise_time.hour}:${sunrise_time.minute.toString().padLeft(2, '0')}';
      String sunset_Hr_Min = '${sunset_time.hour}:${sunset_time.minute.toString().padLeft(2, '0')}';

      // Add extracted data to the CURRENT section of the map
      current_weather_data = {
        'coord': coord,
        'utc_time': utc_time,
        'local_time': local_time,
        'format_date_time': format_local_time,
        'icon_str': icon_str,
        'alert':event,
        //
        "current_city":current_city_name,
        "current_country":current_country_code,
        "rough_location":("$current_city_name, $current_country_code"),
        //
        'K_temp': Ktemp,
        'F_temp': ((Ktemp - 273.15) * 9 / 5 + 32),
        'C_temp': (Ktemp - 273.15),
        //
        'K_temp_feel': Kfeels,
        'F_temp_feel': ((Kfeels - 273.15) * 9 / 5 + 32),
        'C_temp_feel': (Kfeels - 273.15),
        //
        'K_temp_min': Ktemp_min,
        'K_temp_max': Ktemp_max,
        'F_temp_min': ((Ktemp_min - 273.15) * 9 / 5 + 32),
        'F_temp_max': ((Ktemp_max - 273.15) * 9 / 5 + 32),
        'C_temp_min': (Ktemp_min - 273.15),
        'C_temp_max': (Ktemp_max - 273.15),
        //
        'weather_cond': W_condition,
        //
        'MPH_wind': MPH_windspeed,
        'KPH_wind': (MPH_windspeed * 1.60934),
        'wind_direction': wind_direction,
        'MPH_wind_g': wind_gust_MPH,
        'KPH_wind_g': (wind_gust_MPH != 0.0 ? wind_gust_MPH * 1.60934 : 0.0),
        //
        'humid': humidity,
        'precipi_MM': MM_precipitation,
        'precipi_IN': (MM_precipitation * 0.0393701),
        //
        'press_HPA': HPA_pressure,
        'press_MB': (HPA_pressure / 100),
        //
        'clouds': cloud_coverage,
        'uvi': UV_index,
        //
        'sunrise_time':sunrise_Hr_Min,
        'sunset_time':sunset_Hr_Min,
      };

      print('API get_current_weather_datas Response: ${response.body}');
      print('Function get_current_weather_datas map return: $current_weather_data');

    } else {
      //Display API error dialog
      show_api_error(context);
    }
  } catch (er) {
    //Handle any other exceptions
    print('Error: $er');

    //Display generic error dialog
    show_generic_error(context);
  }

  //Return the map of weather data
  return current_weather_data;
}

//Function to get daily max/min temp, hourly temp and icons, 1 call
Future<Map<String, dynamic>> get_weekly_hourly_temperature_icons(
    BuildContext context, List<double> lat_lon, int current_weekday) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------get_weekly_hourly_temperature_icons function executed------]");

  // Build URL using latitude and longitude
  final url = Uri.parse(
      'https://api.openweathermap.org/data/3.0/onecall?lat=${lat_lon[0]}'
          '&lon=${lat_lon[1]}&exclude=current,minutely&appid=$_OWeather_api_key');

  // Declare returning variable (2 sections)
  Map<String, dynamic> week_hour_icon_data = {
    "daily": {},
    "hourly": {}
  };

  try {
    // Make API call
    final response = await http.get(url);

    //Check if API response is successful
    if (response.statusCode == 200) {
      //Parse the response body
      final API_data = conv.jsonDecode(response.body);
      //Remove latitude and longitude
      API_data.remove('lat');
      API_data.remove('lon');

      //Validate API response
      if (!validate_weekly_hourly_weather(API_data)){
        //Handle if API is kind of weird
        print("---API response is invalid, Stopping---");
        show_api_error(context);
        throw Exception('Invalid weekly or hourly data');
      }
      print("---API response is valid, proceeding---");

      print("API get_weekly_hourly_temperature_icons response: ${response.body}");
      final daily_data = API_data['daily'];
      final hourly_data = API_data['hourly'];

      //Process daily min/max temperatures and weather icons starting with current weekday
      for (int i = 0; i < daily_data.length; i++) {
        int day_index = (current_weekday + i) % 7;
        double K_min_temp = daily_data[i]['temp']['min'].toDouble();
        double K_max_temp = daily_data[i]['temp']['max'].toDouble();
        String weather_icon = daily_data[i]['weather'][0]['icon'];

        week_hour_icon_data['daily']['day${day_index + 1}'] = {
          'K_min_temp': K_min_temp,
          'K_max_temp': K_max_temp,
          'F_min_temp': ((K_min_temp - 273.15) * 9 / 5 + 32),
          'F_max_temp': ((K_max_temp - 273.15) * 9 / 5 + 32),
          'C_min_temp': (K_min_temp - 273.15),
          'C_max_temp': (K_max_temp - 273.15),
          'icon': weather_icon
        };
      } //Format is week_hour_icon_data['daily']['day1']['C_min_temp'];

      //Process hourly temperatures and weather icons for the next 24 hours
      for (int i = 0; i < 24; i++) {
        int hour_Index = (DateTime.now().hour + i) % 24;
        double K_temp = (hourly_data[i]['temp'] as num).toDouble();
        String weatherIcon = hourly_data[i]['weather'][0]['icon'];

        week_hour_icon_data['hourly']['hour${hour_Index + 1}'] = {
          'K_temp': K_temp,
          'F_temp': ((K_temp - 273.15) * 9 / 5 + 32),
          'C_temp': (K_temp - 273.15),
          'icon': weatherIcon
        };
      } //Format is week_hour_icon_data['hourly']['hour1']['C_temp'];
    } else {
      //Display API error
      show_api_error(context);

      //Handle API problem
      throw Exception('Failed hourly and weekly temperature and icon strings');
    }
  } catch (er) {
    //Display generic error
    show_generic_error(context);

    //Handle any other errors
    print('Error: $er');
    throw Exception('Generic error occurred');
  }

  //Return and print successful result
  print("get_weekly_hourly_temperature_icons return value: $week_hour_icon_data");
  return week_hour_icon_data;
}

//Obtain date and time, 0 calls
Map<String, dynamic> get_date_time_data(BuildContext context) {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------get_date_time_data function executed------]");

  //Declare list of date and time data
  Map<String, dynamic> date_time = {};

  //Get current date and time
  DateTime date_now_extracted_data = DateTime.now();

  //Define weekdays and months
  List<String> weekdays = ['', 'Mon', 'Tue', 'Wed',
    'Thur', 'Fri', 'Sat', 'Sun'];
  List<String> months = ['', 'January', 'February', 'March', 'April', 'May',
    'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  //Extract data components
  int month_day_num = date_now_extracted_data.day;
  int weekday_num = date_now_extracted_data.weekday;
  String weekday_str = weekdays[weekday_num]; //From 1 to 7
  int month_num = date_now_extracted_data.month; //From 1 to 12
  String month_str = months[month_num];
  int current_hour = date_now_extracted_data.hour;
  String current_minutes = date_now_extracted_data.minute.toString().padLeft(2, '0'); // Pad minutes;
  int current_year = date_now_extracted_data.year;

  //Insert extracted data
  date_time = {
    'month_day_num': month_day_num,
    'weekday_num':weekday_num,
    'weekday_str': weekday_str,
    'month_num': month_num,
    'month_str': month_str,
    'hour': current_hour,
    'minutes': current_minutes,
    'year': current_year,
  };

  //Add the next six days' weekday names
  for (int i = 1; i <= 6; i=i+1) {
    int future_week_day = (weekday_num + i) % 7; //Go from the next day onwards
    future_week_day = future_week_day == 0 ? 7 : future_week_day; //Adjust for Sunday

    date_time['weekday_str${i + 1}'] = weekdays[future_week_day]; //Insert future week day
    //Format= 'weekday_str2':weekdays[future_week_day], and so on
  }

  //Add the next 23 hours
  for (int i = 1; i <= 23; i=i+1) {
    int future_hour = (current_hour + i) % 24; // Calculate the future hour
    date_time['hour${i + 1}'] = future_hour; // Insert future hour
    //Format= 'hour2': future_hour, and so on
  }

  print("Function get_date_time_data map return: $date_time");
  return date_time;
}

/////////////////////////////////////////////////////////////////////////////

//Data manipulation, retrieval and checking
//To capitalize the first letter of the strings
String capitalize_strings(String input) {
  print("------String capitalization executed------");
  if (input.isEmpty) {
    return input;
  }
  return input.split(' ').map((word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

//To check valid city
String validate_user_input(BuildContext context,
    String givencityname) {
  print("[------validateuserinput function executed------]");
  if (givencityname == null || givencityname.isEmpty) {

    //Handle empty Text field
    show_no_city_or_postalcode_provided(context);
    print("Invalid user input");
    throw ArgumentError("Input is empty");
  }

  //Limit the valid characters by user
  final validCharacters = RegExp(r'^[a-zA-Z0-9\s\-]+$');

  if (givencityname.length >= 2 &&
      givencityname.length <= 40 &&
      validCharacters.hasMatch(givencityname)) {
    print("Valid user input");
    return givencityname;
  } else {
    //Handle invalid name or even possible attack
    show_nice_try_fed(context);
    print("Invalid user input");
    throw ArgumentError("Invalid input: Input does not meet criteria");
  }
}

//To convert icon codes into actual icons
IconData return_correct_icon(String striconcode) {
  //Use switch statement to select the correct case
  switch (striconcode) {
  //For when it is day
    case '01d':
      return WeatherIcons.wi_day_sunny;
    case '02d':
    case '03d':
    case '04d':
      return WeatherIcons.wi_day_cloudy;
    case '09d':
    case '10d':
      return WeatherIcons.wi_day_rain;
    case '11d':
      return WeatherIcons.wi_day_thunderstorm;
    case '13d':
      return WeatherIcons.wi_day_snow;
    case '50d':
      return WeatherIcons.wi_day_fog;

  //For when it is night
    case '01n':
      return WeatherIcons.wi_night_clear;
    case '02n':
    case '03n':
    case '04n':
      return WeatherIcons.wi_night_cloudy;
    case '09n':
    case '10n':
      return WeatherIcons.wi_night_rain;
    case '11n':
      return WeatherIcons.wi_night_thunderstorm;
    case '13n':
      return WeatherIcons.wi_night_snow;
    case '50n':
      return WeatherIcons.wi_night_fog;
    default:
      return WeatherIcons.wi_na; // Default icon for unknown codes
  }
}

//To retrieve the apikey from .env file
String use_api_key() {
  String? oWeatherApiKey = dotenv.env['OWeatherapikey'];
  if (oWeatherApiKey == null) {
    throw Exception('API key not found');
  }

  print("---API key succesfully retrieved---");
  //Return the API key
  return oWeatherApiKey;
}

//To validate API response for get_current_weather_datas
bool validate_current_weather_data(Map<String, dynamic> data) {
  // Check for the presence and types of essential fields
  try {
    // Coordinates
    if (data['coord'] == null || data['coord']['lat'] == null || data['coord']['lon'] == null) return false;

    // Weather
    if (data['weather'] == null || data['weather'][0] == null || data['weather'][0]['icon'] == null || data['weather'][0]['description'] == null) return false;

    // Main data
    if (data['main'] == null || data['main']['temp'] == null || data['main']['feels_like'] == null || data['main']['temp_min'] == null || data['main']['temp_max'] == null || data['main']['humidity'] == null || data['main']['pressure'] == null) return false;

    // Wind data
    if (data['wind'] == null || data['wind']['speed'] == null || data['wind']['deg'] == null) return false;

    // System data (sunrise and sunset)
    if (data['sys'] == null || data['sys']['sunrise'] == null || data['sys']['sunset'] == null) return false;

    // Optional fields (check if they exist, if they do, check their types)
    if (data.containsKey('clouds') && data['clouds']['all'] == null) return false;
    if (data.containsKey('rain') && data['rain']['1h'] == null) return false;
    if (data.containsKey('snow') && data['snow']['1h'] == null) return false;
    if (data.containsKey('uvi') && data['uvi'] == null) return false;

    return true;
  } catch (e) {
    //If any error occurs during validation, return false
    return false;
  }
}

//To validate API response for get_current_weather_datas
bool validate_current_weather_alerts(Map<String, dynamic> data) {
  try {
    // Check if 'alerts' key is present and is a list
    if (data.containsKey('alerts') && data['alerts'] is List) {
      for (var alert in data['alerts']) {
        if (alert['event'] == null || alert['event'] is! String) return false;
      }
    }

    return true;
  } catch (e) {
    return false;
  }
}

//To validate API response for getWEEKLYHOURLYtempsicons
bool validate_weekly_hourly_weather(Map<String, dynamic> data) {
  try {
    if (!data.containsKey('daily') || !data.containsKey('hourly')) return false;

    // Validate daily data
    for (var dayData in data['daily']) {
      if (dayData['temp']['min'] == null || dayData['temp']['max'] == null || dayData['weather'][0]['icon'] == null) {
        return false;
      }
    }

    // Validate hourly data
    for (var hourData in data['hourly']) {
      if (hourData['temp'] == null || hourData['weather'][0]['icon'] == null) {
        return false;
      }
    }

    return true;
  } catch (e) {
    return false;
  }
}

//To validate API response for getcitycountry
bool validate_get_city_country(List<dynamic> data) {
  try {
    if (data.isEmpty) return false;
    if (data[0]['name'] == null || data[0]['country'] == null) return false;

    return true;
  } catch (e) {
    return false;
  }
}

/////////////////////////////////////////////////////////////////////////////

//Alert dialog for error handling
// Function to display the location is disabled in the device
void show_location_disable(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services disabled",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Please, close the app then turn on location services in your "
          "device settings",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display why access to GPS is necessary
void show_gps_access_necessary(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services required",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Please, Weather App Project requires access to your device's"
          "GPS location in order to obtain the relevant information about"
          "the current and forecasted weather in your location",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display device's GPS is unable to determine location
void show_gps_unable_to_determine(BuildContext context){
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services error",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "There was an error with your device's GPS, it was unable to"
        "determine your current position, please try again later",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display inability gpslocation because access was denied
void show_gps_access_denied(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services access denied",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Access to location services has been denied, "
          "please allow acees to use GPS feature",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Function to display API error dialog (if API or parsing fails)
void show_api_error(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "API or parsing Error",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "There has been a problem with API call or data parsing",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display invalid url
void show_invalid_url(BuildContext context){
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "URL launch error",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "There was an error when trying to launch URL and obtain its"
          "resources, please try again later",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Function to display generic error
void show_generic_error(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: Generic error",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Unexpected unknonwn error, please try later again",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Function to display location not found error
void show_location_not_found(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: Location error",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Unexpected error when trying to get location, please try later again",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Function to display invalid cityname not found error
void show_invalid_city_name(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: Invalid city name",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Entered city name is invalid, please enter a valid city name. "
          "You can check in your built in Mapping app (Google maps or Apple maps)",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display no cityname provided
void show_no_city_or_postalcode_provided(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: No city or Postal code provided",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "No input has been provided, please provide a valid City name "
          "or Postal Code before continuing",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//Function to display dont try to hack me pal provided
void show_nice_try_fed(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Set variables as the alert itself
  var alert = AlertDialog(
    backgroundColor: const Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "You think you can SQL-inject me?",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(77, 204, 189, 1.0),
        ),
      ),
    ),
    content: Text(
      "Seriously mate?, you really believed it was going to be that "
          "easy?, get sanitized you Numbskull, bypass this you filthy"
          " casual",
      style: GoogleFonts.quantico(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
    ),
    actions: [
      okbutton,
    ],
  );

  //Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}