// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/pages/view_data_updated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:devstack/assets.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    Key? key,
    required this.isDone,
    required this.title,
    required this.time,
    required this.check,
    required this.onChange,
    required this.index,
    required this.description,
    required this.document,
    required this.id,
    required this.priority,
    required this.coins,
  }) : super(key: key);
  //we need to assign all value dynamically
  final String title;
  final int coins;
  final DateTime time;
  final bool check;
  final Function onChange;
  final index;
  final description;
  final bool isDone;
  final Map<String, dynamic> document;
  final String id;
  final priority;
  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Color color = todoCardBGColor;
  @override
  void initState() {
    super.initState();
  }

  bool animatBool = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
            color: findColor(widget.time, widget.isDone, widget.priority),
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 115, 115, 115).withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: Offset(0, 3),
              )
            ]),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 18),
            ),
            SizedBox(
              height: 2,
            ),
            widget.isDone == false
                ? countDown(widget.time, widget.isDone)
                : SizedBox(
                    width: 0,
                    height: 0,
                  ),
            SizedBox(
              height: 6,
            ),
            Text(
              widget.description,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date due:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat.yMMMEd().format(widget.time),
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.normal)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat.j().format(widget.time),
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.normal)),
                  ],
                ),
                widget.isDone == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                //Edit button to view and edit data
                                Navigator.of(context).push(PageTransition(
                                    type: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 550),
                                    reverseDuration:
                                        Duration(milliseconds: 250),
                                    child: ViewData(
                                        document: widget.document,
                                        id: widget.id)));
                              },
                              child: Text(
                                'Edit',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () async {
                                showSuccessDialog();
                                await Future.delayed(
                                    Duration(milliseconds: 2000));
                                Navigator.of(context).pop();
                                FirebaseFirestore.instance
                                    .collection("collect2")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("Todo")
                                    .doc(widget.id)
                                    .update({"isDone": true});
                                ExpCoin(widget.document);
                                setState(() {});
                              },
                              child: Text(
                                'Mark as done',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget countDown(
    DateTime time,
    bool isDone,
  ) {
    var daysLeft = time.day - DateTime.now().day;
    var daysLeftAbs = daysLeft.abs();
    var overdue = false;
    if (daysLeft < 0) {
      setState(() {
        overdue = true;
      });
    } else {
      setState(() {
        overdue = false;
      });
    }
    return overdue == false
        ? Text(
            daysLeft != 0 ? "$daysLeftAbs day(s) left" : "Due today!",
            style: GoogleFonts.poppins(),
          )
        : Text(
            "Overdue!!",
            style: GoogleFonts.poppins(
                color: Colors.red, fontWeight: FontWeight.bold),
          );
  }

  bool isOverdue(
    DateTime time,
    bool isDone,
  ) {
    var daysLeft = time.day - DateTime.now().day;
    var overdue = false;
    if (daysLeft < 0) {
      setState(() {
        overdue = true;
      });
    } else {
      setState(() {
        overdue = false;
      });
    }

    return overdue;
  }

  Color findColor(DateTime time, bool isdone, String priority) {
    var daysLeft = time.day - DateTime.now().day;

    bool overdue = false;
    setState(() {
      overdue = isOverdue(time, isdone);
    });

    if (isdone == true) {
      setState(() {
        //color = Color.fromRGBO(189, 240, 198, 1);
        color = returnDoneColor(context);
      });
      return color;
    } else {
      if (priority == "critical") {
        setState(() {
          //color = Color.fromARGB(255, 253, 213, 213);
          color = returnCriticalColor(context);
        });
      }
      if (priority == "mild") {
        setState(() {
          //color = Color.fromARGB(255, 255, 234, 197);
          color = returnMildColor(context);
        });
      }
      if (priority == "normal") {
        setState(() {
          //color = Color.fromRGBO(207, 236, 255, 1);
          color = returnNormalColor(context);
        });
      }
    }
    return color;
  }

  Future showSuccessDialog() => showDialog(
        context: context,
        barrierColor: Colors.white,
        builder: (context) => AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: null,
          contentPadding: EdgeInsets.all(5),
          content: Lottie.asset("assets/lottieSuccess.json"),
        ),
      );

  void ExpCoin(document) {
    int coins2 = 0;
    if (document['priority'] == 'critical') {
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("userDetails")
          .update({
        "coins": FieldValue.increment(20),
        "Experience": FieldValue.increment(50)
      });
    }
    if (document['priority'] == 'mild') {
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("userDetails")
          .update({
        "coins": FieldValue.increment(25),
        "Experience": FieldValue.increment(25)
      });
    }
    if (document['priority'] == 'normal') {
      FirebaseFirestore.instance
          .collection("collect2")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userModel")
          .doc("userDetails")
          .update({
        "coins": FieldValue.increment(10),
        "Experience": FieldValue.increment(15)
      });
    }
  }
}

//mild color
Color returnMildColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromARGB(255, 255, 234, 197);
  }
}

//normal color

Color returnNormalColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(207, 236, 255, 1);
  }
}
//critical color

Color returnCriticalColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromARGB(255, 253, 213, 213);
  }
}

//critical color

Color returnDoneColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(189, 240, 198, 1);
  }
}
