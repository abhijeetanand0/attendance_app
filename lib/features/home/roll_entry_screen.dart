import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../common/topbar.dart';
import 'attendance_screen.dart';

class RollEntryScreen extends StatefulWidget {
  final course, exam;

  const RollEntryScreen({super.key, required this.course, required this.exam});

  @override
  State<RollEntryScreen> createState() => _RollEntryScreenState();
}

class _RollEntryScreenState extends State<RollEntryScreen> {

  final TextEditingController _rollEditingController = TextEditingController();
  bool _sendingRequest = false;

  @override
  Widget build(BuildContext context) {

    double width = MyDeviceUtils.getScreenWidth(context);

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          backgroundColor: MyColors.primary,
          title: TopBar(title: "Add Entry"),
        ),
        body: Padding(
          padding:
              EdgeInsets.only(top: 0, left: width * 0.05, right: width * 0.05),
          child: Column(
            children: [
              // Spacer(),
              SizedBox(height: 24),
              Container(
                height: 45,
                width: width * 0.90,
                child: TextField(
                  controller: _rollEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MyColors.textWhite),
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0.0),
                    filled: true,
                    fillColor: MyColors.fadedPrimary,
                    hintText: "Enter roll number",
                    hintStyle: TextStyle().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      // Border radius
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(1),
                        width: 0.7,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 40,
                width: width * 0.90,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceScreen(
                                roll: _rollEditingController.text,
                                exam: widget.exam,
                                course: widget.course),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.textWhite,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0),
                      ),
                      elevation: 5.0,
                    ),
                    child:
                        Text(
                      'Continue',
                      style: TextStyle().copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.primary),
                      textAlign: TextAlign.center,
                    )),
              )


            ],
          ),
        ),

    );
  }
}
