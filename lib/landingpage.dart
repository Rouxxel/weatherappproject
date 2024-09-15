import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:icons_flutter/icons_flutter.dart'; //For more icons

//Other pages import
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/detailspage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//List views imports
import 'package:weatherappproject/adailylistview.dart';
import 'package:weatherappproject/ahourlylistview.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//Top most container in listview
String device_city="NaN";
String device_location = "NaN, NaN";
String date_time = "NaN NaN, NaN NaN:NaN";
double center_temp_numb = 0;
String subtext_condition = "Double tap to refresh";

//Middle container in listview
double precipitation = 0.0;
int humidity = 0;
double wind_speed = 0.0;

//Bottom container in List view
//Daily initialization
List<String> days = List.generate(7, (_) => "NaN");
List<List<double>> daily_max_min_temps = List.generate(7, (_) => [0.0, 0.0]);
List<String> daily_icon_strs = List.generate(7, (_) => "NaN");

//Hourly initialization
List<int> hours = List.generate(24, (_) => 0);
List<double> hourly_temps = List.generate(24, (_) => 0.0);
List<String> hourly_icon_strs = List.generate(24, (_) => "NaN");

//global variables
/////////////////////////////////////////////////////////////////////////////
//screen itself
class landingpage extends StatefulWidget {
  const landingpage({super.key});

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
  //Prepare index controller for Hourly and Daily
  int _selected_index = 0;
  final List<Widget> _pages = [
    const hourlyweatherscreen(),
    const dailyweatherscreen(),
  ];

  //Private function to fetch all the data
  Future<void> _fetch_weather_data() async {
    // Use block to create a new scope and limit lifespan of variables
    {
      try {
        // Declare and obtain list with latitude and longitude
        List<double> lat_lon = await get_gps_location(context);

        // Declare and obtain string of date and time
        Map<String, dynamic> date_info = get_date_time_data(context);

        // Declare and obtain list with all weather information
        Map<String, dynamic> weather_info = await get_current_weather_datas(
          context: context,
          lat_lon: lat_lon,
        );

        // Declare and obtain list with temp hourly, weekly and weather icons
        Map<String, dynamic> weekhour_icon_data =
        await get_weekly_hourly_temperature_icons(
          context,
          lat_lon,
          date_info['month_day_num'],
        );

        // Set state for all relevant variables
        setState(() {
          // Update relevant variables
          device_location = weather_info["rough_location"];
          device_city = weather_info["current_city"];

          // Date and time
          date_time =
          "${date_info["weekday_str"]} ${date_info["month_day_num"]}, "
              "${date_info["month_str"]} ${date_info['hour']}:"
              "${date_info["minutes"]}";

          // Weather information
          center_temp_numb = weather_info["C_temp"];
          subtext_condition = weather_info["weather_cond"];
          precipitation = weather_info["precipi_MM"];
          humidity = weather_info["humid"];
          wind_speed = weather_info["KPH_wind"];

          // Daily information
          for (int i = 0; i < days.length; i++) {
            int dayindex = (date_info['month_day_num'] + i) % 7;

            String key = 'weekday_str${i == 0 ? '' : (i + 1).toString()}';
            days[i] = date_info[key];

            daily_max_min_temps[i][0] =
            weekhour_icon_data['daily']['day${dayindex + 1}']['C_min_temp'];
            daily_max_min_temps[i][1] =
            weekhour_icon_data['daily']['day${dayindex + 1}']['C_max_temp'];

            daily_icon_strs[i] =
            weekhour_icon_data['daily']['day${dayindex + 1}']['icon'];
          }

          // Hourly information
          for (int i = 0; i < hours.length; i++) {
            int hourindex = (DateTime.now().hour + i) % 24;

            String key = 'hour${i == 0 ? '' : (i + 1).toString()}';
            hours[i] = date_info[key];

            hourly_temps[i] =
            weekhour_icon_data['hourly']['hour${hourindex + 1}']['C_temp'];
            hourly_icon_strs[i] =
            weekhour_icon_data['hourly']['hour${hourindex + 1}']['icon'];
          }
        });
      } catch (error) {
        show_weather_data_fetching_error(context);
        print('Error fetching weather data: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch_weather_data(); //Call the function once the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: const Color.fromRGBO(35, 22, 81, 0.85), //decide color

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
              //Pad everything in the body (in this case a list view)
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

              //Align everything in the body to the Top center
              child: Align(
                alignment: Alignment.topCenter,

                //Use listview to avoid Render overflow
                child: ListView(
                  //Children of the listview
                  children: [
                    //Top container (Gesture to trigger functions)
                    GestureDetector(
                      onDoubleTap: () async {
                        await _fetch_weather_data(); //Refresh data manually
                      },

                      //Top Container
                      child: Container(
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
                                  MaterialIcons
                                      .location_on, //maybe location_city
                                  size: 30,
                                  color: Colors.white,
                                ),

                                //Sized box for minimal spacing
                                const SizedBox(
                                  width: 4,
                                ),

                                Text(
                                  device_location,
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
                            Text(
                              date_time,
                              style: GoogleFonts.quantico(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            //Big temperature text (Do not remove expanded or container)
                            Expanded(
                              child: Container(
                                //color: Colors.greenAccent,
                                width: 260,
                                height: 140,
                                child: Center(
                                  child: Text(
                                    "${center_temp_numb.round()}\u00B0C",
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
                            Text(
                              capitalize_strings(subtext_condition),
                              style: GoogleFonts.quantico(
                                textStyle: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
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

                    //Middle container (Least height and max width)
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
                                "${precipitation}mm",
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
                                Icons
                                    .water_drop, //maybe Entypo.water of package
                                size: 45,
                                color: Colors.white,
                              ),
                              Text(
                                "$humidity%",
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

                          //Wind speed container (rightmost), maybe put in a
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
                                "${wind_speed.round()} KMH",
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

                    //Bottom container (Highest height and max width)
                    Container(
                      //Round up container's edges
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(214, 255, 246, 0.15),
                      ),
                      height: 335,

                      child: Padding(
                        //Padding for the column within the container
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),

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
                                color: const Color.fromRGBO(35, 22, 81, 0.3),
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
                                      minimumSize: const Size(150, 45),
                                      //Dynamically change button background color
                                      backgroundColor: _selected_index == 0
                                          ? const Color.fromRGBO(77, 204, 189, 1.0)
                                          : const Color.fromRGBO(35, 22, 81, 1.0),
                                    ),

                                    child: Text(
                                      "Hourly",
                                      style: GoogleFonts.quantico(
                                        textStyle: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          //Dynamically change the Texts color
                                          color: _selected_index == 0
                                              ? const Color.fromRGBO(35, 22, 81, 1.0)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selected_index = 0;
                                        print("Current index: $_selected_index");
                                      });
                                    },
                                  ),

                                  //Daily button
                                  ElevatedButton(
                                    //Manipulate button size
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(150, 45),
                                      //Dynamically change button background color
                                      backgroundColor: _selected_index == 1
                                          ? const Color.fromRGBO(77, 204, 189, 1.0)
                                          : const Color.fromRGBO(35, 22, 81, 1.0),
                                    ),

                                    child: Text(
                                      "Daily",
                                      style: GoogleFonts.quantico(
                                        textStyle: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,

                                          //Dynamically change the Texts color
                                          color: _selected_index == 1
                                              ? const Color.fromRGBO(35, 22, 81, 1.0)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selected_index = 1;
                                        print("Current index: $_selected_index");
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),

                            //Results of selected option
                            Expanded(
                              child: _pages[_selected_index],
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
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    //Use navigator to go to the landing page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const detailspage(),
                      ),
                    );
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
                  color: const Color.fromRGBO(140, 127, 186, 1.0),
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    //No functionality here because this is the page
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
                    //Use navigator to go to the search page
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