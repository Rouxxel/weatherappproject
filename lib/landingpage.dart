import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as gfont; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

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
            ],
          ),
        ),
      ),
    );
  }
}
