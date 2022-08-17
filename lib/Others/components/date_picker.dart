
import 'package:flutter/material.dart';

Future<DateTime?> datePicker({
  required BuildContext context,
  required DateTime selectedDate,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: selectedDate,
    currentDate: DateTime.now(),
    firstDate: startDate,
    lastDate: endDate,

    builder: (context, child) {
      return child!;
      // return Theme(
      //   data: ThemeData.dark().copyWith(
      //     colorScheme: ColorScheme.dark(primary: Color(red)),
      //     buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //   ),
      //   child: child!,
      // );
    },
  );
}
