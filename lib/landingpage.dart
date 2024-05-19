import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing

//Other pages import
import 'package:weatherappproject/searchpage.dart';
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
class landingpage extends StatelessWidget {
  const landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height MAY NOT BE USED
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: Color.fromRGBO(35, 22, 81, 0.85), //decide color

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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          // EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 40.0), //Maybe

          //Central column
          child: Column(
            //Alignment of the column
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,

            //Children of the column
            children: [
              //Top container (middle height)
              Container(
                color: Colors.amber,
                width: 270,
                height: 240,
                child: Padding(
                  //Pad only left and right inside container
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),

                  child: Column(
                    //Alignment of the inner column
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //Children
                    children: [
                      //Top text with location icon
                      Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: 30,

                        //Row to organize text with icon
                        child: Row(
                          //Alignment of inner row
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            Icon(Icons.location_on),
                            Text(
                                "Berlin, Germany"), //TODO: insert here function to get city and country
                          ],
                        ),
                      ),

                      //Subtext of top text
                      Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: 30,
                        child: Center(
                          child: Text(
                              "Monday 1, January 7:00 am"), //TODO: insert here function to get date and time
                        ),
                      ),

                      //Big temperature text
                      Container(
                        color: Colors.greenAccent,
                        width: double.infinity,
                        height: 140,
                        child: Center(
                          child: Text(
                              "23"), //TODO: insert here function to get temp
                        ),
                      ),

                      //Subtext of Big temperature text
                      Container(
                        color: Colors.pink,
                        width: double.infinity,
                        height: 30,
                        child: Center(
                          child: Text(
                              "Cloudy"), //TODO: insert here function to get weather condition
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Middle container (Least height and max width)
              Container(
                color: Colors.amber,
                width: double.infinity,
                height: 140,

                //Center the Row for the 3 containers
                child: Center(
                  child: Row(
                    //Alignment of the row
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //Children
                    children: [
                      //Precipitation container (leftmost)
                      Container(
                        color: Colors.blue,
                        width: 120,
                        height: 120,

                        //Inner column
                        child: Column(
                          //Column alignment
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            Icon(Icons.umbrella),
                            Text("30%"), //TODO: insert function to get precipitation
                            Text("Precipitation"),
                          ],
                        ),
                      ),
                      //Humidity container (central)
                      Container(
                        color: Colors.red,
                        width: 120,
                        height: 120,

                        //Inner column
                        child: Column(
                          //Column alignment
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            Icon(Icons.water_drop),
                            Text("20%"), //TODO: insert function to get humidity
                            Text("Humidity"),
                          ],
                        ),
                      ),
                      //Windspeed container (rightmost)
                      Container(
                        color: Colors.lightGreenAccent,
                        width: 120,
                        height: 120,

                        //Inner column
                        child: Column(
                          //Column alignment
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            Icon(Icons.wind_power),
                            Text(
                                "15 km/h"), //TODO: insert function to get wind speed
                            Text("Wind speed"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Bottom container (Highest height and max width)
              Container(
                color: Colors.amber,
                width: double.infinity,
                height: 335,
                child: Padding(
                  //Padding for the column within the container
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),

                  //Column with inner containers
                  child: Column(
                    //Alignment within the inner Column
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //Children of inner column
                    children: [
                      //Options (Hourly-Daily)
                      Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: 80,

                        //Use row to organize elevated buttons
                        child: Row(
                          //Alignment in inner row
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            //Hourly button
                            ElevatedButton(
                              child: Text("Hourly"),
                              onPressed: () {
                                //TODO: insert functionaly to change to hourly format
                              },
                            ),

                            //Daily button
                            ElevatedButton(
                              child: Text("Daily"),
                              onPressed: () {
                                //TODO: insert functionaly to change to daily format
                              },
                            )
                          ],
                        ),
                      ),

                      //Results of selected option
                      Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: 190,

                        //Pad all size evenly
                        child: Padding(
                          padding: EdgeInsets.all(10),

                          //Insert list of results
                          child: Column(
                            //Alignment in the inner column
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            //Children
                            children: [
                              //Today container
                              Container(
                                color: Colors.greenAccent,
                                width: double.infinity,
                                height: 50,

                                //Pad all sides evenly
                                child: Padding(
                                  padding: EdgeInsets.all(6),

                                  //Use row to organizer 3 widgets
                                  child: Row(
                                    //Alignment in inner row
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    //3 widget children
                                    children: [
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("Today"),
                                        ),
                                      ),
                                      Icon(Icons.cloud_sharp),
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("12 - 22"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Next day container
                              Container(
                                color: Colors.purple,
                                width: double.infinity,
                                height: 50,

                                //Pad all sides evenly
                                child: Padding(
                                  padding: EdgeInsets.all(6),

                                  //Use row to organizer 3 widgets
                                  child: Row(
                                    //Alignment in inner row
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,

                                    //3 widget children
                                    children: [
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("Mon"),
                                        ),
                                      ),
                                      Icon(Icons.cloud_sharp),
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("14 - 25"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Next-next day container
                              Container(
                                color: Colors.deepOrangeAccent,
                                width: double.infinity,
                                height: 50,

                                //Pad all sides evenly
                                child: Padding(
                                  padding: EdgeInsets.all(6),

                                  //Use row to organizer 3 widgets
                                  child: Row(
                                    //Alignment in inner row
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,

                                    //3 widget children
                                    children: [
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("Tues"),
                                        ),
                                      ),
                                      Icon(Icons.cloud_sharp),
                                      Container(
                                        color: Colors.teal,
                                        width: 150,
                                        height: double.infinity,
                                        child: Center(
                                          child: Text("13 - 18"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
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
                  color: Color.fromRGBO(140, 127, 186, 1.0),
                  icon: Icon(Icons.home),
                  onPressed: () {
                    //No functionality here because this is the page
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
                    //Use navigator to go to the search page
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
