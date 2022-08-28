import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'globalvar.dart';
import 'mainpage.dart';

class UpdateDetails extends StatefulWidget {
  UpdateDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  bool isChecked = false;
  List<String> files = [];

  void initState() {
    super.initState();
  }

  bool toenable = false;

  var updatedescriptionController = TextEditingController();
  var updatepathController = TextEditingController()..text = pathxy;
  var updatepriceController = TextEditingController();
  var updatecategoriesController = TextEditingController()..text = temp[1];

  @override
  Widget build(BuildContext context) {
    if (temp[0] == "yes") {
      toenable = true;
      updatepriceController.text = temp[4].toString();
      updatedescriptionController.text = temp[3];
      isChecked = true;
    }

    return WillPopScope(
        onWillPop: () async {
          pathxy = pathxy.substring(0, pathxy.lastIndexOf("/"));
          gotolastpage(context);
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z ]")),
                      ],
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                    Container(
                      // if image list is empty it must not give an error, for now it is showing invalid arguments

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
                                    child: Image.network(
                                      pickedimgList[indx].toString().trim(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 0, 30),
                                        onPressed: () {
                                          // setState(() {

                                          //   if (indx < alreadyimgcount) {
                                          //    //delete the already uploaded file the url is saved in "pickedimglist, uplimg and temp[2]"
                                          //     alreadyimgcount--;
                                          //   }

                                          //   else {
                                          //     FirebaseStorage.instance
                                          //         .refFromURL(files[indx])
                                          //         .delete();
                                          //     files.removeAt(indx);
                                          //   }

                                          //   pickedimgList.removeAt(indx);
                                          //   uplimg.removeAt(indx);
                                          // });

                                          setState(() {
                                            {
                                              if (indx < alreadyimgcount) {
                                                pickedimgList.removeAt(indx);
                                                alreadyimgcount--;
                                              } else {
                                                FirebaseStorage.instance
                                                    .refFromURL(files[indx])
                                                    .delete();
                                                files.removeAt(indx);
                                              }
                                            }
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z ]")),
                      ],
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z ]")),
                      ],
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

                        // final snackBar = SnackBar(
                        //   content: Text('Updated Data'),
                        //   duration: new Duration(milliseconds: 500),
                        // );

                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        // pathxy = "MainPage";

                        // pgtitle = "MainPage";

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => MainPage(
                        //             title: pathxy,
                        //           )),
                        // );
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

  @override
  void deactivate() {
    vehicleStream?.cancel();
    super.deactivate();
  }

  uploadImage(int camnum) async {
    pp = updatecategoriesController.text.toString().trim().toString();

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

      setState(() => pickedimgList.add(file));
    } on PlatformException catch (e) {}
  }

  void updatedata() async {
    print("xxxxxxxxxxx" + temp[2].toString());
    print("xxxxxxxxxxxyyyyyyyyyyyyyy" + pickedimgList.toString());

    temp[2].removeWhere((element) => pickedimgList.contains(element));

    print("xxxxxxxxxxxzzzzzzzzzzzzzzz" + temp[2].toString());

    for (var xy in temp[2]) {
      FirebaseStorage.instance.refFromURL(xy).delete();
    }
    // var newadd = (pathxy.substring(0, pathxy.lastIndexOf("/") + 1)) +
    //     updatecategoriesController.text;
    // database.child(pathxy).set({
    //   "images": (pickedimgList + files).toString(),
    //   "lp": landingpg,
    //   "desc": updatedescriptionController.text.isEmpty
    //       ? null
    //       : updatedescriptionController.text,
    //   "price": updatepriceController.text.isEmpty
    //       ? null
    //       : updatepriceController.text
    // });

    // dynamic datax;

    // vehicleStream = database.child(pathxy).onValue.listen((event) {
    //   datax = event.snapshot.value;
    // });

    // updatedescriptionController.clear();
    // updatecategoriesController.clear();
    // updatepriceController.clear();
  }
}
