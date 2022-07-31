// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/userData.dart';
import 'package:devstack/assets.dart';
import 'package:devstack/pages/Screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Service/SoundSystem.dart';
import 'Welcome/welcome_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String userName = "";
  int gender = 0,
      level = 0,
      experience = 0,
      restStat = 0,
      studyStat = 0,
      workStat = 0,
      highestStat = 0,
      isDoneCountTrue = 0,
      isDoneCountFalse = 0,
      mildCount = 0,
      criticalCount = 0,
      normalCount = 0,
      overdueCount = 0,
      totaltaskCount = 0;
  late List<pomodoroData> pomodoroChartData;
  @override
  void initState() {
    // TODO: implement initState
    fetchUserDetails();
    fetchProductivityStats();
    fetchPomodoroStats();
    pomodoroChartData = getPomodoroData();
    setState(() {});
    display();
    super.initState();
  }

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
                      Text(userName),
                      SizedBox(
                        height: 5,
                      ),
                      Text(gender == 1 ? "Male" : "Female"),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Level $level")
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
                  children: [
                    Text("Stats"),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Focus Timer Stats"),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: SfCartesianChart(
                        series: <ChartSeries>[
                          BarSeries<pomodoroData, String>(
                              dataSource: pomodoroChartData,
                              xValueMapper: (pomodoroData data, _) =>
                                  data.Priority,
                              yValueMapper: (pomodoroData data, _) =>
                                  data.count)
                        ],
                        primaryXAxis: CategoryAxis(),
                      ),
                    )
                  ]),
            ),
          ),
          //this container makes sure that no widget is overlapped by bottom navigation bar
          Container(
            height: 70,
          )
        ],
      )),
    );
  }

  Future fetchUserDetails() async {
    var myUserdocument = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("userDetails");
    myUserdocument.get().then((value) => {
          setState(() {
            gender = value["Gender"];
            userName = value["userName"];
            level = value["Level"];
            experience = value["Experience"];
          })
        });
  }

  Future fetchPomodoroStats() async {
    var myPomodorodocument = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("pomodoroCummulative")
        .get();
    myPomodorodocument.then((value) => {
          setState(() {
            restStat = value["rest"];
            studyStat = value["study"];
            workStat = value["work"];
          })
        });
    print("restat $restStat");
  }

  Future fetchProductivityStats() async {
    var myTaskdocument = await FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Todo")
        .get();
    myTaskdocument.docs.forEach((element) {
      setState(() {
        totaltaskCount++;
        if (element['isDone'] == true) {
          isDoneCountTrue++;
        } else {
          isDoneCountFalse++;
        }
        if ((element['priority']).toString().compareTo('mild') == 0) {
          mildCount++;
        }
        if ((element['priority']).toString().compareTo('normal') == 0) {
          normalCount++;
        }
        if ((element['priority']).toString().compareTo('critical') == 0) {
          criticalCount++;
        }
        if (DateTime.now().isAfter((element['scheduledTime']).toDate())) {
          overdueCount++;
        }
      });
    });

    print("mildcount $mildCount");
    print("nomalcount $normalCount");
    print("critcount $criticalCount");
    print("overdue $overdueCount");
    print("isdone $isDoneCountTrue");
    print("total $totaltaskCount");
  }

  List<pomodoroData> getPomodoroData() {
    final List<pomodoroData> pomodoro = [
      pomodoroData("Study", studyStat),
      pomodoroData("Rest", restStat),
      pomodoroData("Work", workStat),
    ];

    return pomodoro;
  }

  void display() {
    print("aaa $restStat");
  }
}

class pomodoroData {
  pomodoroData(this.Priority, this.count);
  String Priority = '';
  int count = 0;
}
