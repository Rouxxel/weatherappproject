import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:intl/intl.dart'; //For getting date and time

//GPS information
bool gpsaccess = false;

//API key and other variables
String apikey = "809ed526e7c4e8e434c7f931a2e54742";

//To get API data with city name Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&exclude=minutely,alerts&appid=$apikey)'
//To get API data with latitude and longitude Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apikey)'

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//GPS related
//Request GPS permission and get it if given (MUST BE EXECUTED FIRST)
Future<void> getgpspermission(BuildContext context) async {
  // Check if device has location active and prevent execution if disabled
  bool locationservice = await Geolocator.isLocationServiceEnabled();
  if (!locationservice) {
    //Show user their location is disabled
    showLOCATIONdisableddialog(context);
    gpsaccess = false;

    return Future.error("Location service is disabled");
  }

  // Permission variable
  LocationPermission permission = await Geolocator.checkPermission();

  // Ask the user for permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
      gpsaccess = false;
      return Future.error("GPS permissions denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Handle permanently denied permission
    gpsaccess = false;
    return Future.error("GPS permissions permanently denied");
  }

  gpsaccess = true;
}

// Function to get GPS location and return as a list
Future<List<double>> getgpslocation(BuildContext context) async {
  //Create empty list for latitude and longitude
  List<double> coordinates = [];
  try {
    // Check if GPS access is granted
    if (gpsaccess == true) {
      // Get the current position with low accuracy
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      // Assign the latitude and longitude to the list
      coordinates = [position.latitude, position.longitude];

      print("Latitude and Longitude: $coordinates");
    } else {
      // Handle access denied situation
      showACCESStogpsdenieddialog(context);
    }
  } catch (er) {
    // Handle error situation
    showGENERICerrordialog(context);
    print("Error getting location: $er");
  }

  // Return the list of coordinates
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
        'https://api.openweathermap.org/data/2.5/weather?q=$cityname&exclude=minutely,alerts&appid=$apikey';
  } else if (latlon != null) {
    // Use latitude and longitude to build the URL
    double lat = latlon[0];
    double lon = latlon[1];

    url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&exclude=minutely,alerts&appid=$apikey';
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
      Map<String, dynamic> data = conv.jsonDecode(response.body);

      /// Extract and store weather data
      double Ktemperature = data['main']['temp'];
      double Ftemperature = (Ktemperature - 273.15) * 9 / 5 + 32;
      double Ctemperature = Ktemperature - 273.15;

      String wcondition = data['weather'][0]['description'];

      double MPHwindspeed = data['wind']['speed'].toDouble();
      double KPHwindspeed = MPHwindspeed * 1.60934;
      int humidity = data['main']['humidity'];
      double precipitation =
          data.containsKey('rain') ? data['rain']['1h'].toDouble() : 0.0;

      //int currentClouds = data['current']['clouds'];
      //int pressure = data['current']['pressure'];

      // Add extracted data to the map
      currentweatherdata = {
        'Ktemp': Ktemperature,
        'Ftemp': Ftemperature,
        'Ctemp': Ctemperature,
        'weathercond': wcondition,
        'MPHwind': MPHwindspeed,
        'KPHwind': KPHwindspeed,
        'humid': humidity,
        'precipi': precipitation,
        //'clouds': currentClouds,
        //'press': pressure,
      };

      print(currentweatherdata);
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
