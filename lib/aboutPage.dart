import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(13.067439, 80.237617), zoom: 15);
  GoogleMapController? _googlecontroller;
  Set<Marker> _markers = {
    Marker(markerId: MarkerId("1"), position: LatLng(13.067439, 80.237617))
  };

  @override
  void dispose() {
    // TODO: implement dispose
    _googlecontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us ")),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height * 1 / 2 - 100,
              child: Container(
                child: Text("Hello"),
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 1 / 2 - 50,
                width: MediaQuery.of(context).size.width - 50,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) =>
                          _googlecontroller = controller,
                      markers: _markers,
                      initialCameraPosition: _initialCameraPosition,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.center_focus_strong,
                            size: 30,
                          ),
                          onPressed: () => _googlecontroller?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  _initialCameraPosition)),
                          mini: true,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
