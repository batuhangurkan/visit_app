import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  String locationMessage = "test";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.933365, 32.859741),
    zoom: 14.4746,
  );


  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisi kapalı');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Konum izni verilmedi - forever');
      // Konum izni verilmedi - forever
    }else {
      print("merhaba");
      return await Geolocator.getCurrentPosition();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _getCurrentLocation().then((value) => (value) {
                    print(value.latitude);
                    print(value.longitude);
                    setState(() {
                      locationMessage =
                          "Enlem: ${value.latitude} \nBoylam: ${value.longitude}";
                    });
                  });
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    width: MediaQuery.of(context).size.width,
                        height: 400,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Gitmek istediğiniz yeri seçin',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(height: 30, width: MediaQuery.of(context).size.width / 1.2, child: SearchBar(
                              //renk
                            ),)
                          ],
                        ),
                      ));
            },
            icon: Icon(
              FontAwesomeIcons.search,
              color: Colors.black,
            )),
        title: Text('Gitmek İstediğin Yeri Seç',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.bell,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: GoogleMap(
        padding: EdgeInsets.only(bottom: 10),
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
