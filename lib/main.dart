// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stickynote/google_sheets_api.dart';
import 'package:stickynote/homepage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
        theme: ThemeData(primarySwatch: Colors.pink));
  }
}