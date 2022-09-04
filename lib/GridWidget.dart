import 'dart:async';

import 'package:anything/globalvar.dart';
import 'package:anything/mainpage.dart';
import 'package:anything/storage_service.dart';
import 'package:anything/updateData.dart';
import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  int length;
  Function acti;
  bool isSelected;
  List text;
  GridWidget({
    Key? key,
    required this.length,
    required this.text,
    required this.acti,
    required this.isSelected,
  }) : super(key: key);

  callupda(var context) {
    temp.clear();
    pickedimgList.clear();
    vehicleStream = database.child(pathxy).onValue.listen((event) {
      dynamic data = event.snapshot.value;
      if (data["lp"] == "yes") {
        temp.add("yes");
        temp.add(event.snapshot.key);
        temp.add(data["images"]);

        temp.add(data["desc"]);
        temp.add(data["price"]);
      } else {
        temp.add("no");
        temp.add(event.snapshot.key);
        temp.add(data["images"]);
      }
    });

    var _timer = new Timer(const Duration(milliseconds: 400), () {
      temp[2] = temp[2].toString().substring(
          1,
          temp[2].toString().length -
              1); //get only the urls by removing square brackets

      temp[2] = temp[2].toString().split(","); // split the urls

      // assign the values

      for (var mx in temp[2]) {
        pickedimgList.add(mx);
      }

      alreadyimgcount = pickedimgList.length;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateDetails(),
        ),
      );
    });

    Future.delayed(Duration(milliseconds: 10000), () {
      // print(temp[2]);

      // temp[2] = temp[2].toString().substring(
      //     1,
      //     temp[2].toString().length -
      //         1); //get only the urls by removing square brackets

      // temp[2] = temp[2].toString().split(","); // split the urls

      // // assign the values

      // pickedimgList = temp[2];

      // print(temp[2]);
      // alreadyimgcount = pickedimgList.length;

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UpdateDetails(),
      //   ),
      // );
    });
  }

  Storage storage = new Storage();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.loadImages(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
              ),
              itemCount: length,
              itemBuilder: (context, idx) {
                return InkWell(
                  onTap: () {
                    pgtitle = categories[idx];

                    pathxy += "/" + categories[idx];
                    !isSelected
                        ? callupda(context)
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      title: categories[idx],
                                    )),
                          );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs0uyjWTrJw53i8IJPHJ3IIjxs3-UXMkN3LyaVEtU&s",
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    text[idx].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 25,
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete ${text[idx]}"),
                                          content: Text(
                                              "Are you sure you want to delete?"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                gotolastpage(context);
                                              },
                                              child: Text("No"),
                                            ),
                                            FlatButton(
                                                onPressed: () {
                                                  database
                                                      .child(pathxy)
                                                      .child(text[idx])
                                                      .remove()
                                                      .whenComplete(() {
                                                    gotolastpage(context);
                                                  });
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                        'Deleted ${text[idx]}'),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                child: Text("Yes "))
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
