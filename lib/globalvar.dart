import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'mainpage.dart';

final formkey = GlobalKey<FormState>();
var pathxy = "MainPage";
var pgtitle = "MainPage";
var landingpg;
var img, desc, price;
List categories = [];
List uplimg = [];
List pickedimgList = [];
int count = 0;
dynamic images = [];
List names = [];
List temp = [];
List temp2 = [];
var database = FirebaseDatabase.instance.ref();
StreamSubscription? vehicleStream;
Map<String, List> dummy = {};
var imgstorage = FirebaseStorage.instance;
var pp;

List tempforname = [];

var smap = new Map<String, String>();
var smapkeys = [];
var smapval = [];
var storageImages = [];

Future<void> getimgurl(String pathforimg) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final result = await storage.ref(pathforimg).list();
  final List<Reference> allFiles = result.items;

  await Future.forEach<Reference>(allFiles, (file) async {
    final String fileUrl = await file.getDownloadURL();

    storageImages.add(fileUrl);
  });


   
}

gotolastpage(var context) {
    print("SDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD " + pathxy + " kk " + pgtitle);
    pgtitle = pathxy;
    if (pathxy != "MainPage") {
      pgtitle = pathxy.substring(pathxy.lastIndexOf("/") + 1);
    }
    print("SDDDDDDDDDDDDDDD " + pathxy + " kk " + pgtitle);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainPage(
                title: pgtitle,
              )),
    );

  }
