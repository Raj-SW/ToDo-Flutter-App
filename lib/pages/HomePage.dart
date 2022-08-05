// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/pages/pagetodo.dart';
import 'package:devstack/pages/studyTodoHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'groceryToDoPage.dart';
import 'sportsTodoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int Coins = 0;
  final document = FirebaseFirestore.instance
      .collection("collect2")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Todo')
      .get();
  int todoCountDone = 0,
      todoCount = 0,
      studyCount = 0,
      studyCountDone = 0,
      sportCount = 0,
      sportCountDone = 0,
      groceryCount = 0,
      groceryCountDone = 0;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    FirebaseFirestore.instance
        .collection('collect2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("userDetails")
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map? firestoreInfo = documentSnapshot.data() as Map?;
      setState(() {
        Coins = firestoreInfo!['coins'];
      });
    });
    document.then((value) {
      value.docs.forEach((element) {
        if (element['category'] == 'todos') {
          setState(() {
            todoCount++;
            if (element['isDone'] == true) {
              todoCountDone++;
            }
          });
        }
        if (element['category'] == 'study') {
          setState(() {
            studyCount++;
            if (element['isDone'] == true) {
              studyCountDone++;
            }
          });
        }
        if (element['category'] == 'sports') {
          setState(() {
            sportCount++;
            if (element['isDone'] == true) {
              sportCountDone++;
            }
          });
        }
        if (element['category'] == 'grocery') {
          setState(() {
            groceryCount++;
            if (element['isDone'] == true) {
              groceryCountDone++;
            }
          });
        }
      });
    });
    setState(() {});
  }

  List<String> itemList = [
    'Today',
    'This Week',
    'All',
    'Done',
  ];
  String? selectedItem = 'Today';
  _HomePageState() {
    /*  AlanVoice.onCommand.add((command) {
      Map<String, dynamic> commandData = command.data;
      //Add a new task-- voice command: Add a new task
      if (commandData["command"] == "addTask") {
        SoundSystem().playLocal();
        Navigator.of(context).push(_createRoute());
        print("maybe");
      }
      //List down all this week tasks
      if (commandData["command"] == "weekTasks") {
        String all = "Here is the list of all this weeks tasks: ";
        setState(() {
          selectedItem = 'This Week';
        });
        print("week tasks ");
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
              if (theTime.day >= strtWk.day &&
                  theTime.day <= endWk.day &&
                  isDone == false) {
                String formattedDate = DateFormat.MMMMEEEEd().format(theTime);
                String formattedTime = DateFormat.Hm().format(theTime);
                print(formattedTime);
                String thisTask = doc["title"] +
                    " due " +
                    formattedDate +
                    /*" at " +
                              formattedTime +*/
                    ", ";
                all += thisTask;
                print(all);
                print(date.toString());
              }
            }
          });
          if (all == "Here is the list of all this weeks tasks: ") {
            AlanVoice.playText("You don't have any task set for this week");
          } else {
            AlanVoice.playText(all);
          }
        });
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
                  " due " +
                  formattedDate +
                  /*" at " +
                  formattedTime +*/
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
                  " was due on " +
                  formattedDate + /*
                  " at " +
                  formattedTime +*/
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
    }
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "$Coins",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(FontAwesomeIcons.coins)
                    ],
                  ),
                )
              ],
              leading: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bars,
                    // color: Color(0xff5d5fef),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ZoomDrawer.of(context)!.toggle();
                  },
                  iconSize: 26,
                ),
              ),
              elevation: 8,

              floating: true,
              pinned: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              toolbarHeight: 80,
              centerTitle: false,
              backgroundColor: returnBettermeBackgroundColor(context),
              //color: returnBettermeBackgroundColor(context),
              // backgroundColor: Color.fromARGB(255, 106, 139, 228),
              // Color.fromARGB(255, 102, 133, 218), //Color.fromRGBO(83, 123, 233, 1),

              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Better.Me",
                    style: GoogleFonts.pacifico(
                      //  color: Color(0xff5d5fef),
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(children: [
            //Todos
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddTodoHomePage())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ],
                        color: returnTodoCategoryColor(
                            context), // Color.fromRGBO(107, 72, 246, 0.75),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$todoCountDone/$todoCount tasks',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Divider(
                            thickness: 1,
                            height: 2,
                            color: Colors.white,
                            indent: 1,
                            endIndent: 120,
                          ),
                        ),
                        Text('Todos',
                            style: GoogleFonts.poppins(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Lottie.asset(
                      "assets/todo(3).json",
                      animate: true,
                      frameRate: FrameRate.max,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 225, top: 95),
                    child: Lottie.asset(
                      "assets/miscLottie(11).json",
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 145, top: 55),
                    child: Lottie.asset(
                      "assets/miscLottie(6).json",
                      width: 70,
                      height: 70,
                    ),
                  ),
                ]),
              ),
            ),
            //Education Container
            InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => studyTodoHomePage())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ],
                        color: returnStudyCategoryColor(
                            context), //Color.fromRGBO(245, 119, 185, 0.95),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$studyCountDone/$studyCount tasks',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Divider(
                            thickness: 1,
                            height: 2,
                            color: Colors.white,
                            indent: 1,
                            endIndent: 120,
                          ),
                        ),
                        Text('Study',
                            style: GoogleFonts.poppins(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 215, top: 90),
                    child: Transform.rotate(
                      angle: 0.25,
                      child: Lottie.asset(
                        "assets/educationGlobe.json",
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 30),
                    child: Transform.rotate(
                      angle: 0.25,
                      child: Lottie.asset(
                        "assets/BooksLottie.json",
                        animate: true,
                        frameRate: FrameRate.max,
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 0),
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Lottie.asset(
                        "assets/miscLottie(5).json", //"assets/educBrainLottie.json",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            //sport
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => sportsTodoHomePage())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ],
                        color: returnSportsCategoryColor(
                            context), //Color.fromRGBO(255, 229, 164, 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$sportCountDone/$sportCount tasks',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: returnSportFontColor(
                                    context), //Colors.black,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Divider(
                            thickness: 1,
                            height: 2,
                            color: returnSportFontColor(
                                context), // Colors.black54,
                            indent: 120,
                            endIndent: 1,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Text('Sports',
                            style: GoogleFonts.poppins(
                                fontSize: 32,
                                color: returnSportFontColor(
                                    context), //Colors.black,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 150, top: 20),
                    child: Lottie.asset(
                      "assets/sportLottie(1).json",
                      animate: true,
                      frameRate: FrameRate.max,
                      //width: 250,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50, top: 20),
                    child: Transform.rotate(
                      angle: -0.35,
                      child: Lottie.asset(
                        "assets/sportLottie(2).json",
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            //grocery shopping
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => groceryTodoHomePage())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ],
                        color: returnGroceryCategoryColor(
                            context), //Color.fromRGBO(218, 174, 159, 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$groceryCountDone/$groceryCount tasks',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Divider(
                            thickness: 1,
                            height: 2,
                            color: Colors.white,
                            indent: 1,
                            endIndent: 120,
                          ),
                        ),
                        Text('Grocery &\nShopping',
                            style: GoogleFonts.poppins(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 190, top: 60),
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Lottie.asset(
                        "assets/grocery3.json",
                        width: 175,
                        height: 175,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, top: 30),
                    child: Transform.rotate(
                      angle: 0.0,
                      child: Lottie.asset(
                        "assets/grocery4.json",
                        animate: true,
                        frameRate: FrameRate.max,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 0),
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Lottie.asset(
                        "assets/miscLottie(3).json", //"assets/educBrainLottie.json",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            //ici sa
          ]),
        ),
      ),
    );
  }

  date(document) {
    DateTime myDateTime = (document['scheduledTime']).toDate();
    return myDateTime;
  }

  //Settings color
  Color returnSettingsColor(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    if (currentTheme.brightness == Brightness.dark) {
      return Color.fromARGB(0, 0, 0, 0);
    } else {
      return Color.fromRGBO(254, 218, 191, 1);
    }
  }
}

class Select {
  String id = '';
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}

//Profile pic color
Color returnBettermeBackgroundColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(83, 123, 233, 1);
  }
}

//better me color
Color returnBettermeColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(0, 0, 0, 0);
  } else {
    return Color.fromRGBO(83, 123, 233, 1);
  }
}

//floatingcolor
Color returnFloatingColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return Color.fromARGB(255, 233, 116, 80);
  }
}

//drop down color
Color returnTodoCategoryColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 0, 0, 0);
  } else {
    return Color.fromRGBO(107, 72, 246, 0.75);
  }
}

Color returnStudyCategoryColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 0, 0, 0);
  } else {
    return Color.fromRGBO(245, 119, 185, 0.95);
  }
}

Color returnSportsCategoryColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 0, 0, 0);
  } else {
    return Color.fromRGBO(255, 229, 164, 1);
  }
}

Color returnGroceryCategoryColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 0, 0, 0);
  } else {
    return Color.fromARGB(246, 252, 212, 109);
  }
}

Color returnSportFontColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return Color.fromARGB(255, 0, 0, 0);
  }
}
