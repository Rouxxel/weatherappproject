import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:http/http.dart' as http; //For http resources
import 'package:url_launcher/url_launcher.dart'; //To launch URLs
import 'package:icons_flutter/icons_flutter.dart'; //For icon import
import 'dart:convert' as conv; //For JSON parsing
import 'package:intl/intl.dart'; //For data formatting import
import 'package:flutter_dotenv/flutter_dotenv.dart'; //To access API key .env
import 'package:logger/logger.dart';

//
//Other files import
import 'package:weatherappproject/utils/alert_dialogs.dart';
import 'package:weatherappproject/methods/validation_methods.dart';

//GPS information (controller variable)
bool gps_permission = false;

//API key and other variables
String _ow_api_key = retrieve_api_key();

//Initialize logger
Logger log_handler= Logger();

//To get API data with city name Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&exclude=minutely,alerts&appid=$apikey)'
//To get API data with latitude and longitude Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apikey)'

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method
//GPS related
//Request GPS permission and get it if given (MUST BE EXECUTED FIRST)
Future<void> get_gps_permissions(BuildContext context) async {
  log_handler.d("[------get_gps_permissions function executing------]");

  try {
    //Check if device has location active and prevent execution if disabled
    bool location_service_active = await Geolocator.isLocationServiceEnabled();
    if (!location_service_active) {
      //Show user their location is disabled
      alert_location_disable(context);
      log_handler.e("Error: Location-GPS function is disabled in the device");
      return Future.error("Location service is disabled");
    }

    //Permission variable
    LocationPermission permission = await Geolocator.checkPermission();

    //Ask the user for permission if currently denied
    if(permission == LocationPermission.denied || permission==LocationPermission.deniedForever){
      await alert_gps_access_necessary(context);
      log_handler.d("Requesting GPS permission");
      permission = await Geolocator.requestPermission();

      //Handle several possible scenarios after permission asked
      switch(permission){
        case LocationPermission.unableToDetermine:
        //Handle when permission status couldn't be determined
          log_handler.w("Unable to determine GPS permission status");
          alert_gps_unable_to_determine(context);
          return Future.error("Unable to determine GPS permission status");

        case LocationPermission.denied:
        //Handle denied permission
          log_handler.w("GPS Permission denied");
          alert_gps_access_denied(context);
          return Future.error("GPS permissions denied");

        case LocationPermission.deniedForever:
        //Handle permanently denied permission
          log_handler.w("GPS Permission denied permanently");
          alert_gps_access_denied(context);
          return Future.error("GPS permissions permanently denied");

        case LocationPermission.always:
        case LocationPermission.whileInUse:
        //Handle location permission granted
          log_handler.i("GPS Permission granted");
          gps_permission = true;
          break;

        default:
          log_handler.w("Unhandled GPS permission status: $permission");
          alert_generic_error(context);
          return Future.error("Unhandled GPS permission status");
      }
    } else {
      //Permission already granted (always or whileInUse)
      log_handler.i("GPS Permission already granted");
      gps_permission = true;
    }
  } catch (er, stackTrace) {
    log_handler.e("Unexpected error during GPS permission handling: $er, $stackTrace");
    alert_gps_unable_to_determine(context);
    return Future.error("Unexpected error: $er");
  }
}

//Function to get GPS location and return as a list
//MUST BE CALLED AFTER get_gps_permission
Future<Map<String, double>?> get_gps_location(BuildContext context) async {
  log_handler.d("[------get_gps_location function executing------]");
  //Create empty list for latitude and longitude
  Map<String, double> user_coordinates = {
    "latitude":0.0,
    "longitude":0.0,
  };

  try {
    //Check if GPS permission is in line
    if (gps_permission) {
      //Get the current position with low accuracy
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      //Assign the latitude and longitude to the list
      user_coordinates["latitude"] = position.latitude;
      user_coordinates["longitude"] = position.longitude;

      log_handler.d("Latitude and Longitude from get_gps_location: $user_coordinates");
      //Return the list of coordinates
      return user_coordinates;
    } else {
      //Handle gps permission denied scenario
      alert_gps_access_denied(context);
      log_handler.w("GPS permission denied, unable to get latitude and longitude");
      return null;
    }
  } catch (er) {
    //Handle error situation
    alert_generic_error(context);
    log_handler.e("Error getting location: $er");
    return null;
  }
}

//Function to launch URLs
Future<void> launch_URL(BuildContext context, String given_URL) async {
  log_handler.d("[------launch_URL function executing------]");

  try {
    if (!await launchUrl(Uri.parse(given_URL),
        mode: LaunchMode.externalApplication)) {
      alert_error_launching_url(context);
      throw Exception('Could not launch $given_URL');
    }
    log_handler.i("URL resource launching");

  } catch (er,stack_trace) {
    //Handle error situation
    alert_error_launching_url(context);
    log_handler.e("Error launching URL: $er, $stack_trace");
  }
}

/////////////////////////////////////////////////////////////////////////////
//API and data extraction
//Get current weather data by either latitude and longitude or city name
Future<Map<String, dynamic>> get_latest_weather_data({
  required BuildContext context,
    String? city_name, Map<String,double>? lat_lon,}) async {
  log_handler.d("[------get_current_weather_data function executing------]");

  //Determine the type of request
  String url="";

  //Both type of request or neither handling
  if (city_name != null && lat_lon != null) {
    //Both city_name and lat_lon are provided, throw an error
    alert_location_not_found(context); //Show the error to the user
    log_handler.w("Latitude-longitude and city name provided together, do not");
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  } else if (city_name == null && lat_lon == null){
    //Neither city_name or lat_lon are provided, throw an error
    log_handler.w("No Latitude-longitude nor city name provided, provide either");
    alert_location_not_found(context); //Show the error to the user
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  }

  //Latitude and longitude URL or URL with city name
  if (lat_lon != null) {
    log_handler.d("Getting data from latitude and longitude");
    //Use latitude and longitude to build the URL
    url ='https://api.openweathermap.org/data/2.5/weather?lat=${lat_lon["latitude"]}'
        '&lon=${lat_lon["longitude"]}&exclude=minutely&appid=$_ow_api_key';
  } else if (city_name != null) {
    //Check city_name is valid (at least is not empty)
    log_handler.d("Getting data from city name");
    if (city_name.isEmpty){
      alert_no_city_or_postalcode_provided(context);
      log_handler.w("Invalid city name entered");
      throw Exception("--------User has entered an invalid city name--------");
    } else{
      //Use city_name to build the URL
      url ='https://api.openweathermap.org/data/2.5/weather?q=$city_name'
          '&exclude=minutely&appid=$_ow_api_key';
    }
  }

  //Map to store the extracted weather data
  Map<String, dynamic> latest_weather_data = {};

  //Try to obtain API call from URL
  try {
    log_handler.d("Getting API call");
    //Make API call
    final response = url.isEmpty ?
    throw Exception("URL cannot be Empty")
        : await http.get(Uri.parse(url));

    //Check response success
    if (response.statusCode == 200) {
      //Parse response if response is successful
      Map<String, dynamic> API_data = conv.jsonDecode(response.body);

      //Validate API response (sanitize)
      if (!validate_latest_weather_data(API_data)) {

        //Handle if API response is weird
        alert_api_error(context);
        log_handler.w("---API response is invalid, Stopping---");
        throw Exception('Invalid API response structure');
      }
      log_handler.d("---API response is valid, proceeding to extract data---");

      //Extract coordinates in case the input used is city name
      //Extract longitude and latitude
      List<double> coord = [API_data['coord']['lat'], API_data['coord']['lon']];

      //Extract timezone
      //Convert the time stamp API_data['dt'] to a DateTime object
      DateTime utc_time = DateTime.fromMillisecondsSinceEpoch(API_data['dt'] * 1000, isUtc: true);
      //Apply the timezone offset API_data['timezone'] to get the local time
      DateTime local_time = utc_time.add(Duration(seconds: API_data['timezone']));

      //Extract city and country
      String city_name = API_data['name'];
      String country_code = API_data['sys']['country'];

      //Extract and store CURRENT weather data
      //Current Temperature
      double k_temp = (API_data['main']['temp'] as num).toDouble();

      //Feels like temperature
      double k_feels = (API_data['main']['feels_like'] as num).toDouble();

      //Extract and convert temp_min and temp_max
      double k_temp_min = (API_data['main']['temp_min'] as num).toDouble();
      double k_temp_max = (API_data['main']['temp_max'] as num).toDouble();

      //Weather condition
      double hpa_pressure = (API_data['main']['pressure'] as num).toDouble();

      //Possible alerts, requires a different URL than the 2 before and a new API call
      String event="No alerts today!!!";
      if (lat_lon != null) { //If latitude and longitude are provided
        final alert_URL = Uri.parse(
            'https://api.openweathermap.org/data/3.0/onecall?lat=${lat_lon["latitude"]}'
                '&lon=${lat_lon["longitude"]}&exclude=current,minutely,hourly,'
                'daily&lang=en&appid=$_ow_api_key');
        try { //Same treatment as first call
          final alert_response = await http.get(alert_URL);
          if (alert_response.statusCode == 200) {
            final alert_data = conv.jsonDecode(alert_response.body);
            //Remove latitude and longitude
            alert_data.remove('lat');
            alert_data.remove('lon');

            //Validate second API response
            if (!validate_latest_weather_alerts(alert_data)){
              //Handle if API second response is weird
              alert_api_error(context);
              log_handler.w("---Second API response is invalid, Stopping---");
              throw Exception('Invalid weather alerts data');
            }
            log_handler.d("---Second API response is valid, proceeding---");
            if (alert_data['alerts'] != null && (alert_data['alerts'] as List).isNotEmpty) {
              event = alert_data['alerts'][0]['event'];
            }
          } else {
            alert_api_error(context);
            log_handler.e("Failed to load weather alerts");
            throw Exception('Failed to load weather alerts');
          }
        } catch (er) {
          alert_generic_error(context);
          log_handler.e('Error fetching alerts: $er');
        }
      } else if (city_name != null && city_name.isNotEmpty) { //If city name is provided
        final alert_URL = Uri.parse(
            'https://api.openweathermap.org/data/3.0/onecall?lat=${coord[0]}&lon=${coord[1]}'
                '&exclude=current,minutely,hourly,daily&lang=en&appid=$_ow_api_key');
        try {
          final alert_response = await http.get(alert_URL);
          if (alert_response.statusCode == 200) {
            final alert_data = conv.jsonDecode(alert_response.body);
            //Remove latitude and longitude
            alert_data.remove('lat');
            alert_data.remove('lon');

            //Validate second API response
            if (!validate_latest_weather_alerts(alert_data)){
              //Handle if API second response is weird
              log_handler.w("---Second API response is invalid, Stopping---");
              alert_api_error(context);
              throw Exception('Invalid weather alerts data');
            }
            log_handler.d("---Second API response is valid, proceeding---");
            if (alert_data['alerts'] != null && (alert_data['alerts'] as List).isNotEmpty) {
              event = alert_data['alerts'][0]['event'];
            }
          } else {
            alert_api_error(context);
            log_handler.e("Failed to load weather alerts");
            throw Exception('Failed to load weather alerts');
          }
        } catch (er) {
          alert_generic_error(context);
          log_handler.e('Error fetching alerts: $er');
        }
      }

      //Wind information
      double mph_wind_speed = (API_data['wind']['speed'] as num).toDouble();
      double mph_wind_gust = API_data['wind'].containsKey('gust') ?
      (API_data['wind']['gust'] as num).toDouble() : 0.0;

      //Precipitation
      double mm_precipitation = 0.0;
      //Check if there's precipitation data
      if (API_data.containsKey('rain') && API_data['rain'].containsKey('1h')) {
        mm_precipitation = mm_precipitation + (API_data['rain']['1h'] as num).toDouble();
      }
      //Check if there's snow data and add it to precipitation
      if (API_data.containsKey('snow') && API_data['snow'].containsKey('1h')) {
        mm_precipitation = mm_precipitation + (API_data['snow']['1h'] as num).toDouble();
      }

      //Extract sunrise and sunset timestamps and convert to hour and minute
      //Convert API_data['sys']['sunrise'] and API_data['sys']['sunset'] to DateTime format
      DateTime sunrise_time = DateTime.fromMillisecondsSinceEpoch(API_data['sys']['sunrise'] * 1000, isUtc: true);
      DateTime sunset_time = DateTime.fromMillisecondsSinceEpoch(API_data['sys']['sunset'] * 1000, isUtc: true);
      //Convert to string
      String sunrise_Hr_Min = '${sunrise_time.hour}:${sunrise_time.minute.toString().padLeft(2, '0')}';
      String sunset_Hr_Min = '${sunset_time.hour}:${sunset_time.minute.toString().padLeft(2, '0')}';

      // Add extracted data to the CURRENT section of the map
      latest_weather_data = {
        'coord': coord,
        'utc_time': utc_time,
        'local_time': local_time,
        'format_date_time': DateFormat('EEEE d, MMMM HH:mm').format(local_time),
        'icon_str': API_data['weather'][0]['icon'],
        'alert':event,
        //
        "current_city":city_name,
        "current_country":country_code,
        "rough_location":("$city_name, $country_code"),
        //
        'K_temp': k_temp,
        'F_temp': ((k_temp - 273.15) * 9 / 5 + 32),
        'C_temp': (k_temp - 273.15),
        //
        'K_temp_feel': k_feels,
        'F_temp_feel': ((k_feels - 273.15) * 9 / 5 + 32),
        'C_temp_feel': (k_feels - 273.15),
        //
        'K_temp_min': k_temp_min,
        'K_temp_max': k_temp_max,
        'F_temp_min': ((k_temp_min - 273.15) * 9 / 5 + 32),
        'F_temp_max': ((k_temp_max - 273.15) * 9 / 5 + 32),
        'C_temp_min': (k_temp_min - 273.15),
        'C_temp_max': (k_temp_max - 273.15),
        //
        'weather_cond': API_data['weather'][0]['description'],
        //
        'MPH_wind': mph_wind_speed,
        'KPH_wind': (mph_wind_speed * 1.60934),
        'wind_direction': API_data['wind']['deg'],
        'MPH_wind_g': mph_wind_gust,
        'KPH_wind_g': (mph_wind_gust != 0.0 ? mph_wind_gust * 1.60934 : 0.0),
        //
        'humid': API_data['main']['humidity'],
        'precipi_MM': mm_precipitation,
        'precipi_IN': (mm_precipitation * 0.0393701),
        //
        'press_HPA': hpa_pressure,
        'press_MB': (hpa_pressure / 100),
        //
        'clouds': API_data.containsKey('clouds') ? API_data['clouds']['all'] : 0,
        'uvi': API_data.containsKey('uvi') ? (API_data['uvi'] as num).toDouble() : 0.0,
        //
        'sunrise_time':sunrise_Hr_Min,
        'sunset_time':sunset_Hr_Min,
      };

      log_handler.d('API get_current_weather_data Response: ${response.body}');
      log_handler.d('Function get_current_weather_data map return: $latest_weather_data');

    } else {
      //Display API error dialog
      log_handler.w("API or parsing error");
      alert_api_error(context);
    }
  } catch (er) {
    //Handle any other exceptions
    log_handler.e('Error: $er');

    //Display generic error dialog
    alert_generic_error(context);
  }

  //Return the map of weather data
  return latest_weather_data;
}

//Function to get daily max/min temp, hourly temp and icons
Future<Map<String, dynamic>?> get_weekly_hourly_icons(
    BuildContext context, Map<String,double>? lat_lon, int? current_weekday) async {
  log_handler.d("[------get_weekly_hourly_icons function executing------]");

  //Handle null latitude and longitude and stop early
  if (lat_lon == null || current_weekday == null){
    log_handler.w("lat_lon or current_weekday is null — aborting");
    alert_generic_error(context);
    return null;
  }

  // Build URL using latitude and longitude
  final url = Uri.parse(
      'https://api.openweathermap.org/data/3.0/onecall?lat=${lat_lon["latitude"]}'
          '&lon=${lat_lon["longitude"]}&exclude=current,minutely&appid=$_ow_api_key');

  // Declare returning variable (2 sections)
  Map<String, dynamic> week_hour_icon_data = {"daily": {}, "hourly": {} };

  try {
    // Make API call
    final response = await http.get(url);
    log_handler.d("Calling API for daily/hourly");

    //Check if API response is successful
    if (response.statusCode == 200) {
      //Parse the response body
      final API_data = conv.jsonDecode(response.body);
      //Remove latitude and longitude
      API_data.remove('lat');
      API_data.remove('lon');

      //Validate API response
      if (!validate_weekly_hourly_data(API_data)){
        //Handle if API is kind of weird
        log_handler.w("---API response is invalid, Stopping---");
        alert_api_error(context);
        throw Exception('Invalid weekly or hourly data');
      }
      log_handler.d("---API response is valid, proceeding---");
      log_handler.d("API get_weekly_hourly_temperature_icons response: ${response.body}");

      final daily_data = API_data['daily'];
      final hourly_data = API_data['hourly'];
      const double factor_K_to_C = -273.15;
      const double factor_K_to_F = 1.8;
      const double factor_K_to_F_offset = 459.67;

      //Process daily min/max temperatures and weather icons starting with current weekday
      for (int i = 0; i < daily_data.length; i++) {
        int day_index = (current_weekday + i) % 7;

        week_hour_icon_data['daily']['day${day_index + 1}'] = {
          'K_min_temp': daily_data[i]['temp']['min'].toDouble(),
          'K_max_temp': daily_data[i]['temp']['max'].toDouble(),
          'F_min_temp': ((daily_data[i]['temp']['min'] * factor_K_to_F) - factor_K_to_F_offset),
          'F_max_temp': ((daily_data[i]['temp']['max'] * factor_K_to_F) - factor_K_to_F_offset),
          'C_min_temp': (daily_data[i]['temp']['min'] + factor_K_to_C),
          'C_max_temp': (daily_data[i]['temp']['max'] + factor_K_to_C),
          'icon': daily_data[i]['weather'][0]['icon'],
        };
      } //Format is week_hour_icon_data['daily']['day1']['C_min_temp'];

      //Process hourly temperatures and weather icons for the next 24 hours
      for (int i = 0; i < 24; i++) {
        int hour_Index = (DateTime.now().hour + i) % 24;

        week_hour_icon_data['hourly']['hour${hour_Index + 1}'] = {
          'K_temp': hourly_data[i]['temp'].toDouble(),
          'F_temp': ((hourly_data[i]['temp'] * factor_K_to_F) - factor_K_to_F_offset),
          'C_temp': (hourly_data[i]['temp'] + factor_K_to_C),
          'icon': hourly_data[i]['weather'][0]['icon'],
        };
      } //Format is week_hour_icon_data['hourly']['hour1']['C_temp'];
    } else {
      //Display API error
      alert_api_error(context);

      //Handle API problem
      throw Exception('Failed hourly and weekly temperature and icon strings');
    }
  } catch (er) {
    //Display generic error
    alert_generic_error(context);

    //Handle any other errors
    log_handler.e('Error: $er');
    throw Exception('Generic error occurred');
  }

  //Return and log successful result
  log_handler.d("get_weekly_hourly_icons return value: $week_hour_icon_data");
  return week_hour_icon_data;
}

//Obtain date and time
Map<String, dynamic>? get_date_time_data(BuildContext context) {
  log_handler.d("[------get_date_time_data function executing------]");

  try {
    //Declare list of date and time data
    Map<String, dynamic> date_time = {};
    //Get current date and time
    DateTime date_now_data = DateTime.now();

    //Define weekdays and months
    List<String> weekdays = ['dummy', 'Mon', 'Tue', 'Wed',
      'Thur', 'Fri', 'Sat', 'Sun'];
    List<String> months = ['dummy', 'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    //Insert extracted data
    date_time = {
      'month_day_num': date_now_data.day,
      'weekday_num':date_now_data.weekday,
      'weekday_str': weekdays[date_now_data.weekday],
      'month_num': date_now_data.month,
      'month_str': months[date_now_data.month],
      'hour': date_now_data.hour,
      'minutes': date_now_data.minute.toString().padLeft(2, '0'), // Pad minutes;
      'year': date_now_data.year,
    };

    //Add the next six days' weekday names
    for (int i = 1; i <= 6; i=i+1) {
      int future_week_day = (date_time["weekday_num"] + i) % 7; //Go from the next day onwards
      future_week_day = future_week_day == 0 ? 7 : future_week_day; //Adjust for Sunday

      date_time['weekday_str${i + 1}'] = weekdays[future_week_day]; //Insert future week day
      //Format= 'weekday_str2':weekdays[future_week_day], and so on
    }

    //Add the next 23 hours
    for (int i = 1; i <= 23; i=i+1) {
      int future_hour = (date_time["hour"] + i) % 24; // Calculate the future hour
      date_time['hour${i + 1}'] = future_hour; // Insert future hour
      //Format= 'hour2': future_hour, and so on
    }

    log_handler.d("Function get_date_time_data map return: $date_time");
    return date_time;
  } catch (er) {
    //Display generic error
    alert_generic_error(context);

    //Handle any other errors
    log_handler.e('Error: $er');
    throw Exception('Generic error occurred');
  }
}

/////////////////////////////////////////////////////////////////////////////
//Data manipulation
//To capitalize the first letter of the strings
String capitalize_strings(String input) {
  log_handler.d("------capitalize_strings executing------");
  if (input.isEmpty) {
    return input;
  }
  return input.split(' ').map((word) {
    if (word.isEmpty) {
      return word;
    }
    log_handler.d("String capitalized successfully");
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

//To convert icon codes into actual icons
IconData return_icon_code(String str_icon_code) {
  log_handler.d("------return_icon_code executing------");
  //Use switch statement to select the correct case
  switch (str_icon_code) {
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
String retrieve_api_key() {
  log_handler.d("------retrieve_api_key executing------");
  String? o_weather_API_key = dotenv.env['OWeatherapikey'];
  if (o_weather_API_key == null) {
    throw Exception('API key not found');
  }

  log_handler.d("---API key successfully retrieved---");
  //Return the API key
  return o_weather_API_key;
}
