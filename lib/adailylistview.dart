import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//Actual List view

class dailyweatherscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 81, 0),

      //Container for Daily listview
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

          //Use Listview.builder to avoid hardcoding 7 containers
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              //Actual container blueprint
              return Container(
                //Round up container's edges
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(77, 204, 189, 0.7),
                ),
                margin: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 50,

                //Pad everything evenly
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),

                  //Use row to organizer 3 widgets
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Weekday text container
                      Container(
                        //color: Colors.teal,
                        width: 130,
                        height: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${days[index]}", //Days of the week text
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

                      //Icon weather container
                      Icon(
                          returnCORRECTiconforweather(dailyiconsstr[index]),
                        size: 35,
                        color: Colors.white,
                      ),

                      //Max-Min Temperature container
                      Container(
                        //color: Colors.teal,
                        width: 130,
                        height: double.infinity,

                        child: Center(
                          child: Text(
                            "${maxmintemps[index][0].round()} - ${maxmintemps[index][1].round()} \u00B0C",
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