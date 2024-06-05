import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:icons_flutter/icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing
//TODO:determine if all of these imports are truly necessary for this page

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//City name given by user
String Dcitybyuser="";

//Top most container in listview
String Dcitycountry = "NaN, NaN";
String Ddatetime="NaN NaN, NaN NaN:NaN";
double Dcentraltempnum = 0;
String Dsubtxtwcondition = "Please go to search page";

//Alert container in Listview
String Dalert = "No Location provided...";

//All other containers in listview
double Dmaxtemp = 0;
double Dfeelstemp = 0;
double Dmintemp = 0;
double Dprecipitation = 0.0;
int Dhumidity = 0;
int Dcloudsper = 0;
int Dwinddir = 0;
double Dwindgust = 0.0;
double Dwindspeed = 0.0;
String Dsunset = "NaN:NaN";
double Duvi = 0.0;
String Dsunrise = "NaN:NaN";
double Dpressurehpa = 0.0;
double Dpressuremb = 0.0;

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself

class detailspage extends StatefulWidget {
  const detailspage({super.key});

  @override
  State<detailspage> createState() => _detailspageState();
}

class _detailspageState extends State<detailspage> {
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
          //Pad everything in the body
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),

          //Align everything in the body to the Top center
          child: Align(
            alignment: Alignment.topCenter,

            child: ListView(

              //Children of the listview
              children: [
                //Top container
                Container(
                  //color: Colors.brown,
                  height: 240,
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
                            MaterialIcons.location_on, //maybe location_city
                            size: 30,
                            color: Colors.white,
                          ),

                          //Sized box for minimal spacing
                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            "$Dcitycountry",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                            maxLines: 2, //Allowing up to 2 lines
                            softWrap: true, //Enable text wrapping to avoid overflow
                          ),
                        ],
                      ),

                      //Subtext of top text (maybe punt in a container with
                      //width: 260, height: 18,)
                      Center(
                        child: Text(
                          "$Ddatetime",
                          style: GoogleFonts.quantico(
                            textStyle: TextStyle(
                              fontSize: 15,
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
                              "${Dcentraltempnum.round()}\u00B0C",
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
                          capitalize(Dsubtxtwcondition),
                          style: GoogleFonts.quantico(
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                            ),
                          ),
                          maxLines: 2, //Allowing up to 4 lines
                          softWrap: true, //Enable text wrapping to avoid overflow
                        ),
                      ),
                    ],
                  ),
                ),

                //Sized box for spacing
                SizedBox(
                  height: 51,
                ),

                //Alert container
                Container(
                  //Round up container's edges
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(214, 255, 246, 0.15),
                  ),
                  height: 170,

                  //Center the Row for the 3 containers (Maybe wrap with Center)
                  child: Row(
                    //Alignment of the row
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //Children
                    children: [
                      Column(
                        //Alignment of the column
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Icon(
                          FontAwesome.warning,
                            size: 75,
                            color: Colors.white,
                          ),
                          Text(
                            "Today!",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "$Dalert",
                        style: GoogleFonts.quantico(
                          textStyle: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                        maxLines: 4, //Allowing up to 4 lines
                        softWrap: true, //Enable text wrapping to avoid overflow
                      ),
                    ],
                  ),
                ),

                //Sized box for spacing
                SizedBox(
                  height: 20,
                ),

                //Container 1 (Max, Min and Feels like temperature in C)
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
                      //Max temp container (leftmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_thermometer,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dmaxtemp.round()}\u00B0C",
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
                            "Max today",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Farenheit container (central), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_thermometer_exterior, //maybe Entypo.water of package
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dfeelstemp.round()}\u00B0C",
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
                            "Feels..",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Min Temp container (rightmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_thermometer,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dmintemp.round()}\u00B0C",
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
                            "Min today",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
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

                //Container 2 (Precipitation, Humidity and Clouds)
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
                            "${Dprecipitation}mm",
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
                                fontSize: 17,
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
                            "$Dhumidity%",
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
                            "Humidity",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Clouds container (rightmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_cloudy,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "$Dcloudsper%",
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
                            "Clouds",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
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

                //Container 3 (Wind direction, gust and speed)
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
                      //Wind direction (leftmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_wind_direction,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "$Dwinddir\u00B0",
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
                            "Direction",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
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
                            WeatherIcons.wi_wind_beaufort_1, //maybe Entypo.water of package
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dwindgust.round()} KMH",
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
                            "Wind gust",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Clouds container (rightmost), maybe put in a
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
                            "${Dwindspeed.round()} KMH",
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
                                fontSize: 17,
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

                //Container 4 (Sunse, UVi, Sunrise)
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
                      //Sunset time (leftmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_sunset,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "$Dsunset",
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
                            "Sunset",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //UV index (central), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_day_sunny,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "$Duvi",
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
                            "UV index",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Sunrise time (rightmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_sunrise,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "$Dsunrise",
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
                            "Sunrise",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
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

                //Container 5 (Pressure hPa and mb)
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
                      //Pressure hPa (leftmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_barometer,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dpressurehpa.round()}hPa",
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
                            "Pressure",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Pressure mb (rightmost), maybe put in a
                      //container with width: 120, height: 120,
                      Column(
                        //Column alignment
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        //Children
                        children: [
                          Icon(
                            WeatherIcons.wi_barometer,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            "${Dpressuremb}mb",
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
                            "Pressure",
                            style: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 17,
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