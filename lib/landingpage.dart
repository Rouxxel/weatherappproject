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
String devicecitycountry = "NaN, NaN";
String datetime = "NaN NaN, NaN NaN:NaN";
double centraltempnum = 0;
String subtxtwcondition = "Double tap big zero";

//Middle container in listview
double precipitation = 0.0;
int humidity = 0;
double windspeed = 0.0;

//Bottom container in List view
//Daily
List<String> days = ["NaN","NaN","NaN","NaN","NaN","NaN","NaN",];
List<List<double>> maxmintemps = [
  [0.0, 0.0],[0.0, 0.0],[0.0, 0.0],[0.0, 0.0],
  [0.0, 0.0],[0.0, 0.0],[0.0, 0.0],
];
List<String> dailyiconsstr = [
  "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN"];

//Hourly
List<int> hours = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
List<double> temphours = [
  0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
  0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
];
List<String> hourlyiconsstr = [
  "NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN",
  "NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN","NaN",
  "NaN","NaN"
];

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
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const hourlyweatherscreen(),
    const dailyweatherscreen(),
  ];

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
            Container(
              child: Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
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
                        //Use block to create new scope and limit lifespan of variables
                        {
                          //Declare and obtain list with latitude and longitude
                          List<double> latlon = await getgpslocation(context);

                          //Declare and obtain string of city and country
                          String devicelocation =
                          await getcitycountry(context, latlon);

                          //Declare and obtain string of date and time
                          Map<String, dynamic> dateinfo =
                          getdatetimedata(context);

                          //Declare and obtain list with all weather information
                          Map<String, dynamic> weatherinfo =
                          await getCURRENTweatherdata(
                              context: context, latlon: latlon);

                          //Declare and obtain list with temp hourly, weekly and weather icons
                          Map<String, dynamic> weekhouricondata =
                          await getWEEKLYHOURLYtempsicons(
                              context, latlon, dateinfo['daynum']);

                          //Set state an all relevant variables
                          setState(() {
                            //DO NOT USE ASYNC IN SET STATE

                            //Update relevant variables
                            //Device location
                            devicecitycountry = devicelocation;

                            //Date and time
                            datetime =
                            "${dateinfo["weekdaystr"]} ${dateinfo["daynum"]}, "
                                "${dateinfo["monthstr"]} ${dateinfo['hour']}:"
                                "${dateinfo["minutes"]}";

                            //Weather information
                            centraltempnum = weatherinfo["Ctemp"];
                            subtxtwcondition = weatherinfo["weathercond"];
                            precipitation = weatherinfo["precipiMM"];
                            humidity = weatherinfo["humid"];
                            windspeed = weatherinfo["KPHwind"];

                            //Daily information
                            //Using a for loop to assign day strings and corresponding max min temp
                            for (int i = 0; i < days.length; i = i + 1) {
                              //Construct the key dynamically
                              String key =
                                  'weekdaystr${i == 0 ? '' : (i + 1)
                                  .toString()}';
                              days[i] = dateinfo[key];

                              //Assign the temperatures
                              int dayindex = (dateinfo['daynum'] + i) %
                                  7; // Calculate the correct day index
                              maxmintemps[i][0] = weekhouricondata['daily']
                              ['day${dayindex + 1}']['Cmintemp'];
                              maxmintemps[i][1] = weekhouricondata['daily']
                              ['day${dayindex + 1}']['Cmaxtemp'];

                              //Assign icons
                              dailyiconsstr[i] = weekhouricondata['daily']
                              ['day${dayindex + 1}']['icon'];
                            }

                            //Hourly information
                            //Using a for loop to assign hours ints
                            for (int i = 0; i < hours.length; i = i + 1) {
                              //Construct the key dynamically
                              String key =
                                  'hour${i == 0 ? '' : (i + 1).toString()}';
                              hours[i] = dateinfo[key];

                              //Assign the temperatures
                              int hourindex = (DateTime
                                  .now()
                                  .hour + i) % 24;
                              temphours[i] = weekhouricondata['hourly']
                              ['hour${hourindex + 1}']['Ctemp'];

                              //Assign icons
                              hourlyiconsstr[i] = weekhouricondata['hourly']
                              ['hour${hourindex + 1}']['icon'];
                            }
                          });
                        } //End of block
                      },

                      //Top Container
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
                                  MaterialIcons
                                      .location_on, //maybe location_city
                                  size: 30,
                                  color: Colors.white,
                                ),

                                //Sized box for minimal spacing
                                const SizedBox(
                                  width: 5,
                                ),

                                Text(
                                  devicecitycountry,
                                  style: GoogleFonts.quantico(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                  maxLines: 2, //Allowing up to 2 lines
                                  softWrap:
                                  true, //Enable text wrapping to avoid overflow
                                ),
                              ],
                            ),

                            //Subtext of top text (maybe punt in a container with
                            //width: 260, height: 18,)
                            Center(
                              child: Text(
                                datetime,
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

                            //Big temperature text (Do not remove expanded or container)
                            Expanded(
                              child: SizedBox(
                                //color: Colors.greenAccent,
                                width: 260,
                                height: 140,
                                child: Center(
                                  child: Text(
                                    "${centraltempnum.round()}\u00B0C",
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
                                capitalize(subtxtwcondition),
                                style: GoogleFonts.quantico(
                                  textStyle: const TextStyle(
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
                                "${windspeed.round()} KMH",
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
                        padding:
                        const EdgeInsets.symmetric(vertical: 25, horizontal: 20),

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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                //Children
                                children: [
                                  //Hourly button
                                  ElevatedButton(
                                    //Manipulate button size
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(150, 45),
                                      //Dynamically change button background color
                                      backgroundColor: _selectedIndex == 0
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
                                          color: _selectedIndex == 0
                                              ? const Color.fromRGBO(35, 22, 81, 1.0)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                        print("Current index: $_selectedIndex");
                                      });
                                    },
                                  ),

                                  //Daily button
                                  ElevatedButton(
                                    //Manipulate button size
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(150, 45),
                                      //Dynamically change button background color
                                      backgroundColor: _selectedIndex == 1
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
                                          color: _selectedIndex == 1
                                              ? const Color.fromRGBO(35, 22, 81, 1.0)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                        print("Current index: $_selectedIndex");
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),

                            //Results of selected option
                            Expanded(
                              child: _pages[_selectedIndex],
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
