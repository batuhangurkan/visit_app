import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp1/services/auth.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:theme_manager/theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _scaffoldState = GlobalKey();
  AuthService _authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
      FirebaseFirestore.instance.collection("Location").snapshots();

  //progress bar

  _onlyMessageProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: "Giriş bilgileriniz alınıyor...",
      hideValue: true,
    );

    /** You can update the message value after a certain action **/
    await Future.delayed(Duration(milliseconds: 1000));
    pd.update(msg: "Uygulamaya Giriliyor....");

    await Future.delayed(Duration(milliseconds: 1000));
    pd.close();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Ana Sayfa',
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
              FontAwesomeIcons.gear,
              color: Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.signOut,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Çıkış Yap',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {
                                currentUser.signOut();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                            ),
                          ],
                        ),
                      ));
            },
          )),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Location')
              .where('locationName')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading');

            final docs = snapshot.data!.docs..shuffle();
            return Container(
              child: ListView.builder(
                itemCount: docs.indexOf(docs.last),
                itemBuilder: (BuildContext context, int index) {
                  final user = docs[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Bugün Nereye Gideceksin?',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Gidilecek yer:' + ' ' + user['locationName'],
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: user['adress'] != null
                                ? Text(
                                    user['adress'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    'Adres Bilgisi Yok',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shadowColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                docs.shuffle();
                              });
                            },
                            child: Text('Karıştır')),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
