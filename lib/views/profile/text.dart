import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Texts extends StatefulWidget {
  const Texts({Key? key}) : super(key: key);

  @override
  State<Texts> createState() => _TextsState();
}

class _TextsState extends State<Texts> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right:30,left: 30),
          color: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Material(color: Colors.transparent,
          child: Text('Your professional bio is an important piece of\n personal branding real estate that can help you\n catch the interest of a recruiter, earn a speaking\n gig, land a guest blogging opportunity, gain \nadmission to a program, or prompt other \ncareer wins.',style: GoogleFonts.inter(
            textStyle: TextStyle(fontSize:14.sp,fontWeight: FontWeight.w400,color:
            Color.fromRGBO(0, 0, 0, 0.5))
          ),),
        ),
            SizedBox(height:30.h),
            Material(color: Colors.transparent,
              child: Text('Info',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
            ),
              SizedBox(height:13.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                    child: Icon(Icons.person,
                        color: Colors.white, size: 35),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'Gender : ',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(165, 165, 165, 0.9))),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'Male',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:9.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    child: Icon(Icons.card_giftcard,color: Colors.white,size:35),
                    // SvgPicture.asset('assets/profile_assets/born on.svg'),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'Born on ',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(165, 165, 165, 0.9))),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'December 6th 2000',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:9.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    child: Icon(Icons.language_sharp,color: Colors.white,size:35),
                    // SvgPicture.asset('assets/profile_assets/born on.svg'),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'I Speak',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(165, 165, 165, 0.9))),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'English, Tamil',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:9.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    child: Icon(Icons.call_outlined,color: Colors.white,size:35),
                    // SvgPicture.asset('assets/profile_assets/call_outline.svg'),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      '+91 9874653631',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:9.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    child: Icon(Icons.mail_outline,color: Colors.white,size: 40,),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'Deejos123@gmail.com',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:17.h),
              Material(color: Colors.transparent,
                child: Text('Website',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                    fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              ),
              SizedBox(height:13.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    child: Icon(Icons.link,color: Colors.white,size: 40,),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Text(
                      'http://deejos.in/',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                ],
              ),
              SizedBox(height:13.h),
              Material(color: Colors.transparent,
                child: Text('Work Experience',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                    fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              ),
              SizedBox(height:12.h),
              Row(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UI UX designer - Tech 4 Lyf',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),
                        Text(
                          'May 2022 - Present',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(185, 185, 185, 1))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height:21.h),
              Row(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marketing Executive',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),
                        Text(
                          'May 2021 - june 2021',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(185, 185, 185, 1))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 19.h),
              Material(color: Colors.transparent,
                child: Text('Skills',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                    fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              ),
              SizedBox(height: 19.h),
              Row(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child:
                        Text(
                          'Marketing Strategy',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),


                    ),

                ],
              ),
              SizedBox(height: 21.h),
              Row(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(165, 165, 165, 0.9),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 11.w),
                  Material(color: Colors.transparent,
                    child:
                    Text(
                      'Marketing Strategy',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),


                  ),

                ],
              ),
          ],),
        ),
      ),
    );
  }
}
