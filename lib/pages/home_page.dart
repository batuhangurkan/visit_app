
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp1/pages/profile_page.dart';
import 'package:myapp1/services/auth.dart';

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




  @override
  Widget build(BuildContext context) {
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
              width: MediaQuery.of(context).size.width / 1.0,
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text("Kategori Seç", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),)
              ],),
            ),
            
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
