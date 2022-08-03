// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:alan_voice/alan_voice.dart';
import 'package:devstack/assets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Service/Notif_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

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
  _AddToDoPageState() {
    AlanVoice.onCommand.add((command) {
      Map<String, dynamic> commandData = command.data;
      if (commandData["command"] == "cancelTask") {
        Navigator.pop(context);
        print("yes I am here");
      }
      if (commandData["command"] == "getTitle") {
        _titleController.text = commandData['text'];
        print("aight");
      }
      if (commandData["command"] == "getDescription") {
        _descriptionController.text = commandData['text'];
        print("wow");
      }
      if (commandData["command"] == "getDate") {
        print("olala");

        print(commandData["text"]);
        print("******");

        mydateTime = DateTime.parse(commandData["text"]);
        DateTime due = DateTime.parse(commandData["text"]);
        DateTime today = DateTime.now();
        int a = due.compareTo(today);
        print(a);

        if (a < 0) {
          AlanVoice.playText("Date cannot be before today");
        } else {
          setState(() {
            mydateTime = DateTime.parse(commandData["text"]);
            AlanVoice.playText("Date has been set successfully");
          });
        }

        // mydateTime = DateTime.parse(commandData["text"]);
        print(mydateTime);
      }
      //set priority
      if (commandData["command"] == "criticalPriority") {
        print("criticalPriority");
        setState(() {
          priority = "critical";
          isSelected1 = true;
          isSelected2 = false;
          isSelected3 = false;
        });
      }
      if (commandData["command"] == "mildPriority") {
        print("mildPriority");
        setState(() {
          priority = "mild";

          isSelected1 = false;
          isSelected2 = true;
          isSelected3 = false;
        });
      }
      if (commandData["command"] == "normalPriority") {
        print("normalPriority");
        setState(() {
          priority = "normal";
          isSelected1 = false;
          isSelected2 = false;
          isSelected3 = true;
        });
      }

      if (commandData["command"] == "saveTask") {
        print("olala");
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
            "scheduledTime": finalDateTime,
            "isDone": false,
            "priority": priority
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

      if (commandData["command"] == "getTime") {
        String number = commandData["text"].toString();
        num seconds = num.parse(number);
        num hours;
        num minutes;
        hours = seconds / 3600;
        minutes = (seconds % 3600) / 60;
        int numHours = hours.floor();
        int numMinutes = minutes.floor();
        setState(() {
          _timePicked = TimeOfDay(hour: numHours, minute: numMinutes);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  String priority = "";
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28,
                  ),
                  iconSize: 28,
                  color: PrimaryColor,
                ),
                label('Add New Task', PrimaryColor, 25),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () => openDialog(),
                  child: Icon(
                    Icons.image_search_sharp,
                    color: PrimaryColor,
                  ),
                ),
                SizedBox(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
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
                  label('Priority', Colors.black, 16.5),
                  SizedBox(
                    height: 5,
                  ),
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
                            priority = "critical";
                          });
                        },
                        label: Text(
                          "Critical",
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
                            priority = "mild";
                          });
                        },
                        label: Text(
                          "Mild",
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
                            priority = "normal";
                          });
                        },
                        label: Text(
                          "Normal",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          label('Choose Date', Colors.black, 16.5),
                          SizedBox(
                            height: 12,
                          ),
                          dateSelected(),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          label('Choose Time', Colors.black, 16.5),
                          SizedBox(
                            height: 10,
                          ),
                          timeSelected(),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
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
            _titleController.text.isEmpty ||
            priority.isEmpty) {
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
              "scheduledTime": finalDateTime,
              "isDone": false,
              "priority": priority
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
        color: SecondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Description",
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
        color: SecondaryColor,
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
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: SecondaryColor,
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
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: SecondaryColor,
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
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        toastLength: Toast.LENGTH_SHORT,
        msg: "Task Added",
        fontSize: 18,
        textColor: Colors.white,
        gravity: ToastGravity.TOP);
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText = "Error";
        showToastError("Error");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No text found")));
      });
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    _descriptionController.text = scannedText;
    recognisedText(scannedText);
    setState(() {});
    Navigator.of(context).pop();
    if (scannedText == "") {
      errorDialog('Unfortunately no text found');
    } else if (!scannedText.contains("scheduled for") &&
        !scannedText.contains("at time")) {
      errorDialog("Sorry date and time not found");
    } else if (!scannedText.contains("scheduled for") &&
        scannedText.contains("at time")) {
      errorDialog("Sorry date not found");
    } else if (!scannedText.contains("at time") &&
        scannedText.contains("scheduled for")) {
      errorDialog("Sorry time not found");
    }
  }

  Future errorDialog(String text) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Oops!!"),
            content: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "ok",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            child: AlertDialog(
              title: Text(
                "Add description from image?",
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(

                          ///Choose from Gallery
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.image),
                              Text("Gallery")
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(

                          ///Choose from camera
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.camera),
                              Text("Camera")
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ));
  void recognisedText(String scannedText) {
    print("recognising text");
    if (scannedText.length > 10) {
      _titleController.text = scannedText.substring(0, 10);
    }

    if (scannedText.contains("scheduled for")) {
      try {
        mydateTime = DateTime.parse(scannedText.substring(
            scannedText.lastIndexOf("scheduled for") + 14,
            scannedText.lastIndexOf("scheduled for") + 24));
        print(DateFormat.yMMMEd().format(mydateTime!));
      } catch (e) {}
    }
    if (scannedText.contains("appointment on the")) {
      try {
        mydateTime = DateTime.parse(scannedText.substring(
            scannedText.lastIndexOf("appointment on the") + 20,
            scannedText.lastIndexOf("appointment on the") + 30));
      } catch (e) {
        print("not found");
      }
    }

    //priprity
    if (scannedText.contains("of priority critical")) {
      try {
        /*    priority = (scannedText.substring(
            scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 16));*/
        setState(() {
          isSelected2 = false;
          isSelected3 = false;
          isSelected1 = true;
          priority = "critical";
        });
        print(scannedText.substring(scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 16));
        print(priority);
      } catch (e) {
        print("not found");
      }
    }
    if (scannedText.contains("of priority mild")) {
      try {
        /*  priority = (scannedText.substring(
            scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 16));*/
        setState(() {
          isSelected1 = false;
          isSelected3 = false;
          isSelected2 = true;
          priority = "mild";
        });
        print(scannedText.substring(scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 16));
      } catch (e) {
        print("not found");
      }
    }
    if (scannedText.contains("of priority normal")) {
      try {
        setState(() {
          isSelected1 = false;
          isSelected2 = false;
          isSelected3 = true;
          priority = "normal";
        });
        /*priority = (scannedText.substring(
            scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 18));*/
        print(scannedText.substring(scannedText.lastIndexOf("of priority") + 12,
            scannedText.lastIndexOf("of priority") + 18));
      } catch (e) {
        print("not found");
      }
    }

    //for time
    if (scannedText.contains("at time")) {
      try {
        print(scannedText.substring(scannedText.lastIndexOf("at time") + 8,
            scannedText.lastIndexOf("at time") + 13));
        var string = scannedText.substring(
            scannedText.lastIndexOf("at time") + 8,
            scannedText.lastIndexOf("at time") + 13);
        List<String> split = string.split(":");
        _timePicked =
            TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
        _titleController.text = scannedText.substring(0, 30);
      } catch (e) {
        print(e);
      }
    }
  }

  showToastError(String message) {
    return Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 233, 83, 83),
        toastLength: Toast.LENGTH_SHORT,
        msg: message,
        fontSize: 18,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM);
  }
}
