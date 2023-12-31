import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp1/services/firebase_service.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HistoryPlace extends StatefulWidget {
  const HistoryPlace({super.key});

  @override
  State<HistoryPlace> createState() => _HistoryPlaceState();
}

class _HistoryPlaceState extends State<HistoryPlace> {
  TextEditingController _locationNameController = TextEditingController();
  TextEditingController _locationTimeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _adressController = TextEditingController();
  TextEditingController _latlngController = TextEditingController();
  CollectionReference locationadd =
      FirebaseFirestore.instance.collection('Location');

  List<String> categoryList = ['Yemek', 'Tatlı'];

  _onlyMessageProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        barrierDismissible: true,
        msg: "Harita bilgileri alınıyor...",
        hideValue: true,
        backgroundColor: Colors.white);

    /** You can update the message value after a certain action **/
    await Future.delayed(Duration(milliseconds: 1000));
    pd.update(msg: "Haritada işaretleniyor....");

    await Future.delayed(Duration(milliseconds: 1000));
    pd.close();
  }

  getLocationProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        barrierDismissible: false,
        msg: "Lokasyon bilgisi alınıyor.",
        hideValue: true,
        backgroundColor: Colors.white);

    /** You can update the message value after a certain action **/
    await Future.delayed(Duration(milliseconds: 1000));
    pd.update(msg: "Bu işlem biraz uzun sürebilir!");

    await Future.delayed(Duration(milliseconds: 1000));
    pd.close();
  }

//Google maps'e yönlendirme kısmı :)
  _launchMap() async {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> getLat =
        FirebaseFirestore.instance
            .collection("Location")
            .doc('lat')
            .snapshots();
    final Stream<DocumentSnapshot<Map<String, dynamic>>> getLong =
        FirebaseFirestore.instance
            .collection("Location")
            .doc('lng')
            .snapshots();

    final String encodedUrl = Uri.encodeFull(
        'https://www.google.com/maps/search/?api=1&query=${getLat},${getLong}');

    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl);
    } else {
      throw 'Could not launch $encodedUrl';
    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Gezdiğim Yerler',
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
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.locationDot,
              color: Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 600,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Gezilecek bir yer ekleyin!',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 75,
                              child: TextFormField(
                                controller: _locationNameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_city),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hoverColor: Colors.green[600],
                                  hintText: 'Yer Adı',
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 75,
                              child: TextFormField(
                                onTap: () {
                                  showDatePicker(
                                          // showDatePicker() methodu ile kullanıcıya tarih seçtiriyoruz.
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025))
                                      .then((value) {
                                    _locationTimeController.text =
                                        value!.toString();
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                controller: _locationTimeController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.timer),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hoverColor: Colors.green[600],
                                  hintText: 'Zaman Seçin',
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 75,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.category),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hoverColor: Colors.green[600],
                                  hintText: 'Kategori Seçin',
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                value: _categoryController.text.isEmpty
                                    ? null
                                    : _categoryController.text,
                                items: categoryList.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _categoryController.text = value.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 75,
                              child: TextFormField(
                                controller: _adressController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_city),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hoverColor: Colors.green[600],
                                  hintText: 'Adres Bilgisi',
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_locationNameController.text.isNotEmpty &&
                                      _locationTimeController.text.isNotEmpty &&
                                      _categoryController.text.isNotEmpty) {
                                    await FirebaseService().insertLocation(
                                      locationName:
                                          _locationNameController.text,
                                      locationTime:
                                          _locationTimeController.text,
                                      category: _categoryController.text,
                                      adress: _adressController.text,
                                      lat:
                                          _currentPosition!.latitude.toString(),
                                      lng: _currentPosition!.longitude
                                          .toString(),
                                    );

                                    ElegantNotification.success(
                                            progressIndicatorBackground:
                                                Colors.green,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1,
                                            height: 100,
                                            title: Text("Başarılı!"),
                                            description:
                                                Text("Lokasyon eklendi! "))
                                        .show(context);

                                    _locationNameController.clear();
                                    _locationTimeController.clear();
                                    _categoryController.clear();
                                  } else {
                                    ElegantNotification.error(
                                            progressIndicatorBackground:
                                                Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1,
                                            height: 100,
                                            title: Text("Hata!"),
                                            description: Text(
                                                "Bilgilerinizi kontrol ediniz!"))
                                        .show(context);
                                  }
                                },
                                child: Text('Ekle',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.blueAccent),
                                onPressed: () async {
                                  print(_getCurrentPosition());
                                  getLocationProgress(context);

                                  setState(() {
                                    _handleLocationPermission();
                                    _adressController.text =
                                        _currentAddress.toString();
                                  });
                                },
                                child: Text(
                                  'Lokasyon bilgimi çek',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
            },
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                if (ConnectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        final location = data[index].data();

                        return Dismissible(
                          key: Key(location['locationName']),
                          onDismissed: (direction) async {
                            FirebaseFirestore.instance
                                .collection('Location')
                                .doc(data[index].id)
                                .delete();
                            ElegantNotification.success(
                                    progressIndicatorBackground: Colors.green,
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    height: 100,
                                    title: Text("Başarılı!"),
                                    description: Text("Lokasyon silindi! "))
                                .show(context);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.update,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  location['locationName'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(location['adress'],
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                                trailing: GestureDetector(
                                    onTap: () {
                                      print(_currentPosition);
                                      _onlyMessageProgress(context);
                                      _launchMap();
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.locationArrow,
                                      color: Colors.green,
                                    )),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      location['category'],
                                      style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
              stream:
                  FirebaseFirestore.instance.collection("Location").snapshots(),
            ),
          ],
        ),
      ),
    );
  }
}
