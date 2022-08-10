
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Style/Colors.dart';
import '../Style/Text.dart';
import '../main.dart';

Future alertDialogBox(
    {required BuildContext context,
      required String title,
      required String subtitle,
      Axis mainAxis = Axis.vertical,
      List<Widget>? widgets,
      Widget? bodyWidget,
      bool bannerDismissible = true}) async {
  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setState(() {});
            return WillPopScope(
                onWillPop: (bannerDismissible == true)
                    ? () async {
                  return true;
                }
                    : () async {
                  return false;
                },
                child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                    title: Text(
                      title,
                      style: GoogleFonts.poppins(textStyle: textStyle(fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        mainAxis: mainAxis,
                        children: <Widget>[
                          (bodyWidget != null) ? bodyWidget : Container(),
                          Text(
                            subtitle,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    actions: widgets));
          },
        );
      });
}
