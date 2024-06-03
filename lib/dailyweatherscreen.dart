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
import 'package:weatherappproject/functionality.dart';

import 'dailyweatherscreen.dart';
import 'hourlyweatherscreen.dart';
import 'landingpage.dart'; //Import necessary functionality

class dailyweatherscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 81, 0),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(35, 22, 81, 0.3),
        ),
        width: double.infinity,
        height: 190,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(77, 204, 189, 0.7),
                ),
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                color: Color.fromRGBO(35, 22, 81, 1.0),
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
                                color: Color.fromRGBO(35, 22, 81, 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
