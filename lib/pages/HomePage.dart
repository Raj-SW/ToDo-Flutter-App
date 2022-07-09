// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/SoundSystem.dart';
import 'package:devstack/circle_transition_clipper.dart';
import 'package:devstack/pages/AddToDo.dart';
import 'package:devstack/pages/TodoCard.dart';
import 'package:devstack/pages/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Service/Auth_Service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:devstack/assets.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("collect2")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Todo")
      .orderBy("scheduledTime", descending: false)
      .snapshots();

  DateTime now = DateTime.now();
  late DateTime strtWk;
  late DateTime endWk;

  List<Select> selected = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    endWk = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    strtWk = now.subtract(Duration(days: now.weekday - 1));
  }

  List<String> itemList = ['Today', 'This Week', 'All', 'Done'];
  String? selectedItem = 'Today';
  _HomePageState() {
    AlanVoice.onCommand.add((command) {
      Map<String, dynamic> commandData = command.data;
      //Add a new task-- voice command: Add a new task
      if (commandData["command"] == "addTask") {
        SoundSystem().playLocal();
        Navigator.of(context).push(_createRoute());
        print("maybe");
      }
      //List down all tasks for the day-- voice command: What are today's tasks
      if (commandData["command"] == "today") {
        String today = "Your tasks for today are as follows: ";
        setState(() {
          selectedItem = 'Today';
        });
        FirebaseFirestore.instance
            .collection("collect2")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Todo")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            bool isDone = doc['isDone'];
            DateTime theTime = (doc['scheduledTime']).toDate();
            String formattedDate = DateFormat.MMMMEEEEd().format(theTime);
            String formattedTime = DateFormat.Hm().format(theTime);
            if ((theTime.day == DateTime.now().day) && (isDone == false)) {
              print(formattedTime);
              String thisTask = doc["title"] + " at " + formattedTime + ", ";
              today += thisTask;
              print(today);
              print(date.toString());
            }
          });

          if (today == "") {
            AlanVoice.playText("Your don't have anything due today");
          } else {
            AlanVoice.playText(today);
          }
        });
      }
      //List down all pending tasks-- voice command: List all my tasks
      if (commandData["command"] == "allTasks") {
        String all = "Here is the list of all your tasks: ";
        setState(() {
          selectedItem = 'All';
        });
        print("all tasks ");
        FirebaseFirestore.instance
            .collection("collect2")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Todo")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            bool isDone = doc['isDone'];
            if (isDone == false) {
              DateTime theTime = (doc['scheduledTime']).toDate();
              String formattedDate = DateFormat.MMMMEEEEd().format(theTime);
              String formattedTime = DateFormat.Hm().format(theTime);
              print(formattedTime);
              String thisTask = doc["title"] +
                  " on " +
                  formattedDate +
                  " at " +
                  formattedTime +
                  ", ";
              all += thisTask;
              print(all);
              print(date.toString());
            }
          });
          if (all == "Here is the list of all your tasks: ") {
            AlanVoice.playText("You don't have any upcoming task");
          } else {
            AlanVoice.playText(all);
          }
        });
      }
      //List down all completed tasks-- voice command: List the completed tasks
      if (commandData["command"] == "completedTasks") {
        String allCompleted = "Here is the list of all your completed tasks: ";
        setState(() {
          selectedItem = 'Done';
        });
        print("completed tasks ");
        FirebaseFirestore.instance
            .collection("collect2")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Todo")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            bool isDone = doc['isDone'];
            if (isDone == true) {
              DateTime theTime = (doc['scheduledTime']).toDate();
              String formattedDate = DateFormat.MMMMEEEEd().format(theTime);
              String formattedTime = DateFormat.Hm().format(theTime);
              print(formattedTime);
              String thisTask = doc["title"] +
                  " due on " +
                  formattedDate +
                  " at " +
                  formattedTime +
                  ", ";
              allCompleted += thisTask;
              print(allCompleted);
              print(date.toString());
            }
          });
          if (allCompleted ==
              "Here is the list of all your completed tasks: ") {
            AlanVoice.playText("You don't have any completed task");
          } else {
            AlanVoice.playText(allCompleted);
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var _selectedValue;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //   backgroundColor: Color.fromARGB(0, 255, 255, 255), centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            "To-Dos",
            style: GoogleFonts.pacifico(
              color: Color.fromRGBO(93, 95, 239, 1),
              fontSize: 41,
            ),
          ),
        ), //
        /*  leading: IconButton(
          icon: Icon(Icons.menu), color: Colors.deepPurple,
          onPressed: () {
            SoundSystem().playLocal();
            ZoomDrawer.of(context)!.toggle();
            //MenuWidget();
          },
          //menu widget can used instead of icon button
          //MenuWidget(),
        ),*/
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.deepPurple,
            onPressed: () {
              authClass.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => WelcomeScreen()),
                  (route) => false);
            },
          )
        ],

        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SoundSystem().playLocal();
          Navigator.of(context).push(_createRoute());
        },
        backgroundColor: PrimaryColor,
        child: Icon(
          Icons.add,
          size: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 15),
                  child: DropdownButton<String>(
                    iconEnabledColor: Colors.deepPurple,
                    focusColor: Colors.deepPurple,
                    value: selectedItem,
                    items: itemList
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 18),
                            )))
                        .toList(),
                    onChanged: (item) => setState(() => selectedItem = item),
                  ),
                ),
              ],
            ),

            /* SizedBox(
              height: MediaQuery.of(context).size.height - 196,

              child: */
            StreamBuilder(
                stream: _stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> document =
                            snapshot.data.docs[index].data()
                                as Map<String, dynamic>;
                        selected.add(Select(
                            id: snapshot.data.docs[index].id,
                            checkValue: false));
                        DateTime time = date(document);
                        bool isDone = document["isDone"];

                        if (selectedItem == "Today" && isDone == false) {
                          if (time.day == DateTime.now().day) {
                            return TodoCard(
                              isDone: document["isDone"],
                              check: selected[index].checkValue,
                              time: date(document),
                              title: document["title"] == null
                                  ? "Add your tasks"
                                  : document["title"],
                              description: document["description"],
                              index: index,
                              document: document,
                              id: snapshot.data.docs[index].id,
                              onChange: onChange,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (selectedItem == "This Week" && isDone == false) {
                          if (time.day >= strtWk.day && time.day <= endWk.day) {
                            return TodoCard(
                              isDone: document["isDone"],
                              check: selected[index].checkValue,
                              time: date(document),
                              title: document["title"] == null
                                  ? "Add your tasks"
                                  : document["title"],
                              description: document["description"],
                              index: index,
                              document: document,
                              id: snapshot.data.docs[index].id,
                              onChange: onChange,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (selectedItem == "Done") {
                          if (document['isDone'] == true) {
                            return TodoCard(
                              isDone: document["isDone"],
                              check: selected[index].checkValue,
                              time: date(document),
                              title: document["title"] == null
                                  ? "Add your tasks"
                                  : document["title"],
                              description: document["description"],
                              index: index,
                              document: document,
                              id: snapshot.data.docs[index].id,
                              onChange: onChange,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (selectedItem == "All" && isDone == false) {
                          return TodoCard(
                            isDone: document["isDone"],
                            check: selected[index].checkValue,
                            time: date(document),
                            title: document["title"] == null
                                ? "Add your tasks"
                                : document["title"],
                            description: document["description"],
                            index: index,
                            document: document,
                            id: snapshot.data.docs[index].id,
                            onChange: onChange,
                          );
                        }
                        if (selectedItem == "Done") {
                          if (isDone == true) {
                            return TodoCard(
                              check: selected[index].checkValue,
                              isDone: document["isDone"],
                              time: date(document),
                              title: document["title"] == null
                                  ? "Add your tasks"
                                  : document["title"],
                              description: document["description"],
                              index: index,
                              document: document,
                              id: snapshot.data.docs[index].id,
                              onChange: onChange,
                            );
                          }
                        }
                        return Container();
                      });
                }),
            //),
          ],
        ),
      ),
    );
  }

  date(document) {
    DateTime myDateTime = (document['scheduledTime']).toDate();
    return myDateTime;
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddToDoPage(),
        transitionDuration: Duration(milliseconds: 900),
        reverseTransitionDuration: Duration(milliseconds: 900),
        barrierColor: PrimaryColor,
        barrierDismissible: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var screenSize = MediaQuery.of(context).size;
          var centerCircleClipper =
              Offset(screenSize.width - 0, screenSize.height - 0);

          double beginRadius = 0.1;
          double endRadius = screenSize.height * 1 * 2;

          var radiusTween = Tween(begin: beginRadius, end: endRadius);
          //var radiusTweenAnimation = animation.drive(radiusTween);
          var radiusTweenAnimation = animation
              .drive(CurveTween(curve: Curves.easeInToLinear))
              .drive(radiusTween);

          return ClipPath(
            child: child,
            clipper: CircleTransitionClipper(
              centerCircleClipper,
              radiusTweenAnimation.value,
            ),
          );
        });
  }

  Future openDialog() =>
      showDialog(context: context, builder: (context) => AddToDoPage());
}

class Select {
  String id = '';
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
