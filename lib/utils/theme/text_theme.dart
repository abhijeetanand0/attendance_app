import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Custom Class for textWhite & Dark Text Themes
class MyTextTheme {
  MyTextTheme._(); // To avoid creating instances

  /// Customizable Dark Text Theme
  static TextTheme textTheme = TextTheme(

    // SECTION HEADER
    headlineLarge: const TextStyle().copyWith(
      fontSize: 17.0,
      fontWeight: FontWeight.w600,
      color: MyColors.textWhite,
    ), // SECTION HEADER

    headlineMedium: const TextStyle().copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: MyColors.textWhite),

    bodySmall: const TextStyle().copyWith(
        fontSize: 13.0, fontWeight: FontWeight.w400, color: MyColors.textWhite),

    bodyMedium: const TextStyle().copyWith(
      fontSize: 15.0, fontWeight: FontWeight.w500, color: MyColors.textWhite
    ),

    bodyLarge: const TextStyle().copyWith(
        fontSize: 17.0, fontWeight: FontWeight.w400, color: MyColors.textWhite
    ),


  );
}
