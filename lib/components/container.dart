import 'package:flutter/material.dart';

import '../Style/Colors.dart';


Widget container(
    {bool shadow = true,
      required Widget child,
      bool border = false,
      Color? backgroundColor,
      Color borderColor = const Color(black),
      double radius = 10.0,
      double spreadRadius = 5.0,
      double blurRadius = 7.0,
      double borderWidth = 1.0,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      AlignmentGeometry? alignment}) {
  return Container(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: (shadow)
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: spreadRadius,
              blurRadius: blurRadius,
              offset: Offset(0, 3),
            ),
          ]
              : null,
          border: (border == false) ? null : Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(radius)));
}
