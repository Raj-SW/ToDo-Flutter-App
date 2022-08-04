import 'package:devstack/pages/Backgrounds/backgroundSignUp.dart';
import 'package:devstack/pages/Welcome/welcome_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:devstack/Service/Auth_Service.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  Widget currentPage = const splashScreen();
  AuthClass authClass = AuthClass();
  @override
  void initState() {
    //set time to load the new page
    Future.delayed(Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Background2(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 300,
                          width: 300,
                          child:
                              Lottie.asset('assets/opener-loading (1).json')),
                      //SizedBox(height: 1),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Loading ",
                              style: GoogleFonts.actor(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              "Better.Me ",
                              style: GoogleFonts.pacifico(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 35,
                                  color: Color(0xFF5D5FEF)),
                            ),
                            Container(
                              child: Column(children: [
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Lottie.asset(
                                        'assets/98196-loading-teal-dots.json')),
                              ]),
                            ),
                          ]),
                    ]))));
  }
}
