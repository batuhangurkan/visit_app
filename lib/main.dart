import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/pages/bottomnavigationbar.dart';
import 'package:myapp1/pages/date_page.dart';
import 'package:myapp1/pages/home_page.dart';
import 'package:myapp1/pages/login_page.dart';
import 'package:myapp1/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color black = Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black)),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: MaterialColor(
          0xFF000000,
          <int, Color>{
            50: black,
            100: black,
            200: black,
            300: black,
            400: black,
            500: black,
            600: black,
            700: black,
            800: black,
            900: black,
          },
        ),
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const LoginPage(),
        '/home ': (context) => const HomePage(),
        '/date': (context) => const DatePage(),
        '/bottomnavigationbar': (context) => const BottomNavigationBarPage(),
      },
    );
  }
}
