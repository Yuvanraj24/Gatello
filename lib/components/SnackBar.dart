
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Style/Text.dart';

SnackBar snackbar({
  required String content,
  SnackBarBehavior snackBarBehaviour = SnackBarBehavior.floating,
  Duration duration = const Duration(seconds: 5),
  Color borderColor = const Color(0xFF000000),
  Color? backgroundColor,
  Color? textColor,
}) {
  return SnackBar(
    duration: duration,
    content: Text(
      (content.isNotEmpty && content.trim() != "") ? content : "Something went wrong!",
      style: GoogleFonts.poppins(textStyle: textStyle(color: textColor)),
    ),
    shape: RoundedRectangleBorder(side: BorderSide(color: borderColor)),
    backgroundColor: backgroundColor,
  );
}
