
import 'package:flutter/material.dart';

import '../Style/Colors.dart';
import '../main.dart';

Future scaffoldAlertDialogBox({required BuildContext context, required Widget page, bool bannerDismissible = true}) async {
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
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // shape: RoundedRectangleBorder(
                  //   // borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                  // ),
                  backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                  content: Builder(
                    builder: (context) => Container(height: MediaQuery.of(context).size.height - 100, width: 500, child: page),
                  ),
                ));
          },
        );
      });
}
