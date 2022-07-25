// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/userData.dart';
import 'package:devstack/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Service/SoundSystem.dart';
import 'Welcome/welcome_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(83, 123, 233, 1),
        elevation: 0,
        foregroundColor: PrimaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              authClass.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const WelcomeScreen()),
                  (route) => false);
            },
          )
        ],
        title: Text(
          "Preferences",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    foregroundImage: AssetImage(
                      "assets/profileMen.png",
                    ),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Gender"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Age"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Level 10")
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Settings"),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.volumeHigh,
                      size: 18,
                    ),
                    title: Slider(
                      max: 100,
                      min: 0,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          value++;
                          print("increasing volume");
                        });
                      },
                      value: 0,
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.bell),
                    title: Text("Notifications"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.palette),
                    title: Text("Theme"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Stats"), Card()]),
            ),
          )
        ],
      )),
    );
  }
}
