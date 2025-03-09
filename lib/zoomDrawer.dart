import 'package:devstack/MenuPage.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/PomodoroTimer.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:devstack/pages/calendarView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'Service/SoundSystem.dart';
import 'menuItem.dart';

class zoomDrawer extends StatefulWidget {
  const zoomDrawer({Key? key}) : super(key: key);

  @override
  State<zoomDrawer> createState() => _zoomDrawerState();
}

class _zoomDrawerState extends State<zoomDrawer> {
  MenuItema currentItem = MenuItems.homePage;
  @override
  Widget build(BuildContext context) => ZoomDrawer(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),

        openCurve: const Interval(0, 1, curve: Curves.easeInOut),
        closeCurve: const Interval(0, 1, curve: Curves.easeInOut),

        boxShadow: const [
          BoxShadow(
              //spreadRadius: 5,
              color: Colors.black45,
              blurRadius: 10,
              blurStyle: BlurStyle.outer,
              offset: Offset(2, 2))
        ],
        borderRadius: 30,
        //  drawerShadowsBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        menuScreenWidth: MediaQuery.of(context).size.width * 0.45,
        slideWidth: MediaQuery.of(context).size.width * 0.6,
        //  menuBackgroundColor: Colors.deepPurple.shade100,
        //menuBackgroundColor: Color.fromARGB(255, 133, 135, 237),
        menuBackgroundColor: drawerBackground(context),
        angle: 0,
        mainScreenScale: 0.25,
        mainScreen: getScreen(),
        menuScreen: Builder(
            builder: (context) => MenuPage(
                currentItem: currentItem,
                onSelectedItem: (item) {
                  setState(() => currentItem = item);
                  SoundSystem().playLocal();
                  ZoomDrawer.of(context)!.close();
                })),
        mainScreenTapClose: true,
        isRtl: false,
        showShadow: true,
        style: DrawerStyle.defaultStyle,
      );
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.homePage:
        return const HomePage();
      case MenuItems.calendar:
        return const MyHomePage();
      case MenuItems.pomodoro:
        return const PomodoroTimer();
      case MenuItems.Settings:
        return const Settings();
      default:
        return const HomePage();
    }
  }
}

//drawer background
Color drawerBackground(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.black;
  } else {
    return Color.fromARGB(
        255, 141, 142, 255); // Color.fromARGB(255, 133, 135, 237);
  }
}
