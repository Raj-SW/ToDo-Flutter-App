// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/Notif_services.dart';
import 'package:devstack/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../main.dart';
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
      totaltaskCount = 0,
      coins = 0;

  bool lockedDarkmode = false;

  late List<pomodoroData> pomodoroChartData;
  late List<taskCat> taskCatChartData;
  int sounder = 0;
//Testing avatars
  int selectedImage = 0;
  bool firstProfileUnlocked = false;
  bool secondProfileUnlocked = false;

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
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.bars,
                        //  color: Color(0xff5d5fef),
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ZoomDrawer.of(context)!.toggle();
                      },
                      iconSize: 32,
                    ),
                  ),
                  floating: true,
                  pinned: true,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  toolbarHeight: 70,
                  centerTitle: true,
                  backgroundColor: preferencesBackground(context),
                  //backgroundColor: Color(0xff5d5fef),
                  //backgroundColor: Color.fromARGB(255, 106, 139, 228),
                  // Color.fromARGB(255, 102, 133, 218), //Color.fromRGBO(83, 123, 233, 1),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      "Preferences",
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 41,
                      ),
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                              color: returnProfilePicColor(context),
                              // color: Color.fromRGBO(207, 236, 255, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                foregroundImage: AssetImage(
                                  profilePicture(selectedImage),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text("Lv. " + getLevel(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 16)),
                                      LinearPercentIndicator(
                                        animationDuration: 1000,
                                        animation: true,
                                        barRadius: Radius.circular(30),
                                        width: 160,
                                        lineHeight: 10,
                                        percent: getExpPer(),
                                        progressColor: PrimaryColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Change Avatar",
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      //First choice
                                      Material(
                                        shape: CircleBorder(),
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                          ),
                                          child: InkWell(
                                              splashColor: Colors.black26,
                                              onTap: () {
                                                print(coins);
                                                if (firstProfileUnlocked ==
                                                    true) {
                                                  setState(() {
                                                    selectedImage = 1;
                                                    FirebaseFirestore.instance
                                                        .collection("collect2")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection('userModel')
                                                        .doc('userDetails')
                                                        .update({
                                                      'selectedImage': 1,
                                                    });
                                                  });
                                                } else {
                                                  if (coins >= 15) {
                                                    coins -= 15;
                                                    setState(() {
                                                      selectedImage = 1;
                                                      firstProfileUnlocked =
                                                          true;
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "collect2")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'userModel')
                                                          .doc('userDetails')
                                                          .update({
                                                        'coins': coins,
                                                        'selectedImage': 1,
                                                        'pic1': true,
                                                      });
                                                    });
                                                  }
                                                }
                                              },
                                              child: Ink.image(
                                                image: AssetImage(
                                                    "assets/profileWomen.png"),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      //Second choice
                                      Material(
                                        shape: CircleBorder(),
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                          ),
                                          child: InkWell(
                                              splashColor: Colors.black26,
                                              onTap: () {
                                                print(coins);
                                                if (secondProfileUnlocked ==
                                                    true) {
                                                  setState(() {
                                                    selectedImage = 2;
                                                    FirebaseFirestore.instance
                                                        .collection("collect2")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection('userModel')
                                                        .doc('userDetails')
                                                        .update({
                                                      'selectedImage': 2,
                                                    });
                                                  });
                                                } else {
                                                  if (coins >= 15) {
                                                    coins -= 15;
                                                    setState(() {
                                                      selectedImage = 2;
                                                      secondProfileUnlocked =
                                                          true;
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "collect2")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'userModel')
                                                          .doc('userDetails')
                                                          .update({
                                                        'coins': coins,
                                                        'selectedImage': 2,
                                                        'pic2': true,
                                                      });
                                                    });
                                                  }
                                                }
                                              },
                                              child: Ink.image(
                                                image: AssetImage(
                                                    "assets/pomodoroFill.png"),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              // Expanded(child: SizedBox()),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Icon(Icons.keyboard_arrow_right),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 50),
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
                                  color: returnSettingsColor(context),
                                  //color: Color.fromRGBO(254, 218, 191, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Settings",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
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
                                        activeColor: volumeSliderColor(context),
                                        onChanged: (double value) {
                                          setState(() {
                                            _setVolumeValue = value;
                                            VolumeController()
                                                .setVolume(_setVolumeValue);
                                          });
                                        },
                                        value: _setVolumeValue,
                                      ),
                                    ),
                                    ListTile(
                                      leading: FaIcon(FontAwesomeIcons.bell),
                                      title: Text("Notifications",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                          )),
                                      trailing: InkWell(
                                          onTap: () => showSoundpickerdialog(),
                                          child:
                                              Icon(Icons.keyboard_arrow_right)),
                                    ),
                                    ListTile(
                                        leading: FaIcon(
                                          FontAwesomeIcons.palette,
                                        ),
                                        title: Text("Dark Mode",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                            )),
                                        trailing: //Dark mode switch
                                            lockedDarkmode == true
                                                ? //Dark mode switch
                                                Switch(
                                                    value: themeManager
                                                            .themeMode ==
                                                        ThemeMode.dark,
                                                    onChanged: (newvalue) {
                                                      themeManager.toggleTheme(
                                                          newvalue);
                                                    })
                                                : InkWell(
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                    ),
                                                    onTap: () =>
                                                        showPurchaseDialog(),
                                                  )
                                        //Icon(Icons.keyboard_arrow_right),
                                        ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/setting.png",
                              width: 125,
                              height: 125,
                            ),
                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
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
                                  color: returnYourStatsColor(context),
                                  // color: Color.fromARGB(255, 255, 254, 215),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Stats",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
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
                                              xValueMapper:
                                                  (pomodoroData data, _) =>
                                                      data.Priority,
                                              yValueMapper:
                                                  (pomodoroData data, _) =>
                                                      data.count)
                                        ],
                                        primaryXAxis: CategoryAxis(
                                            majorGridLines:
                                                MajorGridLines(width: 0)),
                                        primaryYAxis: NumericAxis(
                                            title: AxisTitle(
                                                text: "Hours",
                                                textStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                )),
                                            majorGridLines:
                                                MajorGridLines(width: 0)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(00),
                                      width: MediaQuery.of(context).size.width,
                                      height: 175,
                                      child: SfCircularChart(
                                          legend: Legend(
                                              isVisible: true,
                                              overflowMode:
                                                  LegendItemOverflowMode.wrap),
                                          series: <CircularSeries>[
                                            PieSeries<taskCat, String>(
                                              dataSource: taskCatChartData,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      isVisible: true),
                                              xValueMapper: (taskCat data, _) =>
                                                  data.priority,
                                              yValueMapper: (taskCat data, _) =>
                                                  data.count,
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
                    child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
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
                                  //test theme
                                  color: returnSignOutColor(context),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  authClass.signOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const WelcomeScreen()),
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
                                          // color: Color.fromARGB(194, 255, 0, 0)),
                                          color: returnSignOutFont(context)),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    FaIcon(
                                        FontAwesomeIcons.arrowRightFromBracket,
                                        // color: Color.fromARGB(194, 255, 0, 0))
                                        color: returnSignOutFont(context)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, bottom: 20, top: 0),
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
                    height: 50,
                  )
                ],
              ),
            )));
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
            coins = value['coins'];
            lockedDarkmode = value['darkModeUnlocked'];
            selectedImage = value['selectedImage'];
            firstProfileUnlocked = value['pic1'];
            secondProfileUnlocked = value['pic2'];
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

  showPurchaseDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text("Unlock Dark Mode?"),
            actions: [
              InkWell(
                  onTap: () {
                    bool purchaseCan = makePurchase();
                    if (purchaseCan == true) {
                      Fluttertoast.showToast(msg: "You unlocked Dark Mode");
                      Navigator.of(context).pop();
                    } else if (purchaseCan == false) {
                      Fluttertoast.showToast(
                          msg: "You don't have enough coins!",
                          gravity: ToastGravity.TOP);
                    }
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  )),
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ))
            ],
          ));

  bool makePurchase() {
    if (coins >= 20) {
      setState(() {
        lockedDarkmode = true;
        coins = coins - 20;
      });
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("userDetails")
          .update({"coins": coins, "darkModeUnlocked": lockedDarkmode});
      return true;
    } else {
      return false;
    }
  }

  showSoundpickerdialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text("Choose Sound"),
            content: Container(
                height: 250,
                width: 250,
                child: Column(
                  children: [
                    Row(children: [
                      Text("Sound1"),
                      IconButton(
                        onPressed: () => setState(() {
                          NotificationService.init();
                          //NotificationService.selected = 2;
                          //NotificationService.sound = 'sounda.wav';
                          print("sound1");
                        }),
                        icon: Icon(Icons.abc),
                      ),
                    ]),
                    Row(children: [
                      Text("Sound2"),
                      IconButton(
                        onPressed: () => setState(() {
                          NotificationService.init();
                          //NotificationService.selected = 2;
                          //NotificationService.sound = 'soundb.wav';
                          print("sound2");
                        }),
                        icon: Icon(Icons.abc),
                      ),
                    ]),
                    IconButton(
                        onPressed: () {
                          NotificationService.showNotification(title: "Oss!");
                        },
                        icon: Icon(Icons.play_arrow))
                  ],
                )),
          ));

  String profilePicture(int x) {
    if (x == 1) {
      return "assets/profileWomen.png";
    } else if (x == 2) {
      return "assets/pomodoroFill.png";
    } else {
      return "assets/profileMen.png";
    }
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

//Profile pic color
Color returnProfilePicColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(207, 236, 255, 1);
  }
}

//Sign out color
Color returnSignOutColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  print('currentTheme');
  print(currentTheme.brightness);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromARGB(255, 251, 175, 175);
  }
}

//Sign out font color
Color returnSignOutFont(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  print('currentTheme');
  print(currentTheme.brightness);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return Color.fromARGB(194, 255, 0, 0);
  }
}

//Settings color
Color returnSettingsColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(254, 218, 191, 1);
  }
}

//Your stats color
Color returnYourStatsColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromARGB(255, 255, 254, 215);
  }
}

//Volume Slider
Color volumeSliderColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Color.fromRGBO(83, 123, 233, 1) //Colors.amberAccent
        ;
  }
}

//Preferences background
Color preferencesBackground(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.black;
  } else {
    return Color.fromRGBO(83, 123, 233, 1);
  }
}
