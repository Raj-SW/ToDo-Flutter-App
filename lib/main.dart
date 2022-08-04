// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:alan_voice/alan_voice.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/zoomDrawer.dart';
import 'package:devstack/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Service/Notif_services.dart';
import 'pages/Welcome/welcome_screen.dart';
import 'theme/theme_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
  await Firebase.initializeApp();

  runApp(MyApp());
}

//Instance of ThemeManager
ThemeManager themeManager = ThemeManager();

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //dispose listener after use

  //listen to theme change
  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  _MyAppState() {
    AlanVoice.addButton(
        "78940e6b9b106789ef7fc772c11b89892e956eca572e1d8b807a3e2338fdd0dc/stage");
  }
  //Widget currentPage = SignUpPage();
  Widget currentPage = WelcomeScreen();
  AuthClass authClass = AuthClass();
  User? user;
  @override
  void initState() {
    //react to listener of theme change
    themeManager.addListener(themeListener);
    super.initState();
    checkLogin();
    NotificationService.init();
    listenNotification();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    String? token2 = await authClass.getToken2();
    if (token != null) {
      setState(() {
        // currentPage = MainPage();
        currentPage = zoomDrawer();
      });
    } else {
      String? token2 = await authClass.getTokenForEmailAuth();
      if (token2 == null) {
        print("Email token null");
      } else {
        setState(() {
          //currentPage = MainPage();
          currentPage = zoomDrawer();
        });
      }
    }
    if (token == null) {
      if (token2 != null) {
        setState(() {
          //currentPage = MainPage();
          currentPage = zoomDrawer();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      /* ThemeData(
        useMaterial3: false,
      ),*/
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }

  void listenNotification() {
    NotificationService.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => zoomDrawer()));
}
