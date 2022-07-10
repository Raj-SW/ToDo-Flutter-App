import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: PrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.deepPurple,
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
        title: Text("Settings"),
      ),
    );
  }
}
