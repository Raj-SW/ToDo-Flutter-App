// ignore_for_file: prefer_const_constructors

import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/Welcome/components/body.dart';
import 'package:devstack/pages/mainPage.dart';
import 'package:flutter/material.dart';

import '../../Service/Auth_Service.dart';
import '../../Service/Notif_services.dart';
import '../../zoomDrawer.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
    NotificationService.init();
    listenNotification();
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
      .push(MaterialPageRoute(builder: (context) => zoomDrawer()));
}
