// ignore_for_file: prefer_const_constructors

import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/Welcome/components/body.dart';
import 'package:flutter/material.dart';

import '../../Service/Auth_Service.dart';
import '../../Service/Notif_services.dart';
import '../../zoomDrawer.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget currentPage = WelcomeScreen();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    NotificationService.init();
    listenNotification();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        //currentPage = HomePage();
        //currentPage = HiddenDrawer();
        currentPage = zoomDrawer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }

  void listenNotification() {
    NotificationService.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => HomePage()));
}
