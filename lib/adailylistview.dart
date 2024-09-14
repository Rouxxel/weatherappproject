import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//Actual List view

class dailyweatherscreen extends StatelessWidget {
  const dailyweatherscreen({super.key});

  @override
  Widget build(BuildContext context) {

    //Media Query
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_pixel_ratio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 81, 0),

      //Container for Daily listview
      body: Container(
        //Round up container's edges
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(35, 22, 81, 0.3),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        width: double.infinity,
        height: 190,

        //Pad everything evenly
        child: Padding(
          padding: const EdgeInsets.all(10),

          //Use Listview.builder to avoid hardcoding 7 containers
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              //Actual container blueprint
              return Container(
                //Round up container's edges
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(77, 204, 189, 0.7),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 50,

                //Pad everything evenly
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),

                  //Use row to organizer 3 widgets
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Weekday text container
                      SizedBox(
                        //color: Colors.teal,
                        width: 52, //Minimize pixel overflow
                        height: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            days[index], //Days of the week text
                            style: GoogleFonts.quantico(
                              textStyle: const TextStyle(
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
                          return_correct_icon(daily_icon_strs[index]),
                        size: 35,
                        color: Colors.white,
                      ),

                      //Max-Min Temperature container
                      SizedBox(
                        //color: Colors.teal,
                        width: 130,
                        height: double.infinity,

                        child: Center(
                          child: Text(
                            "${daily_max_min_temps[index][0].round()} - ${daily_max_min_temps[index][1].round()} \u00B0C",
                            style: GoogleFonts.sansita(
                              textStyle: const TextStyle(
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