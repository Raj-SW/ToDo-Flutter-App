// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import 'Screen1.dart';
import 'Screen2.dart';

class cardioScreen extends StatefulWidget {
  const cardioScreen({Key? key}) : super(key: key);

  @override
  State<cardioScreen> createState() => _cardioScreenState();
}

class _cardioScreenState extends State<cardioScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const List<String> quotes = ["Quote 1", "Quote 2", "Quote 3"];
  String quote = quotes.first;
  static int counter = 0;
  late ShakeDetector detector;
  static bool shake = false;
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        counter++;
      });
    });
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    detector.stopListening();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    detector.stopListening(); // TODO: implement dispose
    super.dispose();
  }

  int screen = 0;
  bool setScreen = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          elevation: 0,
          title: Text("Tab Bar"),
          backgroundColor: Color.fromRGBO(83, 123, 233, 1),
        ),
        body: Column(children: [
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 194, 210, 255),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    color: Color.fromRGBO(83, 123, 233, 1),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                // indicatorWeight: 0.1,
                //indicatorColor: Color.fromARGB(255, 194, 210, 255),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: _tabController.index == 0
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.settings,
                      color: _tabController.index == 1
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 0, 0, 0),
                    ),
                  )
                ]),
          ),
          Expanded(
              child: TabBarView(
                  controller: _tabController, children: [Screen1(), Screen2()]))
        ]),
      ),
    );
  }

  void startListen() {
    detector.startListening();
    setState(() {
      counter++;
    });
  }

  void stopListen() {
    detector.stopListening();
  }
}
