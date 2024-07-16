import 'package:attendance_app/features/common/topbar.dart';
import 'package:attendance_app/utils/constants/colors.dart';
import 'package:attendance_app/utils/http/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../utils/device/device_utility.dart';
import '../../utils/theme/text_theme.dart';

class ToiletScreen extends StatefulWidget {
  final exam, course;

  const ToiletScreen({super.key, required this.exam, required this.course});

  @override
  State<ToiletScreen> createState() => _ToiletScreenState();
}

class _ToiletScreenState extends State<ToiletScreen> {
  String access = "";
  Map<String, dynamic> toiletData = {"count": 0};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Map<String, dynamic> response = await MyHttpHelper.private_get(
          'api/toilet/exam/${widget.exam['id']}', access);
      if (response['result'] == 'success') {
        setState(() {
          toiletData = response['data'];
        });
      }
      print("PRINTING TOILET DATA");
      print(toiletData);
    } on Exception catch (ae) {
      return;
    }
  }

  void sendToilet(String roll) async {
    try {
      Map<String, dynamic> response = await MyHttpHelper.private_get(
          'api/toilet/create/exam/${widget.exam['id']}/student/${roll}',
          access);

      if (response['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Student added successfully!")));
        fetchData();
      }
    } on Exception catch (ae) {
      return;
    }
  }

  void clearToilet() async {
    try {
      Map<String, dynamic> response = await MyHttpHelper.private_get(
          'api/toilet/clear/exam/${widget.exam['id']}', access);

      if (response['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Record removed successfully!")));
        fetchData();
      }
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
          title: TopBar(title: "Restroom")),
      body: Padding(
        padding:
            EdgeInsets.only(top: 20, left: width * 0.05, right: width * 0.05),
        child: (toiletData['count'] == 0)
            ? Column(
              children: [
                Text(
                  "Currently empty.",
                  style: TextStyle().copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8)),
                ),
                SizedBox(height: 8,),
                Text(
                  "You may create new entry.",
                  style: TextStyle().copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8)),
                ),
                SizedBox(height: 16,),

                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ));
                        if (res != Null) {
                          print(res);
                          sendToilet(res);
                        }
                      },
                      child: Text("Add Entry"),
                    ),
                    Spacer()
                  ],
                ),
              ],
            )
            : (Container(
                child: Column(children: [
                  Column(
                    children: [
                      Text(
                        "Occupied by",
                        style: TextStyle().copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  buildExamContainer(toiletData['student'], width, '02:37 PM'),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            clearToilet();
                          },
                          child: Text("Clear")),
                      Spacer()
                    ],
                  ),
                ]),
              )),
      ),
    );
  }

  Widget buildExamContainer(Map<String, dynamic> student, double width, String time) {
    return Column(
      children: [
        Container(
          width: width * 0.9,
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 8),
          decoration: BoxDecoration(
              color: MyColors.fadedPrimary,
              border: Border.all(color: MyColors.borderColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Text(
                student['name'],
                style: MyTextTheme.textTheme.headlineMedium,
              ),
              Spacer(),
              Text(
                time,
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
        SizedBox(
          height: 12,
        )
      ],
    );
  }



}
