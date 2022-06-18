// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_final_fields

import 'package:devstack/assets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Service/Notif_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? mydateTime;
  TimeOfDay _timePicked = TimeOfDay.now();
  DateTime? finalDateTime;
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: PrimaryColor,
                    size: 28,
                  ),
                  iconSize: 28,
                ),
                label('Add New Task', PrimaryColor, 25),
                SizedBox(
                  width: 50,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Add Task Title', Colors.black, 16.5),
                  SizedBox(
                    height: 10,
                  ),
                  title(),
                  SizedBox(
                    height: 25,
                  ),
                  label('Add Task Description', Colors.black, 16.5),
                  SizedBox(
                    height: 10,
                  ),
                  description(),
                  SizedBox(
                    height: 25,
                  ),
                  label('Choose Date', Colors.black, 16.5),
                  SizedBox(
                    height: 12,
                  ),
                  dateSelected(),
                  SizedBox(
                    height: 10,
                  ),
                  label('Choose Time', Colors.black, 16.5),
                  SizedBox(
                    height: 10,
                  ),
                  timeSelected(),
                  SizedBox(
                    height: 50,
                  ),
                  button(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        //validation
        if (mydateTime == null ||
            _descriptionController.text.isEmpty ||
            _titleController.text.isEmpty) {
          //show error message
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("You have missed a field"),
                  content: Text("Please fill all fields again!"),
                  actions: <Widget>[
                    InkWell(
                        onTap: (() {
                          Navigator.pop(context);
                        }),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Fill Again!",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ))
                  ],
                );
              });
        } else {
          //final date time declaration and initialisation
          finalDateTime = DateTime(mydateTime!.year, mydateTime!.month,
              mydateTime!.day, _timePicked.hour, _timePicked.minute);
          print("final date and time");
          print(finalDateTime);

          //writing instance on firebase
          FirebaseFirestore.instance
              .collection("collect2")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Todo")
              .add(
            {
              "title": _titleController.text,
              "description": _descriptionController.text,
              "scheduledTime": finalDateTime
            },
          );

          //calling on notification
          NotificationService.showScheduledNotification(
              title: _titleController.text,
              body: _descriptionController.text,
              payload: 'HomePage',
              scheduledDate: finalDateTime!);
          Navigator.pop(context);
          showToast();
        }
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: PrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          "Add ToDo",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: todoCardBGColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle:
                TextStyle(color: Color.fromARGB(255, 96, 96, 96), fontSize: 17),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: todoCardBGColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle:
                TextStyle(color: Color.fromARGB(255, 96, 96, 96), fontSize: 17),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
      ),
    );
  }

  Widget label(String label, Color color, double fontsize) {
    return (Text(label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: fontsize,
          letterSpacing: 0.2,
        )));
  }

  Widget dateSelected() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: todoCardBGColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () async {
              mydateTime = (await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime(2023),
              ));
              setState(() {});
            },
          ),
          Text(
            mydateTime == null
                ? 'DD/MM/YY'
                : DateFormat.yMMMEd().format(mydateTime!).toString(),
            style: TextStyle(
                color: mydateTime == null
                    ? Color.fromARGB(255, 96, 96, 96)
                    : Color.fromARGB(255, 0, 0, 0)),
          )
        ],
      ),
    );
  }

  Widget timeSelected() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: todoCardBGColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.alarm),
            onPressed: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) {
                setState(() {
                  _timePicked = value!;
                });
              });
              setState(() {});
            },
          ),
          Text(
            _timePicked.format(context),
          )
        ],
      ),
    );
  }

  Future<void> delay() async {
    await Future.delayed(Duration(milliseconds: 13000));
  }

  showToast() {
    return Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: "Task Added",
        fontSize: 18,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM);
  }
}
