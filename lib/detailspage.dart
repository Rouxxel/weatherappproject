import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing
//TODO:determine if all of these imports are truly necessary for this page

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/searchpage.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself

class details extends StatelessWidget {
  const details({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: Color.fromRGBO(35, 22, 81, 0.85),

        //Appbar only with the name of the app
        appBar: AppBar(
          //Make appbar background translucent
          backgroundColor: Colors.transparent,

          title: Align(
            //Align the title in a certain way
            alignment: Alignment.centerLeft,

            child: Text(
              "ForKast",
              style: GoogleFonts.pressStart2p(
                textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        //

        //Main content of the page
        body: Column(
          //Alignment of the column
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          //Children of the column
          children: [],
        ),

        //

        //Bottom navigation bar
        bottomNavigationBar: BottomAppBar(
          //Main color
          color: Color.fromRGBO(35, 22, 81, 1.0),

          //Use a container to manipulate the size of the row
          child: Row(
            //Alignment within the row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            //Children
            children: [
              //Left most container (leftmost button)
              Container(
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //TODO: DECIDE ICON COLORS
                  color: Color.fromRGBO(140, 127, 186, 1.0),
                  icon:
                  Icon(Icons.info),
                  onPressed: () {
                    //No functionality here because this is the page
                  },
                ),
              ),

              //Center container (main button)
              Container(
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //TODO: DECIDE ICON COLORS
                  color: Color.fromRGBO(140, 127, 186, 0.5),
                  icon: Icon(Icons.home_outlined),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => landingpage(),
                      ),
                    );
                  },
                ),
              ),

              //Right most container (rightmost button)
              Container(
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  //TODO: DECIDE ICON COLORS
                  color: Color.fromRGBO(140, 127, 186, 0.5),
                  icon: Icon(Icons.search_outlined),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => searchpage(),
                      ),
                    );
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