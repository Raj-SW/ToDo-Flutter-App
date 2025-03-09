// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shake/shake.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);
  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  double weight = 70.0;
  Duration duration = Duration();
  Timer? timer;
  int steps = 0;
  double distance = 0;
  bool isStarted = false;
  bool animateBool = false;
  static int counter = 0;
  late ShakeDetector detector;
  static bool shake = false;
  double calories = 0.0;
  static double monday = 0;
  static double tuesday = 0;
  static double wednesday = 0;
  static double thursday = 0;
  static double friday = 0;
  static double saturday = 0;
  static double sunday = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //firebaseInit();
    firebaseStart();
    //startTimer()
    detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          calcCalories();
          setState(() {
            steps++;
          });
        },
        shakeThresholdGravity: 1.5);
    detector.stopListening();
  }

  @override
  void dispose() {
    detector.stopListening(); // TODO: implement dispose
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: <Widget>[
          Container(
            height: 175,
            child: Lottie.network(
                'https://assets1.lottiefiles.com/packages/lf20_ruadfgs9.json',
                height: 200,
                width: 200,
                animate: animateBool,
                fit: BoxFit.fill),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hour : Minutes : Seconds",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$steps",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Steps",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          isStarted == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isStarted = false;
                            animateBool = false;
                            stopListen();
                            setCumulativeVAlues();
                            steps = 0;
                            print(calcCalories());
                          });

                          timer?.cancel();
                          duration = new Duration();
                        },
                        child: Text("Stop"))
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isStarted = true;
                            animateBool = true;
                            startTimer();
                            startListen();
                          });
                        },
                        child: Text("Start Timer"))
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "approx. ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              calcDistance().toStringAsFixed(1),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              " covered",
              style: TextStyle(fontSize: 22),
            )
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              calcCalories().toStringAsFixed(1),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              " calories burnt",
              style: TextStyle(fontSize: 22),
            )
          ])
        ],
      ),
    );
  }

  addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));

    return Text("$hours:$minutes:$seconds", style: TextStyle(fontSize: 80));
  }

  void startListen() {
    detector.startListening();
  }

  void stopListen() {
    detector.stopListening();
  }

  calcDistance() {
    setState(() {
      distance = 0.762 * steps;
    });
    return distance;
  }

  calcCalories() {
    //(duration in minutes*MET*3.5*weight)/200
    //met=11
    setState(() {
      calories = (((duration.inSeconds / 60) * 11 * weight)) / 200;
      print("Calories-- $calories");
      print(duration.inMinutes);
      print(duration.inSeconds);

      print(calories);
    });
    return calories;
  }

  void setCumulativeVAlues() {
    if (DateTime.now().weekday == 1) {
      monday = monday + calcCalories();
    }
    if (DateTime.now().weekday == 2) {
      tuesday = tuesday + calcCalories();
    }
    if (DateTime.now().weekday == 3) {
      wednesday = wednesday + calcCalories();
    }
    if (DateTime.now().weekday == 4) {
      thursday = thursday + calcCalories();
    }
    if (DateTime.now().weekday == 5) {
      friday = friday + calcCalories();
    }
    if (DateTime.now().weekday == 6) {
      saturday = saturday + calcCalories();
    }
    if (DateTime.now().weekday == 7) {
      sunday = sunday + calcCalories();
    }

    FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("runStats")
        .doc("runStats")
        .update({
      "mondayCal": monday,
      "tuesdayCal": tuesday,
      "wednesdayCal": wednesday,
      "thursdayCal": thursday,
      "fridayCal": friday,
      "saturdayCal": saturday,
      "sundayCal": sunday
    });
  }

  static double getCaloriesMonday() {
    return monday;
  }

  static double getCaloriesTuesday() {
    return tuesday;
  }

  static double getCaloriesWednesday() {
    return wednesday;
  }

  static double getCaloriesThursday() {
    return thursday;
  }

  static double getCaloriesFriday() {
    return friday;
  }

  static double getCaloriesSaturday() {
    return saturday;
  }

  static double getCaloriesSunday() {
    return sunday;
  }

  Future<void> firebaseStart() async {
    var document = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("runStats")
        .doc("runStats");
    document.get().then((value) => {
          if (value.exists)
            {
              print(" document exists"),
              monday = (value["mondayCal"]).toDouble(),
              tuesday = (value["tuesdayCal"]).toDouble(),
              wednesday = (value["wednesdayCal"]).toDouble(),
              thursday = (value["thursdayCal"]).toDouble(),
              friday = (value["fridayCal"]).toDouble(),
              saturday = (value["saturdayCal"]).toDouble(),
              sunday = (value["sundayCal"]).toDouble(),
              print(monday)
            }
          else
            {
              FirebaseFirestore.instance
                  .collection("collect2")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("runStats")
                  .doc("runStats")
                  .set({
                "mondayCal": 0,
                "tuesdayCal": 0,
                "wednesdayCal": 0,
                "thursdayCal": 0,
                "fridayCal": 0,
                "saturdayCal": 0,
                "sundayCal": 0,
                "userWeight": 0,
                "goalCalorie": 0
              }),
              print("document not exists now creating")
            }
        });
  }
}
