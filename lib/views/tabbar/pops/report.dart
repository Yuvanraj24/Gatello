import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/tabbar/pops/secondreport.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Report_Page extends StatefulWidget {
  const Report_Page({Key? key}) : super(key: key);

  @override
  State<Report_Page> createState() => _Report_PageState();
}

class _Report_PageState extends State<Report_Page> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ResponsiveBuilder(
        builder: (context,sizingInformation) {
          return Scaffold(
            body: ConstrainedBox(
              constraints:  BoxConstraints(
            maxWidth: (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
                ? MediaQuery.of(context).size.width / 2.5 : double.infinity),
              child: Container(
                padding: EdgeInsets.only(left: 12.w,top:16.h),
                color: Colors.white,
                child: Column(
                  children: [
                    Divider(
                      endIndent: 164,
                      indent: 164,
                      thickness: 2,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    Text(
                      'Report',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              decoration: TextDecoration.none,
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp)),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Why are you reporting this post?',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize:16.sp)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text(
                          "Unless youre reporting an incident of intellectual\nproperty infringement, your report will be kept\nconfidential and the account that you reported won't\nsee who reported them. Please bear in mind that\nreporting something to Gatello doesn't guarantee\nthat it will be removed.",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(134, 134, 134, 1),
                                  fontSize:13.sp,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 53),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text( 'It’s spam', style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp)),),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Nudity or sexual acitivity',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'I just don’t like it',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Hate speech or symbols',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Violence or dangerous organisations',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Bulying or harassment',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'False information',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Scam or fraud',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Suicide or self-injury',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Sale of illegal or regulated goods ',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Intellectual property violation',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Second_Report()));
                          },
                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Something else',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
