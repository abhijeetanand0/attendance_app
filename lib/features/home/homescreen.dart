import 'package:attendance_app/features/common/topbar.dart';
import 'package:attendance_app/features/home/course_exam.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/http/http_client.dart';
import '../../utils/theme/text_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String access = "";
  var courses = [];
  // late List<CameraDescription> cameras;
  // late CameraController controller;


  @override
  void initState() {
    super.initState();
    fetchCourses();
    // initializeCamera();
  }

  void fetchCourses() async {
    print("SEDNING REQUEST ________");
    try {
      Map<String, dynamic> response =
          await MyHttpHelper.private_get('api/get_courses/', access);
      if (response['result'] == 'success') {
        setState(() {
          courses = response['data'];
        });
        print(courses);
      }
    } on Exception catch (ae) {
      return;
    }
  }


  // Future<void> initializeCamera() async {
  //   // Fetch the available cameras
  //   cameras = await availableCameras();
  //   // Select the first available camera
  //   controller = CameraController(cameras[0], ResolutionPreset.high);
  //   await controller.initialize();
  //   setState(() {});
  // }


  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MyDeviceUtils.getScreenWidth(context);

    double offsetHeight = 60;

    // if (!controller.value.isInitialized) {
    //   return Text("Camera de!");
    // }




    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: MyColors.primary,
        title: TopBar(title: 'Course List'),
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
                children: (courses.isNotEmpty == true)
                    ? courses
                        .map((course) => buildCourseContainer(course, width))
                        .toList()
                    : [
                        Center(
                          child: Text(
                            'No courses available.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCourseContainer(Map<String, dynamic> course, double width) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseScreen(course: course),
                ));
          },
          child: Container(
            width: width * 0.9,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
                color: MyColors.fadedPrimary,
                border: Border.all(color: MyColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      course['code'],
                      style: MyTextTheme.textTheme.headlineLarge,
                    ),
                    Spacer(),
                    Text(
                      capitalize(course['semester'] +
                          " | " +
                          course['year'].toString()),
                      style: MyTextTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  course['title'],
                  style: MyTextTheme.textTheme.bodyMedium,
                ),
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

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}
