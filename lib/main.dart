import 'package:flutter/material.dart';
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/loadingpage.dart';
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/detailspage.dart';
//TODO: Determine if all of these imports are necessary here

//imports
/////////////////////////////////////////////////////////////////////////////
//Run app

void main() {
  runApp(
    MaterialApp(
      home: loadingpage(),
    ),
  );
}
