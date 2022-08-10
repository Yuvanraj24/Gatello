
import 'package:flutter/material.dart';

import '../Style/Colors.dart';
import 'container.dart';

Widget flatButton({
  double spreadRadius = 2.0,
  bool shadow = true,
  required Function()? onPressed,
  required Widget child,
  double radius = 5.0,
  bool border = false,
  Color borderColor = const Color(black),
  Color? backgroundColor,
  Color? primary,
  Color? textbuttonBackgroundColor,
  TextStyle? textStyle,
  Size size = const Size(125, 45),
  double? width,
}) {
  return container(
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: TextButton.styleFrom(
          primary: primary,
          backgroundColor: textbuttonBackgroundColor,
          textStyle: textStyle,
          minimumSize: size,
        ),
      ),
      width: width,
      backgroundColor: backgroundColor,
      shadow: shadow,
      spreadRadius: spreadRadius,
      radius: radius,
      border: border,
      borderColor: borderColor);
}
