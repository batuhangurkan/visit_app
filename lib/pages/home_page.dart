import 'package:cloud_firestore/cloud_firestore.dart';
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
              // showMaterialModalBottomSheet( gelicek :)
            },
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [

            SizedBox(
              height: 20,
            ),
            Row(children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(" Hi Cnm Hg ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),

              )
            ],),
            SizedBox(height: 20,),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/profilepage', (route) => true);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 125,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" Kazıklandığım Yerler ", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                ),
              ),

            ),
            SizedBox(height: 15,),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/profilepage', (route) => true);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 125,
                decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" Tombalağ ", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                ),
              ),


            ),
            SizedBox(height: 10,),
            Row(children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Kayıtlı Kullanıcılar", style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),

              )
            ],),

            Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        final person = data[index].data();
                        var signupDate = user?.metadata.creationTime;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/logo.png'),
                              ),

                              title: Text(person['displayName']),
                              subtitle:  Text(DateFormat.yMMMMEEEEd().format(signupDate!),
                            ),
                              trailing: GestureDetector(onTap: () {

                              }, child: FaIcon(FontAwesomeIcons.locationArrow, color: Colors.green,)),
                            ),],
                        );
                      }),
                );
              },
              stream:
              FirebaseFirestore.instance.collection("Person").snapshots(),
            ),)
          ],
        ),
      ),
    );
  }
}
