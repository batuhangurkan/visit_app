import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp1/pages/bottomnavigationbar.dart';
import 'package:myapp1/pages/home_page.dart';
import 'package:myapp1/pages/register_page.dart';
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
                  height: 200,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 100,
                  child: Center(
                    child: Text(
                      'Giriş Yapın',
                      style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 75,
                        child: TextFormField(
                          controller: _emailcontroller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'E-mail',
                            prefixIcon: Icon(Icons.mail),
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 75,
                        child: TextFormField(
                          controller: _passwordcontroller,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Şifre',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(200, 0, 0, 25),
                            child: Text("Şifremi Unuttum",
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline))),
                        onTap: () {
                          //şifremi sıfırla
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/resetpasswordpage',
                              (Route<dynamic> route) => true);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_emailcontroller.text.isNotEmpty &&
                                _passwordcontroller.text.isNotEmpty) {
                              setState(() async {
                                await _authService
                                    .signIn(_emailcontroller.text,
                                        _passwordcontroller.text)
                                    .then((value) => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/bottomnavigationbar',
                                            (Route<dynamic> route) => false));
                              });
                            } else {
                              ElegantNotification.error(
                                      progressIndicatorBackground: Colors.red,
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      height: 100,
                                      title: Text("Hata!"),
                                      description: Text(
                                          "Giriş bilgilerinizi kontrol ediniz."))
                                  .show(context);
                            }
                          },
                          child: Text('Giriş Yap',
                              style: GoogleFonts.poppins(fontSize: 15)),
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
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            child: RichText(
                                text: TextSpan(
                                    text: "Hesabınız yok mu? ",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black, fontSize: 15),
                                    children: [
                                  TextSpan(
                                      text: "Kayıt Olun",
                                      style: TextStyle(
                                          color: Colors.blueAccent[200],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ])),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ))),
    );
  }
}
