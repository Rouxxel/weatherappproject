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
bool gpsaccess = false;

//API key and other variables
String OWeatherapikey = useapikey();

//To get API data with city name Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&exclude=minutely,alerts&appid=$apikey)'
//To get API data with latitude and longitude Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apikey)'

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//GPS related
//Request GPS permission and get it if given (MUST BE EXECUTED FIRST)
void getgpspermission(BuildContext context) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getgpspermission function executed------]");
  //Check if device has location active and prevent execution if disabled
  bool locationservice = await Geolocator.isLocationServiceEnabled();
  if (!locationservice) {
    //Show user their location is disabled
    showLOCATIONdisableddialog(context);
    gpsaccess = false;

    print("GPS Location services are disabled");
    return Future.error("Location service is disabled");
  }

  //Permission variable
  LocationPermission permission = await Geolocator.checkPermission();

  //Ask the user for permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //Handle denied permission
      gpsaccess = false;
      print("GPS Permission denied");
      return Future.error("GPS permissions denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    //Handle permanently denied permission
    gpsaccess = false;
    print("GPS Permission denied permanently");
    return Future.error("GPS permissions permanently denied");
  }
  print("GPS Permission granted");
  gpsaccess = true;
}

//Function to get GPS location and return as a list
Future<List<double>> getgpslocation(BuildContext context) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getgpslocation function executed------]");
  //Create empty list for latitude and longitude
  List<double> coordinates = [];
  try {
    //Check if GPS access is granted
    if (gpsaccess == true) {
      // Get the current position with low accuracy
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      //Assign the latitude and longitude to the list
      coordinates = [position.latitude, position.longitude];
    } else {
      //Handle access denied situation
      showACCESStogpsdenieddialog(context);
    }
  } catch (er) {
    //Handle error situation
    showGENERICerrordialog(context);
    print("Error getting location: $er");
  }

  print("Latitude and Longitude from getgpslocation: $coordinates");
  //Return the list of coordinates
  return coordinates;
}

/////////////////////////////////////////////////////////////////////////////

//API and data extraction
//Get current weather data by either latitude and longitude or city name
Future<Map<String, dynamic>> getCURRENTweatherdata({
  required BuildContext context,
  String? cityname, List<double>? latlon,}) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getCURRENTweatherdata function executed------]");

  //Determine the type of request
  String url;
  if ((cityname != null) && (latlon != null)) {
    //If both are provided, throw an error
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  } else if (cityname != null) {
    //Check cityname is valid (at least is not empty)
    if (cityname.isEmpty){
      showNOCITYORPOSTALCODEprovided(context);
      throw Exception("--------User has entered an invalid city name--------");
    }
    // Use city name to build the URL
    url ='https://api.openweathermap.org/data/2.5/weather?q=$cityname'
        '&exclude=minutely,alerts&appid=$OWeatherapikey';

  } else if (latlon != null) {
    // Use latitude and longitude to build the URL
    url ='https://api.openweathermap.org/data/2.5/weather?lat=${latlon[0]}'
        '&lon=${latlon[1]}&exclude=minutely,alerts&appid=$OWeatherapikey';
  } else {
    // If neither is provided, throw an error
    throw ArgumentError(
        'Either city name or both latitude and longitude must be provided.');
  }

  //Map to store the extracted weather data
  Map<String, dynamic> currentweatherdata = {};

  //Try to obtain API call from URL
  try {
    //Make API call
    final response = await http.get(Uri.parse(url));

    //Check response success
    if (response.statusCode == 200) {
      // Parse response if response is successful
      Map<String, dynamic> APIdata = conv.jsonDecode(response.body);

      //Validate API response (sanitize)
      if (!VALIDATEgetCURRENTweatherdata(APIdata)) {

        //Handle if API response is weird
        showAPIerrordialog(context);
        print("---API response is invalid, Stopping---");
        throw Exception('Invalid API response structure');
      }
      print("---API response is valid, proceeding---");

      //Extract coordinates in case the input used is city name
      //Extract longitude and latitude
      List<double> coord = [APIdata['coord']['lat'], APIdata['coord']['lon']];

      //Extract icon code
      String iconstr = APIdata['weather'][0]['icon'];

      //Extract timezone
      //Extract the timestamp and timezone offset from the response
      int timestamp = APIdata['dt'];
      int timezoneoffset = APIdata['timezone'];
      //Convert the timestamp to a DateTime object
      DateTime utctime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
      //Apply the timezone offset to get the local time
      DateTime localtime = utctime.add(Duration(seconds: timezoneoffset));
      //Format the local time to a readable string
      String formattedlocaltime = DateFormat('EEEE d, MMMM HH:mm').format(localtime);

      // Extract and store CURRENT weather data
      // Temperature
      double Ktemperature = (APIdata['main']['temp'] as num).toDouble();
      double Ftemperature = (Ktemperature - 273.15) * 9 / 5 + 32;
      double Ctemperature = Ktemperature - 273.15;

      // Feels like temperature
      double Kfeelslike = (APIdata['main']['feels_like'] as num).toDouble();
      double Ffeelslike = (Kfeelslike - 273.15) * 9 / 5 + 32;
      double Cfeelslike = Kfeelslike - 273.15;

      // Extract and convert temp_min and temp_max
      double Ktempmin = (APIdata['main']['temp_min'] as num).toDouble();
      double Ftempmin = (Ktempmin - 273.15) * 9 / 5 + 32;
      double Ctempmin = Ktempmin - 273.15;

      double Ktempmax = (APIdata['main']['temp_max'] as num).toDouble();
      double Ftempmax = (Ktempmax - 273.15) * 9 / 5 + 32;
      double Ctempmax = Ktempmax - 273.15;

      // Weather condition
      String wcondition = APIdata['weather'][0]['description'];
      double HPApressure = (APIdata['main']['pressure'] as num).toDouble();
      double MBpressure = HPApressure / 100.0;

      int cloudcoverage =
        APIdata.containsKey('clouds') ? APIdata['clouds']['all'] : 0;

      // Wind information
      double MPHwindspeed = (APIdata['wind']['speed'] as num).toDouble();
      double KPHwindspeed = MPHwindspeed * 1.60934;
      int winddirection = APIdata['wind']['deg'];
      double windgustMPH = APIdata['wind'].containsKey('gust') ?
      (APIdata['wind']['gust'] as num).toDouble() : 0.0;
      double windgustKPH = windgustMPH != 0.0 ? windgustMPH * 1.60934 : 0.0;

      // Water related things
      int humidity = APIdata['main']['humidity'];

      // Precipitation
      double MMprecipitation = 0.0;
      // Check if there's precipitation data
      if (APIdata.containsKey('rain') && APIdata['rain'].containsKey('1h')) {
        MMprecipitation = MMprecipitation + (APIdata['rain']['1h'] as num).toDouble();
      }
      // Check if there's snow data and add it to precipitation
      if (APIdata.containsKey('snow') && APIdata['snow'].containsKey('1h')) {
        MMprecipitation = MMprecipitation + (APIdata['snow']['1h'] as num).toDouble();
      }
      double INprecipitation = MMprecipitation * 0.0393701;

      //UV index
      double uvindex = APIdata.containsKey('uvi') ?
      (APIdata['uvi'] as num).toDouble() : 0.0;

      //Extract sunrise and sunset timestamps and convert to hour and minute
      //Extract int of both
      int sunriseTimestamp = APIdata['sys']['sunrise'];
      int sunsetTimestamp = APIdata['sys']['sunset'];
      //Convert to DateTime format
      DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000, isUtc: true);
      DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000, isUtc: true);
      //Convert to string
      String sunriseHrMin = '${sunriseTime.hour}:${sunriseTime.minute.toString().padLeft(2, '0')}';
      String sunsetHrMin = '${sunsetTime.hour}:${sunsetTime.minute.toString().padLeft(2, '0')}';

      // Add extracted data to the CURRENT section of the map
      currentweatherdata = {
        'coord': coord,
        'utctime': utctime,
        'localtime': localtime,
        'formatdatetime': formattedlocaltime,
        'iconstr': iconstr,
        //
        'Ktemp': Ktemperature,
        'Ftemp': Ftemperature,
        'Ctemp': Ctemperature,
        //
        'Ktempfeel': Kfeelslike,
        'Ftempfeel': Ffeelslike,
        'Ctempfeel': Cfeelslike,
        //
        'Ktempmin': Ktempmin,
        'Ktempmax': Ktempmax,
        'Ftempmin': Ftempmin,
        'Ftempmax': Ftempmax,
        'Ctempmin': Ctempmin,
        'Ctempmax': Ctempmax,
        //
        'weathercond': wcondition,
        //
        'MPHwind': MPHwindspeed,
        'KPHwind': KPHwindspeed,
        'winddir': winddirection,
        'MPHwindg': windgustMPH,
        'KPHwindg': windgustKPH,
        //
        'humid': humidity,
        'precipiMM': MMprecipitation,
        'precipiIN': INprecipitation,
        //
        'pressHPA': HPApressure,
        'pressMB': MBpressure,
        //
        'clouds': cloudcoverage,
        'uvi': uvindex,
        //
        'sunrisetime':sunriseHrMin,
        'sunsettime':sunsetHrMin,
      };

      print('API getCURRENTweatherdata Response: ${response.body}');
      print('Function getCURRENTweatherdata map return: $currentweatherdata');

      //Enable this prints only for testing
      /*
      print("Latitude and longitude from getCURRENTweatherdata: ${currentweatherdata["coord"]}");

      print("UTC time: ${currentweatherdata["utctime"]}");
      print("Local time: ${currentweatherdata["localtime"]}");
      print("Required format date and time: ${currentweatherdata["formatdatetime"]}");
      print("Icon string: ${currentweatherdata["iconstr"]}");

      print("Kelvin K: ${currentweatherdata["Ktemp"]}");
      print("Fahrenheit F: ${currentweatherdata["Ftemp"]}");
      print("Celsius C: ${currentweatherdata["Ctemp"]}");

      print("Feels K: ${currentweatherdata["Ktempfeel"]}");
      print("Feels F: ${currentweatherdata["Ftempfeel"]}");
      print("Feels C: ${currentweatherdata["Ctempfeel"]}");

      print("Min K: ${currentweatherdata["Ktempmin"]}");
      print("Max K: ${currentweatherdata["Ktempmax"]}");
      print("Min F: ${currentweatherdata["Ftempmin"]}");
      print("Max F: ${currentweatherdata["Ftempmax"]}");
      print("Min C: ${currentweatherdata["Ctempmin"]}");
      print("Max C: ${currentweatherdata["Ctempmax"]}");

      print(
          "Weather condition: ${currentweatherdata["weathercond"]}");
      print("Pressure in hPa: ${currentweatherdata["pressHPA"]}");
      print("Pressure in mb: ${currentweatherdata["pressMB"]}");
      print("Clouds in %: ${currentweatherdata["clouds"]}");

      print("MPH: ${currentweatherdata["MPHwind"]}");
      print("KPH: ${currentweatherdata["KPHwind"]}");
      print(
          "Wind direction in degree: ${currentweatherdata["winddir"]}");
      print("MPH wind gust: ${currentweatherdata["MPHwindg"]}");
      print("KPH wind gust: ${currentweatherdata["KPHwindg"]}");

      print("Humidity in %: ${currentweatherdata["humid"]}");
      print(
          "Precipitation in MM: ${currentweatherdata["precipiMM"]}");
      print(
          "Precipitation in IN: ${currentweatherdata["precipiIN"]}");

      print("UV index: ${currentweatherdata["uvi"]}");

      print("Sunrise time: ${currentweatherdata["sunrisetime"]}");
      print("Sunset time: ${currentweatherdata["sunsettime"]}");
      */
    } else {
      // Display API error dialog
      showAPIerrordialog(context);
    }
  } catch (er) {
    // Handle any other exceptions
    print('Error: $er');

    //Display generic error dialog
    showGENERICerrordialog(context);
  }

  // Return the map of weather data
  return currentweatherdata;
}

//Function to get current weather alerts by latitude and longitude
Future<String> getCURRENTweatheralerts(
    BuildContext context, List<double> latlon,) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getCURRENTweatheralerts function executed------]");

  //Build the URL for the API call
  final url = Uri.parse(
      'https://api.openweathermap.org/data/3.0/onecall?lat=${latlon[0]}&lon=${latlon[1]}'
          '&exclude=current,minutely,hourly,daily&lang=en&appid=$OWeatherapikey');

  //Declare returning variable
  String event="No alerts today!!!";

  try{
    //Make API call
    final response = await http.get(url);

    //Check if the response is successful
    if (response.statusCode == 200) {

      //Parse the response body if so
      final APIdata = conv.jsonDecode(response.body);
      //Remove latitude and longitude
      APIdata.remove('lat');
      APIdata.remove('lon');

      //Validate API response
      if (!VALIDATEgetCURRENTweatheralerts(APIdata)){
        //Handle if API response is weird
        print("---API response is invalid, Stopping---");
        showAPIerrordialog(context);
        throw Exception('Invalid weather alerts data');
      }
      print("---API response is valid, proceeding---");
      print("API getCURRENTweatheralerts response: ${response.body}");

      //Extract wanted data
      if (APIdata['alerts'] != null && (APIdata['alerts'] as List).isNotEmpty){
        //Extract data
        event = APIdata['alerts'][0]['event'];
        print("Function String return: $event");

        //Limit the event variable to a maximum of 25 characters
        if (event.length > 25) {
          event = event.substring(0, 25);
        }

        return event;
      } else {

        //Handle case where no data is returned
        print("Function String return: $event");
        return event;
      }
    } else {
      //Display API error
      showAPIerrordialog(context);

      //Handle API problem
      throw Exception('Failed to load weather alerts');
    }

  } catch(er) {
    //Display generic error
    showGENERICerrordialog(context);

    //Handle any other errors
    print('Error: $er');
    throw Exception('Generic error ocurred');
  }
}

//Function to get daily max/min temp, hourly temp and icons
Future<Map<String, dynamic>> getWEEKLYHOURLYtempsicons(
    BuildContext context, List<double> latlon, int currentweekday) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getWEEKLYHOURLYtempsicons function executed------]");

  // Build URL using latitude and longitude
  final url = Uri.parse(
      'https://api.openweathermap.org/data/3.0/onecall?lat=${latlon[0]}&lon=${latlon[1]}&exclude=current,minutely&appid=$OWeatherapikey');

  // Declare returning variable (2 sections)
  Map<String, dynamic> weekhouricondata = {
    "daily": {},
    "hourly": {}
  };

  try {
    // Make API call
    final response = await http.get(url);

    //Check if API response is successful
    if (response.statusCode == 200) {
      //Parse the response body
      final APIdata = conv.jsonDecode(response.body);
      //Remove latitude and longitude
      APIdata.remove('lat');
      APIdata.remove('lon');

      //Validate API response
      if (!VALIDATEgetWEEKLYHOURLYtempsicons(APIdata)){
        //Handle if API is kind of weird
        print("---API response is invalid, Stopping---");
        showAPIerrordialog(context);
        throw Exception('Invalid weekly or hourly data');
      }
      print("---API response is valid, proceeding---");

      print("API getWEEKLYHOURLYtempsicons response: ${response.body}");
      final dailydata = APIdata['daily'];
      final hourlydata = APIdata['hourly'];

      //Process daily min/max temperatures and weather icons starting with current weekday
      for (int i = 0; i < dailydata.length; i++) {
        int dayindex = (currentweekday + i) % 7;
        double Kmintemp = dailydata[i]['temp']['min'].toDouble();
        double Kmaxtemp = dailydata[i]['temp']['max'].toDouble();
        double Fmintemp = (Kmintemp - 273.15) * 9 / 5 + 32;
        double Fmaxtemp = (Kmaxtemp - 273.15) * 9 / 5 + 32;
        double Cmintemp = Kmintemp - 273.15;
        double Cmaxtemp = Kmaxtemp - 273.15;
        String weathericon = dailydata[i]['weather'][0]['icon'];

        weekhouricondata['daily']['day${dayindex + 1}'] = {
          'Kmintemp': Kmintemp,
          'Kmaxtemp': Kmaxtemp,
          'Fmintemp': Fmintemp,
          'Fmaxtemp': Fmaxtemp,
          'Cmintemp': Cmintemp,
          'Cmaxtemp': Cmaxtemp,
          'icon': weathericon
        };

        //Enable this prints only for testing
        //Print the values being inserted for daily data
        /*
        print("Day ${dayindex + 1} "
            "Kmintemp: $Kmintemp, "
            "Kmaxtemp: $Kmaxtemp, "
            "Fmintemp: $Fmintemp, "
            "Fmaxtemp: $Fmaxtemp, "
            "Cmintemp: $Cmintemp, "
            "Cmaxtemp: $Cmaxtemp, "
            "icon: $weathericon");
         */
      } //Format is weekhouricondata['daily']['day1']['Cmintemp'];

      //Process hourly temperatures and weather icons for the next 24 hours
      for (int i = 0; i < 24; i++) {
        int hourIndex = (DateTime.now().hour + i) % 24;
        double Ktemp = (hourlydata[i]['temp'] as num).toDouble();
        double Ftemp = (Ktemp - 273.15) * 9 / 5 + 32;
        double Ctemp = Ktemp - 273.15;
        String weatherIcon = hourlydata[i]['weather'][0]['icon'];

        weekhouricondata['hourly']['hour${hourIndex + 1}'] = {
          'Ktemp': Ktemp,
          'Ftemp': Ftemp,
          'Ctemp': Ctemp,
          'icon': weatherIcon
        };

        //Enable this prints only for testing
        // Print the values being inserted for hourly data
        /*
        print("Hour ${hourIndex + 1} "
            "Ktemp: $Ktemp, "
            "Ftemp: $Ftemp, "
            "Ctemp: $Ctemp, "
            "icon: $weatherIcon");
        */
      } //Format is weekhouricondata['hourly']['hour1']['Ctemp'];
    } else {
      // Display API error
      showAPIerrordialog(context);

      // Handle API problem
      throw Exception('Failed to load weather alerts');
    }
  } catch (er) {
    // Display generic error
    showGENERICerrordialog(context);

    // Handle any other errors
    print('Error: $er');
    throw Exception('Generic error occurred');
  }

  //Return and print successful result
  print("getWEEKLYHOURLYtempsicons return value: $weekhouricondata");
  return weekhouricondata;
}

//Obtain city and country
Future<String> getcitycountry(
    BuildContext context, List<double> latlon) async {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getcitycountry function executed------]");

  //Build the URL for the reverse geocoding API call
  String url =
      'https://api.openweathermap.org/geo/1.0/reverse?'
      'lat=${latlon[0]}&lon=${latlon[1]}&limit=1&appid=$OWeatherapikey';

  try {
    //Make the API call
    final response = await http.get(Uri.parse(url));

    //Check if the response is successful
    if (response.statusCode == 200) {
      //Parse the response body
      List<dynamic> APIdata = conv.jsonDecode(response.body);
      //Remove latitude and longitude
      APIdata.remove('lat');
      APIdata.remove('lon');

      //Validate API response
      if (!VALIDATEgetcitycountry(APIdata)){
        //Handle if response is kinda weird
        print("---API response is invalid, Stopping---");
        showAPIerrordialog(context);
        throw Exception('Invalid city or country data');
      }
      print("---API response is valid, proceeding---");

      //Extract city and country from data in Json
      if (APIdata.isNotEmpty) {
        String city = APIdata[0]['name'];
        String country = APIdata[0]['country'];

        String citycountry = "$city, $country";

        print("API citycountry response: ${response.body}");
        print("Function citycountry string: $citycountry");

        //Return the formatted city and country string
        return citycountry;

      } else {
        //Display location not found dialog
        showLOCATIONnotfounddialog(context);

        //Handle case where no data is returned
        return 'Location not found';
      }
    } else {
      //Display API error dialog
      showAPIerrordialog(context);

      //Handle API error
      throw Exception('Failed to load location data');
    }
  } catch (er) {
    //Display Generic error dialog
    showGENERICerrordialog(context);

    // Handle any other errors
    print('Error: $er');
    return 'Error getting location';
  }
}

//Obtain date and time
Map<String, dynamic> getdatetimedata(BuildContext context) {
  print("[------------------------------------------------------------------------------------------------------------------------------------------------------------------]");
  print("[------getdatetimedata function executed------]");

  //Declare list of date and time data
  Map<String, dynamic> datetime = {};

  //Get current date and time
  DateTime datenowextracteddata = DateTime.now();

  //Define weekdays and months
  List<String> weekdays = ['', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> months = ['', 'January', 'February', 'March', 'April', 'May',
    'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  //Extract data components
  int daynum = datenowextracteddata.day;
  int weekdaynum = datenowextracteddata.weekday;
  String weekdaystr = weekdays[weekdaynum]; //From 1 to 7
  int monthnum = datenowextracteddata.month; //From 1 to 12
  String monthstr = months[monthnum];
  int currhour = datenowextracteddata.hour;
  String currminutes = datenowextracteddata.minute.toString().padLeft(2, '0'); // Pad minutes;
  int curryear = datenowextracteddata.year;

  //Insert extracted data
  datetime = {
    'daynum': daynum,
    'weekdaynum':weekdaynum,
    'weekdaystr': weekdaystr,
    'monthnum': monthnum,
    'monthstr': monthstr,
    'hour': currhour,
    'minutes': currminutes,
    'year': curryear,
  };

  //Add the next six days' weekday names
  for (int i = 1; i <= 6; i=i+1) {
    int futureweekday =
        (datenowextracteddata.weekday + i) % 7; //Go from the next day onwards

    futureweekday = futureweekday == 0 ? 7 : futureweekday; //Adjust for Sunday

    datetime['weekdaystr${i + 1}'] =
    weekdays[futureweekday]; //Insert future week day
    //Format= 'weekday2':weekdays[futureweekday], and so on
  }

  //Add the next 23 hours
  for (int i = 1; i <= 23; i=i+1) {
    int futureHour = (currhour + i) % 24; // Calculate the future hour
    datetime['hour${i + 1}'] = futureHour; // Insert future hour
    //Format= 'hour2': futureHour, and so on
  }

  print("Function gettimedate map return: $datetime");
  return datetime;
}

/////////////////////////////////////////////////////////////////////////////

//Data manipulation, retrieval and checking
//To capitalize the first letter of the strings
String capitalize(String input) {
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
String validateuserinput(BuildContext context,
    String givencityname) {
  print("[------validateuserinput function executed------]");
  if (givencityname == null || givencityname.isEmpty) {

    //Handle empty Text field
    showNOCITYORPOSTALCODEprovided(context);
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
    showNICETRYfed(context);
    print("Invalid user input");
    throw ArgumentError("Invalid input: Input does not meet criteria");
  }
}

//To convert icon codes into actual icons
IconData returnCORRECTiconforweather(String striconcode) {
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
String useapikey() {
  String? oWeatherApiKey = dotenv.env['OWeatherapikey'];
  if (oWeatherApiKey == null) {
    throw Exception('API key not found');
  }

  print("---API key succesfully retrieved---");
  //Return the API key
  return oWeatherApiKey;
}

//To validate API response for getCURRENTweatherdata
bool VALIDATEgetCURRENTweatherdata(Map<String, dynamic> data) {
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

//To validate API response for getCURRENTweatheralerts
bool VALIDATEgetCURRENTweatheralerts(Map<String, dynamic> data) {
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
bool VALIDATEgetWEEKLYHOURLYtempsicons(Map<String, dynamic> data) {
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
bool VALIDATEgetcitycountry(List<dynamic> data) {
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
void showLOCATIONdisableddialog(BuildContext context) {
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
      "Please enable location services to use GPS feature, "
          "turn on location services in your device settings",
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
void showACCESStogpsdenieddialog(BuildContext context) {
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
void showAPIerrordialog(BuildContext context) {
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

// Function to display generic error
void showGENERICerrordialog(BuildContext context) {
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
void showLOCATIONnotfounddialog(BuildContext context) {
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
void showINVALIDcityname(BuildContext context) {
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
void showNOCITYORPOSTALCODEprovided(BuildContext context) {
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
void showNICETRYfed(BuildContext context) {
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