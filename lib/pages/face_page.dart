// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:devstack/main.dart';
import 'package:devstack/pages/mainPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:devstack/api/local_auth_api.dart';
//import 'package:signup_login/api/local_auth_api.dart';
import 'package:flutter/material.dart';
//import 'package:signup_login/pages/Backgrounds/backgroundSignIn.dart';
import 'Backgrounds/backgroundSignIn.dart';
//import 'package:signup_login/pages/HomePage.dart';

import 'HomePage.dart';

class FacePage extends StatefulWidget {
  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  /* @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff5d5fef),
          title: Text('Sign up with biometrics'),
          centerTitle: true,
        ),
        body: Background3(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                SizedBox(height: 32),
                buildAvailability(context),
                SizedBox(height: 24),
                buildAuthenticate(context),
              ],
            ),
          ),
        ),
      );*/
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Background3(
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 10),
            Text(
              "Sign Up with biometrics",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            SvgPicture.asset("assets/biometrics.svg",
                height: size.height * 0.27),
            SizedBox(height: 50),
            buildAvailability(context),
            SizedBox(height: 25),
            buildAuthenticate(context),
            SizedBox(height: 150),
          ]),
        ),
      ),
    );
  }

  Widget buildAvailability(BuildContext context) => buildButton(
        text: 'Check biometrics compatibility',
        icon: Icons.event_available,
        onClicked: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  buildText('Biometrics', isAvailable),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok'),
                )
              ],
            ),
          );
        },
      );

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Color(0xff5d5fef), size: 24)
                : Icon(Icons.close, color: Color(0xff5d5fef), size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Authenticate',
        icon: Icons.fingerprint_sharp,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();
          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        },
      );

  Widget buildButton({
    @required String? text,
    @required IconData? icon,
    @required VoidCallback? onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff5d5fef),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          minimumSize: Size(300, 60),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text!,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );
}
