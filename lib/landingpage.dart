import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:url_launcher/url_launcher.dart'; //For URL launch
import 'package:http/http.dart'; //For http resources

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

bool gpspermission = false;

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//alert dialog for user permission for gps
void showalertfunc(BuildContext context) {
  //Buttons in alert
  Widget acceptbutton = TextButton(
    child: Text("Accept"),
    onPressed: () {
      gpspermission = true;
      print(gpspermission);
      getgpspermission(context);
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget denybutton = TextButton(
    child: Text("Deny"),
    onPressed: () {
      gpspermission = false;
      print(gpspermission);
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  //Alert itself
  var alertbox = AlertDialog(
    title: Text("GPS access permission"),
    content: Text("To get the weather information from your location "
        "the app need your permission"),
    actions: [acceptbutton, denybutton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertbox;
    },
  );
}

//Request GPS permission
Future<void> getgpspermission(BuildContext context) async {
  //Check if device has location active and prevent execution if disabled
  bool locationservice= await Geolocator.isLocationServiceEnabled();
  if (locationservice !=true){
    print("Location in device is disabled");
    return; //TODO: add alertdialog when device's location is disabled
  }

  //Permission var
  LocationPermission permission = await Geolocator.checkPermission();

  //Ask the user for permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //Handle denied permission
      return Future.error("GPS permissions denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    //Handle permanently denied permission
    return Future.error("GPS permissions permanently denied denied");
  }


}

/*
//Get location function
Future<void> getlocation() async {
  double longit;
  double latit;

  Position userposition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.lowest);

  print(
      'Latitude: ${userposition.latitude}, Longitude: ${userposition.longitude}');
}
*/
//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself
class landingpage extends StatelessWidget {
  const landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("app bar with only a title"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: Text("body with only a text"),
              ),
              ElevatedButton(
                child: Text("Test alert and location"),
                onPressed: () {
                  showalertfunc(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}