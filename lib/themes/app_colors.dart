import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color accent = Color(0xffed3237);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff2b2b2b);
  static const Color black2 = Color(0x80181818);
  static const Color black3 = Color(0xff1f1f1f);
  static const Color grey1 = Color(0xffc2c2c2);
  static const Color grey2 = Color(0xffb2b2b2);

  static bool isDark(Color c) {
    var grayscale = (0.299 * c.red) + (0.587 * c.green) + (0.114 * c.blue);
    return grayscale < 128;
  }
}