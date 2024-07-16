import 'package:attendance_app/features/common/topbar.dart';
import 'package:attendance_app/features/home/attendance_screen.dart';
import 'package:attendance_app/features/home/roll_entry_screen.dart';
import 'package:attendance_app/features/home/toilet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/http/http_client.dart';
import '../../utils/theme/text_theme.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class StudentScreen extends StatefulWidget {
  final course, exam;

  const StudentScreen({super.key, required this.course, required this.exam});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String access = "";
  var students = [];
  int present_count = 0;
  int absent_count = 0;
  int total = 0;
  int idx = 1;

  String scanResult = "";

  @override
  void initState() {
    super.initState();
    idx = 1;
    fetchStudents();
  }

  void fetchStudents() async {
    try {
      // print("api/course/${widget.course['id']}/exam/${widget.exam['id']}/students");
      Map<String, dynamic> response = await MyHttpHelper.private_get(
          'api/course/${widget.course['id']}/exam/${widget.exam['id']}/students',
          access);

      if (response['result'] == 'success') {
        setState(() {
          students = response['data'];
          absent_count = response['absent_count'];
          present_count = response['present_count'];
          total = present_count + absent_count;
        });
      }
      print(students);
    } on Exception catch (ae) {
      return;
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MyDeviceUtils.getScreenWidth(context);
    double height = MyDeviceUtils.getScreenHeight(context);
    idx = 1;

    return Scaffold(
        appBar: AppBar(
            leadingWidth: 40,
            title: TopBar(
                title: trim(
                    (widget.course['code'] + ": " + (widget.exam['title'])),
                    30))),
        body: Padding(
          padding:
              EdgeInsets.only(top: 0, left: width * 0.05, right: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              (total > 0 ? buildBar(width * 0.9) : Container()),
              SizedBox(height: 16),
              Container(
                height: height * 0.67,
                child: ListView(
                  children: (students.isNotEmpty == true)
                      ? students
                          .map((student) =>
                              buildStudentContainer(student, idx++, width))
                          .toList()
                      : [
                          Center(
                            child: Text(
                              'No students available!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ],
                ),
              ),
              Spacer(),
              buildButtons(width),
              Spacer()
            ],
          ),
        ));
  }

  Widget buildStudentContainer(
      Map<String, dynamic> student, int index, double width) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: width * 0.9,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 8),
            decoration: BoxDecoration(
              color: student['present']
                  ? MyColors.fadedPresentColor
                  : MyColors.fadedAbsentColor,
              border: Border.all(
                  color: student['present']
                      ? MyColors.presentColor
                      : MyColors.absentColor,
                  width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(index.toString() + ". ",
                    style: MyTextTheme.textTheme.headlineMedium),
                SizedBox(width: 5),
                Text(
                  student['name'],
                  style: MyTextTheme.textTheme.headlineMedium,
                ),
                Spacer(),
                Text(
                  student['roll'],
                  style: TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget buildBar(double width) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: width * present_count / (total),
              height: 10,
              decoration: BoxDecoration(
                color: MyColors.presentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomLeft: Radius.circular(3)),
              ),
            ),
            Container(
              width: width * absent_count / (total),
              height: 10,
              decoration: BoxDecoration(
                color: MyColors.absentColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              "Marked (${present_count})",
              style: TextStyle().copyWith(
                  fontSize: 14,
                  color: MyColors.presentColor,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              "Unmarked (${absent_count})",
              style: TextStyle().copyWith(
                  fontSize: 14,
                  color: MyColors.absentColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        // SizedBox(height: 10,)
      ],
    );
  }

  Widget buildButtons(double width) {
    return Row(
      children: [
        Spacer(),
        Container(
          height: 60,
          width: width * 0.3,
          decoration: BoxDecoration(
            // color: MyColors.fadedPrimary,
            border: Border.all(color: MyColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RollEntryScreen(
                          exam: widget.exam, course: widget.course),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.fadedPrimary,
                foregroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                'MARK',
                style: TextStyle().copyWith(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.textWhite),
                textAlign: TextAlign.center,
              )),
        ),
        Spacer(),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            // color: MyColors.fadedPrimary,
            border: Border.all(color: MyColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));

              if (res != Null) {
                print(res);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceScreen(
                          roll: res, exam: widget.exam, course: widget.course),
                    ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.fadedPrimary,
              foregroundColor: Colors.white60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            child: Icon(
              IconData(0xe4f7,
                  fontFamily: 'MaterialIcons'),
            ),
          ),
        ),
        Spacer(),
        Container(
          height: 60,
          width: width * 0.3,
          decoration: BoxDecoration(
            // color: MyColors.fadedPrimary,
            border: Border.all(color: MyColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToiletScreen(
                          exam: widget.exam, course: widget.course),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.fadedPrimary,
                foregroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Circular border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                // elevation: 5.0,
              ),
              child: Text(
                'TOILET',
                style: TextStyle().copyWith(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.textWhite),
                textAlign: TextAlign.center,
              )),
        ),
        Spacer()
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
