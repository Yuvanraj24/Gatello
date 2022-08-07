

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class Delete1Dialog extends StatelessWidget {
  const Delete1Dialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isChecked=false;
    return AlertDialog(
      insetPadding: EdgeInsets.only(left: 12, right: 12),
        titlePadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              8)), //this right here
      title: Container(
      //  color: Colors.pink,
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 5,right: 12),
      //  padding: EdgeInsets.only(left: 3, top: 3, bottom: 0),
        height: 195.h,
        width: 380.w,
        child: Column(
          children: [
            // SizedBox(height: 6),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Text(
                  'Delete this Ping?',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                          FontWeight.w700,
                          color: Color.fromRGBO(
                              0, 0, 0, 1))),
                ),
              ],
            ),
            SizedBox(height: 30.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: isChecked,
                      onChanged: (bool? value1) {

                        // This is where we update the state when the checkbox is tapped
                        // setState(() {
                        //   isChecked = value!;
                        // });
                      }),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  'Also delete media recevied in this\nchat from the mobile gallery',

                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(157, 157, 157, 1))),
                ),
              ],
            ),
          Spacer(),
          //  SizedBox(height: 30.h),
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
                    'DELETE PINGS',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 38, 38, 1))),
                  ),
                ),
          ],
        ),
        ]
        )
      ),

    );
  }
}
