import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:icons_flutter/icons_flutter.dart'; //For more icons

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/detailspage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//screen itself

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  //Create a TextEditingController to control the TextField
  final TextEditingController _Scontroller = TextEditingController();

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
                              controller: _Scontroller,

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
                                  //Update city according to user input
                                  Dcitybyuser = _Scontroller.text;

                                  //Declare and obtain list with all weather information
                                  Map<String, dynamic> Dweatherinfo =
                                      await getCURRENTweatherdata(
                                          context: context,
                                          cityname: Dcitybyuser);

                                  //Declare and obtain the city and country location
                                  String Dcitylocation = await getcitycountry(
                                      context, Dweatherinfo["coord"]);

                                  //Declare and obtain possible alerts
                                  String Dalertstoday =
                                      await getCURRENTweatheralerts(
                                          context, Dweatherinfo["coord"]);

                                  setState(() {
                                    //Update citycountry string
                                    Dcitycountry = Dcitylocation;

                                    //Update date and time string
                                    Ddatetime = Dweatherinfo["formatdatetime"];

                                    //Update alert
                                    Dalert = Dalertstoday;

                                    //Weather information
                                    //Top container
                                    Dcentraltempnum = Dweatherinfo["Ctemp"];
                                    Dsubtxtwcondition =
                                        Dweatherinfo["weathercond"];

                                    //Temp container
                                    Dmaxtemp = Dweatherinfo["Ctempmax"];
                                    Dfeelstemp = Dweatherinfo["Ctempfeel"];
                                    Dmintemp = Dweatherinfo["Ctempmin"];

                                    //Precipitation, Humidity, clouds container
                                    Dprecipitation = Dweatherinfo["precipiMM"];
                                    Dhumidity = Dweatherinfo["humid"];
                                    Dcloudsper = Dweatherinfo["clouds"];

                                    //Wind container
                                    Dwinddir = Dweatherinfo["winddir"];
                                    Dwindgust = Dweatherinfo["KPHwindg"];
                                    Dwindspeed = Dweatherinfo["KPHwind"];

                                    //Sun container
                                    Dsunset = Dweatherinfo["sunsettime"];
                                    Duvi = Dweatherinfo["uvi"];
                                    Dsunrise = Dweatherinfo["sunrisetime"];

                                    //Pressure container
                                    Dpressurehpa = Dweatherinfo["pressHPA"];
                                    Dpressuremb = Dweatherinfo["pressMB"];
                                  });

                                  //Use navigator to go to the landing page
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const detailspage(),
                                    ),
                                  );
                                  print("Printing city given by user: $Dcitybyuser");
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

                        //Use list view to create a scrollable options
                        child: ListView(
                          children: [
                            //Suggestion 1
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "Stuttgart"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align Column of children to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "Stuttgart, Germany",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 2
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "Paris"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "Paris, France",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 3
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "Shenzhen"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "Shenzhen, China",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 4
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "Tokyo"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "Tokyo, Japan",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 5
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "London"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "London, United Kingdom",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 6
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "New York"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "New York, United States",
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

                            //Sized box for spacing
                            const SizedBox(
                              height: 25,
                            ),

                            //Suggestion 7
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _Scontroller.text =
                                      "Madrid"; //TODO: see how to optimize this
                                });
                              },
                              child: Container(
                                //Round up container's edges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors
                                      .black, //TODO: replace color with image
                                ),
                                height: 100,
                                width: double.infinity,

                                //Align text to center left of container
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  //Pad children of the Column
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),

                                    //Use column to organize texts
                                    child: Text(
                                      "Madrid, Spain",
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
                          ],
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
