
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BirthdayGatello extends StatefulWidget {
  const BirthdayGatello({Key? key}) : super(key: key);
  @override
  State<BirthdayGatello> createState() => _BirthdayGatelloState();
}

class _BirthdayGatelloState extends State<BirthdayGatello> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      
      child: Scaffold(
        
        appBar: AppBar(       
        leading: Center(
              child: 
             TextButton(onPressed: (){
                Navigator.pop(context);
             }, child: Text('Back',
           
             style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                           fontWeight: FontWeight.w600,
                              color:Colors.black)),
                ),
               )
            ),
          ),
        body: Container(
          padding: EdgeInsets.only(top: 55.h,  left: 13.w, right: 13.w),
          child: Column(children: [
            Center(
              child:SvgPicture.asset('assets/birthday_image/birthday_icon.svg'),
            ),
            SizedBox(height:21.h),
            Text(
                  "Birthdays on Galetto",
               
                       style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                              fontSize: 28.sp,
                         fontWeight: FontWeight.w500,
                              color:Colors.black)),
                ),
            SizedBox(height: 25.h),
      
             Text(
                      "Providing your date of birth improves the feature",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize:currentHeight*0.017 ,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#494949'))),
                    ),
        SizedBox(height:5.h),
             Text(
                      "you see and helps us keep the Gatello community",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize:currentHeight*0.017 ,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#494949'))),
                    ),
            SizedBox(height:5.h),
             Text(
                      "safe. You can find your date of birth under",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                           fontSize:currentHeight*0.017 ,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#494949'))),
                    ),
            SizedBox(height:5.h),
             Text(
                      "“Personalinformation” in your account settings.",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize:currentHeight*0.017 ,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#494949'))),
                    ),
          
      
            Spacer(),
      
          ]),
        ),
      ),
    );
  }
}
