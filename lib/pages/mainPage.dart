// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this

import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/PomodoroTimer.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:devstack/pages/calendarView.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final screens = <Widget>[
    HomePage(),
    MyHomePage(),
    // cardioScreen(),
    PomodoroTimer(),
    Settings()
  ];
  int _index = 0;
  int _selectedIndex = 0;

  @override
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
        // backgroundColor: Color.fromARGB(255, 109, 146, 250),
        backgroundColor: returnBottomNavColor(context),
        selectedBackgroundColor: Color.fromARGB(255, 247, 247, 247),
        //selectedItemColor: Color.fromARGB(215, 0, 68, 255),
        selectedItemColor: returnSelectedColor(context),
        unselectedItemColor: Color.fromARGB(210, 255, 255, 255),
        currentIndex: currentIndex,
        onTap: (int val) => setState(() => currentIndex = val),
        items: [
          FloatingNavbarItem(icon: Icons.home),
          FloatingNavbarItem(icon: Icons.calendar_month_sharp),
          FloatingNavbarItem(icon: Icons.timer_sharp),
          FloatingNavbarItem(icon: Icons.settings),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}

//Bottom nav color
Color returnBottomNavColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return Color.fromARGB(255, 109, 146, 250);
  }
}

//Bottom nav color
Color returnSelectedColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return Color.fromARGB(215, 0, 68, 255);
  }
}
