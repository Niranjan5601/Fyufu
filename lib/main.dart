import 'package:anything/globalvar.dart';
import 'package:anything/mainpage.dart';
import 'package:anything/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    
    // check for update in the firebasedatabase

    vehicleStream = database.child("Update").onValue.listen((event) {
      dynamic data = event.snapshot.value;

      if (data == "yes") {
        //show alert dialog box to update the app from playstore

      } else {
        
      }
    });

  
    return MaterialApp(
      title: 'MainPage',
      theme: ThemeData(
        fontFamily: "OpenSans",
        primarySwatch: Colors.amber,
      ),
      home: MainPage(title: "MainPage"),
    );
  }
}
