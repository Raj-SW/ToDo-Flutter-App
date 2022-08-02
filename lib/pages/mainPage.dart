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

      //next page
      if (commandData["command"] == "backPage") {
        if (currentIndex == 0) {
          AlanVoice.playText("You are on the first page");
        } else {
          setState(() {
            print('load todo');
            currentIndex--;
            if (currentIndex == 0) {
              AlanVoice.playText("You have been redirected to the todo page");
            } else if (currentIndex == 1) {
              AlanVoice.playText(
                  "You have been redirected to the tab bar page");
            } else if (currentIndex == 2) {
              AlanVoice.playText(
                  "You have been redirected to the activity timer page");
            } else if (currentIndex == 3) {
              AlanVoice.playText(
                  "You have been redirected to the settings page");
            }
          });
        }
      }

      if (commandData["command"] == "todoPage") {
        if (currentIndex == 0) {
          AlanVoice.playText("You are already on the todo page");
        } else {
          setState(() {
            print('load todo');
            currentIndex = 0;
            AlanVoice.playText("You have been redirected to the todo page");
          });
        }
      }
      if (commandData["command"] == "tabBarPage") {
        if (currentIndex == 1) {
          AlanVoice.playText("You are already on the tab bar page");
        } else {
          setState(() {
            print('load todo');
            currentIndex = 1;
            AlanVoice.playText("You have been redirected to the tab bar page");
          });
        }
      }
      if (commandData["command"] == "activityTimerPage") {
        if (currentIndex == 2) {
          AlanVoice.playText("You are already on the activity timer page");
        } else {
          setState(() {
            print('load todo');
            currentIndex = 2;
            AlanVoice.playText(
                "You have been redirected to the activity timer page");
          });
        }
      }
      if (commandData["command"] == "settingsPage") {
        if (currentIndex == 3) {
          AlanVoice.playText("You are already on the settings page");
        }
        setState(() {
          print('load settings');
          currentIndex = 3;
          AlanVoice.playText("You have been redirected to the settings page");
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
        backgroundColor: Color.fromARGB(255, 109, 146, 250),
        selectedBackgroundColor: Color.fromARGB(255, 247, 247, 247),
        selectedItemColor: Color.fromARGB(215, 0, 68, 255),
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
