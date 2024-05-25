import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
//Other pages import
import 'package:weatherappproject/landingpage.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//global variables

//global variables
/////////////////////////////////////////////////////////////////////////////
//functions-method

// Function to navigate to the landing page after 6 seconds
void autonavigationtimer(BuildContext context) {
  //Use Future<t> method with .delayed(Duration(time unit:int)) to execute code
  // after 6 seconds
  Future.delayed(Duration(seconds: 6), () {
    //Use navigator to go to the landing page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => landingpage()),
    );
  });
}

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself

class loadingpage extends StatelessWidget {
  const loadingpage({super.key});

  @override
  Widget build(BuildContext context) {
    //Timer to automatically navigate to the landing page
    autonavigationtimer(context);

    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: Color.fromRGBO(35, 22, 81, 1.0),

        body: Stack(
          children: [
            //Background image
            Container(
              child: Image.asset(
                "images/map.png",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),

            //Content of the page
            SafeArea(
              child: Column(
                //Alignment within the Column
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                //Children
                children: [
                  //Ghost container for centering purposes
                  Container(
                    width: double.infinity,
                  ),

                  Container(
                    //Original emulator is Pixel 8 Pro (height: 2992px, width: 1344px)
                    //Dynamically scale according to screen size
                    height: 80,
                    width: 320,
                    child: Center(
                      child: Text(
                        "ForKast",
                        style: GoogleFonts.pressStart2p(
                          textStyle: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 150,
                    child: Center(
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.quantico(
                          textStyle: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Color.fromRGBO(77, 204, 189, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}