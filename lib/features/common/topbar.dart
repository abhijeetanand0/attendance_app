import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // SizedBox(width: 10),
            Text(
              title,
              style: TextStyle().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
        // SizedBox(height: 8),
        // Container(
        //   width: double.infinity,
        //   child: Divider(
        //     height: 0.5,
        //     color: MyColors.borderColor,
        //     thickness: 0.3,
        //   ),
        // )
      ],
    );
  }
}
