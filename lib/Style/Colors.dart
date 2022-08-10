import 'package:flutter/material.dart';
// const int name = 0xFF;

const int materialBlack = 0xFF0D0D0D;
const int lightBlack = 0xFF1A1A1A;
const int white = 0xFFFFFFFF;
const int black = 0xFF000000;
const int grey = 0xFF828282;
const int lightGrey = 0xFFF5F5F5;
const int dividerGrey = 0xFFCCCCCC;
const int googleRed = 0xFFDF4930;
const int facebookBlue = 0xFF507CC0;
const int accent = 0xFFFFCA28;
const int transparent = 0x00000000;
const int red = 0xFFEB5757;
const int likeRed = 0xFFEC4133;
const int commentBlue = 0xFF4497C6;
const int green = 0xFF57EB5D;
const int linkBlue = 0xFF106E99;
const int yellow = 0xFFF7A102;

//palette.dart
class Palette {
  static const MaterialColor dark = const MaterialColor(
    0xFF000000,
    const <int, Color>{
      50: const Color(0xFF000000), //10%
      100: const Color(0xFF000000), //20%
      200: const Color(0xFF000000), //30%
      300: const Color(0xFF000000), //40%
      400: const Color(0xFF000000), //50%
      500: const Color(0xFF000000), //60%
      600: const Color(0xFF000000), //70%
      700: const Color(0xFF000000), //80%
      800: const Color(0xFF000000), //90%
      900: const Color(0xFF000000), //100%
    },
  );
  static const MaterialColor light = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );
}
