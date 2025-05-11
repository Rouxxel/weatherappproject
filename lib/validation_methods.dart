import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//
//Other pages import
import 'package:weatherappproject/alert_dialogs.dart';
import 'package:weatherappproject/methods.dart';

//To check valid city
String validate_user_input(BuildContext context,
    String givencityname) {
  log_handler.d("[------validate_user_input function executed------]");
  if (givencityname == null || givencityname.isEmpty) {

    //Handle empty Text field
    show_no_city_or_postalcode_provided(context);
    log_handler.w("Invalid user input");
    throw ArgumentError("Input is empty");
  }

  //Limit the valid characters by user
  final validCharacters = RegExp(r'^[a-zA-Z0-9\s\-]+$');

  if (givencityname.length >= 2 &&
      givencityname.length <= 40 &&
      validCharacters.hasMatch(givencityname)) {
    log_handler.d("Valid user input");
    return givencityname;
  } else {
    //Handle invalid name or even possible attack
    show_nice_try_fed(context);
    log_handler.w("Invalid user input");
    throw ArgumentError("Invalid input: Input does not meet criteria");
  }
}

//To validate API response for get_current_weather_datas
bool validate_current_weather_data(Map<String, dynamic> data) {
  log_handler.d("[------validate_current_weather_data function executed------]");
  // Check for the presence and types of essential fields
  try {
    // Coordinates
    if (data['coord'] == null || data['coord']['lat'] == null || data['coord']['lon'] == null) return false;

    // Weather
    if (data['weather'] == null || data['weather'][0] == null || data['weather'][0]['icon'] == null || data['weather'][0]['description'] == null) return false;

    // Main data
    if (data['main'] == null || data['main']['temp'] == null || data['main']['feels_like'] == null || data['main']['temp_min'] == null || data['main']['temp_max'] == null || data['main']['humidity'] == null || data['main']['pressure'] == null) return false;

    // Wind data
    if (data['wind'] == null || data['wind']['speed'] == null || data['wind']['deg'] == null) return false;

    // System data (sunrise and sunset)
    if (data['sys'] == null || data['sys']['sunrise'] == null || data['sys']['sunset'] == null) return false;

    // Optional fields (check if they exist, if they do, check their types)
    if (data.containsKey('clouds') && data['clouds']['all'] == null) return false;
    if (data.containsKey('rain') && data['rain']['1h'] == null) return false;
    if (data.containsKey('snow') && data['snow']['1h'] == null) return false;
    if (data.containsKey('uvi') && data['uvi'] == null) return false;

    log_handler.w("API response valid");
    return true;
  } catch (e) {
    //If any error occurs during validation, return false
    log_handler.w("Error during API response for weather data validation, stopping");
    return false;
  }
}

//To validate API response for get_current_weather_datas
bool validate_current_weather_alerts(Map<String, dynamic> data) {
  log_handler.d("[------validate_current_weather_alerts function executed------]");
  try {
    // Check if 'alerts' key is present and is a list
    if (data.containsKey('alerts') && data['alerts'] is List) {
      for (var alert in data['alerts']) {
        if (alert['event'] == null || alert['event'] is! String) return false;
      }
    }

    log_handler.w("API response valid");
    return true;
  } catch (e) {
    log_handler.w("Error during API response for weather alerts validation, stopping");
    return false;
  }
}

//To validate API response for getWEEKLYHOURLYtempsicons
bool validate_weekly_hourly_weather(Map<String, dynamic> data) {
  log_handler.d("[------validate_weekly_hourly_weather function executed------]");
  try {
    if (!data.containsKey('daily') || !data.containsKey('hourly')) return false;

    // Validate daily data
    for (var dayData in data['daily']) {
      if (dayData['temp']['min'] == null || dayData['temp']['max'] == null || dayData['weather'][0]['icon'] == null) {
        log_handler.w("API response for daily data invalid");
        return false;
      }
    }

    // Validate hourly data
    for (var hourData in data['hourly']) {
      if (hourData['temp'] == null || hourData['weather'][0]['icon'] == null) {
        log_handler.w("API response for hourly data invalid");
        return false;
      }
    }

    log_handler.w("API response for daily and hourly data valid");
    return true;
  } catch (e) {
    log_handler.w("Error during API response for daily and hourly data validation, stopping");
    return false;
  }
}
