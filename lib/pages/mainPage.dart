// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this

import 'package:alan_voice/alan_voice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:devstack/assets.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/PomodoroTimer.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
//next page
      if (commandData["command"] == "nextPage") {
        if(currentIndex==3){
          AlanVoice.playText("You have reached the last page");
        } else{
            setState(() {
          print('load todo');
          currentIndex++;
          if(currentIndex==0){
            AlanVoice.playText("You have been redirected to the todo page");
          } else if(currentIndex==1){
            AlanVoice.playText("You have been redirected to the tab bar page");
          } else if(currentIndex==2){
            AlanVoice.playText("You have been redirected to the activity timer page");
          } else if(currentIndex==3){
            AlanVoice.playText("You have been redirected to the settings page");
          }
          
        });
        }
      
      }
      //next page
      if (commandData["command"] == "backPage") {
        if(currentIndex==0){
          AlanVoice.playText("You are on the first page");
        } else{
          setState(() {
          print('load todo');
          currentIndex--;
          if(currentIndex==0){
            AlanVoice.playText("You have been redirected to the todo page");
          } else if(currentIndex==1){
            AlanVoice.playText("You have been redirected to the tab bar page");
          } else if(currentIndex==2){
            AlanVoice.playText("You have been redirected to the activity timer page");
          } else if(currentIndex==3){
            AlanVoice.playText("You have been redirected to the settings page");
          }
          
        });
        }
        
      }

       if (commandData["command"] == "todoPage") {
        if(currentIndex==0){
          AlanVoice.playText("You are already on the todo page");
        } else{
           setState(() {
          print('load todo');
          currentIndex = 0;
          AlanVoice.playText("You have been redirected to the todo page");
        });
        }
       
      }
      if (commandData["command"] == "tabBarPage") {
        if(currentIndex==1){
            AlanVoice.playText("You are already on the tab bar page");
        } else{
           setState(() {
          print('load todo');
          currentIndex = 1;
          AlanVoice.playText("You have been redirected to the tab bar page");
        });
        }
       
      }
      if (commandData["command"] == "activityTimerPage") {

        if(currentIndex==2){
          AlanVoice.playText("You are already on the activity timer page");
        } else{
           setState(() {
          print('load todo');
          currentIndex = 2;
          AlanVoice.playText("You have been redirected to the activity timer page");
        });
        }
       
      }
      if (commandData["command"] == "settingsPage") {
        if(currentIndex==3){
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
    cardioScreen(),
    PomodoroTimer(),
    Settings()
  ];
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
      ),
      body: screens[currentIndex],
    );
  }
}
