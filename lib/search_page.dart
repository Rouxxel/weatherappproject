import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:icons_flutter/icons_flutter.dart'; //For more icons

//Other pages import
import 'package:weatherappproject/home_page.dart';
import 'package:weatherappproject/details_page.dart';
import 'package:weatherappproject/methods.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

List<String> city_suggestions= ["Stuttgart","Paris","Shenzhen","Tokyo","London",
  "New York","Madrid","Riyadh","Bangkok","Caracas"];
List<String> country_suggestion= ["Germany","France","China","Japan","United Kingdom",
  "United States","Spain","Saudi Arabia","Thailand","Venezuela"];

//global variables
/////////////////////////////////////////////////////////////////////////////
//screen itself

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  //Create a TextEditingController to control the TextField
  final TextEditingController _text_controller = TextEditingController();

  //Public function to fetch all detailed weather data
  Future<void> fetch_detailed_weather_data(String text_controller) async{
    //Use block to create new scope and limit lifespan of variables
    {
      //Update city according to user input
      D_city_by_user = validate_user_input(context, text_controller);

      //Declare and obtain list with all weather information
      Map<String, dynamic> D_weather_info =
      await get_current_weather_datas(
          context: context,
          city_name: D_city_by_user);

      //Declare and obtain possible alerts
      String D_alerts_today =D_weather_info["alert"];

      setState(() {
        //Update city_country string
        D_city_country = D_weather_info["rough_location"];

        //Update date and time string
        D_date_time = D_weather_info["format_date_time"];

        //Update alert
        D_weather_alert = D_alerts_today;

        //Weather information
        //Top container
        D_central_temp_num = D_weather_info["C_temp"];
        D_subtxt_weather_condition = D_weather_info["weather_cond"];

        //Temp container
        D_max_temp = D_weather_info["C_temp_max"];
        D_min_temp = D_weather_info["C_temp_min"];
        D_feels_temp = D_weather_info["C_temp_feel"];


        //Precipitation, Humidity, clouds container
        D_precipitation = D_weather_info["precipi_MM"];
        D_humidity = D_weather_info["humid"];
        D_clouds_percent = D_weather_info["clouds"];

        //Wind container
        D_wind_dir = D_weather_info["wind_direction"];
        D_wind_gust = D_weather_info["KPH_wind_g"];
        D_wind_speed = D_weather_info["KPH_wind"];

        //Sun container
        D_sunset = D_weather_info["sunset_time"];
        D_uvi = D_weather_info["uvi"];
        D_sunrise = D_weather_info["sunrise_time"];

        //Pressure container
        D_pressure_hpa = D_weather_info["press_HPA"];
        D_pressure_mb = D_weather_info["press_MB"];
      });
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
              //Pad horizontal part of of inner column
              padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),

              //Central column
              child: Column(
                //Alignment of the column
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                //Children of the column
                children: [
                  //Container for User input
                  SizedBox(
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
                              //Controller to update city variable based on user input
                              controller: _text_controller,

                              //Decorate hint text
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(77, 204, 189, 0.4),
                                hintText: "Search City or Postal Code...",
                                hintStyle: GoogleFonts.quantico(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                  ),
                                ),

                                //Round up Textfield's edges
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),

                              //Modify the style of characters the user types
                              style: GoogleFonts.quantico(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          //Container to create frame for Search icon button
                          Container(
                            //Round up Iconbutton's container edges
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(77, 204, 189, 0.4),
                              borderRadius: BorderRadius.circular(12.0),
                            ),

                            height: 58,
                            width: 58,

                            //Search Icon button
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                    MaterialCommunityIcons.map_search_outline),
                                alignment: Alignment.center,
                                iconSize: 40,
                                color: Colors.white,

                                onPressed: () async {

                                  await fetch_detailed_weather_data(_text_controller.text);

                                  //Use navigator to go to the landing page
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const detailspage(),
                                    ),
                                  );
                                  print("---------------------------------------------------------");
                                  print("City given by user: $D_city_by_user");
                                  print("---------------------------------------------------------");
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //"Suggestions" text
                  SizedBox(
                    //color: Colors.black,
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
                          style: GoogleFonts.quantico(
                            textStyle: const TextStyle(
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
                        color: const Color.fromRGBO(214, 255, 246, 0.15),
                      ),

                      child: Padding(
                        //Pad all sides evenly
                        padding: const EdgeInsets.all(20),


                        //Use Listview.builder to avoid hardcoding 10 containers
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            // Actual container blueprint
                            return Column(
                              //Alignment of the inner column
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _text_controller.text = "${city_suggestions[index]}";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromRGBO(77, 204, 189, 0.4),
                                    ),
                                    height: 100,
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 20
                                        ),
                                        child: Text(
                                          "${city_suggestions[index]}, ${country_suggestion[index]}",
                                          style: GoogleFonts.quantico(
                                            textStyle: const TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: 25
                                ),
                              ],
                            );
                          },
                        ),

                      ),
                    ),
                  ),
                ],
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