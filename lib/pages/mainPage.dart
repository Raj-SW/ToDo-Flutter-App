// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this

import 'package:alan_voice/alan_voice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:devstack/assets.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/PomodoroTimer.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:devstack/pages/calendarView.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'cardioScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  _MainPageState() {
    AlanVoice.onCommand.add((command) {
      Map<String, dynamic> commandData = command.data;
      if (commandData["command"] == "settingsPage") {
        setState(() {
          print('load settings');
          currentIndex = 3;
        });
      }
      if (commandData["command"] == "todoPage") {
        setState(() {
          print('load todo');
          currentIndex = 0;
        });
      }
    });
  }
  final screens = <Widget>[
    HomePage(),
    MyHomePage(),
    // cardioScreen(),
    PomodoroTimer(),
    Settings()
  ];
  @override
  int _index = 0;
  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,

      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: FloatingNavbar(
        elevation: 0,
        margin: EdgeInsets.all(10),
        borderRadius: 30,
        itemBorderRadius: 60,
        backgroundColor: Color.fromARGB(255, 109, 146, 250),
        selectedBackgroundColor: Color.fromARGB(255, 247, 247, 247),
        selectedItemColor: Color.fromARGB(215, 0, 68, 255),
        unselectedItemColor: Color.fromARGB(210, 255, 255, 255),
        currentIndex: currentIndex,
        onTap: (int val) => setState(() => currentIndex = val),
        items: [
          FloatingNavbarItem(icon: Icons.home),
          FloatingNavbarItem(icon: Icons.calendar_month_sharp),
          // FloatingNavbarItem(icon: Icons.run_circle_outlined),
          FloatingNavbarItem(icon: Icons.timer_sharp),
          FloatingNavbarItem(icon: Icons.settings),
        ],
      ),
      /*  CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 102, 133, 218),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_month_sharp,
            color: Colors.white,
          ),
          Icon(
            Icons.run_circle_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.timer_sharp,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          )
        ],
        height: 50,
        index: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),*/
      body: screens[currentIndex],

      // body: screens[_index],
    );
  }
}
