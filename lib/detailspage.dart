import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:icons_flutter/icons_flutter.dart'; //For more icons

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

final String _web_URL = 'https://www.youtube.com/watch?v=1DD_NCM_RJs';

//City name given by user
String D_city_by_user="";

//Top most container in listview
String D_city_country = "NaN, NaN";
String D_date_time="NaN NaN, NaN NaN:NaN";
double D_central_temp_num = 0;
String D_subtxt_weather_condition = "Please go to search page";

//Alert container in Listview
String D_weather_alert = "No Location provided...";

//All other containers in listview
double D_max_temp = 0;
double D_feels_temp = 0;
double D_min_temp = 0;

double D_precipitation = 0.0;
int D_humidity = 0;
int D_clouds_percent = 0;

int D_wind_dir = 0;
double D_wind_gust = 0.0;
double D_wind_speed = 0.0;

String D_sunset = "NaN:NaN";
double D_uvi = 0.0;
String D_sunrise = "NaN:NaN";

double D_pressure_hpa = 0.0;
double D_pressure_mb = 0.0;

//global variables
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

    //Media Query
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_pixel_ratio = MediaQuery.of(context).devicePixelRatio;

    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: const Color.fromRGBO(35, 22, 81, 0.85),

        //Appbar only with the name of the app
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(35, 22, 81, 1.0),

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

        //Stack background with actual content
        body: Stack(
          children: [
            //Background image
            Image.asset(
              "images/background.png",
              fit: BoxFit.cover,
              width: screen_width,
              height: screen_height,
            ),

            //Pad listview to maintain consistency
            //Actual content of the body
            Padding(
            //Pad everything in the body
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

            //Align everything in the body to the Top center
            child: Align(
              alignment: Alignment.topCenter,

              child: ListView(

                //Children of the listview
                children: [
                  //Top container
                  SizedBox(
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
                            const Icon(
                              MaterialIcons.location_on, //maybe location_city
                              size: 30,
                              color: Colors.white,
                            ),

                            //Sized box for minimal spacing
                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              D_city_country,
                              style: GoogleFonts.quantico(
                                textStyle: const TextStyle(
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
                            D_date_time,
                            style: GoogleFonts.quantico(
                              textStyle: const TextStyle(
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
                          child: SizedBox(
                            //color: Colors.greenAccent,
                            width: 260,
                            height: 140,
                            child: Center(
                              child: Text(
                                "${D_central_temp_num.round()}\u00B0C",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sansita(
                                  textStyle: const TextStyle(
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
                            capitalize_strings(D_subtxt_weather_condition),
                            style: GoogleFonts.quantico(
                              textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 51,
                  ),

                  //Alert container
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                            FontAwesome.warning,
                              size: 75,
                              color: Colors.white,
                            ),
                            Text(
                              "Today!",
                              style: GoogleFonts.quantico(
                                textStyle: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 200,
                          //Put in a sized box to avoid overflow
                          child: Text(
                            capitalize_strings(D_weather_alert),
                            style: GoogleFonts.quantico(
                              textStyle: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                            maxLines: 4, //Allowing up to 4 lines
                            softWrap: true, //Enable text wrapping to avoid overflow
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Sized box for spacing
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 1 (Max, Min and Feels like temperature in C)
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                              WeatherIcons.wi_thermometer,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_max_temp.round()}\u00B0C",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_thermometer_exterior, //maybe Entypo.water of package
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_feels_temp.round()}\u00B0C",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_thermometer,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_min_temp.round()}\u00B0C",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 2 (Precipitation, Humidity and Clouds)
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                              FontAwesome.umbrella,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_precipitation}mm",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              Icons.water_drop, //maybe Entypo.water of package
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "$D_humidity%",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_cloudy,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "$D_clouds_percent%",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 3 (Wind direction, gust and speed)
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                              WeatherIcons.wi_wind_direction,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "$D_wind_dir\u00B0",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_wind_beaufort_1, //maybe Entypo.water of package
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_wind_gust.round()} KMH",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              Icons.wind_power_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_wind_speed.round()} KMH",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 4 (Sunse, UVi, Sunrise)
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                              WeatherIcons.wi_sunset,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              D_sunset,
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_day_sunny,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "$D_uvi",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_sunrise,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              D_sunrise,
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 5 (Pressure hPa and mb)
                  Container(
                    //Round up container's edges
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(214, 255, 246, 0.15),
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
                            const Icon(
                              WeatherIcons.wi_barometer,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_pressure_hpa.round()}hPa",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                            const Icon(
                              WeatherIcons.wi_barometer,
                              size: 45,
                              color: Colors.white,
                            ),
                            Text(
                              "${D_pressure_mb}mb",
                              style: GoogleFonts.sansita(
                                textStyle: const TextStyle(
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
                                textStyle: const TextStyle(
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
                  const SizedBox(
                    height: 20,
                  ),

                  //Container 6 (Link to webpage)
                  GestureDetector(
                    onTap: () async {
                      await launch_URL(_web_URL);
                    },

                    child: Container(
                      //Round up container's edges
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(214, 255, 246, 0.3),
                      ),
                      height: 145,

                      //Center the Row for the 3 containers (Maybe wrap with Center)
                      child: Center(
                        //Children
                        child: Text(
                          "Check out our Web site !!!",
                          style: GoogleFonts.quantico(
                            textStyle: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],),

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
              SizedBox(
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  color: const Color.fromRGBO(140, 127, 186, 1.0),
                  icon:
                  const Icon(Icons.info),
                  onPressed: () {
                    //No functionality here because this is the page
                  },
                ),
              ),

              //Center container (main button)
              SizedBox(
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
                        builder: (context) => const landingpage(),
                      ),
                    );
                  },
                ),
              ),

              //Right most container (rightmost button)
              SizedBox(
                height: 58,
                width: 58,

                //ICON button
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const searchpage(),
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