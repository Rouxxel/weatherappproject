import 'package:flutter/material.dart';
import 'package:weatherappproject/loading_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//imports
/////////////////////////////////////////////////////////////////////////////
//Run app

void main() async {
  //Load environment variables from the .env file
  await dotenv.load(fileName: "envvar.env");

  runApp(
    const MaterialApp(
      home: loading_page(),
    ),
  );
}
