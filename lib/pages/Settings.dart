// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Welcome/welcome_screen.dart';
import 'package:volume_controller/volume_controller.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;
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
  late List<taskCat> taskCatChartData;

  @override
  void initState() {
    fetchUserDetails();
    pomodoroChartData = getPomodoroData();
    taskCatChartData = getTaskCatData();

    setState(() {});
    super.initState();

    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(83, 123, 233, 1),
        elevation: 0,
        toolbarHeight: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        centerTitle: true,
        foregroundColor: PrimaryColor,
        title: Text("Preferences",
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 40)),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(2, 2), // Shadow position
                    ),
                  ],
                  color: Color.fromRGBO(207, 236, 255, 1),
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
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text("Lv. " + getLevel(),
                              style: GoogleFonts.poppins(fontSize: 16)),
                          LinearPercentIndicator(
                            animationDuration: 1000,
                            animation: true,
                            barRadius: Radius.circular(30),
                            width: 175,
                            lineHeight: 10,
                            percent: getExpPer(),
                            progressColor: PrimaryColor,
                          ),
                        ],
                      )
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
                        max: 1,
                        min: 0,
                        onChanged: (double value) {
                          setState(() {
                            _setVolumeValue = value;
                            VolumeController().setVolume(_setVolumeValue);
                          });
                        },
                        value: _setVolumeValue,
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.bell),
                      title: Text("Notifications"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(alignment: AlignmentDirectional.topEnd, children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                      color: Color.fromARGB(255, 255, 254, 215),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Stats",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Focus Timer Stats",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                            )),
                        Container(
                          padding: EdgeInsets.all(00),
                          width: MediaQuery.of(context).size.width,
                          height: 175,
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            plotAreaBorderColor:
                                Color.fromARGB(255, 255, 255, 255),
                            series: <ChartSeries>[
                              BarSeries<pomodoroData, String>(
                                  trackBorderWidth: 0,
                                  enableTooltip: true,
                                  dataSource: pomodoroChartData,
                                  color: PrimaryColorlight,
                                  xValueMapper: (pomodoroData data, _) =>
                                      data.Priority,
                                  yValueMapper: (pomodoroData data, _) =>
                                      data.count)
                            ],
                            primaryXAxis: CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0)),
                            primaryYAxis: NumericAxis(
                                title: AxisTitle(
                                    text: "Hours",
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                    )),
                                majorGridLines: MajorGridLines(width: 0)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(00),
                          width: MediaQuery.of(context).size.width,
                          height: 175,
                          child: SfCircularChart(
                              legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap),
                              series: <CircularSeries>[
                                PieSeries<taskCat, String>(
                                  dataSource: taskCatChartData,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  xValueMapper: (taskCat data, _) =>
                                      data.priority,
                                  yValueMapper: (taskCat data, _) => data.count,
                                )
                              ]),
                        ),
                        Text(
                            "Total Tasks - $totaltaskCount\nOverdue tasks - ${overdueCount - isDoneCountTrue}\nCompleted tasks - $isDoneCountTrue\nPending tasks -$isDoneCountFalse ",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(
                  "assets/stats.png",
                  width: 150,
                  height: 150,
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(alignment: AlignmentDirectional.topEnd, children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                      color: Color.fromARGB(255, 251, 175, 175),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      authClass.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const WelcomeScreen()),
                          (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Out",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(194, 255, 0, 0)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FaIcon(FontAwesomeIcons.arrowRightFromBracket,
                            color: Color.fromARGB(194, 255, 0, 0))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20, top: 0),
                child: Image.asset(
                  "assets/logout1.png",
                  width: 90,
                  height: 90,
                ),
              )
            ]),
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
    var myPomodorodocument = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("pomodoroCummulative");
    myPomodorodocument.get().then((value) => {
          setState(() {
            restStat = value["rest"];
            studyStat = value["study"];
            workStat = value["work"];
          })
        });

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
    print("restat $restStat");
    print("studyStat $studyStat");
    print("workStat $workStat");
    setState(() {
      pomodoroChartData = getPomodoroData();
      taskCatChartData = getTaskCatData();
    });
  }

  List<pomodoroData> getPomodoroData() {
    List<pomodoroData> pomodoro = [
      pomodoroData("Study", studyStat),
      pomodoroData("Rest", restStat),
      pomodoroData("Work", workStat),
    ];
    setState(() {});
    return pomodoro;
  }

  List<taskCat> getTaskCatData() {
    List<taskCat> taskCatData = [
      taskCat("Normal", normalCount),
      taskCat("Mild", mildCount),
      taskCat("Critical", criticalCount),
    ];
    setState(() {});
    return taskCatData;
  }

  String getLevel() {
    return ((experience / 200).floor()).toString();
  }

  getExpPer() {
    return (experience.remainder(200) / 200);
  }
}

class pomodoroData {
  pomodoroData(this.Priority, this.count);
  String Priority = '';
  int count = 0;
}

class taskCat {
  taskCat(this.priority, this.count);
  String priority = '';
  int count = 0;
}
