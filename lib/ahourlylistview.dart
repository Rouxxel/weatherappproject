import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:geolocator/geolocator.dart'; //For GPS function
import 'package:icons_flutter/icons_flutter.dart'; //For more icons
import 'package:url_launcher/url_launcher.dart' as url; //For URL launch
import 'package:http/http.dart' as http; //For http resources
import 'dart:convert' as conv; //For JSON parsing
//TODO: Determine if all of this imports are truly necessary

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//List views imports
import 'ahourlylistview.dart';
import 'ahourlylistview.dart';

class hourlyweatherscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 81, 0),

      //Container for Hourly listview
      body: Container(
        //Round up container's edges
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(35, 22, 81, 0.3),
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        width: double.infinity,
        height: 190,

        //Pad everything evenly
        child: Padding(
          padding: EdgeInsets.all(10),

          //Use Listview.builder to avoid hardcoding 24 containers
          child: ListView.builder(
            //Make scrolling horizontal instead of default vertical
            scrollDirection: Axis.horizontal,

            itemCount: 24,
            itemBuilder: (context, index) {
              //Actual container blueprint
              return Container(
                //Round up container's edges
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(77, 204, 189, 0.7),
                ),
                margin: EdgeInsets.only(right: 10),
                width: 100,
                height: double.infinity,

                //Pad everything evenly
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Icon weather container
                    Icon(
                      WeatherIcons.wi_day_sunny, //TODO: insert functionality to get correct icon
                      size: 35,
                      color: Colors.white,
                    ),

                    //Temperature
                    Text(
                      "${temphours[index].round()}\u00B0C", //TODO: insert functionality to get actual temperature
                      style: GoogleFonts.sansita(
                        textStyle: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(35, 22, 81, 1.0),
                        ),
                      ),
                    ),

                    //Hour text
                    Text(
                      "${hours[index]}:00", //Hours of the day text
                      style: GoogleFonts.quantico(
                        textStyle: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(35, 22, 81, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}