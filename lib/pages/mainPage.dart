// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this

import 'package:alan_voice/alan_voice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  final items = <Widget>[
    Icon(
      Icons.home,
      color: Colors.white,
    ),
    Icon(Icons.settings, color: Colors.white)
  ];

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
      extendBody: false,
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          color: Colors.deepPurple,
          items: items,
          height: 56,
          index: currentIndex,
          onTap: (index) => setState(() => this.currentIndex = index))

      /*BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
              }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "To-Dos"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_input_component), label: "Settings")
          ])*/
      ,
      body: screens[currentIndex],
    );
  }
}
