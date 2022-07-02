// ignore_for_file: prefer_const_constructors

import 'package:devstack/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'background.dart';
import 'rounded_button.dart';
import 'package:devstack/constants.dart';
import '../../login_screen.dart';
import '../../registration_screen.dart';
/*
import 'package:signup_login/pages/Welcome/components/background.dart';
import 'package:signup_login/pages/Welcome/components/rounded_button.dart';
import 'package:signup_login/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signup_login/pages/login_screen.dart';
import 'package:signup_login/pages/registration_screen.dart';
*/
import '../../registration_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              "Better.me",
              style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.normal,
                  fontSize: 70,
                  color: Color.fromRGBO(93, 95, 239, 1)),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/hey.svg",
              //height: size.height * 0.55,
              width: size.width * 0.95,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegistrationScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
