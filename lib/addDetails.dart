import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import 'globalvar.dart';
import 'mainpage.dart';

class AddDetails extends StatefulWidget {
  AddDetails({Key? key}) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  bool isChecked = false;
  bool toenable = false;

  var imageurlController = TextEditingController();
  var categoriesController = TextEditingController();
  var descriptionController = TextEditingController();
  var pathController = TextEditingController()..text = pathxy;

  var priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void insertData() {
      if (categoriesController.text.isEmpty) {
        return null;
      }
      uploadtofb();
      database.child(pathxy).child(categoriesController.text).set({
        "name": categoriesController.text.isEmpty
            ? null
            : categoriesController.text,
        "image":
            imageurlController.text.isEmpty ? null : imageurlController.text,
        "lp": landingpg,
        "desc": descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        "price": priceController.text.isEmpty ? null : priceController.text
      });
      descriptionController.clear();
      categoriesController.clear();
      imageurlController.clear();
      priceController.clear();
      final snackBar = SnackBar(
        content: Text('Added Data'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Insert Data"),
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
                        onPressed: () =>
                            uploadImage(0) //pickImage(ImageSource.gallery),

                        ),
                    ElevatedButton(
                        child: const Text("Choose from \n gallery",
                            textAlign: TextAlign.center),
                        onPressed: () =>
                            uploadImage(1) //pickImage(ImageSource.gallery),
                        ),
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
                                          padding:
                                              EdgeInsets.fromLTRB(30, 0, 0, 30),
                                          onPressed: () {
                                            setState(() {
                                              pickedimgList.removeAt(indx);
                                              uplimg.removeAt(indx);
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
                      label: Text("Description"), border: OutlineInputBorder()),
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
                    print(pathxy);
                    pathxy = "MainPage";
                    print(pathxy);

                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(title: pathxy,)),
                  );
                    //Navigator.pop(context);
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
    );
  }

  uploadImage(int camnum) async {
    final _imagePicker = ImagePicker();
    PickedFile image;

    if (camnum == 0) {
      image = (await _imagePicker.getImage(source: ImageSource.camera))!;
    } else {
      image = (await _imagePicker.getImage(source: ImageSource.gallery))!;
    }

    try {
      if (image == null) {
        return null;
      }
      var file = File(image.path);

      uplimg.add(file);
      //    print(pathxy);

      setState(() => pickedimgList.add(file));
    } on PlatformException catch (e) {
      //   print("failed to pick image: $e");
    }
  }

//
  //  Future<List> loadImages(String imgloadpath) async {
  //   List<String> files = [];
  //   final firebase_storage.FirebaseStorage storage =
  //       firebase_storage.FirebaseStorage.instance;

  //   final result = await storage.ref(imgloadpath).list();
  //   final List<firebase_storage.Reference> allFiles = result.items;

  //   await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
  //     final String fileUrl = await file.getDownloadURL();

  //     files.add(fileUrl);
  //   });

  //   return files;
  // }

  uploadtofb() async {
    count = 0;
    String pp = categoriesController.text;

    for (var zx in uplimg) {
      count++;

      final ref = FirebaseStorage.instance
          .ref()
          .child((pathxy + "/" + pp + "/" + count.toString()));

      ref.putFile(zx);

      var imgurl;

      imgurl = ref.getDownloadURL();
    }
  }
}
