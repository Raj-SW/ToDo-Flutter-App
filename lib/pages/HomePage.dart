// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/SoundSystem.dart';
import 'package:devstack/circle_transition_clipper.dart';
import 'package:devstack/pages/AddToDo.dart';
import 'package:devstack/pages/TodoCard.dart';
import 'package:devstack/zoomDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
  var level = 0;
  int gender = 3;
  String userName = "";
  var completedCount = 0;
  var incompletedCount = 0;
  var totalTasks = 0;
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    strtWk = now.subtract(Duration(days: now.weekday - 1));
    endWk = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    initialiseNameetc();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var _selectedValue;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
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
                  iconSize: 32,
                ),
              ),
              elevation: 8,
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Better.Me",
                  style: GoogleFonts.pacifico(
                    //  color: Color(0xff5d5fef),
                    color: Colors.white,
                    fontSize: 41,
                  ),
                ),
              ),
              toolbarHeight: 70,
              centerTitle: true,
              // backgroundColor: Color.fromARGB(255, 255, 255, 255),
              backgroundColor: Color(0xff5d5fef),
              // Color.fromARGB(255, 102, 133, 218), //Color.fromRGBO(83, 123, 233, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 60, top: 0),
                  child: DropdownButton<String>(
                    icon: FaIcon(FontAwesomeIcons.angleDown),
                    isDense: false,
                    elevation: 3,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
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
                                  fontWeight: FontWeight.w500,
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
                        }
                        return Container(
                          height: 2,
                        );
                      });
                }),
            //Education Container
            Padding(
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
                      color: Color.fromRGBO(245, 119, 185, 0.95),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('5/7 tasks',
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
                      Text('Education',
                          style: GoogleFonts.poppins(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 225, top: 100),
                  child: Transform.rotate(
                    angle: 0.25,
                    child: Lottie.asset(
                      "assets/educationGlobe.json",
                      width: 85,
                      height: 85,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 30),
                  child: Transform.rotate(
                    angle: 0.25,
                    child: Lottie.asset(
                      "assets/BooksLottie.json",
                      width: 175,
                      height: 175,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0, top: 0),
                  child: Lottie.asset(
                    "assets/brain2.json",
                    width: 175,
                    height: 175,
                  ),
                ),
              ]),
            ),
            Padding(
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
                      color: Color.fromRGBO(107, 72, 246, 0.75),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2/12 tasks',
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
                      Expanded(child: SizedBox()),
                      Text('Todos',
                          style: GoogleFonts.poppins(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 15),
                  child: Image.asset(
                    "assets/todos.png",
                    width: 175,
                    height: 175,
                  ),
                ),
              ]),
            ),
            Padding(
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
                      color: Color.fromRGBO(255, 229, 164, 1),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2/12 tasks',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Divider(
                          thickness: 1,
                          height: 2,
                          color: Colors.black54,
                          indent: 1,
                          endIndent: 120,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text('Todos',
                          style: GoogleFonts.poppins(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 15),
                  child: Image.asset(
                    "assets/wishlist2.jpg",
                    width: 175,
                    height: 175,
                  ),
                ),
              ]),
            ),
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

  Future<void> initialiseNameetc() async {
    var mydocument = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("userDetails");
    mydocument.get().then((value) => {
          setState(() {
            gender = value["Gender"];
            userName = value["userName"];
            level = value["Level"];
          })
        });
    final mytaskDoc = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Todo");
    mytaskDoc.get().then((value) {
      value.docs.forEach((element) {
        if (element['isDone'] == false) {
          setState(() {
            incompletedCount++;
          });
        }
        if (element['isDone'] == true) {
          setState(() {
            completedCount++;
          });
        }
      });
    });
  }
}

class Select {
  String id = '';
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
