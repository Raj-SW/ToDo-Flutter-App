// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Service/Notif_services.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

List<String> menuItems = ["Sport", "Study", "Rest", "Other"];
int beginTime = 0;
bool isSelected1 = false;
bool isSelected2 = true;
bool isSelected3 = false;
String activityType = "Study";
TextStyle mystyle = TextStyle(
  fontSize: 20,
);
TextEditingController _minuteController = TextEditingController();
TextEditingController _hourController = TextEditingController();
double percent = 0;
int counterTime = 10;
Timer? timer;
Duration duration1 = Duration();
bool isnotStarted = false;

class _PomodoroTimerState extends State<PomodoroTimer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 65,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "Your Pomodoro",
              textAlign: TextAlign.center,
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(83, 123, 233, 1),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: MediaQuery.of(context).size.width - 140,
                padding:
                    EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(2, 2), // Shadow position
                    ),
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(-1, -1), // Shadow position
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          activityType,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black54),
                        ),
                      ),
                      CircularPercentIndicator(
                        backgroundColor: Color.fromARGB(
                            255, 227, 227, 227), //rgb(239,239,239)
                        percent: percentCalc(),
                        animation: true,
                        animateFromLastPercent: true,
                        radius: 80,
                        circularStrokeCap: CircularStrokeCap.round,
                        lineWidth: 23,
                        progressColor:
                            Color.fromRGBO(154, 167, 240, 1), //rgb(153,166,240)
                        center: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !isnotStarted
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (counterTime < 60) {
                                            counterTime = counterTime + 5;
                                          }
                                        });
                                      },
                                      child: FaIcon(FontAwesomeIcons.caretUp))
                                  : FaIcon(
                                      FontAwesomeIcons.caretUp,
                                      color: Colors.black26,
                                    ),
                              !isnotStarted
                                  ? Text("$counterTime",
                                      style: GoogleFonts.poppins(
                                          fontSize: 26,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600))
                                  : buildTime(),
                              !isnotStarted
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (counterTime > 5) {
                                            counterTime = counterTime - 5;
                                          }
                                        });
                                      },
                                      child: FaIcon(FontAwesomeIcons.caretDown))
                                  : FaIcon(
                                      FontAwesomeIcons.caretDown,
                                      color: Colors.black26,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          !isnotStarted
                              ? InkWell(
                                  onTap: isCatselected()
                                      ? () {
                                          print("button start pressed");
                                          duration1 =
                                              Duration(minutes: counterTime);
                                          startTimer();
                                          /* FlutterAlarmClock.createAlarm(
                                              DateTime.now().hour +
                                                  (counterTime / 60)
                                                      .abs()
                                                      .toInt(),
                                              DateTime.now().minute +
                                                  counterTime % 60

                                              DateTime.now().hour +
                                                  duration1.inHours,
                                              DateTime.now().minute +
                                                  duration1.inMinutes
                                              ,
                                              title: "Time'sUp",
                                              skipUi: true);*/

                                          FlutterAlarmClock.createTimer(
                                              counterTime * 60,
                                              skipUi: true,
                                              title: "Time is Up");
                                          /* NotificationService
                                              .showScheduledNotification(
                                                  id: 007,
                                                  title: 'Times Up',
                                                  scheduledDate: DateTime.now()
                                                      .add(duration1));*/
                                          setState(() {
                                            isnotStarted = true;
                                            beginTime = counterTime;
                                          });
                                        }
                                      : showToast(),
                                  child: FaIcon(
                                    FontAwesomeIcons.solidCirclePlay,
                                    size: 30,
                                    color: Color.fromRGBO(154, 167, 240, 1),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    beginTime = duration1.inMinutes;
                                    duration1 = Duration();
                                    endTimer();
                                    NotificationService.cancel(007);
                                    setState(() {
                                      isnotStarted = false;
                                    });
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.circleStop,
                                    size: 30,
                                    color: Color.fromRGBO(154, 167, 240, 1),
                                  ))
                        ],
                      )
                    ]),
              ),
            ]),
            !isnotStarted
                ? Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Activity Type",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          )),
                      //Row for chips
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          ChoiceChip(
                            avatar: isSelected1 == true
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                            avatarBorder: CircleBorder(side: BorderSide.none),
                            selected: isSelected1,
                            onSelected: (newboolvalue) {
                              setState(() {
                                isSelected2 = false;
                                isSelected3 = false;
                                isSelected1 = newboolvalue;
                                activityType = "Work";
                              });
                            },
                            label: Text(
                              "Work",
                              style: TextStyle(
                                  color: isSelected1 == true
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            backgroundColor: Color.fromARGB(255, 255, 146, 146),
                            shadowColor: Colors.transparent,
                            selectedColor: Color(0xFFEF5350),
                            selectedShadowColor: Colors.red,
                            side: BorderSide(
                                color: isSelected1 == true
                                    ? Color(0xFFEF5350)
                                    : Color.fromARGB(255, 255, 0, 0),
                                style: BorderStyle.solid,
                                width: 2),
                            pressElevation: 10,
                            elevation: 10,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ChoiceChip(
                            avatar: isSelected2 == true
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                            avatarBorder: CircleBorder(side: BorderSide.none),
                            selected: isSelected2,
                            onSelected: (newboolvalue) {
                              setState(() {
                                isSelected1 = false;
                                isSelected3 = false;
                                isSelected2 = newboolvalue;
                                activityType = "Study";
                              });
                            },
                            label: Text(
                              "Study",
                              style: TextStyle(
                                  color: isSelected2 == true
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            backgroundColor: Color.fromARGB(255, 255, 253, 136),
                            shadowColor: Colors.transparent,
                            selectedColor: Color.fromARGB(177, 255, 196, 59),
                            selectedShadowColor: Colors.yellow,
                            side: BorderSide(
                                color: Color.fromARGB(54, 255, 196, 59),
                                style: BorderStyle.solid,
                                width: 2),
                            pressElevation: 10,
                            elevation: 10,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ChoiceChip(
                            avatar: isSelected3 == true
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                            avatarBorder: CircleBorder(side: BorderSide.none),
                            selected: isSelected3,
                            onSelected: (newboolvalue) {
                              setState(() {
                                isSelected1 = false;
                                isSelected2 = false;
                                isSelected3 = newboolvalue;
                                activityType = "Rest";
                              });
                            },
                            label: Text(
                              "Rest",
                              style: TextStyle(
                                  color: isSelected3 == true
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            backgroundColor: Color.fromARGB(255, 185, 227, 255),
                            shadowColor: Colors.transparent,
                            selectedColor: Colors.blue,
                            selectedShadowColor: Colors.blue,
                            side: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                                width: 2),
                            pressElevation: 10,
                            elevation: 10,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Use your timer to track \nyour focus time",
                          style: GoogleFonts.poppins(
                              color: Colors.black38,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            "assets/pomodoroFill.png",
                            height: 150,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding:
                        EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
                    child: Lottie.asset("assets/lottie5.json"),
                  ),
          ],
        ));
  }

  void startTimer() {
    print("Timer Started");
    timer = Timer.periodic(Duration(seconds: 1), (_) => reduceTime());
  }

  void endTimer() {
    //timer?.cancel();
    writeToFirebase();
    setState(() {
      timer?.cancel();
    });
    duration1 = Duration();
  }

  reduceTime() {
    print("reducing by 1");
    final reduceSeconds = 1;
    setState(() {
      if (duration1.inSeconds > 0) {
        final seconds = duration1.inSeconds - reduceSeconds;
        duration1 = Duration(seconds: seconds);
      } else {
        /*  NotificationService.showNotification(
          id: 007,
          title: 'Times Up',
        );*/
        isnotStarted = false;
        endTimer();
        counterTime = 5;
      }
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration1.inMinutes.remainder(60));
    final seconds = twoDigits(duration1.inSeconds.remainder(60));

    return Text("$minutes:$seconds",
        style: GoogleFonts.poppins(
            fontSize: 26, color: Colors.black54, fontWeight: FontWeight.w600));
  }

  percentCalc() {
    return (duration1.inSeconds) / (counterTime * 60);
  }

  showToast() {
    Fluttertoast.showToast(
        msg: "Please enter activity type to start timer",
        gravity: ToastGravity.TOP);
  }

  isCatselected() {
    if ((isSelected1 || isSelected2 || isSelected3) == false) {
      return false;
    } else
      return true;
  }

  Future<void> writeToFirebase() async {
    int workCumm, studyCumm, restCumm;
    final doc = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("pomodoroCummulative");
    final snapshot = await doc.get();

    workCumm = snapshot["work"];
    studyCumm = snapshot["study"];
    restCumm = snapshot["rest"];

    if (activityType == 'Work') {
      setState(() {
        workCumm = workCumm + beginTime;
      });
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("pomodoroCummulative")
          .update({"work": workCumm});
    }
    if (activityType == 'Study') {
      setState(() {
        studyCumm = studyCumm + beginTime;
      });
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("pomodoroCummulative")
          .update({"study": studyCumm});
    }
    if (activityType == 'Rest') {
      setState(() {
        restCumm = restCumm + beginTime;
      });

      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("pomodoroCummulative")
          .update({"rest": restCumm});
    }

    print("firebase  $activityType");
    print(restCumm);
  }
}
