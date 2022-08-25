import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';

import 'globalvar.dart';

class AddDetails extends StatefulWidget {
  AddDetails({Key? key}) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  bool isChecked = false;
  bool toenable = false;

  List<String> files = [];

  var categoriesController = TextEditingController();
  var descriptionController = TextEditingController();
  var pathController = TextEditingController()..text = pathxy;

  var priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pgtitle = "Insert Data";
    return WillPopScope(
      onWillPop: () async {
        gotolastpage(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(pgtitle),
        ),
        body: SafeArea(
            child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(children: [
              Column(
                children: [
                  const Text(
                    "Insert Data",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: pathController,
                    enabled: false,
                    decoration: const InputDecoration(
                        label: Text("Path"), border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: categoriesController,
                    decoration: const InputDecoration(
                        label: Text("Categories/Models"),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Image :",
                        style: TextStyle(fontSize: 18),
                      ),
                      ElevatedButton(
                          child: const Text(
                            "Open Camera",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => uploadImage(0)),
                      ElevatedButton(
                          child: const Text("Choose from \n gallery",
                              textAlign: TextAlign.center),
                          onPressed: () => uploadImage(1)),
                    ],
                  ),
                  pickedimgList.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height / 7,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: pickedimgList.length,
                              itemBuilder: (BuildContext ctx, int indx) {
                                return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          pickedimgList[indx],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            padding: EdgeInsets.fromLTRB(
                                                30, 0, 0, 30),
                                            onPressed: () {
                                              setState(() {
                                                FirebaseStorage.instance
                                                    .refFromURL(files[indx])
                                                    .delete();

                                                pickedimgList.removeAt(indx);
                                                uplimg.removeAt(indx);
                                                files.removeAt(indx);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 20,
                                            )),
                                      )
                                    ]);
                              }),
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
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
                    controller: priceController,
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        label: Text("Description"),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (!isChecked) {
                      } else if (!formkey.currentState!.validate()) {
                        return;
                      }
                      insertData();
                      //loadImages().then((value) => insertData());
                      //uploadtofb();
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ]),
          ),
        )),
      ),
    );
  }

  uploadImage(int camnum) async {
    pp = categoriesController.text.toString().trim().toString();

    if (pp.toString().isEmpty) {
      final snackBar = SnackBar(
        content: Text('Enter category name first'),
        duration: Duration(milliseconds: 500),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    ;

    final _imagePicker = ImagePicker();
    PickedFile image;

// sometimes even if the quality is more the actual quality is less than the one obtained from less quality function i.e. - it is confusing
// but this method is very quick and saves a lot of trouble
// so gotta do some research for the value

    if (camnum == 0) {
      image = (await _imagePicker.getImage(
          source: ImageSource.camera, imageQuality: 40))!;
    } else {
      image = (await _imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 40))!;
    }

                                                    
    try {
      if (image == null) {
        return null;
      }
      var file = File(image.path);

      print(image.path.toString());

      final ref = FirebaseStorage.instance
          .ref()
          .child(pathxy + "/" + pp + "/" + image.path.replaceAll("/", ""));

      ref.putFile(file).then((TaskSnapshot taskSnapshot) {
        if (taskSnapshot.state == TaskState.success) {
          print("Image uploaded Successful");
          // Get Image URL Now
          taskSnapshot.ref.getDownloadURL().then((imageURL) {
            files.add(imageURL);
            {
              print("Image Download URL is $imageURL");
            }
          });
        } else if (taskSnapshot.state == TaskState.running) {
          // Show Prgress indicator
        } else if (taskSnapshot.state == TaskState.error) {
          // Handle Error Here
        }
      });
      ;

      uplimg.add(file);

      setState(() => pickedimgList.add(file));
    } on PlatformException catch (e) {}
  }

  Future<void> insertData() async {
    if (categoriesController.text.isEmpty) {
      return null;
    }
    database.child(pathxy).child(categoriesController.text).set({
      "lp": landingpg,
      "iamges": pickedimgList.isEmpty ? "[]" : files.toString(),
      "desc": descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
      "price": priceController.text.isEmpty ? null : priceController.text
    });

    descriptionController.clear();
    categoriesController.clear();
    priceController.clear();

    final snackBar = SnackBar(
      content: Text(' Data Added '),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    gotolastpage(context);
  }

  
}
