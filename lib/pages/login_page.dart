import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp1/pages/bottomnavigationbar.dart';
import 'package:myapp1/pages/home_page.dart';
import 'package:myapp1/pages/register_page.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../services/auth.dart';
import 'flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  AuthService _authService = AuthService();

  // progress bar
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          width: MediaQuery.of(context)
              .size
              .width, // this will take full width of screen
          height: MediaQuery.of(context).size.height,
          child: (SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 150,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
                Center(
                  child: Text(
                    "Hoşgeldin,",
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Kullanıcını seçerek giriş yapabilirsin!",
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
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
                            final person = data[index].data();

                            var signupDate = user?.metadata.creationTime;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _onlyMessageProgress(context);
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
// Here you can write your code

                                      setState(() {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/bottomnavigationbar',
                                            (route) => false);
                                      });
                                    });
                                  },
                                  child: ListTile(
                                    title: Text(
                                      person['displayName'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(person['email'],
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                    trailing: FaIcon(
                                      FontAwesomeIcons.locationArrow,
                                      color: Colors.green,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        ('assets/images/logo.png'),
                                      ),
                                      radius: 20,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  },
                  stream: FirebaseFirestore.instance
                      .collection("Person")
                      .snapshots(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      height: 2,
                      color: Colors.grey,
                    )),
                    Text(
                      "Bunları Dene",
                      style: GoogleFonts.poppins(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Divider(
                      height: 2,
                      color: Colors.grey,
                    )),
                  ]),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: SignInButton(
                        buttonType: ButtonType.google,
                        onPressed: () {
                          print('click');
                        })),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: SignInButton(
                        buttonType: ButtonType.githubDark,
                        onPressed: () {
                          print('click');
                        })),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: SignInButton(
                        buttonSize: ButtonSize.small,
                        buttonType: ButtonType.discord,
                        onPressed: () {
                          print('click');
                        })),
              ],
            ),
          ))),
    );
  }
}
