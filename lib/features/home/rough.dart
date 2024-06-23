// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../utils/constants/colors.dart';
// import '../../utils/device/device_utility.dart';
// import '../../utils/theme/text_theme.dart';
// import '../common/topbar.dart';
//
// class CourseScreen extends StatelessWidget {
//   final course;
//
//   const CourseScreen({super.key, required this.course});
//
//   @override
//   Widget build(BuildContext context) {
//
//     double width = MyDeviceUtils.getScreenWidth(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColors.primary,
//         title: TopBar(
//             title: (course['code'] ?? "") + ": " + (course['title'] ?? "")),
//       ),
//       body: Padding(
//         padding: EdgeInsets.only(top: 0, left: width * 0.05),
//         child: Column(
//           children: [
//             SizedBox(height: 8),
//
//             // SizedBox(height: 12),
//
//             ...exams.map((exam) => Column(
//               children: [
//                 GestureDetector(
//                   child: Container(
//                     width: width * 0.9,
//                     padding: EdgeInsets.only(
//                         top: 12, bottom: 12, left: 16, right: 8),
//                     decoration: BoxDecoration(
//                         color: MyColors.fadedPrimary,
//                         border: Border.all(
//                             color: MyColors.borderColor, width: 1),
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Row(
//                       children: [
//                         Text(
//                           exam['title'] ?? "Loading...",
//                           style: MyTextTheme.textTheme.headlineMedium,
//                         ),
//                         Spacer(),
//                         Text(
//                           exam['date'] ?? "Loading...",
//                           style: TextStyle().copyWith(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w300),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 )
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
