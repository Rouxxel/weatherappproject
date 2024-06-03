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

class hourlyweatherscreen extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyWeatherData = [
    {"time": "7 PM", "icon": WeatherIcons.wi_day_sunny, "temp": "20°"},
    {"time": "8 PM", "icon": WeatherIcons.wi_day_cloudy, "temp": "19°"},
    {"time": "9 PM", "icon": WeatherIcons.wi_day_rain, "temp": "18°"},
    {"time": "10 PM", "icon": WeatherIcons.wi_day_thunderstorm, "temp": "17°"},
    {"time": "11 PM", "icon": WeatherIcons.wi_day_fog, "temp": "16°"},
    {"time": "12 AM", "icon": WeatherIcons.wi_night_clear, "temp": "15°"},
    {"time": "1 AM", "icon": WeatherIcons.wi_night_cloudy, "temp": "14°"},
    {"time": "2 AM", "icon": WeatherIcons.wi_night_rain, "temp": "13°"},
    {"time": "3 AM", "icon": WeatherIcons.wi_night_snow, "temp": "12°"},
    {"time": "4 AM", "icon": WeatherIcons.wi_night_storm_showers, "temp": "11°"},
    {"time": "5 AM", "icon": WeatherIcons.wi_night_alt_cloudy, "temp": "10°"},
    {"time": "6 AM", "icon": WeatherIcons.wi_night_alt_rain, "temp": "9°"},
    {"time": "7 AM", "icon": WeatherIcons.wi_day_sunny, "temp": "8°"},
    {"time": "8 AM", "icon": WeatherIcons.wi_day_cloudy, "temp": "7°"},
    {"time": "9 AM", "icon": WeatherIcons.wi_day_rain, "temp": "6°"},
    {"time": "10 AM", "icon": WeatherIcons.wi_day_thunderstorm, "temp": "5°"},
    {"time": "11 AM", "icon": WeatherIcons.wi_day_fog, "temp": "4°"},
    {"time": "12 PM", "icon": WeatherIcons.wi_day_sunny, "temp": "3°"},
    {"time": "1 PM", "icon": WeatherIcons.wi_day_cloudy, "temp": "2°"},
    {"time": "2 PM", "icon": WeatherIcons.wi_day_rain, "temp": "1°"},
    {"time": "3 PM", "icon": WeatherIcons.wi_day_thunderstorm, "temp": "0°"},
    {"time": "4 PM", "icon": WeatherIcons.wi_day_fog, "temp": "-1°"},
    {"time": "5 PM", "icon": WeatherIcons.wi_day_sunny, "temp": "-2°"},
    {"time": "6 PM", "icon": WeatherIcons.wi_day_cloudy, "temp": "-3°"},
  ];

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
            scrollDirection: Axis.horizontal,
            itemCount: hourlyWeatherData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(77, 204, 189, 0.7),
                ),
                width: 100,
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        hourlyWeatherData[index]["icon"],
                        size: 35,
                        color: Colors.white,
                      ),
                      Text(
                        hourlyWeatherData[index]["temp"],
                        style: GoogleFonts.sansita(
                          textStyle: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Color.fromRGBO(35, 22, 81, 1.0),
                          ),
                        ),
                      ),

                      Text(
                        hourlyWeatherData[index]["time"],
                        style: GoogleFonts.quantico(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Color.fromRGBO(35, 22, 81, 1.0),
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