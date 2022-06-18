// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:devstack/assets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Service/Notif_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

class ViewData extends StatefulWidget {
  const ViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController =
      TextEditingController(text: "test Mode");
  DateTime? mydateTime;
  TimeOfDay _timePicked = TimeOfDay.now();
  DateTime? finalDateTime;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    String title = widget.document['title'] == null
        ? "Hey there"
        : widget.document['title'];
    _titleController = TextEditingController(text: title);
    _descriptionController =
        TextEditingController(text: widget.document['description']);
    DateTime initDate = widget.document["scheduledTime"].toDate();
    mydateTime = initDate;
    _timePicked = TimeOfDay.fromDateTime(initDate);
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(
                  width: 20,
                ),
                label(edit ? 'Edit Task' : 'View Task', PrimaryColor, 25),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Row(
                    children: [
                      //icon for delete
                      IconButton(
                          onPressed: edit
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete Task?"),
                                          content: Text(
                                              "Are you sure to delete Task!"),
                                          actions: <Widget>[
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    edit = !edit;
                                                    FirebaseFirestore.instance
                                                        .collection("collect2")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection("Todo")
                                                        .doc(widget.id)
                                                        .delete()
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                  Navigator.pop(context);
                                                  //after delete show Toast
                                                  showToast("Deleted");
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                )),
                                            InkWell(
                                                onTap: (() {
                                                  setState(() {
                                                    edit = false;
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        );
                                      });
                                }
                              : null,
                          icon: Icon(
                            Icons.delete,
                            color: edit
                                ? Color.fromARGB(255, 232, 87, 87)
                                : Color.fromARGB(141, 119, 121, 226),
                            size: 28,
                          )),
                      //icon for update
                      IconButton(
                          onPressed: () {
                            if (edit) {
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit Task?"),
                                    content: Text(
                                        "You might lose previous information!"),
                                    actions: <Widget>[
                                      InkWell(
                                          onTap: (() {
                                            setState(() {
                                              edit = !edit;
                                            });
                                            Navigator.pop(context);
                                          }),
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          )),
                                      InkWell(
                                          onTap: (() {
                                            setState(() {
                                              edit = false;
                                            });
                                            Navigator.pop(context);
                                          }),
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ))
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: PrimaryColor,
                          ))
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label(edit ? 'Edit Title' : 'View Title', Colors.black, 16.5),
                  SizedBox(
                    height: 10,
                  ),
                  title(),
                  SizedBox(
                    height: 25,
                  ),
                  label(edit ? 'Edit Description' : 'View Description',
                      Colors.black, 16.5),
                  SizedBox(
                    height: 10,
                  ),
                  description(),
                  SizedBox(
                    height: 25,
                  ),
                  label(edit ? 'Edit Date' : 'Scheduled date', Colors.black,
                      16.5),
                  SizedBox(
                    height: 12,
                  ),
                  dateSelected(),
                  SizedBox(
                    height: 10,
                  ),
                  label(edit ? 'Edit Time' : 'Scheduled Time', Colors.black,
                      16.5),
                  SizedBox(
                    height: 10,
                  ),
                  timeSelected(),
                  SizedBox(
                    height: 50,
                  ),
                  edit ? button() : Container(),
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
        if (_descriptionController.text.isEmpty ||
            _titleController.text.isEmpty ||
            mydateTime == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("You left a field empty"),
                  content: Text("Please fill all fields!"),
                  actions: <Widget>[
                    InkWell(
                        onTap: (() {
                          Navigator.pop(context);
                        }),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Okay!",
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

//updating instance on firebase
          FirebaseFirestore.instance
              .collection("collect2")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Todo")
              .doc(widget.id)
              .update(
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
          showToast("Updated");
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
          "Update ToDo",
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
        enabled: edit ? true : false,
        controller: _descriptionController,
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle:
                TextStyle(color: Color.fromARGB(255, 96, 96, 96), fontSize: 17),
            contentPadding:
                EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10)),
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
        enabled: edit ? true : false,
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
            onPressed: edit
                ? () async {
                    mydateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2023),
                    );
                    setState(() {});
                  }
                : null,
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
            onPressed: edit
                ? () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      setState(() {
                        _timePicked = value!;
                      });
                    });
                    setState(() {});
                  }
                : null,
          ),
          Text(
            _timePicked.format(context),
          )
        ],
      ),
    );
  }

  showToast(String txt) {
    return Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: "Task $txt",
        fontSize: 18,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM);
  }
}
