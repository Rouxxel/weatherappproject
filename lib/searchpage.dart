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
                //color: Colors.brown,
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
                            hintStyle: GoogleFonts.quantico(
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

              //"Suggestions" text
              Container(
                //color: Colors.black,
                height: 40,
                width: double.infinity,
                child: Padding(
                  //Move text a little offset to the right
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    //Bound text to always be center left
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Suggestions:",
                      style: GoogleFonts.quantico(
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

              //Container for list view of suggestions
              Expanded(
                child: Container(
                  //Round up container's edges
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(214, 255, 246, 0.15),
                  ),

                  child: Padding(
                    //Pad all sides evenly
                    padding: EdgeInsets.all(20),

                    //Use list view to create a scrollable options
                    child: ListView(
                      children: [
                        //Suggestion 1
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align Column of children to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Column(
                                //Ensure content aligns to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                //Children that shows options
                                children: [
                                  Text(
                                    "19\u00B0",
                                    style: GoogleFonts.sansita(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Hamburg, Germany",
                                    style: GoogleFonts.quantico(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 2
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Column(
                                //Ensure content aligns to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "23\u00B0",
                                    style: GoogleFonts.sansita(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Paris, France",
                                    style: GoogleFonts.quantico(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 3
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Column(
                                //Ensure content aligns to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "9\u00B0",
                                    style: GoogleFonts.sansita(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Shenzhen, China",
                                    style: GoogleFonts.quantico(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 4
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Column(
                                //Ensure content aligns to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "13\u00B0",
                                    style: GoogleFonts.sansita(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Tokyo, Japan",
                                    style: GoogleFonts.quantico(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 5
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Column(
                                //Ensure content aligns to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "10\u00B0",
                                    style: GoogleFonts.sansita(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "London, England",
                                    style: GoogleFonts.quantico(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //

        //Bottom navigation bar
        bottomNavigationBar: BottomAppBar(
          //Main color
          color: const Color.fromRGBO(35, 22, 81, 1.0),

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
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => detailspage(),
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
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.home_outlined),
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
                  color: const Color.fromRGBO(140, 127, 186, 1.0),
                  icon: const Icon(Icons.search),
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