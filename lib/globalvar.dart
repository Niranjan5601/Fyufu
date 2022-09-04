import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'mainpage.dart';

final formkey = GlobalKey<FormState>();
var pathxy = "MainPage";
var pgtitle = "MainPage";
var landingpg;
  var alreadyimgcount = 0;

var img, desc, price;
List categories = [];
List pickedimgList = [];
int count = 0;
dynamic images = [];
List names = [];
List temp = [];
List temp2 = [];
var database = FirebaseDatabase.instance.ref();
var vehicleStream;
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
    pgtitle = pathxy;
    if (pathxy != "MainPage") {
      pgtitle = pathxy.substring(pathxy.lastIndexOf("/") + 1);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainPage(
                title: pgtitle,
              )),
    );

  }
