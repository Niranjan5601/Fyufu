import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

final formkey = GlobalKey<FormState>();
var pathxy = "MainPage";
var landingpg;
var img, desc, price;
List categories = [];
List uplimg = [];
List pickedimgList = [];
int count = 0;
List images = [];
var pgtitle = "MainPage";
List names = [];
List temp = [];
List temp2 = [];
var database = FirebaseDatabase.instance.ref();
StreamSubscription? vehicleStream;
Map<String, List> dummy = {};
var imgstorage = FirebaseStorage.instance;

var smap = new Map<String, String>();
var smapkeys = [];
var smapval = [];
