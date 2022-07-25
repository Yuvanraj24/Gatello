import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class ExitGroupCustomDialog extends StatefulWidget {
  @override
  _ExitGroupCustomDialogState createState() => _ExitGroupCustomDialogState();
}

class _ExitGroupCustomDialogState extends State<ExitGroupCustomDialog> {
  var _result;
  bool isSelcted=false;

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog3(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ExitGroupCustomDialog();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: EdgeInsets.only(left: 12, right: 12),
      titlePadding: EdgeInsets.all(0),
      // title: Text(
      //   'Mute notifications for...',
      //   style: GoogleFonts.inter(
      //       textStyle: TextStyle(
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w700,
      //           color: Color.fromRGBO(0, 0, 0, 1))),
      // ),
      title: Container(
//color: Colors.blue,
        height: 150.h,
        width: 380.w,
        padding: EdgeInsets.only(left: 12, top: 20, bottom: 0,right: 12),
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10.w,),
                Text(
                  'Exit from group?',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ],
            ),
//


            SizedBox(height: 50.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 163, 255, 1))),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Exit group',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 38, 38, 1))),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
