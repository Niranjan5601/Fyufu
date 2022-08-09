import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'globalvar.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class UpdateDetails extends StatefulWidget {
  UpdateDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  bool isChecked = false;
  List temp2 = [];

  void initState() {
    print(temp);

    super.initState();
  }

  bool toenable = false;
  var updateimageurlController = TextEditingController()..text = temp[2];

  var updatedescriptionController = TextEditingController();
  var updatepathController = TextEditingController()..text = pathxy;
  var updatepriceController = TextEditingController();
  var updatecategoriesController = TextEditingController()..text = temp[1];

  @override
  Widget build(BuildContext context) {
    if (temp[0] == "yes") {
      updatepriceController.text = temp[4].toString();
      updatedescriptionController.text = temp[3];
      isChecked = true;
    }
    dynamic datax;

    void updatedata() async {
      var newadd = (pathxy.substring(0, pathxy.lastIndexOf("/") + 1)) +
          updatecategoriesController.text;

      database.child(pathxy).set({
        "name": updatecategoriesController.text,
        "image": updateimageurlController.text,
        "lp": landingpg,
        "desc": updatedescriptionController.text.isEmpty
            ? null
            : updatedescriptionController.text,
        "price": updatepriceController.text.isEmpty
            ? null
            : updatepriceController.text
      });
     

      updatedescriptionController.clear();
      updatecategoriesController.clear();
      updateimageurlController.clear();
      updatepriceController.clear();

    }

    return WillPopScope(
        onWillPop: () async {
          pathxy = pathxy.substring(0, pathxy.lastIndexOf("/"));
          Navigator.pop(context);
          pgtitle = pathxy.substring(pathxy.lastIndexOf("/") + 1);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Update Data"),
          ),
          body: SafeArea(
              child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Update Data",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: updatepathController,
                      enabled: false,
                      decoration: const InputDecoration(
                          label: Text("Path"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: updatecategoriesController,
                      decoration: const InputDecoration(
                          label: Text("Categories/Models"),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text("Image:",
                            style: TextStyle(
                              fontSize: 15,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network(updateimageurlController.text),
                        )
                      ],
                    ),

                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                              toenable = value;
                              if (value) {
                                landingpg = "yes";
                              } else {
                                landingpg = "no";
                              }
                            });
                          },
                          value: isChecked,
                        ),
                        const Text(
                          "Landing Page",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      enabled: toenable,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "This field is mandatory";
                        }
                      },
                      controller: updatepriceController,
                      decoration: const InputDecoration(
                          label: Text("Price"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      enabled: toenable,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "This field is mandatory";
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      controller: updatedescriptionController,
                      decoration: const InputDecoration(
                          label: Text("Description"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (!isChecked) {
                        } else if (!formkey.currentState!.validate()) {
                          return;
                        }

                        updatedata();

                        final snackBar =
                            SnackBar(content: Text('Updated Data'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          )),
        ));
  }

  Future<List> loadImages(String imgloadpath) async {
    List<String> files = [];
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    final result = await storage.ref(imgloadpath).list();
    final List<firebase_storage.Reference> allFiles = result.items;

    await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      files.add(fileUrl);
    });

    return files;
  }

  @override
  void deactivate() {
    vehicleStream?.cancel();
    super.deactivate();
  }

  static Future<int> getUserAmount() async {
    dynamic datax;

    vehicleStream = database.child("MainPage").onValue.listen((event) async {
   });
    final sdfsd = await FirebaseDatabase.instance.ref().child("MainPage").get();
    var users = [];
  
    var collection = FirebaseDatabase.instance.ref().child('MainPage');
    var querySnapshot = await collection.get();

    return users.length;
  }

 
}
