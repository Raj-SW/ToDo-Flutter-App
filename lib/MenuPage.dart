// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/menuItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItems {
  static const homePage = MenuItema('To-Dos', Icons.add_task_rounded);
  static const calendar = MenuItema('Calendar', Icons.calendar_month);
  static const pomodoro = MenuItema('Pomodoro', Icons.alarm);
  static const Settings = MenuItema('Settings', Icons.settings);
  static const all = <MenuItema>[homePage, calendar, pomodoro, Settings];
}

class MenuPage extends StatefulWidget {
  final MenuItema currentItem;
  final ValueChanged<MenuItema> onSelectedItem;
  const MenuPage({
    Key? key,
    required this.currentItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

int gender = 0;
String userName = "";
int level = 0;

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    initialiseNameetc();
  }

  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: drawerBackground(context),
      //  Color.fromARGB(255, 133, 135, 237), // Colors.deepPurple.shade300,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          CircleAvatar(
            foregroundImage: gender == 1
                ? AssetImage("assets/profileMen.png")
                : AssetImage("assets/profileWomen.png"),
            radius: 35,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$userName",
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          Text(
            "Lv. $level",
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          SizedBox(
            height: 50,
          ),
          ...MenuItems.all.map(buildMenuItem).toList(),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
        ],
      )),
    );
  }

  Widget buildMenuItem(MenuItema item) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 2,
                      color: Colors.white60,
                      style: BorderStyle.solid))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTileTheme(
                selectedColor: Colors.deepPurple,
                textColor: Colors.white,
                child: ListTile(
                  minLeadingWidth: 20,
                  selected: widget.currentItem == item,
                  selectedTileColor: Colors.white70,

                  //leading: Icon(item.icon),
                  title: Text(
                    item.title,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  onTap: () => widget.onSelectedItem(item),
                ),
              ),
            ],
          ),
        ),
      );
  Widget buildMenuItem2(MenuItema item) => SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: selected == true ? Colors.amber : Colors.black),
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = true;
                    });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(item.icon),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.title),
                      )
                    ],
                  ),
                ),
              ),
            ]),
      );

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
  }
}

//drawer background
Color drawerBackground(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return Color.fromARGB(255, 133, 135, 237);
  }
}
