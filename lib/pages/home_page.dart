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
  Widget build(BuildContext context) {
    _shuffleButton() {
      FutureBuilder(
          future: FirebaseFirestore.instance.collection('Location').get(),
          builder: (context, snapshot) {
            final randomizedList = (snapshot.data! as QuerySnapshot).docs;
            randomizedList.shuffle();
            return ListView.builder(
              itemCount: randomizedList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Text(
                  randomizedList[index]['locationName'],
                );
              },
            );
          });
    }

    String _sonuc = '';
    Color? likeButton;
    return Scaffold(
      backgroundColor: Colors.white,
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Kategori Seç",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Category")
                  .where("categoryName")
                  .snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      offset: Offset(0, 3))
                                ]),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Text(
                                  data['categoryName'],
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Mekan Seç",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Location")
                  .where("locationName")
                  .snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      offset: Offset(0, 3))
                                ]),
                            child: Center(
                              child: Text(
                                data['locationName'],
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _sonuc,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
