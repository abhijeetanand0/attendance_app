import 'package:attendance_app/features/home/student_screen.dart';
import 'package:attendance_app/utils/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/http/http_client.dart';
import '../common/topbar.dart';

class AttendanceScreen extends StatefulWidget {
  final roll;
  final exam;
  final course;

  const AttendanceScreen({super.key, required this.roll, required this.exam, required this.course});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String access = "";
  var student = {};
  bool found = false;

  @override
  void initState() {
    super.initState();
    print(widget.roll);
    fetchStudentDetails();
  }

  void fetchStudentDetails() async {
    try {
      Map<String, dynamic> response =
          await MyHttpHelper.private_get('api/student/${widget.roll}', access);
      if (response['result'] == 'success') {
        setState(() {
          student = response['data'];
          found = true;
        });
      }
      print(student);
    } on Exception catch (ae) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!found) {
      return Scaffold(
        appBar: AppBar(
            leadingWidth: 50,
            backgroundColor: MyColors.primary,
            title: TopBar(
              title: "Mark Attendance",
            )),
        body: Container(
          child: Column(children: [SizedBox(height: 100), Text("Loading...")]),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 50,
          backgroundColor: MyColors.primary,
          title: TopBar(
            title: trim("Mark Attendance - " + student['roll'], 20),
          )),
      body: Column(
        children: [
          SizedBox(height: 40),
          Image(
            image: AssetImage("assets/images/profile.png"),
            width: 150,
            height: 150,
          ),
          SizedBox(height: 16),
          Text(student['name'] + ' | ' + student['roll'],
              style: MyTextTheme.textTheme.headlineLarge),
          SizedBox(height: 8),
          Text(student['department'], style: MyTextTheme.textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Batch: " + student['year'].toString(),
              style: MyTextTheme.textTheme.bodyLarge),
          SizedBox(height: 40),
          Row(
            children: [
              Spacer(),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: MyColors.presentColor),
                child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> response =
                          await MyHttpHelper.private_post(
                              'api/mark/exam/${widget.exam['id']}/student/${student['id']}', {},
                              access);

                      if (response['result'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Attendance marked successfully!")));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentScreen(course: widget.course, exam: widget.exam),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Already marked!")));
                      }
                    },
                    child: Image.asset("assets/images/tick.png")),
              ),
              Spacer(),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: MyColors.absentColor),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, AttendanceScreen);
                    },
                    child: Image.asset("assets/images/cross.png")),
              ),

              Spacer()
              // Spacer(),
              // Container(),
              // Spacer()
            ],
          )
        ],
      ),
    );
  }
}

String trim(String input, int length) {
  if (input.isEmpty) {
    return input;
  }
  if (length > input.length) {
    return input;
  } else {
    return input.substring(0, length) + "...";
  }
}
