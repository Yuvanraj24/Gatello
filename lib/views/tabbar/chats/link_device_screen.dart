import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
class LinkedDevices extends StatefulWidget {
  const LinkedDevices({Key? key}) : super(key: key);

  @override
  State<LinkedDevices> createState() => _LinkedDevicesState();
}

class _LinkedDevicesState extends State<LinkedDevices> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(

    appBar: AppBar(

      
    ),

    body: Container(

      padding: EdgeInsets.only(top: 57.h,left: 12.w,right: 12.w),
      child: Column(
        children: [

          Image.asset('assets/linked device image/Group 753.png'),

          SizedBox(height:94.h),
        Text(
                  'Use Gatello on other devices',
            
                         style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: HexColor('#646363'))),
                ),
  SizedBox(height:17.h),
                     ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Link a device',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ),
                  style: ElevatedButton.styleFrom(
                   
                      minimumSize: Size(336.w, 53.h),
                      primary: HexColor('#F8CE61'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
        ],
      ),
    ),
   );
  }
}