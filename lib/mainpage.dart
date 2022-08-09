import 'dart:async';

//import 'package:anything/screens/ui.dart';

import 'package:anything/aboutPage.dart';
import 'package:anything/globalvar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addDetails.dart';
import 'gridwidget.dart';
import 'landingpage.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  String title;

  MainPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final database = FirebaseDatabase.instance.reference();
  bool isSelected = true;
  List names = [];
  @override
  void initState() {
    // TODO: implement initStated
    super.initState();
    getUserAmount();
    activateListeners(pathxy);
    // database.child(pathxy).child("2w").child("a").set({
    //   "name": "abc",
    //   "image":
    //       "https://cdn.pixabay.com/photo/2022/05/03/04/34/marseille-7170837_960_720.jpg",
    //   "lp": "yes",
    //   "desc": "descriptionController",
    //   "price": "100"
    // });
  }

  void activateListeners(String x) {
    vehicleStream = database.child(x).onValue.listen((event) async {
      dynamic data = event.snapshot.value;

      List temp = [];
      List tempforname = [];
      landingpg = await event.snapshot.child("lp").value;
      if (landingpg == "yes") {
        data.forEach((k, v) {
          temp.add(event.snapshot.value);
          print(temp);
        });

        setState(() {
          categories = temp;
        });
      } else {
        print("object"+landingpg);
        
        data.forEach((k, v) {
          if (k != "name" && k != "image" && k != "lp") {
            temp.add(k);
            dynamic namedata = event.snapshot.child(k).child("name").value;
            tempforname.add(namedata);
            dynamic imd = event.snapshot.child(k).child("image").value;
            images.add(imd);
          }
        });

        var z = new Map<String, String>();

        for (var i = 0; i < temp.length; i++) {
          z[temp[i]] = images[i];
        }

        smapkeys = z.keys.toList()..sort(); // get only keys

        for (var i = 0; i < temp.length; i++) {
          smap[smapkeys[i]] = z[smapkeys[i]].toString();
        }

        smap.entries
            .map((e) => smapval.add(e.value))
            .toList(); // get only values

        tempforname.sort();
        temp.sort();

        setState(() {
          categories = temp;
        });
      }
    });
  }

  showText() async {
    return Future.delayed(Duration());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pathxy = pathxy.substring(0, pathxy.lastIndexOf("/"));
        Navigator.pop(context);
        activateListeners(pathxy);
        pgtitle = pathxy;

        return false;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 125,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Wrap(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Hello',
                        style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ]),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
              ListTile(
                title: Text(
                  'About Us',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: landingpg == "yes"
                  ? null
                  : FlatButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isSelected = !isSelected;
                          });
                        }
                      },
                      child: isSelected
                          ? const Text(
                              "Edit is Off",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            )
                          : const Text(
                              "Edit is on",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            ),
                    ),
            ),
          ],
          title: Text(pgtitle),
        ),
        body: categories.isEmpty

            ///if Landing page call another activity to diplay things accordingly
            ? const Center(child: CircularProgressIndicator())
            : landingpg == "yes"
                ? LandingPage(
                    cat: categories,
                  )
                : GridWidget(
                    length: smapkeys.length,
                    text: smapkeys,
                    acti: activateListeners,
                    isSelected: isSelected,
                  ),
        floatingActionButton: landingpg == "yes"
            ? null
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  uplimg.clear();
                  pickedimgList.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDetails()),
                  );
                },
              ),
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    vehicleStream?.cancel();
    super.deactivate();
  }

  void getUserAmount() async {
    final database =
        await FirebaseDatabase.instance.reference().child("MainPage/").once();

    List<String> users = [];

    var sds = database.snapshot.value;
  }
}
