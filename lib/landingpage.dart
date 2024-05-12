import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  //For font import
import 'package:geolocator/geolocator.dart';      //For GPS function
import 'package:url_launcher/url_launcher.dart';  //For URL launch
import 'package:http/http.dart';                  //For http resources

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-methods

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
          child: Text("body with only a text"),
        ),
      ),
    );
  }
}
