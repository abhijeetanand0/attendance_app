// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:attendance_app/features/home/student_screen.dart';
import 'package:attendance_app/utils/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constants/colors.dart';
import '../../utils/http/http_client.dart';
import '../common/topbar.dart';

class AttendanceScreen extends StatefulWidget {
  final roll;
  final exam;
  final course;

  const AttendanceScreen(
      {super.key,
      required this.roll,
      required this.exam,
      required this.course});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String access = "";
  var student = {};
  bool found = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    print(widget.roll);
    fetchStudentDetails();
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final resizedImage = await _resizeImage(File(pickedFile.path));

      setState(() {
        _image = resizedImage;
      });
    }
  }

  Future<File> _resizeImage(File pickedFile) async {
    final bytes = await pickedFile.readAsBytes();
    final image = img.decodeImage(bytes);
    final resized =
        img.copyResize(image!, width: 400); // Adjust width as needed
    return File(pickedFile.path)..writeAsBytesSync(img.encodeJpg(resized));
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              MyHttpHelper.mediaURL + student['profile_pic'],
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Text('Failed to load image');
              },
            ),
          ),
          SizedBox(height: 16),
          Text(student['name'] + ' | ' + student['roll'],
              style: MyTextTheme.textTheme.headlineLarge),
          SizedBox(height: 8),
          Text(student['department'] + " | " + student['year'].toString(),
              style: MyTextTheme.textTheme.bodyLarge),
          SizedBox(height: 20),
          ((_image == null)
              ? ElevatedButton(
                  onPressed: _openCamera, child: Text("Add Picture"))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                )),
          SizedBox(height: 16),
          (_image != null)
              ? Row(
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
                                await MyHttpHelper.private_post_multipart(
                                    'api/mark/exam/${widget.exam['id']}/student/${student['id']}',
                                    {},
                                    access,
                                    _image!);

                            if (response['result'] == 'success') {
                              if (response['data'] ==
                                  "Attendance added successfully!") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Attendance marked successfully!")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Already marked!")));
                              }
                              // Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentScreen(
                                        course: widget.course,
                                        exam: widget.exam),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Something went wrong!")));
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
              : (Container())
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
