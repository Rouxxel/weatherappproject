import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:icons_flutter/icons_flutter.dart'; //For more icons

//Other pages import
import 'package:weatherappproject/screens_pages/home_page.dart';
import 'package:weatherappproject/screens_pages/search_page.dart';
import 'package:weatherappproject/utils/alert_dialogs.dart';
import 'package:weatherappproject/methods/methods.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//URL string to external webpage
final String _web_URL = 'https://github.com/Rouxxel/weatherappproject';

//City name given by user
String? city_by_user;

//Top most container in listview
String? city_and_country;
String? date_and_time;
double? current_temperature;
String? subtxt_weather_condition;

//Alert container in Listview
String? weather_alert;

//All other containers in listview
double? max_temp;
double? feels_like;
double? min_temp;

double? detailed_precipitation;
int? detailed_humidity;
int? cloud_percentage;

int? wind_direction;
double? wind_gust;
double? detailed_wind_speed;

String? sunset_time;
double? uvi;
String? sunrise_time;

double? pressure_hpa;
double? pressure_mb;

//global variables
/////////////////////////////////////////////////////////////////////////////
//screen itself

class details_page extends StatefulWidget {
  const details_page({super.key});

  @override
  State<details_page> createState() => _details_pageState();
}

class _details_pageState extends State<details_page> {

  //Private function to fetch all detailed weather data
  Future<void> _fetch_local_detailed_weather_data(String input_text) async{
    //Use block to create new scope and limit lifespan of variables
    {
      try {
        //Fetch latest weather data by city name
        Map<String, dynamic> detailed_weather_info = await get_latest_weather_data(
          context: context,
          city_name: input_text,
        );

        //Extract alert information
        String alert = detailed_weather_info["alert"] ?? "";

        //Update state with fetched data
        setState(() {
          //Location info
          city_and_country = detailed_weather_info["rough_location"] ?? "Unknown location";

          //Date/time
          date_and_time = detailed_weather_info["format_date_time"] ?? "";

          //Alerts
          weather_alert = alert;

          //Weather info (top container)
          current_temperature = detailed_weather_info["C_temp"] ?? 0.0;
          subtxt_weather_condition = detailed_weather_info["weather_cond"] ?? "N/A";

          // Temperature container
          max_temp = detailed_weather_info["C_temp_max"] ?? 0.0;
          min_temp = detailed_weather_info["C_temp_min"] ?? 0.0;
          feels_like = detailed_weather_info["C_temp_feel"] ?? 0.0;

          // Precipitation, Humidity, Clouds
          detailed_precipitation = detailed_weather_info["precipi_MM"] ?? 0.0;
          detailed_humidity = detailed_weather_info["humid"] ?? 0;
          cloud_percentage = detailed_weather_info["clouds"] ?? 0;

          // Wind details
          wind_direction = detailed_weather_info["wind_direction"] ?? "N/A";
          wind_gust = detailed_weather_info["KPH_wind_g"] ?? 0.0;
          detailed_wind_speed = detailed_weather_info["KPH_wind"] ?? 0.0;

          // Sun timings
          sunset_time = detailed_weather_info["sunset_time"] ?? "N/A";
          uvi = detailed_weather_info["uvi"] ?? 0.0;
          sunrise_time = detailed_weather_info["sunrise_time"] ?? "N/A";

          // Pressure data
          pressure_hpa = detailed_weather_info["press_HPA"] ?? 0;
          pressure_mb = detailed_weather_info["press_MB"] ?? 0;
        });
      } catch (error) {
        // Handle errors gracefully
        alert_data_fetching_error(context);
        log_handler.e('Error fetching detailed weather data: $error');
      }
    } //End of block
  }

  @override
  Widget build(BuildContext context) {
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                    //Top container (Gesture to trigger functions)
                    GestureDetector(
                      onDoubleTap: () async {
                        await _fetch_local_detailed_weather_data(device_city!); //Refresh data manually
                      },

                      child: SizedBox(
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
                                  city_and_country ?? "N/A",
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
                                date_and_time ?? "N/A",
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
                                    "${current_temperature?.round() ?? "--"}\u00B0C",
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
                                capitalize_strings(subtxt_weather_condition ?? "Double tap"),
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
                              capitalize_strings(weather_alert ?? "..."),
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
                                "${max_temp?.round() ?? "--"}\u00B0C",
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
                                "Max. today",
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
                                "${feels_like?.round() ?? "--"}\u00B0C",
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
                                "Feels like",
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
                                "${min_temp?.round() ?? "--"}\u00B0C",
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
                                "Min. today",
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
                                "${detailed_precipitation ?? "--"}mm",
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
                                "${detailed_humidity ?? "--"}%",
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
                                "${cloud_percentage ?? "--"}%",
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
                                "${wind_direction ?? "---"}\u00B0",
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
                                "${wind_gust?.round() ?? "--"} KMH",
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
                                "${detailed_wind_speed?.round() ?? "--"} KMH",
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

                    //Container 4 (Sunset, UVi, Sunrise)
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
                                sunset_time ?? "--:--",
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
                                "${uvi ?? "-.-"}",
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
                                sunrise_time ?? "--:--",
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
                                "${pressure_hpa?.round() ?? "----"}hPa",
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
                                "${pressure_mb ?? "--.--"}mb",
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
                        await launch_URL(context,_web_URL);
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
                            "Check out our Repository !!!",
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const home_page(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300), // optional
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const search_page(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300), // optional
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