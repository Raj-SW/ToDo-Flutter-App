// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';

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
import 'package:percent_indicator/percent_indicator.dart';

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
String activityType = "";
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        elevation: 0,
        title: Text("Activity Timer"),
        backgroundColor: Color.fromRGBO(83, 123, 233, 1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff1542bf), Color(0xff51a8ff)],
                begin: FractionalOffset(0.5, 1))),
        child: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            Expanded(
                child: CircularPercentIndicator(
              percent: percentCalc(),
              animation: true,
              animateFromLastPercent: true,
              radius: 120,
              lineWidth: 20,
              progressColor: Color.fromARGB(255, 255, 0, 0),
              center: Container(
                width: 145,
                height: 145,
                child: Center(child: buildTime()),
              ),
            )),
            Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                //padding inside the column
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("Activity Type"),
                    SizedBox(
                      height: 10,
                    ),
                    //Row for chips
                    Row(
                      children: [
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Minutes",
                          style: mystyle,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Center(
                            child: Column(
                          children: [
                            Center(
                                child: Column(
                              children: [
                                InkWell(
                                  child: Icon(Icons.keyboard_arrow_up),
                                  onTap: () {
                                    setState(() {
                                      if (counterTime < 120) {
                                        counterTime = counterTime + 1;
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  "$counterTime",
                                  style: mystyle,
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (counterTime > 1) {
                                          counterTime = counterTime - 1;
                                        }
                                      });
                                    },
                                    child: Icon(Icons.keyboard_arrow_down)),
                              ],
                            )),
                          ],
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: SizedBox()),
                        isnotStarted == false
                            ? ElevatedButton(
                                onPressed: isCatselected()
                                    ? () {
                                        print("button start pressed");
                                        duration1 =
                                            Duration(minutes: counterTime);
                                        startTimer();
                                        /*  FlutterAlarmClock.createAlarm(
                                      DateTime.now().hour + duration1.inHours,
                                      DateTime.now().minute +
                                          duration1.inMinutes,
                                      title: "Time'sUp",
                                      skipUi: true);*/
                                        FlutterAlarmClock.createTimer(
                                            counterTime * 60,
                                            skipUi: true,
                                            title: "Time is Up");
                                        print(DateTime.now().hour +
                                            duration1.inHours);
                                        print(
                                          DateTime.now().second +
                                              duration1.inSeconds.remainder(60),
                                        );
                                        setState(() {
                                          isnotStarted = true;
                                          beginTime = counterTime;
                                        });
                                      }
                                    : showToast(),
                                child: Text("Start"),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  beginTime = duration1.inMinutes;
                                  duration1 = Duration();
                                  endTimer();
                                  setState(() {
                                    isnotStarted = false;
                                  });
                                },
                                child: Text("Stop"),
                              ),
                        Expanded(child: SizedBox()),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Stats"),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
        style: TextStyle(fontSize: 55, color: Colors.white));
  }

  percentCalc() {
    return (duration1.inSeconds / 60) / counterTime;
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
