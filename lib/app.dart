import 'package:attendance_app/features/authentication/login.dart';
import 'package:attendance_app/features/home/attendance_screen.dart';
import 'package:attendance_app/features/home/course_exam.dart';
import 'package:attendance_app/features/home/homescreen.dart';
import 'package:attendance_app/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IITB Attendance',
      themeMode: ThemeMode.system,
      theme: MyTheme.myTheme,

      darkTheme: MyTheme.myTheme,
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        // '/' : (context) => AttendanceScreen(roll: "22B2098"),
      },


    );
  }
}