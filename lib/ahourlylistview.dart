import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import

//Other pages import
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/functionality.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//Actual List view

class hourlyweatherscreen extends StatelessWidget {
  const hourlyweatherscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 81, 0),

      //Container for Hourly listview
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
                  color: const Color.fromRGBO(77, 204, 189, 0.7),
                ),
                margin: const EdgeInsets.only(right: 10),
                width: 100,
                height: double.infinity,

                //Pad everything evenly
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Icon weather container
                    Icon(
                      return_correct_icon(hourly_icon_strs[index]),
                      size: 35,
                      color: Colors.white,
                    ),

                    //Temperature
                    Text(
                      "${hourly_temps[index].round()}\u00B0C",
                      style: GoogleFonts.sansita(
                        textStyle: const TextStyle(
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
                        textStyle: const TextStyle(
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