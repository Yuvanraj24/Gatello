
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Style/Colors.dart';
import '../main.dart';

Future simpleDialogBox({required BuildContext context, required List<SimpleDialogOption> widgetList}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
        title: Text("Choose an Option"),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: IntrinsicWidth(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return widgetList[index];
                  // return SimpleDialogOption(
                  //   onPressed: () {

                  //     Navigator.pop(context);
                  //   },
                  //   child: Center(
                  //     child: Text(
                  //       values[index],
                  //       textAlign: TextAlign.left,
                  //       style:
                  //           GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                  //       softWrap: true,
                  //     ),
                  //   ),
                  // );
                },
                itemCount: widgetList.length,
              ),
            ),
          )
        ],
      );
    },
  );
}
