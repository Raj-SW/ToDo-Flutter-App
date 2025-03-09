// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:devstack/Service/SoundSystem.dart';
import 'package:devstack/circle_transition_clipper.dart';
import 'package:devstack/pages/AddToDo.dart';
import 'package:devstack/pages/TodoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:devstack/assets.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';

class sportsTodoHomePage extends StatefulWidget {
  const sportsTodoHomePage({Key? key}) : super(key: key);

  @override
  State<sportsTodoHomePage> createState() => _sportsTodoHomePageState();
}

class _sportsTodoHomePageState extends State<sportsTodoHomePage> {
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
  int level = 0;
  int experience = 0;

  static int Coins = 0;
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    strtWk = now.subtract(Duration(days: now.weekday - 1));
    endWk = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    //initialiseNameetc();
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
        experience = firestoreInfo['Experience'];
      });
    });
  }

  List<String> itemList = [
    'Today',
    'This Week',
    'All',
    'Done',
  ];
  String? selectedItem = 'Today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Color.fromRGBO(
            83, 123, 233, 1), //Color.fromARGB(255, 233, 116, 80),
        onPressed: () {
          SoundSystem().playLocal();
          Navigator.of(context).push(_createRoute());
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(35),
                  child: FaIcon(
                    FontAwesomeIcons.angleLeft,
                    size: 28,
                  ),
                ),
              ),
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
                            style: GoogleFonts.poppins(fontSize: 18),
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
              elevation: 8,
              floating: true,
              pinned: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              toolbarHeight: 80,
              centerTitle: true,
              backgroundColor: returnBettermeBackgroundColor(context),
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Sports",
                  style: GoogleFonts.pacifico(
                    //  color: Color(0xff5d5fef),
                    color: Colors.white,
                    fontSize: 36,
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
                Container(
                  margin: const EdgeInsets.only(right: 60, top: 0),
                  child: DropdownButton<String>(
                    icon: FaIcon(FontAwesomeIcons.angleDown),
                    isDense: false,
                    elevation: 3,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    // iconEnabledColor: Color.fromRGBO(83, 123, 233, 1),
                    iconEnabledColor: returnDropDownColor(context),
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
                                  // color: Color.fromRGBO(83, 123, 233, 1)
                                  color: returnDropDownColor(context)),
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
                        String category = document["category"];
                        if (selectedItem == "Today" && category == "sports") {
                          if (time.day == DateTime.now().day &&
                              isDone == false) {
                            todayCount++;
                            return TodoCard(
                              priority: priority,
                              coins: Coins,
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
                        } else if (selectedItem == "This Week" &&
                            category == "sports") {
                          if (time.day >= strtWk.day &&
                              time.day <= endWk.day &&
                              isDone == false) {
                            return TodoCard(
                              priority: priority,
                              coins: Coins,
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
                        } else if (selectedItem == "All" &&
                            isDone == false &&
                            category == "sports") {
                          return TodoCard(
                            priority: priority,
                            coins: Coins,
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
                        } else if (selectedItem == "Done" &&
                            category == "sports") {
                          if (isDone == true) {
                            return TodoCard(
                              priority: priority,
                              coins: Coins,
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
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddToDoPage(category: 'sports'),
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

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AddToDoPage(
            category: 'sports',
          ));

  /*Future<void> initialiseNameetc() async {
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
            Coins = value['coins'];
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
  }*/
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
Color returnDropDownColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return Color.fromRGBO(83, 123, 233, 1);
  }
}
