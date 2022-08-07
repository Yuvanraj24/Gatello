import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle(
    {double fontSize = 14,
      Color? color,
      double letterSpacing = 0,
      TextDecoration textDecoration = TextDecoration.none,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(fontSize: fontSize, color: color, letterSpacing: letterSpacing, decoration: textDecoration, fontStyle: fontStyle, fontWeight: fontWeight);
}

TextSpan textSpan({required String text, required TextStyle textStyle, GestureRecognizer? recognizer}) {
  return TextSpan(text: text, style: textStyle, recognizer: recognizer);
}
