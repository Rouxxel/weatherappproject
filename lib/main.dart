import 'package:flutter/material.dart';
import 'package:weatherappproject/landingpage.dart';
import 'package:weatherappproject/loadingpage.dart';
import 'package:weatherappproject/searchpage.dart';
import 'package:weatherappproject/detailspage.dart';

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
