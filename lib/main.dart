// ignore_for_file: prefer_const_constructors

import 'package:devstack/MenuPage.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/hidden_drawer.dart';
import 'package:devstack/pages/HomePage.dart';
import 'package:devstack/pages/Settings.dart';
import 'package:devstack/pages/mainPage.dart';
import 'package:devstack/zoomDrawer.dart';
//import 'package:devstack/pages/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'Service/Notif_services.dart';
import 'menuItem.dart';
import 'pages/Welcome/welcome_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
  await Firebase.initializeApp();

  runApp(MyApp());
}

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Widget currentPage = SignUpPage();
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
        currentPage = MainPage();
        //currentPage = HiddenDrawer();
        //  currentPage = zoomDrawer();
        print('hello from main check login');
      });
    }
  }

  //MenuItema currentItem = MenuItems.homePage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }

  void listenNotification() {
    NotificationService.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MainPage()));
}
