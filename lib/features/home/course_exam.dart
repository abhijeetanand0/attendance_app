import 'package:attendance_app/features/home/student_screen.dart';
import 'package:attendance_app/utils/http/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/theme/text_theme.dart';
import '../common/topbar.dart';

class CourseScreen extends StatefulWidget {
  final course;

  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String access = "";
  var exams = [];

  @override
  void initState() {
    super.initState();
    fetchExams();
  }

  void fetchExams() async {
    try {
      Map<String, dynamic> response = await MyHttpHelper.private_get(
          'api/course/${widget.course['id']}/exams', access);
      if (response['result'] == 'success') {
        setState(() {
          exams = response['data'];
        });
      }
      print(exams);
    } on Exception catch (ae) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MyDeviceUtils.getScreenWidth(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        backgroundColor: MyColors.primary,
        title: TopBar(
            title: trim(
                (widget.course['code']) + ": " + (widget.course['title']), 30)),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: 0, left: width * 0.05, right: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
                height: 400,
                child: ListView(
                  children: (exams.isNotEmpty == true)
                      ? exams
                          .map((exam) => buildExamContainer(exam, width))
                          .toList()
                      : [
                          Center(
                            child: Text(
                              'No exams available!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ],
                ))
          ],
        ),
      ),
    );
  }

  Widget buildExamContainer(Map<String, dynamic> exam, double width) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentScreen(course: widget.course, exam: exam),
                ));
          },
          child: Container(
            width: width * 0.9,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 8),
            decoration: BoxDecoration(
                color: MyColors.fadedPrimary,
                border: Border.all(color: MyColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Text(
                  exam['title'],
                  style: MyTextTheme.textTheme.headlineMedium,
                ),
                Spacer(),
                Text(
                  exam['date'],
                  style: TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        )
      ],
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
