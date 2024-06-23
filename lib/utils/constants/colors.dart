import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  static const Color primary = Color(0xFF0D1925);
  static const Color secondary = Color(0xFF6D0CA6);
  static const Color accent = Color(0xFF3B83F4);

  static const Color textWhite = Colors.white;
  static Color white60 = Colors.white.withOpacity(0.6);

  static const Color fadedPrimary = Color(0xFF192438);

  static const Color borderColor = Color.fromRGBO(255, 255, 255, 0.4);

  static const Color presentColor = Color(0xFF60B91F);
  static const Color absentColor = Color(0xFFFF5A5A);

  static Color fadedPresentColor = Color(0xFF60B91F).withOpacity(0.32);
  static Color fadedAbsentColor = Color(0xFFFF5A5A).withOpacity(0.32);
}
