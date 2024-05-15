import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
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
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        //Background main color TODO: REMOVE COMMENT TO ENABLE
        //backgroundColor: Color.fromRGBO(35, 22, 81, 1.0), decide color

        //Appbar only with the name of the app
        appBar: AppBar(
          //Make appbar background translucent
          backgroundColor: Colors.transparent,

          title: Align(
            //Align the title in a certain way
            alignment: Alignment.bottomLeft, //TODO:Decide alignment

            child: Text(
              "ForKast",
              style: GoogleFonts.pressStart2p(
                textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.black, //TODO: change to white after background
                ),
              ),
            ),
          ),
        ),

        //

        //Main content of the page
        body: Column(
          children: [
            Container(
              child: Text("body with only a text"),
            ),
          ],
        ),

        //

        //Bottom navigation bar
        bottomNavigationBar: BottomAppBar(
          //Main color TODO: REMOVE COMMENT TO ENABLE
          //color: Color.fromRGBO(35, 22, 81, 1.0),

          //Use a container to manipulate the size of the row
          child: Row(
            //Alignment within the row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            //Children
            children: [
              //Left most container (leftmost button)
              Container(
                color: Colors.amber,
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //color: Color.fromRGBO(119, 224, 216, 0.8), decide which color
                  icon: Icon(Icons.question_mark), //Which page does this go???
                  onPressed: () {
                    //TODO: insert here functionality to go to other page
                  },
                ),
              ),

              //Center container (main button)
              Container(
                color: Colors.amber,
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //color: Color.fromRGBO(119, 224, 216, 1.0), decide which color
                  icon: Icon(Icons.home_filled),
                  onPressed: () {
                    //No functionality because this is the button for this page
                  },
                ),
              ),

              //Right most container (rightmost button)
              Container(
                color: Colors.amber,
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //color: Color.fromRGBO(119, 224, 216, 0.8), decide which color
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //TODO: insert here funcionality to go to search page
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
