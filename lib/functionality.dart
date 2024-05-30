import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing
import 'package:google_fonts/google_fonts.dart'; //For font import

//GPS information
bool gpsaccess = false;

//API key and other variables
String OWeatherapikey = "809ed526e7c4e8e434c7f931a2e54742";

//To get API data with city name Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&exclude=minutely,alerts&appid=$apikey)'
//To get API data with latitude and longitude Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apikey)'

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//GPS related
//Request GPS permission and get it if given (MUST BE EXECUTED FIRST)
Future<void> getgpspermission(BuildContext context) async {
  //Check if device has location active and prevent execution if disabled
  bool locationservice = await Geolocator.isLocationServiceEnabled();
  if (!locationservice) {
    //Show user their location is disabled
    showLOCATIONdisableddialog(context);
    gpsaccess = false;

    return Future.error("Location service is disabled");
  }

  //Permission variable
  LocationPermission permission = await Geolocator.checkPermission();

  //Ask the user for permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
      gpsaccess = false;
      return Future.error("GPS permissions denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    //Handle permanently denied permission
    gpsaccess = false;
    return Future.error("GPS permissions permanently denied");
  }

  gpsaccess = true;
}

//Function to get GPS location and return as a list
Future<List<double>> getgpslocation(BuildContext context) async {
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

      print("Latitude and Longitude: $coordinates");
    } else {
      //Handle access denied situation
      showACCESStogpsdenieddialog(context);
    }
  } catch (er) {
    //Handle error situation
    showGENERICerrordialog(context);
    print("Error getting location: $er");
  }

  //Return the list of coordinates
  return coordinates;
}

//

//API and data extraction
//Get current weather data by either latitude and longitude or city name
Future<Map<String, dynamic>> getCURRENTweatherdata({
  required BuildContext context,
  String? cityname,
  List<double>? latlon,
}) async {
  // Determine the type of request
  String url;

  if ((cityname != null) && (latlon != null)) {
    // If both are provided, throw an error
    throw ArgumentError('Do not provide both latitude-longitude and city name');
  } else if (cityname != null) {
    // Use city name to build the URL
    url =
    'https://api.openweathermap.org/data/2.5/weather?q=$cityname&exclude=minutely,alerts&appid=$OWeatherapikey';

  } else if (latlon != null) {
    // Use latitude and longitude to build the URL
    url =
    'https://api.openweathermap.org/data/2.5/weather?lat=${latlon[0]}&lon=${latlon[1]}&exclude=minutely,alerts&appid=$OWeatherapikey';
  } else {
    // If neither is provided, throw an error
    throw ArgumentError(
        'Either city name or both latitude and longitude must be provided.');
  }

  // Map to store the extracted weather data
  Map<String, dynamic> currentweatherdata = {};

  // Try to obtain API call from URL
  try {
    // Make API call
    final response = await http.get(Uri.parse(url));

    // Check response success
    if (response.statusCode == 200) {
      // Parse response if response is successful
      Map<String, dynamic> APIdata = conv.jsonDecode(response.body);

      // Extract and store CURRENT weather data
      //Temperature
      double Ktemperature = APIdata['main']['temp'];
      double Ftemperature = (Ktemperature - 273.15) * 9 / 5 + 32;
      double Ctemperature = Ktemperature - 273.15;

      //Feels like temperature
      double Kfeelslike = APIdata['main']['feels_like'];
      double Ffeelslike = (Kfeelslike - 273.15) * 9 / 5 + 32;
      double Cfeelslike = Kfeelslike - 273.15;

      //Weather condition
      String wcondition = APIdata['weather'][0]['description'];
      double HPApressure = APIdata['main']['pressure'].toDouble();
      double MBpressure = HPApressure / 100.0;;
      int cloudcoverage =
      APIdata.containsKey('clouds') ? APIdata['clouds']['all'] : 0;

      //Wind information
      double MPHwindspeed = APIdata['wind']['speed'].toDouble();
      double KPHwindspeed = MPHwindspeed * 1.60934;
      int winddirection = APIdata['wind']['deg'].toInt();

      //Water related things
      int humidity = APIdata['main']['humidity'];

      //Precipitation is a real pain in the spine
      double MMprecipitation = 0.0;

      // Check if there's rain data
      if (APIdata.containsKey('rain') && APIdata['rain'].containsKey('1h')) {
        MMprecipitation = APIdata['rain']['1h'].toDouble();
      }
      // Check if there's snow data (and add it to the rain data if both are present)
      if (APIdata.containsKey('snow') && APIdata['snow'].containsKey('1h')) {
        MMprecipitation =  MMprecipitation + APIdata['snow']['1h'].toDouble();
      }

      double INprecipitation = MMprecipitation * 0.0393701; // 1 mm = 0.0393701 inches

      //UV index
      double uvindex =
      APIdata.containsKey('uvi') ? APIdata['uvi'].toDouble() : 0.0;

      // Add extracted data to the CURRENT section of the map
      currentweatherdata["current"] = {
        'Ktemp': Ktemperature,
        'Ftemp': Ftemperature,
        'Ctemp': Ctemperature,
        'Ktempfeel':Kfeelslike,
        'Ftempfeel':Ffeelslike,
        'Ctempfeel':Cfeelslike,
        'weathercond': wcondition,
        'MPHwind': MPHwindspeed,
        'KPHwind': KPHwindspeed,
        'winddir' : winddirection,
        'humid': humidity,
        'pressHPA': HPApressure,
        'pressMB' : MBpressure,
        'clouds': cloudcoverage,
        'precipiMM': MMprecipitation,
        'precipiIN':INprecipitation,
        'uvi' : uvindex,
      };

      //TODO: delete all prints once finished with the function
      print("Kelvin K: ${currentweatherdata["current"]["Ktemp"]}");
      print("Fahrenheit F: ${currentweatherdata["current"]["Ftemp"]}");
      print("Celsius C: ${currentweatherdata["current"]["Ctemp"]}");

      print("Feels K: ${currentweatherdata["current"]["Ktempfeel"]}");
      print("Feels F: ${currentweatherdata["current"]["Ftempfeel"]}");
      print("Feels C: ${currentweatherdata["current"]["Ctempfeel"]}");

      print("Weather condition: ${currentweatherdata["current"]["weathercond"]}");
      print("Pressure in hPa: ${currentweatherdata["current"]["pressHPA"]}");
      print("Pressure in mb: ${currentweatherdata["current"]["pressMB"]}");
      print("Clouds in %: ${currentweatherdata["current"]["clouds"]}");

      print("MPH: ${currentweatherdata["current"]["MPHwind"]}");
      print("KPH: ${currentweatherdata["current"]["KPHwind"]}");
      print("Wind direction in degree: ${currentweatherdata["current"]["winddir"]}");

      print("Humidity in %: ${currentweatherdata["current"]["humid"]}");
      print("Precipitation in MM: ${currentweatherdata["current"]["precipiMM"]}");
      print("Precipitation in IN: ${currentweatherdata["current"]["precipiIN"]}");

      print("UV index: ${currentweatherdata["current"]["uvi"]}");

    } else {
      // Display API error dialog
      showAPIerrordialog(context);
    }
  } catch (er) {
    // Handle any other exceptions
    print('Error: $er');

    // Display generic error dialog
    showGENERICerrordialog(context);
  }

  // Return the map of weather data
  return currentweatherdata;
}

//Obtain city and country TODO: add get data based on city name
Future<String> getcitycountry(BuildContext context, List<double> latlon) async {
  // Build the URL for the reverse geocoding API call
  String url =
      'http://api.openweathermap.org/geo/1.0/reverse?lat=${latlon[0]}&lon=${latlon[1]}&limit=1&appid=$OWeatherapikey';

  try {
    //Make the API call
    final response = await http.get(Uri.parse(url));

    //Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the response body
      List<dynamic> responseData = conv.jsonDecode(response.body);

      //Extract city and country from data in Json
      if (responseData.isNotEmpty) {
        String city = responseData[0]['name'];
        String country = responseData[0]['country'];

        String citycountry = "$city, $country";

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
Map<String,dynamic> getdatetimedata(BuildContext context){
  //Declare list of date and time data
  Map<String, dynamic> datetime = {};

  //Get current date and time
  DateTime datenowextracteddata = DateTime.now();

  // Define weekdays and months
  List<String> weekdays = ['','Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday','Sunday'];
  List<String> months = ['','January', 'February', 'March', 'April', 'May',
    'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  //Extract data components
  int daynum = datenowextracteddata.day;
  String weekdaystr = weekdays[datenowextracteddata.weekday]; //From 1 to 7
  int monthnum = datenowextracteddata.month; //From 1 to 12
  String monthstr= months[monthnum];
  int hour = datenowextracteddata.hour;
  int minutes = datenowextracteddata.minute;
  int year = datenowextracteddata.year;

  //TODO: remove prints after finished with function
  print("Day number: $daynum");
  print("Weekday: $weekdaystr");
  print("Month number: $monthnum");
  print("Month: $monthstr");
  print("Current hour: $hour");
  print("Current minutes: $minutes");
  print("Year number: $year");

  //Insert extracted data
  datetime = {
    'daynum':daynum,
    'weekdaystr':weekdaystr,
    'monthnum':monthnum,
    'monthstr':monthstr,
    'hour':hour,
    'minutes':minutes,
    'year':year,
  };

  //Add the next six days' weekday names
  for (int i = 1; i <= 6; i++) {
    int futureweekday = (datenowextracteddata.weekday + i) % 7; //Go from the next day onwards

    futureweekday = futureweekday == 0 ? 7 : futureweekday; //Adjust for Sunday

    datetime['weekdaystr${i + 1}'] = weekdays[futureweekday];//Insert future week day
    //Format: 'weekday2':weekdays[futureweekday],
  }

  return datetime;
}

//

//Data manipulation
//To capitalize the first letter of the strings
String capitalize(String input) {
  if (input == null || input.isEmpty) {
    return input;
  }
  return input.split(' ').map((word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

//

//Alert dialog for error handling
// Function to display the location is disabled in the device
void showLOCATIONdisableddialog(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
    backgroundColor: Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services disabled",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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
    backgroundColor: Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Location services access denied",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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
    backgroundColor: Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "API or parsing Error",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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

// Function to generic error
void showGENERICerrordialog(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
    backgroundColor: Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: Generic error",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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

// Function to generic error
void showLOCATIONnotfounddialog(BuildContext context) {
  //Declare the buttons of alert
  Widget okbutton = TextButton(
    child: Text(
      "Ok",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
    backgroundColor: Color.fromRGBO(35, 22, 81, 1),
    title: Text(
      "Error: Location error",
      style: GoogleFonts.quantico(
        textStyle: TextStyle(
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
        textStyle: TextStyle(
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
