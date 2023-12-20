import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp1/pages/date_page.dart';
import 'package:myapp1/pages/home_page.dart';
import 'package:myapp1/pages/profile_page.dart';

import 'historyplace_page.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int currentIndex = 0;
  final screens = [
    //Sayfa İsimleri Gelicek
    HomePage(),
    DatePage(),
    HistoryPlace(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          activeColor: Colors.green[600],
          inactiveColor: Colors.green /*Colors.black.withOpacity(0.5)*/,
          items: [
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.houseUser)),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.locationArrow)),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.mapLocation)),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.user)),
          ],
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        tabBuilder: (context, index) {
          return screens[index];
        }
        // body: screens[currentIndex],
        );
  }
}
