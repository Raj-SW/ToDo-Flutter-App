// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'Service/Auth_Service.dart';
//import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/ProfilePage.dart';
//import 'package:devstack/pages/SignUpPage.dart';
import 'package:devstack/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'Service/SoundSystem.dart';
import 'pages/registration_screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  ////////////////
  Function function = () async {
    SoundSystem().playLocal();
  };
  /////////
  final myBaseTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18);
  final mySelectedStyle = TextStyle(fontSize: 28);
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'TODOS-hidden drawer',
              onTap: function,
              baseStyle: myBaseTextStyle,
              selectedStyle: const TextStyle(fontSize: 28)),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Settings',
              onTap: function,
              baseStyle: myBaseTextStyle,
              selectedStyle: mySelectedStyle),
          const Settings()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Profile',
              onTap: function,
              baseStyle: myBaseTextStyle,
              selectedStyle: mySelectedStyle),
          const ProfilePage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple.shade300,
      leadingAppBar: GestureDetector(
          child: Icon(Icons.menu_rounded),
          onTap: () {
            SoundSystem().playLocal();
            Scaffold.hasDrawer(context);
          }),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 45,
      actionsAppBar: <Widget>[
        //iconButton to logout
        IconButton(
          onPressed: () async {
            //later check for context

            await authClass.logout(context);
            /*  Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => SignUpPage()),
                (route) => false);*/
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => RegistrationScreen()),
                (route) => false);
          },
          icon: Icon(Icons.logout),
          color: Colors.white,
        ),
      ],
    );
  }
}
