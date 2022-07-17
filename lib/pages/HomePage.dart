// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/SoundSystem.dart';
import 'package:devstack/circle_transition_clipper.dart';
import 'package:devstack/pages/AddToDo.dart';
import 'package:devstack/pages/TodoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  int todayCount = 0;
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

  List<String> itemList = [
    'Today',
    'This Week',
    'All',
    'Done',
  ];
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
              String priority = doc["priority"];
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
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 233, 116, 80),
        onPressed: () {
          SoundSystem().playLocal();
          Navigator.of(context).push(_createRoute());
        },
        child: Icon(
          Icons.add,
          size: 50,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              toolbarHeight: 60,
              centerTitle: true,
              backgroundColor: Color.fromRGBO(83, 123, 233, 1),
              title: Text(
                "To-Do List",
                style: GoogleFonts.pacifico(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                collapseMode: CollapseMode.parallax,
                background: Container(
                  margin: EdgeInsets.only(top: 97),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //"Hey!\n${FirebaseAuth.instance.currentUser!.displayName}",
                                "Hey UserName + Photo of user",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          /*  CircleAvatar(
                            maxRadius: 30,
                            foregroundImage: NetworkImage(FirebaseAuth
                                .instance.currentUser!.photoURL
                                .toString()),
                          )*/
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Image(
                              image: AssetImage("assets/HomePageSliver.png"),
                              height: 170,
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "Your Tasks for\n",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 0.8,
                                ),
                              ),
                              Text(
                                "Today\n",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 0.8,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMEd().format(DateTime.now()),
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                  ),
                  child: DropdownButton<String>(
                    iconEnabledColor: Color.fromRGBO(83, 123, 233, 1),
                    focusColor: Color.fromRGBO(83, 123, 233, 1),
                    value: selectedItem,
                    items: itemList
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(83, 123, 233, 1)),
                            )))
                        .toList(),
                    onChanged: (item) => setState(() => selectedItem = item),
                  ),
                ),
              ],
            ),
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
                        String priority = document["priority"];

                        if (selectedItem == "Today") {
                          if (time.day == DateTime.now().day &&
                              isDone == false) {
                            todayCount++;
                            return TodoCard(
                              priority: priority,
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
                        } else if (selectedItem == "This Week") {
                          if (time.day >= strtWk.day &&
                              time.day <= endWk.day &&
                              isDone == false) {
                            return TodoCard(
                              priority: priority,
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
                        } else if (selectedItem == "All" && isDone == false) {
                          return TodoCard(
                            priority: priority,
                            isDone: isDone,
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
                        } else if (selectedItem == "Done") {
                          if (isDone == true) {
                            return TodoCard(
                              priority: priority,
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
                        } /* else if (todayCount == 0) {
                          return Column(
                            children: [
                              Text("Wow so empty!!"),
                              Image(image: AssetImage("assets/illust1.png")),
                            ],
                          );
                        }*/
                        return Container();
                      });
                }),
          ]),
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
