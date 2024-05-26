import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:icons_flutter/icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing

//Other pages import
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/detailspage.dart';
import 'package:weatherappproject/functionality.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself
class landingpage extends StatefulWidget {
  const landingpage({super.key});

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
  @override
  Widget build(BuildContext context) {

    //Get permission right away
    getgpspermission(context);

    /*List<double> listlatlon=await getgpslocation(context);

    Map<String, dynamic> currweathlist= await getCURRENTweatherdata(
        context: context,latlon: listing);*///

    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: const Color.fromRGBO(35, 22, 81, 0.85), //decide color

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
                textStyle: const TextStyle(
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
        //Pad listview to maintain consistency
        body: Padding(
          //Pad everything in the body (in this case a list view)
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),

          //Align everything in the body to the Top center
          child: Align(
            alignment: Alignment.topCenter,

            //Use listview to avoid Render overflow
            child: ListView(
              //Only if it is necessary to go back to column
              /*//Alignment of the column
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,*/

              //Children of the listview
              children: [
                //Top container (middle height)
                Container(
                  //color: Colors.brown,
                  height: 240,
                  child: Padding(
                    //Pad only left and right inside container
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 75),

                    //Inner column (in case of needing a background, use container)
                    child: Column(
                      //Alignment of the inner column
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      //Children
                      children: [
                        //Top text with location icon
                        Row(
                          //Alignment of inner row (maybe put inside a container
                          //with width: 260, height: 30,)
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          //Children
                          children: [
                            Icon(
                              Icons.location_on, //Maybe my_location of package
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              "Berlin, Germany", //TODO: insert here function to get city and country
                              style: GoogleFonts.quantico(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //Subtext of top text (maybe punt in a container with
                        //width: 260, height: 18,)
                        Center(
                          child: Text(
                            "Monday 1, January 7:00 am", //TODO: insert here function to get date and time
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Big temperature text (Do not remove expanded or container)
                        Expanded(
                          child: Container(
                            //color: Colors.greenAccent,
                            width: 260,
                            height: 140,
                            child: Center(
                              child: Text(
                                "23\u00B0",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sansita(
                                  textStyle: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //Subtext of Big temperature text (maybe out in a
                        //container with width: 260,height: 26,)
                        Center(
                          child: Text(
                            "Cloudy", //TODO: insert here function to get weather condition
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
                      ],
                    ),
                  ),
                ),

                //Sized box for spacing
                SizedBox(
                  height: 20,
                ),

                //Middle container (Least height and max width)
                Container(
                  //Round up container's edges
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(214, 255, 246, 0.15),
                  ),
                  height: 145,

                  //Center the Row for the 3 containers (Maybe wrap with Center)
                  child: Row(
                    //Alignment of the row
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //Children
                    children: [
                      //Precipitation container (leftmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            FontAwesome.umbrella,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "30%", //TODO: insert function to get precipitation
                            style: GoogleFonts.sansita(
                              textStyle: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Precipitation",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Humidity container (central), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            Icons.water_drop, //maybe Entypo.water of package
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "20%",
                            style: GoogleFonts.sansita(
                              textStyle: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Humidity", //TODO: insert function to get humidity
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Wind speed container (rightmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            Icons.wind_power_rounded,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "15 KMH", //TODO: insert function to get wind speed
                            style: GoogleFonts.sansita(
                              textStyle: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Wind speed",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Sized box for spacing
                SizedBox(
                  height: 20,
                ),

                //Bottom container (Highest height and max width)
                Container(
                  //Round up container's edges
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(214, 255, 246, 0.15),
                  ),
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
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(35, 22, 81, 0.3),
                          ),
                          height: 75,
                          width: double.infinity,

                          //Use row to organize elevated buttons
                          child: Row(
                            //Alignment in inner row
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            //Children
                            children: [
                              //Hourly button
                              ElevatedButton(
                                //Manipulate button size
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 45),
                                  backgroundColor:
                                  Color.fromRGBO(35, 22, 81, 1.0),
                                  //TODO: insert function to update color
                                ),

                                child: Text(
                                  "Hourly",
                                  style: GoogleFonts.quantico(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                onPressed: () {
                                  //TODO: insert functionaly to change to hourly format
                                },
                              ),

                              //Daily button
                              ElevatedButton(
                                //Manipulate button size
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 45),
                                  backgroundColor:
                                  Color.fromRGBO(77, 204, 189, 1.0),
                                ),

                                child: Text(
                                  "Daily",
                                  style: GoogleFonts.quantico(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Color.fromRGBO(35, 22, 81, 1.0),
                                      //TODO: insert function to update color
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  //TODO: insert functionaly to change to daily format
                                },
                              )
                            ],
                          ),
                        ),

                        //Results of selected option
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(35, 22, 81, 0.3),
                          ),
                          width: double.infinity,
                          height: 190,

                          //Pad all size evenly
                          child: Padding(
                            padding: EdgeInsets.all(10),

                            //Insert list of results (maybe a list view)
                            //TODO: Decide if show only 3 days or full week
                            child: Column(
                              //Alignment in the inner column
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              //Children
                              children: [
                                //Today container
                                Container(
                                  //Round up container's edge
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(77, 204, 189, 0.7),
                                  ),
                                  width: double.infinity,
                                  height: 50,

                                  //Pad all sides evenly
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),

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
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Today",
                                              style: GoogleFonts.quantico(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          WeatherIcons.wi_cloud, //Maybe use icon package
                                          //TODO: insert function to get appropiate weather condition icon
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,

                                          child: Center(
                                            child: Text(
                                              "23\u00B0 - 22\u00B0", //TODO: insert function to get temp here,
                                              style: GoogleFonts.sansita(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Next day container
                                Container(
                                  //Round up container's edge
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(77, 204, 189, 0.7),
                                  ),
                                  width: double.infinity,
                                  height: 50,

                                  //Pad all sides evenly
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),

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
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Mon", //TODO: insert function to get next day here
                                              style: GoogleFonts.quantico(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          WeatherIcons.wi_day_rain, //Maybe use icon package
                                          //TODO: insert function to get appropiate weather condition icon
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,

                                          child: Center(
                                            child: Text(
                                              "14\u00B0 - 25\u00B0", //TODO: insert function to get temp here,
                                              style: GoogleFonts.sansita(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Next-next day container
                                Container(
                                  //Round up container's edge
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(77, 204, 189, 0.7),
                                  ),
                                  width: double.infinity,
                                  height: 50,

                                  //Pad all sides evenly
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),

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
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Tues", //TODO: insert function to get next-next day here
                                              style: GoogleFonts.quantico(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          WeatherIcons.wi_day_snow, //Maybe use icon package
                                          //TODO: insert function to get appropiate weather condition icon
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          //color: Colors.teal,
                                          width: 130,
                                          height: double.infinity,

                                          child: Center(
                                            child: Text(
                                              "13\u00B0 - 18\u00B0", //TODO: insert function to get temp here,
                                              style: GoogleFonts.sansita(
                                                textStyle: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromRGBO(
                                                      35, 22, 81, 1.0),
                                                ),
                                              ),
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
                ),
              ],
            ),
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