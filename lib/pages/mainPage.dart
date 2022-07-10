// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this

import 'package:alan_voice/alan_voice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:devstack/assets.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
          currentIndex = 1;
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
  final screens = <Widget>[HomePage(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromRGBO(83, 123, 233, 1),
        items: [
          Icon(
            Icons.home,
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
      ),
      body: screens[currentIndex],
    );
  }
}
