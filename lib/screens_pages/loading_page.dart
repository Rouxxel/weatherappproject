import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //For font import
import 'package:flutter/services.dart'; //For exiting app

//
//Other pages import
import 'package:weatherappproject/screens_pages/home_page.dart';
import 'package:weatherappproject/methods/methods.dart'; //Import necessary functionality

//imports
/////////////////////////////////////////////////////////////////////////////
//functions-method

// Function to navigate to the landing page after 8 seconds
void _auto_nav_timer(BuildContext context) {
  //Use Future<t> method with .delayed(Duration(time unit:int))
  //to execute code after 8 seconds
  Future.delayed(const Duration(seconds: 4), () {
    //Use navigator to go to the landing page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const home_page()),
    );
  });
}

//functions-methods
/////////////////////////////////////////////////////////////////////////////
//screen itself

class loading_page extends StatefulWidget {
  const loading_page({super.key});

  @override
  State<loading_page> createState() => _loading_pageState();
}

class _loading_pageState extends State<loading_page> {
  @override
  void initState() {
    super.initState();
    _check_permission_to_navigate();
  }

  // Method to ask for GPS permission, then next action
  Future<void> _check_permission_to_navigate() async {
    try {
      await get_gps_permissions(context);

      if (gps_permission) {
        _auto_nav_timer();
      } else {
        //Exit the app
        SystemNavigator.pop();
      }
    } catch (er) {
      log_handler.w("Error checking permission to navigate to homepage: $er");
      SystemNavigator.pop(); //Exit app on error
    }
  }

  // Method to auto-navigate to home page
  void _auto_nav_timer() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const home_page()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    //Ask GPS permission, then proceed to home page
    _check_permission_to_navigate();

    //Media Query
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_pixel_ratio = MediaQuery.of(context).devicePixelRatio;

    return MaterialApp(
      home: Scaffold(
        //Background main color
        backgroundColor: const Color.fromRGBO(35, 22, 81, 1.0),

        body: Stack(
          children: [
            //Background image
            Image.asset(
              "images/map.png",
              fit: BoxFit.cover,
              width: screen_width,
              height: screen_height,
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

                  //ForKast container
                  SizedBox(
                    //Original emulator is Pixel 8 Pro (height: 2992px, width: 1344px)
                    //Dynamically scale according to screen size
                    height: 80,
                    width: 320,
                    child: Center(
                      child: Text(
                        "ForKast",
                        style: GoogleFonts.pressStart2p(
                          textStyle: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Loading... container
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: Center(
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.quantico(
                          textStyle: const TextStyle(
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