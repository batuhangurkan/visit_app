import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp1/services/firebase_service.dart';

class HistoryPlace extends StatefulWidget {
  const HistoryPlace({super.key});

  @override
  State<HistoryPlace> createState() => _HistoryPlaceState();
}

class _HistoryPlaceState extends State<HistoryPlace> {
  TextEditingController _locationNameController = TextEditingController();
  TextEditingController _locationTimeController = TextEditingController();
  CollectionReference locationadd =
      FirebaseFirestore.instance.collection('Location');

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
                              'Yer Ekleyin',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
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
                            ElevatedButton(
                              onPressed: () async {
                                if (_locationNameController.text.isNotEmpty &&
                                    _locationTimeController.text.isNotEmpty) {
                                  await FirebaseService().insertLocation(
                                      locationName:
                                          _locationNameController.text,
                                      locationTime:
                                          _locationTimeController.text);
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
                                          description:
                                              Text("Bilger boş olamaz! "))
                                      .show(context);
                                }
                              },
                              child: Text('Ekle',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                                subtitle: Text(location['locationTime'],
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                                trailing: GestureDetector(
                                    onTap: () {},
                                    child: FaIcon(
                                      FontAwesomeIcons.locationArrow,
                                      color: Colors.green,
                                    )),
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
