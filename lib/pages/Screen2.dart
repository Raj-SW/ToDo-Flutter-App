// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, implementation_imports, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  static Color myColor = Color.fromRGBO(83, 123, 233, 1);
  static TextStyle style = TextStyle(
    color: Color.fromRGBO(83, 123, 233, 1),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  BorderRadius customBorder = BorderRadius.only(
      topLeft: Radius.circular(10), topRight: Radius.circular(10));
  double Bwidth = 20;
  double calories = 0.0;

  static double monday = 0;
  static double tuesday = 0;
  static double wednesday = 0;
  static double thursday = 0;
  static double friday = 0;
  static double saturday = 0;
  static double sunday = 0;
  static double goalCalorie = 0;
  static double userWeight = 0;
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _userWeightController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCalValues();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calorieController.dispose();
    _userWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 30),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                height: 350,
                width: 300,
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 0,
                  child: BarChart(
                      swapAnimationDuration:
                          Duration(milliseconds: 800), // Optional
                      swapAnimationCurve: Curves.easeInOut,
                      BarChartData(
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, getTitlesWidget: getTitles),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 30,
                                interval: 5,
                                showTitles: true,
                                getTitlesWidget: getleftTitles,
                              ),
                              axisNameWidget: Text(
                                "Calories",
                                style: style,
                              ),
                            ),
                          ),
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 20,
                          minY: 0,
                          gridData: FlGridData(show: false),
                          barTouchData: BarTouchData(enabled: true),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                  toY: monday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder),
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                  toY: tuesday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                  toY: wednesday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(
                                  toY: thursday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(
                                  toY: friday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                            BarChartGroupData(x: 5, barRods: [
                              BarChartRodData(
                                  toY: saturday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                            BarChartGroupData(x: 6, barRods: [
                              BarChartRodData(
                                  toY: sunday,
                                  color: myColor,
                                  width: Bwidth,
                                  borderRadius: customBorder)
                            ]),
                          ])),
                ))
          ])),
    );
  }

  Future<void> setCalValues() async {
    var document = FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("runStats")
        .doc("runStats");
    document.get().then((value) => {
          if (value.exists)
            {
              print(" document exists"),
              setState(() {
                monday = (value["mondayCal"]).toDouble();
                tuesday = (value["tuesdayCal"]).toDouble();
                wednesday = (value["wednesdayCal"]).toDouble();
                thursday = (value["thursdayCal"]).toDouble();
                friday = (value["fridayCal"]).toDouble();
                saturday = (value["saturdayCal"]).toDouble();
                sunday = (value["sundayCal"]).toDouble();
                goalCalorie = (value["goalCalorie"]).toDouble();
                userWeight = (value["userWeight"]).toDouble();
              }),
              print(monday),
              if (goalCalorie == 0 || userWeight == 0)
                {
                  openDialog(),
                }
            }
          else
            {print("No data loaded for stats")}
        });
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("We lack few details about you!"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    try {
                      if (_calorieController.toString().isNotEmpty &&
                          _userWeightController.toString().isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection("collect2")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("runStats")
                            .doc("runStats")
                            .update({
                          "userWeight":
                              double.parse(_userWeightController.text),
                          "goalCalorie": double.parse(_calorieController.text)
                        });
                        setState(() {
                          userWeight = double.parse(_userWeightController.text);
                          goalCalorie = double.parse(_calorieController.text);
                        });

                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Fill all fields", gravity: ToastGravity.TOP);
                      print(e);
                    }
                  },
                  child: Text("Submit"))
            ],
            content: Container(
                height: 190,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("How much Calories you want to lose in cardio?"),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _calorieController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Calorie deficit goals",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(121, 0, 0, 0),
                              fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("What is your weight(in kg)?"),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _userWeightController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Your weight in Kg",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(121, 0, 0, 0),
                              fontSize: 17),
                        ),
                      ),
                    ])),
          ));
}

class Data {
  final int id;
  final String name;
  final double y;
  final Color color;
  const Data({
    required this.id,
    required this.name,
    required this.y,
    required this.color,
  });
}

Widget getTitles(double value, TitleMeta meta) {
  Color myColor = Color.fromRGBO(83, 123, 233, 1);
  TextStyle style = TextStyle(
    color: myColor,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mon';
      break;
    case 1:
      text = 'Tue';
      break;
    case 2:
      text = 'Wed';
      break;
    case 3:
      text = 'Thur';
      break;
    case 4:
      text = 'Fri';
      break;
    case 5:
      text = 'Sat';
      break;
    case 6:
      text = 'Sun';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4.0,
    child: Text(text, style: style),
  );
}

Widget getleftTitles(double value, TitleMeta meta) {
  Color myColor = Color.fromRGBO(83, 123, 233, 1);
  TextStyle style = TextStyle(
    color: myColor,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return SideTitleWidget(
      angle: -45,
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(
        value.toStringAsFixed(0),
        style: style,
      ));
}
