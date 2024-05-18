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
        body: Column(
          //Alignment of the column
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          //Children of the column
          children: [
            //Ghost container for centering purposes
            Container(
              width: double.infinity,
            ),

            //TODO: See if its better to use gridview or list view
            //TODO: Use Padding() with containers to establish limits

            //Pad all containers to maintain consistency
            Padding(
              //Pad horizontal part of of inner column
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),

              //Containers being padded with inner column
              //TODO: check if Expanded can help with overflow problem
              child: Column(
                //Alignment within the inner column
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                //Children of inner column
                children: [
                  //User input Text field and search button
                  Container(
                    color: Colors.red,
                    height: 58,
                    width: double.infinity,

                    //Center input Test field and search button
                    child: Center(
                      //Use row to organize them horizontally
                      child: Row(
                        children: [
                          //Expand to ensure Text Field occupies all the
                          // available space
                          Expanded(
                            //input Text field
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey,
                                hintText: "Please enter city name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //Container to create frame
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),

                            height: 58,
                            width: 58,

                            //search Icon button
                            child: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                //TODO: insert functionality to update global variable and go to main page
                              },
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

                  //Suggestion cities
                  //"Suggestions" text
                  Container(
                    color: Colors.blue,
                    height: 25,
                    width: double.infinity,
                    child: Text("Suggestions:"),
                  ),

                  //Size box for spacing
                  SizedBox(
                    height: 5,
                  ),

                  //TODO: solve gridview

                  /*Cities
                  Container(
                    color: Colors.amber,
                    height: 58,
                    width: double.infinity,
                  ),
                  Container(
                    color: Colors.amber,
                    height: 58,
                    width: double.infinity,
                  ),
                  Container(
                    color: Colors.amber,
                    height: 58,
                    width: double.infinity,
                  ),
                  Container(
                    color: Colors.amber,
                    height: 58,
                    width: double.infinity,
                  ),*/
                ],
              ),
            ),
          ],
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
                  icon:
                      Icon(Icons.info_outline),
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

/*Button bar with search and return buttons MAY NOT BE USED
//TODO: decide where to but the buttonbar
ButtonBar(
mainAxisSize: MainAxisSize.min,
children: [
ElevatedButton.icon(
icon: Icon(Icons.search),
label: Text("Seach"),
onPressed: () {
//TODO: insert functionality to update global variable and go back to main page
},
),
ElevatedButton.icon(
icon: Icon(Icons.cancel_outlined),
label: Text("Return"),
onPressed: () {
//TODO: insert functionality to go back to main page only
},
)
],
),*/
