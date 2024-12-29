import 'package:flutter/material.dart';
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/FirstPage.dart';
import 'package:southern/HomePage.dart';
import 'package:southern/LoginPage.dart';
import 'package:southern/PaperAddingPage.dart';
import 'package:southern/SjopAddingPage.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:southern/xx.dart';
//import 'package:southern/test.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SouthernGraphicsPage() ,
    );
  }
}
