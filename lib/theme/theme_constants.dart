//File containing data pertaining to light and dark theme
import 'package:flutter/material.dart';


const primary = Colors.amber;
//Light theme
ThemeData lightTheme = ThemeData(

    brightness: Brightness.light,
    //primarySwatch: primary,
  elevatedButtonTheme:  ElevatedButtonThemeData(
   style:ButtonStyle(
     backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(83, 123, 233, 1)),
   )
  ),
    textTheme: const TextTheme(
     headlineMedium: TextStyle(color:Colors.black),
),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.amber,
      selectedItemColor: Colors.white,

    )
);

//Dark theme
ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,

    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      thumbColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    elevatedButtonTheme:  ElevatedButtonThemeData(
        style:ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        )
    ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(

    selectedItemColor: Colors.white,
  )
);