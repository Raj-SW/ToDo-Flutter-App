// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devstack/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var calenderView = 2;
var events;
var cellWidth;
BoxDecoration selecteddecoration = BoxDecoration(
    color: containerColorYelllowLight,
    borderRadius: BorderRadius.all(Radius.circular(10)));

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  String? _HeaderText = "", _TodayHeader = "", _monthlyHeader = "";
  String h1 = "", h2 = "", h3 = "", h4 = "", h5 = "", h6 = "", h7 = "";
  String d1 = "", d2 = "", d3 = "", d4 = "", d5 = "", d6 = "", d7 = "";

  @override
  void initState() {
    //getDataFromFirestore();
    getDataFromFirestore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  CalendarController controllerCalendar = CalendarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bars,
              //  color: Color(0xff5d5fef),
              color: Colors.white,
            ),
            onPressed: () {
              ZoomDrawer.of(context)!.toggle();
            },
            iconSize: 32,
          ),
        ),
        toolbarHeight: 60,
        //backgroundColor: Colors.white,
        /*

        backgroundColor: Color(0xff5d5fef),
*/
        backgroundColor: returnCalendarColor(context),
        //backgroundColor: Color.fromRGBO(83, 123, 233, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Calendar",
            style: GoogleFonts.pacifico(
                fontWeight: FontWeight.normal,
                fontSize: 40,
                // color: Color(0xff5d5fef),
                color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.caretLeft,
                    //  color: PrimaryColorlight,
                    color: switchPrimary(context),
                  ),
                  onTap: () {
                    controllerCalendar.backward!();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  decoration: BoxDecoration(
                      color: switchHighlight(context),
                      //Color.fromARGB(255, 255, 238, 208),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: [
                      Text(
                        controllerCalendar.view == CalendarView.day
                            ? _TodayHeader!
                            : controllerCalendar.view == CalendarView.week
                                ? _HeaderText!
                                : _monthlyHeader!,
                        style: GoogleFonts.poppins(
                            color: switchHighlightFont(context),
                            // Color.fromARGB(255, 255, 181, 53),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: FaIcon(FontAwesomeIcons.caretRight,
                      color: switchPrimary(context) //PrimaryColorlight
                      ),
                  onTap: () {
                    controllerCalendar.forward!();
                  },
                ),
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    setState(() {
                      controllerCalendar.view = CalendarView.day;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: controllerCalendar.view == CalendarView.day
                            ? switchContainerSelectedHighlight(
                                context) //containerColorYelllowLight
                            : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.today_rounded,
                          size: 25,
                          color: controllerCalendar.view == CalendarView.day
                              ? switchIconColor(context) //colorYellowbold
                              : Colors.black54,
                        ),
                        Text(
                          "Daily",
                          style: controllerCalendar.view == CalendarView.day
                              ? switchTextStyle(context) //styleLittleCalendar
                              : normalStyleLittleCalendar,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controllerCalendar.view = CalendarView.week;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: controllerCalendar.view == CalendarView.week
                            ? switchContainerSelectedHighlight(
                                context) //containerColorYelllowLight
                            : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_view_week_rounded,
                          size: 30,
                          color: controllerCalendar.view == CalendarView.week
                              ? switchIconColor(context) //colorYellowbold
                              : Colors.black54,
                        ),
                        Text(
                          "Weekly",
                          style: controllerCalendar.view == CalendarView.week
                              ? switchTextStyle(context) //styleLittleCalendar
                              : normalStyleLittleCalendar,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controllerCalendar.view = CalendarView.month;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: controllerCalendar.view == CalendarView.month
                            ? switchContainerSelectedHighlight(
                                context) //containerColorYelllowLight
                            : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 30,
                          color: controllerCalendar.view == CalendarView.month
                              ? switchIconColor(context) //colorYellowbold
                              : Colors.black45,
                        ),
                        Text(
                          "Monthly",
                          style: controllerCalendar.view == CalendarView.month
                              ? switchTextStyle(context) //styleLittleCalendar
                              : normalStyleLittleCalendar,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          controllerCalendar.view == CalendarView.week
              ? weekheaderBuilder()
              : controllerCalendar.view == CalendarView.month
                  ? monthlyHeaderBuilder()
                  : Container(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SfCalendar(
              monthCellBuilder: (context, details) =>
                  monthCellBuilder(context, details),
              headerHeight: 0,
              viewHeaderHeight: 0,
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeRulerSize: 50,
                  timeTextStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      // color: Colors.black54,
                      color: textColorAxes(context),
                      fontSize: 11)),
              allowedViews: [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
                CalendarView.schedule
              ],
              onViewChanged: (ViewChangedDetails viewChangedDetails) {
                if (controllerCalendar.view == CalendarView.week) {
                  _HeaderText = DateFormat('MMMM yyyy')
                      .format(viewChangedDetails.visibleDates[
                          viewChangedDetails.visibleDates.length ~/ 2])
                      .toString();
                  h1 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[0])
                      .toString();
                  h2 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[1])
                      .toString();
                  h3 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[2])
                      .toString();
                  h4 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[3])
                      .toString();
                  h5 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[4])
                      .toString();
                  h6 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[5])
                      .toString();
                  h7 = DateFormat('EEE')
                      .format(viewChangedDetails.visibleDates[6])
                      .toString();
                  d1 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[0])
                      .toString();
                  d2 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[1])
                      .toString();
                  d3 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[2])
                      .toString();
                  d4 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[3])
                      .toString();
                  d5 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[4])
                      .toString();
                  d6 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[5])
                      .toString();
                  d7 = DateFormat('dd')
                      .format(viewChangedDetails.visibleDates[6])
                      .toString();
                  SchedulerBinding.instance.addPostFrameCallback((duration) {
                    setState(() {});
                  });
                }
                if (controllerCalendar.view == CalendarView.day) {
                  _TodayHeader = DateFormat.MMMEd()
                      .format(viewChangedDetails.visibleDates.first);
                  SchedulerBinding.instance.addPostFrameCallback((duration) {
                    setState(() {});
                  });
                }
                if (controllerCalendar.view == CalendarView.month) {
                  _monthlyHeader = DateFormat.yMMM().format(
                      viewChangedDetails.visibleDates[
                          viewChangedDetails.visibleDates.length ~/ 2]);
                  SchedulerBinding.instance.addPostFrameCallback((duration) {
                    setState(() {});
                  });
                }
              },
              showCurrentTimeIndicator: true,
              monthViewSettings: MonthViewSettings(
                  agendaStyle: AgendaStyle(
                      //backgroundColor:// Colors.white,
                      appointmentTextStyle: TextStyle(
                    color: Colors.white,
                  )),
                  navigationDirection: MonthNavigationDirection.horizontal,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showAgenda: true,
                  agendaItemHeight: 60,
                  agendaViewHeight: -1),
              showWeekNumber: false,
              showNavigationArrow: true,
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              dataSource: events,
              controller: controllerCalendar,
              appointmentBuilder: (BuildContext context,
                  CalendarAppointmentDetails calendarAppointmentDetails) {
                if (controllerCalendar.view == CalendarView.day) {
                  final Appointment appointment =
                      calendarAppointmentDetails.appointments.first;
                  return Container(
                    padding: EdgeInsets.only(left: 10),
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height,
                    decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "${appointment.subject} at ${DateFormat.jm().format(appointment.startTime)}",
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else if (controllerCalendar.view == CalendarView.week) {
                  final Appointment appointment =
                      calendarAppointmentDetails.appointments.first;
                  return Container(
                    padding: EdgeInsets.only(left: 10),
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height,
                    decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "${appointment.subject} at ${DateFormat.jm().format(appointment.startTime)}",
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else if (controllerCalendar.view == CalendarView.month) {
                  final Appointment appointment =
                      calendarAppointmentDetails.appointments.first;
                  return Container(
                    padding: EdgeInsets.only(left: 10),
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height,
                    decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "${appointment.subject} at ${DateFormat.jm().format(appointment.startTime)}",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else
                  return Container();
              },
            ),
          )),
        ],
      ),
    );
  }

  checkView() {
    if (calenderView == 1) {
      setState(() {});
      return CalendarView.day;
    }
    if (calenderView == 2) {
      setState(() {});
      return CalendarView.week;
    }
    if (calenderView == 3) {
      setState(() {});
      return CalendarView.month;
    }
  }

  Future<void> getDataFromFirestore() async {
    var document = await FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Todo")
        .get();

    List<Appointment> meetings = document.docs
        .map((e) => Appointment(
            startTime: (e["scheduledTime"] as Timestamp).toDate(),
            endTime: (e["scheduledTime"] as Timestamp)
                .toDate()
                .add(Duration(minutes: 30)),
            subject: e["title"],
            color: e["priority"] == "critical"
                ? Color.fromARGB(255, 253, 142, 142)
                : e["priority"] == "normal"
                    ? Color.fromARGB(255, 115, 199, 255)
                    : e["priority"] == "mild"
                        ? Color.fromARGB(255, 255, 204, 116)
                        : e['isDone'] == true
                            ? Color.fromARGB(255, 133, 239, 153)
                            : Color.fromARGB(255, 250, 155, 155)))
        .toList();
    setState(() {
      events = MeetingDataSource(meetings);
    });
  }

  Widget weekheaderBuilder() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 35,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h1, d1) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h1,
                      style: GoogleFonts.poppins(
                          color: checkToday(h1, d1)
                              ? colorYellowbold
                              : Colors.black54,
                          fontWeight: checkToday(h1, d1)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(d1,
                      style: GoogleFonts.poppins(
                          color: checkToday(h1, d1)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h1, d1)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h1, d1)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h2, d2) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h2,
                      style: GoogleFonts.poppins(
                          color: checkToday(h2, d2)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h2, d2)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(d2,
                      style: GoogleFonts.poppins(
                          color: checkToday(h2, d2)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h2, d2)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h2, d2)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h3, d3) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h3,
                      style: GoogleFonts.poppins(
                        color: checkToday(h3, d3)
                            ? colorYellowbold
                            : Colors.black54,
                        fontSize: 12,
                        fontWeight: checkToday(h3, d3)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  Text(d3,
                      style: GoogleFonts.poppins(
                          color: checkToday(h3, d3)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h3, d3)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h3, d3)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h4, d4) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h4,
                      style: GoogleFonts.poppins(
                          color: checkToday(h4, d4)
                              ? switchHighlightFont(context) //colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h4, d4)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(
                    d4,
                    style: GoogleFonts.poppins(
                        color: checkToday(h4, d4)
                            ? switchHighlightFont(context) //colorYellowbold
                            : Colors.black54,
                        fontSize: 12,
                        fontWeight: checkToday(h4, d4)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h4, d4)
                        ? switchHighlightFont(context) //colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h5, d5) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h5,
                      style: GoogleFonts.poppins(
                          color: checkToday(h5, d5)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h5, d5)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(
                    d5,
                    style: GoogleFonts.poppins(
                        color: checkToday(h5, d5)
                            ? colorYellowbold
                            : Colors.black54,
                        fontSize: 12,
                        fontWeight: checkToday(h5, d5)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h5, d5)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h6, d6) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h6,
                      style: GoogleFonts.poppins(
                          color: checkToday(h6, d6)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h6, d6)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(d6,
                      style: GoogleFonts.poppins(
                          color: checkToday(h6, d6)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h6, d6)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h6, d6)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: checkToday(h7, d7) ? selecteddecoration : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(h7,
                      style: GoogleFonts.poppins(
                          color: checkToday(h7, d7)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h7, d7)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Text(d7,
                      style: GoogleFonts.poppins(
                          color: checkToday(h7, d7)
                              ? colorYellowbold
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: checkToday(h7, d7)
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: checkToday(h7, d7)
                        ? colorYellowbold
                        : Colors.transparent,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool checkToday(String h, String d) {
    if (h + d ==
        DateFormat('EEE').format(DateTime.now()).toString() +
            DateFormat('dd').format(DateTime.now()).toString()) {
      return true;
    } else {
      return false;
    }
  }

  monthlyHeaderBuilder() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Sun",
                style: switchTextStyle(context) //calendarLabelMonthlyStyle,
                ),
            Text("Mon",
                style: switchTextStyle(context) //calendarLabelMonthlyStyle,
                ),
            Text("Tue",
                style: switchTextStyle(context) // calendarLabelMonthlyStyle,
                ),
            Text("Wed",
                style: switchTextStyle(context) //calendarLabelMonthlyStyle,
                ),
            Text("Thur",
                style: switchTextStyle(context) //calendarLabelMonthlyStyle,
                ),
            Text("Fri",
                style: switchTextStyle(context) // calendarLabelMonthlyStyle,
                ),
            Text("Sat",
                style: switchTextStyle(context) // calendarLabelMonthlyStyle,
                )
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  monthCellBuilder(BuildContext buildContext, MonthCellDetails details) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.2,
              offset: Offset(1, 1), // Shadow position
            ),
          ],
          color: switchMonthCellBuilderColor(
              context), // Color.fromARGB(255, 209, 228, 255).withOpacity(0.9),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17.5),
              bottomRight: Radius.circular(17.5))),
      child: Center(
          child: Text(
        details.date.day.toString(),
        style: GoogleFonts.poppins(
            color: switchMonthlyCellTextColor(context) //Colors.black45
            ),
      )),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

//Pomodoro color
Color returnCalendarColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 0, 0, 0);
  } else {
    return Color.fromRGBO(83, 123, 233, 1);
  }
}

//Pomodoro color
Color textColorAxes(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Colors.black54;
  }
}

Color switchPrimary(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return PrimaryColorlight;
  }
}

Color switchHighlight(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return containerColorYelllowLight //Color.fromARGB(255, 255, 181, 53)
        ;
  }
}

Color switchHighlightFont(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Color.fromARGB(255, 255, 181, 53);
  }
}

Color switchIconColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return colorYellowbold;
  }
}

TextStyle switchTextStyle(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return GoogleFonts.poppins(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.w400,
        fontSize: 14);
  } else {
    return normalStyleLittleCalendar;
  }
}

Color switchContainerSelectedHighlight(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return containerColorYelllowLight;
  }
}

Color switchMonthCellBuilderColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Colors.white60;
  } else {
    return Color.fromARGB(255, 209, 228, 255).withOpacity(0.9);
  }
}

Color switchMonthlyCellTextColor(BuildContext context) {
  ThemeData currentTheme = Theme.of(context);
  if (currentTheme.brightness == Brightness.dark) {
    return Color.fromARGB(255, 255, 255, 255);
  } else {
    return Colors.black45;
  }
}
