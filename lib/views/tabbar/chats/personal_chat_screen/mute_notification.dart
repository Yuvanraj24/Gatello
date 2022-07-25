import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var _result;
  bool isSelcted=false;

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog();
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
        height: 270.h,
        width: 380.w,
        padding: EdgeInsets.only(left: 12, top: 20, bottom: 0),
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
                  'Mute notifications for...',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ],
            ),
//
            SizedBox(
              height: 38.h,
              child: RadioListTile(


                  title: Text(
                    '1 Hour',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(157, 157, 157, 1))),
                  ),
                  value: 1,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),
            ),
            SizedBox(
              height: 38.h,
              child: RadioListTile(

                  title: Text(
                    '1 Week',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: isSelcted==true ?Color.fromRGBO(157, 157, 157, 1) : Color.fromRGBO(157, 157, 157, 1))),
                  ),
                  value: 2,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),
            ),
            SizedBox(
              height: 38.h,
              child: RadioListTile(
                  title: Text(
                    'Always',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(157, 157, 157, 1))),
                  ),
                  value: 3,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),
            ),

            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  width:12.5.w,
                ),
                Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    value: isChecked,
                    onChanged: (bool? value) {
                      // This is where we update the state when the checkbox is tapped
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Show notification ',
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 163, 255, 1))),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'OK',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
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
