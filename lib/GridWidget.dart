import 'package:anything/globalvar.dart';
import 'package:anything/mainpage.dart';
import 'package:anything/storage_service.dart';
import 'package:anything/updateData.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    vehicleStream = database.child(pathxy).onValue.listen((event) {
      dynamic data;
      data = event.snapshot.value;
      var df = (data.toString());
      df = df.substring(df.indexOf("\"lp") + 6);
      df = df.substring(0, df.indexOf(","));
      if (df == "yes") {
        temp.add("yes");
        temp.add(event.snapshot.child("name").value);
        temp.add(event.snapshot.child("images").value);

        temp.add(event.snapshot.child("desc").value);
        temp.add(event.snapshot.child("price").value);
      } else {
        temp.add("no");
        temp.add(event.snapshot.child("name").value);
        temp.add(event.snapshot.child("images").value);
      }
    });

    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateDetails(),
        ),
      );
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
