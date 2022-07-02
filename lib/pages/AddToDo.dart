// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_final_fields

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
        setState(() {
          print(commandData["text"]);
          print("******");
          mydateTime = DateTime.parse(commandData["text"]);
          // mydateTime = DateTime.parse(commandData["text"]);
          print(mydateTime);
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
            "isDone": false
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
      /*
      if(commandData["command"]=="getTime"){
        print('yesyesyesys');
        print(commandData["text"].toString());
        int seconds = int.parse(commandData["text"].toString());
        double hours = seconds.toDouble()/3600.0;
        double wholeHours1 = hours.floor() as double;
        int wholeHours = wholeHours1.toInt();
        print(wholeHours.toString());
        int minutes = ((seconds % 3600)/60) as int;

        print(minutes.toString());
      }
*/
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
                    color: PrimaryColor,
                    size: 28,
                  ),
                  iconSize: 28,
                ),
                label('Add New Task', PrimaryColor, 25),
                SizedBox(
                  width: 40,
                ),
                InkWell(
                    onTap: () => openDialog(),
                    child: Icon(Icons.image_search_sharp)),
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
              "scheduledTime": finalDateTime,
              "isDone": false
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
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Error";
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
    setState(() {});
    Navigator.of(context).pop();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add description from gallery or camera"),
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
          ));
}
