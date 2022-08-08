import 'package:anything/globalvar.dart';
import 'package:anything/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    vehicleStream = database.child("Update").onValue.listen((event) {
      dynamic data = event.snapshot.value;

      if (data == "yes") {
//show alert dialog box

      }
    });
    var x = "MainPage";

    return MaterialApp(
      title: 'MainPage',
      theme: ThemeData(
        fontFamily: "OpenSans",
        primarySwatch: Colors.amber,
      ),
      home: MainPage(title: x),
    );
  }
}
