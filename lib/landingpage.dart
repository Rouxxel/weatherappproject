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
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//Top most container in listview
String devicecitycountry = "City, Country";
String datetime="Day x, Month x:xx ym";
int centraltempnum = 0;
String subtxtwcondition = "Double tap big zero";

//Middle container in listview
double precipitation = 0.0;
int humidity = 0;
double windspeed = 0.0;

//Bottom container in List view
//Daily
List<String>days=["day","day","day",
  "day","day","day","day",];
List<List<int>>maxmintemps=[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],];

//Hourly
List<int> hours=[0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0];
List<int> temphours=[0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0];


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

              //Children of the listview
              children: [
                //Top container (middle height)
                GestureDetector(
                  onDoubleTap: ()async{
                    //Declare and obtain list with latitude and longitude
                    List<double> latlon = await getgpslocation(context);

                    //Declare and obtain string of city and country
                    String devicelocation = await getcitycountry(context, latlon);

                    //Declare and obtain string of date and time
                    Map<String,dynamic>dateinfo= await
                      getdatetimedata(context);

                    // Declare and obtain list with all weather information
                    Map<String, dynamic> weatherinfo = await
                      getCURRENTweatherdata(context: context, latlon: latlon);

                    //TODO: implement function to get date and time in format

                    setState(() { //DO NOT USE ASYNC IN SET STATE

                      //Update relevant variables
                      //Device location
                      devicecitycountry = devicelocation;

                      //Date and time
                      datetime = "${dateinfo["weekdaystr"]} ${dateinfo["daynum"]}, "
                          "${dateinfo["monthstr"]} ${dateinfo['hour']}:"
                          "${dateinfo["minutes"]}";

                      //Weather information
                      centraltempnum=weatherinfo["Ctemp"].round();
                      subtxtwcondition=weatherinfo["weathercond"];
                      precipitation=weatherinfo["precipiMM"];
                      humidity=weatherinfo["humid"];
                      windspeed=weatherinfo["KPHwind"];

                      //Daily information
                      days[0]=dateinfo["weekdaystr"];
                      days[1]=dateinfo["weekdaystr2"];
                      days[2]=dateinfo["weekdaystr3"];
                      days[3]=dateinfo["weekdaystr4"];
                      days[4]=dateinfo["weekdaystr5"];
                      days[5]=dateinfo["weekdaystr6"];
                      days[6]=dateinfo["weekdaystr7"];

                      //Hourly information
                      hours[0]=dateinfo["hour"];
                      hours[1]=dateinfo["hour2"];
                      hours[2]=dateinfo["hour3"];
                      hours[3]=dateinfo["hour4"];
                      hours[4]=dateinfo["hour5"];
                      hours[5]=dateinfo["hour6"];
                      hours[6]=dateinfo["hour7"];
                      hours[7]=dateinfo["hour8"];
                      hours[8]=dateinfo["hour9"];
                      hours[9]=dateinfo["hour10"];
                      hours[10]=dateinfo["hour11"];
                      hours[11]=dateinfo["hour12"];
                      hours[12]=dateinfo["hour13"];
                      hours[13]=dateinfo["hour14"];
                      hours[14]=dateinfo["hour15"];
                      hours[15]=dateinfo["hour16"];
                      hours[16]=dateinfo["hour17"];
                      hours[17]=dateinfo["hour18"];
                      hours[18]=dateinfo["hour19"];
                      hours[19]=dateinfo["hour20"];
                      hours[20]=dateinfo["hour21"];
                      hours[21]=dateinfo["hour22"];
                      hours[22]=dateinfo["hour23"];

                    });
                  },

                  //Top Container
                  child: Container(
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
                                "$devicecitycountry", //TODO: insert here function to get city and country
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
                                    fontSize: 20,
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
                              datetime, //TODO: insert here function to get date and time
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
                                  "$centraltempnum\u00B0C",
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
                              capitalize(subtxtwcondition), //TODO: insert here function to get weather condition
                              style: GoogleFonts.quantico(
                                textStyle: TextStyle(
                                  fontSize: 25,
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
                ),

                //Sized box for spacing
                SizedBox(
                  height: 51,
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
                            "${precipitation.round()}mm", //TODO: insert function to get precipitation
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
                            "$humidity%",
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
                                fontSize: 17,
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
                            "${windspeed.round()} KMH", //TODO: insert function to get wind speed
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
                                      fontSize: 23,
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
                                      fontSize: 23,
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
                            child: ListView(
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
                                              "${days[0]}",
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
                                              "${maxmintemps[0][0]}\u00B0 - ${maxmintemps[0][1]}\u00B0", //TODO: insert function to get temp here,
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

                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day2 container
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
                                              "${days[1]}", //TODO: insert function to get next day here
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
                                          WeatherIcons
                                              .wi_day_rain, //Maybe use icon package
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
                                              "${maxmintemps[1][0]}\u00B0 - ${maxmintemps[1][1]}\u00B0", //TODO: insert function to get temp here,
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

                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day3 container
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
                                              "${days[2]}", //TODO: insert function to get next-next day here
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
                                          WeatherIcons
                                              .wi_day_snow, //Maybe use icon package
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
                                              "${maxmintemps[2][0]}\u00B0 - ${maxmintemps[2][1]}\u00B0", //TODO: insert function to get temp here,
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

                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day4 container
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
                                              "${days[3]}", //TODO: insert function to get next-next day here
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
                                          WeatherIcons
                                              .wi_day_snow, //Maybe use icon package
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
                                              "${maxmintemps[3][0]}\u00B0 - ${maxmintemps[3][1]}\u00B0", //TODO: insert function to get temp here,
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

                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day5 container
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
                                              "${days[4]}", //TODO: insert function to get next-next day here
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
                                          WeatherIcons
                                              .wi_day_snow, //Maybe use icon package
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
                                              "${maxmintemps[4][0]}\u00B0 - ${maxmintemps[4][1]}\u00B0", //TODO: insert function to get temp here,
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

                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day6 container
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
                                              "${days[5]}", //TODO: insert function to get next-next day here
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
                                          WeatherIcons
                                              .wi_day_snow, //Maybe use icon package
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
                                              "${maxmintemps[5][0]}\u00B0 - ${maxmintemps[5][1]}\u00B0", //TODO: insert function to get temp here,
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
                                //Sized box for spacing
                                SizedBox(
                                  height: 9,
                                ),

                                //day7 container
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
                                              "${days[6]}", //TODO: insert function to get next-next day here
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
                                          WeatherIcons
                                              .wi_day_snow, //Maybe use icon package
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
                                              "${maxmintemps[6][0]}\u00B0 - ${maxmintemps[6][1]}\u00B0", //TODO: insert function to get temp here,
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
