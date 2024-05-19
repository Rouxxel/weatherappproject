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
import 'package:weatherappproject/detailspage.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself

class searchpage extends StatelessWidget {
  const searchpage({super.key});

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
        //Pad column to maintain consistency
        body: Padding(
          //Pad horizontal part of of inner column
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),

          //Central column
          child: Column(
            //Alignment of the column
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            //Children of the column
            children: [
              //Container for User input
              Container(
                height: 58,
                width: double.infinity,

                //Center input Text field and search button
                child: Center(
                  //Use row to organize them horizontally
                  child: Row(
                    children: [
                      //Expand to ensure Text Field occupies all the
                      //available space
                      Expanded(
                        //input Text field
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(77, 204, 189, 0.4),
                            hintText: "Search city by name...",
                            hintStyle: GoogleFonts.ptSerif(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),

                          //Align text to always be in center-left
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),

                      //Container to create frame for Search icon button
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(77, 204, 189, 0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),

                        height: 58,
                        width: 58,

                        //search Icon button
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.search),
                            alignment: Alignment.center,
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: () {
                              //TODO: insert functionality to search based on city name and go to main page
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Size box for spacing
              SizedBox(
                height: 5,
              ),

              //"Suggestions" text
              Container(
                height: 40,
                width: double.infinity,
                child: Padding(
                  //Move text a little offset to the right
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    //Bound text to always be center left
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Suggestions:",
                      style: GoogleFonts.ptSerif(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //Size box for spacing
              SizedBox(
                height: 5,
              ),

              //TODO: find a way to solve renderer overflowing problem to enable a listview or gridview
              Container(
                color: Colors.white,
                width: double.infinity,
                height: 500,
                child: Center(
                  child: Text(
                      "Here is supposed to be an scrollable listview, but the overflow problem difficults things"),
                ),
              ),
            ],
          ),
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
                  color: Color.fromRGBO(140, 127, 186, 0.5),
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => details(),
                      ),
                    );
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
                  color: Color.fromRGBO(140, 127, 186, 1.0),
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //No functionality here because this is the page
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
