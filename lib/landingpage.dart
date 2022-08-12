import 'dart:async';

import 'package:flutter/material.dart';

import 'globalvar.dart';

class LandingPage extends StatefulWidget {
  List cat;
  LandingPage({Key? key, required this.cat}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  StreamSubscription? _vehicleStream;

  @override
  Widget build(BuildContext context) {
    widget.cat[0].forEach((k, v) {
      if (k == "image") {
        img = v;
      }
      if (k == "price") {
        price = v;
      }
      if (k == "desc") {
        desc = v;
      }
    });
    return Scaffold(
      body: 1 == 0
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          child: Image.network(
                            img,
                            height: 300,
                            width: double.infinity, 
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: IntrinsicHeight(
                          child: Text(
                              desc.toString() + "\n\n\nRs." + price.toString(),
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void deactivate() {
    _vehicleStream?.cancel();
    super.deactivate();
  }
}
