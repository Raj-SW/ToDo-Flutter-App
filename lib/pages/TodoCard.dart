// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/pages/view_data_updated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:devstack/assets.dart';

class TodoCard extends StatefulWidget {
  const TodoCard(
      {Key? key,
      required this.title,
      required this.time,
      required this.check,
      required this.onChange,
      required this.index,
      required this.description,
      required this.document,
      required this.id})
      : super(key: key);
  //we need to assign all value dynamically
  final String title;
  final DateTime time;
  final bool check;
  final Function onChange;
  final index;
  final description;
  final Map<String, dynamic> document;
  final String id;
  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Color color = todoCardBGColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            color: isoverdue(widget.time),
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(),
                countDown(widget.time),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(widget.description),
            SizedBox(
              height: 20,
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat.yMMMEd().format(widget.time)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat.j().format(widget.time)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ViewData(
                                      document: widget.document,
                                      id: widget.id)));*/
                          Navigator.of(context).push(PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 550),
                              reverseDuration: Duration(milliseconds: 250),
                              child: ViewData(
                                  document: widget.document, id: widget.id)));
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                        onTap: () {
                          /*    FirebaseFirestore.instance
                              .collection("collect2")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Todo")
                              .doc(widget.id)
                              .delete();*/
                        },
                        child: Text(
                          'Mark as done',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget countDown(DateTime time) {
    var daysLeft = DateTime.now().day - time.day;
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
    return Text(overdue == false
        ? "Task overdue by $daysLeftAbs days"
        : "$daysLeftAbs days left");
  }

  Color isoverdue(DateTime time) {
    var daysLeft = time.day - DateTime.now().day;
    if (daysLeft > 2) {
      setState(() {
        color = todoCardBGColor;
      });
    } else if (daysLeft >= 0 && daysLeft <= 2) {
      setState(() {
        color = Color.fromARGB(255, 255, 124, 124);
      });
    } else if (daysLeft < 0) {
      setState(() {
        color = Color.fromARGB(255, 187, 186, 186);
      });
    }

    return color;
  }
}
