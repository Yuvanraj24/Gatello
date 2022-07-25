import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class ReportCustomDialog extends StatefulWidget {
  @override
  _ReportCustomDialogState createState() => _ReportCustomDialogState();
}

class _ReportCustomDialogState extends State<ReportCustomDialog> {
  var _result;
  bool isSelcted=false;

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog1(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReportCustomDialog();
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
        height: 160.h,
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
                  'Report Angelena',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ],
            ),
//


            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  width:12.5.w,
                ),
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: isChecked,
                      onChanged: (bool? value) {
                        // This is where we update the state when the checkbox is tapped
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  'Block contact and report',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(157, 157, 157, 1))),
                ),
              ],
            ),
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
                    'Report',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
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
