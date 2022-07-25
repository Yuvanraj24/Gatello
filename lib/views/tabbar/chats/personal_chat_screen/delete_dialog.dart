import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(left: 12, right: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              8)), //this right here
    title: Container(
      padding: EdgeInsets.only(left: 3, top: 3, bottom: 0),
        height: 193.h,
      width: 380.w,
        child: Column(
          children: [
           // SizedBox(height: 6),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Text(
                  'Delete message?',
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
            SizedBox(height: 12.h,),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(

                  ),
                  onPressed: () {},
                  child: Text(
                    'DELETE FOR ME',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                            FontWeight.w400,
                            color: Color.fromRGBO(
                                255, 0, 0, 1))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'DELETE FOR EVERYNONE',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                            FontWeight.w400,
                            color: Color.fromRGBO(
                                255, 0, 0, 1))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                            FontWeight.w400,
                            color: Color.fromRGBO(
                                0, 0, 0, 1))),
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
