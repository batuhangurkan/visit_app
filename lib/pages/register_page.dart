import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp1/pages/login_page.dart';

import '../services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _checkvisibility = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  AuthService _authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kayıt Olun',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: Colors.green[600],
        ),
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
                  height: 20,
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 75,
                  child: TextFormField(
                    controller: _usernamecontroller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hoverColor: Colors.green[600],
                      hintText: 'Kullanıcı Adınız',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 75,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'E-mail',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 75,
                  child: TextFormField(
                    controller: _passwordController,
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
                SizedBox(
                  height: 5,
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CheckboxListTile(
                        checkColor: Colors.green,

                        title: Text(
                          "Kullanım Koşulları ve Gizlilik Politikası",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline),
                        ),
                        value: _checkvisibility,
                        onChanged: (newValue) {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                        "Kullanım Koşulları ve Gizlilik Politikası"),
                                    content: Text(
                                        "Kullanım Koşulları ve Gizlilik Politikası içeriği"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            if (_checkvisibility == true) {
                                              setState(() {
                                                _checkvisibility = newValue!;
                                              });
                                            }
                                          },
                                          child: Text("Kapat")),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_checkvisibility == false) {
                                                _checkvisibility = newValue!;
                                                Navigator.pop(context);
                                              } else {
                                                _checkvisibility = newValue!;
                                              }
                                            });
                                          },
                                          child: Text("Kabul Ediyorum"))
                                    ],
                                  );
                                });
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: RichText(
                      text: TextSpan(
                          text: "Zaten hesabınız var mı? ",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 15),
                          children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            text: "Giriş Yap",
                            style: TextStyle(
                                color: Colors.blueAccent[200],
                                fontSize: 15,
                                fontWeight: FontWeight.bold))
                      ])),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isNotEmpty &&
                          _emailController.text.contains("@") &&
                          _passwordController.text.length >= 6 &&
                          _passwordController.text.isNotEmpty &&
                          _usernamecontroller.text.isNotEmpty &&
                          _checkvisibility == true) {
                        setState(() {
                          _authService.createPerson(
                              _emailController.text,
                              _passwordController.text,
                              _usernamecontroller.text);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);

                          ElegantNotification.success(
                                  progressIndicatorBackground: Colors.green,
                                  width: MediaQuery.of(context).size.width / 1,
                                  height: 100,
                                  title: Text("Başarılı!"),
                                  description: Text(
                                      "Kayıt işlemi başarılı bir şekilde gerçekleşti."))
                              .show(context);
                        });
                      } else {
                        ElegantNotification.error(
                                progressIndicatorBackground: Colors.red,
                                width: MediaQuery.of(context).size.width / 1,
                                height: 100,
                                title: Text("Hata!"),
                                description: Text("Kayıt işlemi başarısız."))
                            .show(context);
                      }
                    },
                    child: Text('Kayıt Ol',
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
              ],
            ),
          )),
        ));
  }
}
