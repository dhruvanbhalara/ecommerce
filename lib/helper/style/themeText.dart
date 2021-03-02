import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeText {
  const ThemeText._();

  static TextStyle get normalText => TextStyle(
        fontSize: 12.sp,
      );

  static TextStyle get mediumText => TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
      );

  static TextStyle get headerText => TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      );
}
