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
import 'package:weatherappproject/detailspage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

//functions-methods
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
          //Pad horizontal part of of inner column
          padding: EdgeInsets.symmetric(vertical: 13.0,horizontal: 16.0),

          //Central column
          child: Column(
            //Alignment of the column
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            //Children of the column
            children: [
              //Container for User input
              Container(
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
                            fillColor: Color.fromRGBO(77, 204, 189, 0.4),
                            hintText: "Search City or Postal Code...",
                            hintStyle: GoogleFonts.quantico(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),

                            //Round up Textfield's edges
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),

                          //Modify the style of characters the user types
                          style: GoogleFonts.quantico(
                            textStyle: TextStyle(
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
                          color: Color.fromRGBO(77, 204, 189, 0.4),
                          borderRadius: BorderRadius.circular(12.0),
                        ),

                        height: 58,
                        width: 58,

                        //Search Icon button
                        child: Center(
                          child: IconButton(
                            icon: Icon(MaterialCommunityIcons.map_search_outline),
                            alignment: Alignment.center,
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: () async {

                              //Update city according to user input
                              Dcitybyuser= _Scontroller.text;

                              //Declare and obtain list with all weather information
                              Map<String, dynamic> Dweatherinfo = await
                              getCURRENTweatherdata(context: context, cityname: "$Dcitybyuser");

                              //Declare and obtain the city and country location
                              String Dcitylocation= await
                              getcitycountry(context, Dweatherinfo["coord"]);

                              //Declare and obtain possible alerts
                              String Dalertstoday= await
                              getCURRENTweatheralerts(context, Dweatherinfo["coord"]);


                              setState(() {

                                //Update citycountry string
                                Dcitycountry = Dcitylocation;

                                //Update date and time string
                                Ddatetime=Dweatherinfo["formatdatetime"];

                                //Update alert
                                Dalert = Dalertstoday;

                                //Weather information
                                //Top container
                                Dcentraltempnum=Dweatherinfo["Ctemp"];
                                Dsubtxtwcondition=Dweatherinfo["weathercond"];

                                //Temp container
                                Dmaxtemp=Dweatherinfo["Ctempmax"];
                                Dfeelstemp=Dweatherinfo["Ctempfeel"];
                                Dmintemp=Dweatherinfo["Ctempmin"];

                                //Precipitation, Humidity, clouds container
                                Dprecipitation=Dweatherinfo["precipiMM"];
                                Dhumidity=Dweatherinfo["humid"];
                                Dcloudsper=Dweatherinfo["clouds"];


                                //Wind container
                                Dwinddir=Dweatherinfo["winddir"];
                                Dwindgust=Dweatherinfo["KPHwindg"];
                                Dwindspeed=Dweatherinfo["KPHwind"];

                                //Sun container
                                Dsunset=Dweatherinfo["sunsettime"];
                                Duvi=Dweatherinfo["uvi"];
                                Dsunrise=Dweatherinfo["sunrisetime"];


                                //Pressure container
                                Dpressurehpa=Dweatherinfo["pressHPA"];
                                Dpressuremb=Dweatherinfo["pressMB"];
                              });

                              //Use navigator to go to the landing page
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => detailspage(),
                                ),
                              );
                              print("Printing city given by user: "+Dcitybyuser);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //"Suggestions" text
              Container(
                //color: Colors.black,
                height: 40,
                width: double.infinity,
                child: Padding(
                  //Move text a little offset to the right
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    //Bound text to always be center left
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Suggestions:",
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
                ),
              ),

              //Container for list view of suggestions
              Expanded(
                child: Container(
                  //Round up container's edges
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(214, 255, 246, 0.15),
                  ),

                  child: Padding(
                    //Pad all sides evenly
                    padding: EdgeInsets.all(20),

                    //Use list view to create a scrollable options
                    child: ListView(
                      children: [
                        //Suggestion 1
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align Column of children to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "Hamburg, Germany",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 2
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "Paris, France",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 3
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "Shenzhen, China",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 4
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "Tokyo, Japan",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 5
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "London, England",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 6
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "New York, England",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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

                        //Sized box for spacing
                        SizedBox(
                          height: 25,
                        ),

                        //Suggestion 7
                        Container(
                          //Round up container's edges
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black, //TODO: replace color with image
                          ),
                          height: 100,
                          width: double.infinity,

                          //Align text to center left of container
                          child: Align(
                            alignment: Alignment.centerLeft,

                            //Pad children of the Column
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),

                              //Use column to organize texts
                              child: Text(
                                "Madrid, Spain",
                                style: GoogleFonts.quantico(
                                  textStyle: TextStyle(
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
                      ],
                    ),
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
          color: const Color.fromRGBO(35, 22, 81, 1.0),

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
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.info_outline),
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
                  color: const Color.fromRGBO(140, 127, 186, 0.5),
                  icon: const Icon(Icons.home_outlined),
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