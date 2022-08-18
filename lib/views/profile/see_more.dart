import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/profile/info.dart';
import 'package:gatello/views/profile/link.dart';
import 'package:gatello/views/profile/photo_pop.dart';
import 'package:gatello/views/profile/skill.dart';
import 'package:gatello/views/profile/workexperience.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';

import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';

class SeeMoreText extends StatefulWidget {
  final VoidCallback? onPressed;
  String phone;
  String email;

   SeeMoreText({Key? key,required this.onPressed,required this.phone,required this.email}) : super(key: key);

  @override
  State<SeeMoreText> createState() => _TextsuState();
}

class _TextsuState extends State<SeeMoreText> {
  int i=0;
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(right:30,left: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    Text('Your professional bio is an important piece of',style: GoogleFonts.inter(
      textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
      Color.fromRGBO(0, 0, 0, 0.5))
    ),),
      SizedBox(height:5.h),
      Text('personal branding real estate that can help you',style: GoogleFonts.inter(
          textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
          Color.fromRGBO(0, 0, 0, 0.5))
      ),), SizedBox(height:5.h),
      Text('catch the interest of a recruiter, earn a speaking',style: GoogleFonts.inter(
          textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
          Color.fromRGBO(0, 0, 0, 0.5))
      ),), SizedBox(height:5.h),
      Text('gig, land a guest blogging opportunity, gain',style: GoogleFonts.inter(
          textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
          Color.fromRGBO(0, 0, 0, 0.5))
      ),), SizedBox(height:5.h),
      Text('admission to a program, or prompt other',style: GoogleFonts.inter(
          textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
          Color.fromRGBO(0, 0, 0, 0.5))
      ),), SizedBox(height:5.h),
      Text('career wins.',style: GoogleFonts.inter(
          textStyle: TextStyle(fontSize:13.5.sp,fontWeight: FontWeight.w400,color:
          Color.fromRGBO(0, 0, 0, 0.5))
      ),),
        SizedBox(height:30.h),

          Row(
            children: [
              Text('Info',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              SizedBox(width:10.w),
              GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Info_Page(uid: '',),));
                  },
                  child:  Container(height:20,width:20,
                      child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          SizedBox(height:13.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
                child: Icon(Icons.person,
                    color: Colors.white),
              ),
              SizedBox(width: 11.w),
              Text(
                'Gender : ',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(165, 165, 165, 0.9))),
              ),
              SizedBox(width: 8.w),
              Text(
                'Male',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:9.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/profile_assets/bornon.svg',height: 15.h,
                        width:15.w),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(width: 11.w),
              Text(
                'Born on ',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(165, 165, 165, 0.9))),
              ),
              SizedBox(width: 8.w),
              Text(
                'December 6th 2000',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:9.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                child:  Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/profile_assets/profilelanguage.svg',height: 15.h,
                        width:15.w),
                  ],
                ),
                // SvgPicture.asset('assets/profile_assets/born on.svg'),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(width: 11.w),
              Text(
                'I Speak',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(165, 165, 165, 0.9))),
              ),
              SizedBox(width: 8.w),
              Text(
                'English, Tamil',

                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:9.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                child: Column(crossAxisAlignment:CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/profile_assets/profilecall.svg',height: 16.h,
                        width:16.w),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(width: 11.w),
              Text(
                  widget.phone,
            // '+91 9874653631',
                //profileDetailsValueNotifier.value.item2.result.profileDetails.name,
             //   profileDetailsValueNotifier.value.item4.result.profile_details.phone,

                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:9.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                child: Icon(Icons.mail_outline,color: Colors.white),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(width: 11.w),
              Text(
                widget.email,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:17.h),
          Row(
            children: [
              Text('Website',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              SizedBox(width:10.w),
              GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>Link_Page(),));
                  },
                  child:  Container(height:20,width:20,
                      child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          SizedBox(height:13.h),
          Row(
            children: [
              Container(
                height: 25.h,
                width: 25.w,
                child:  Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/profile_assets/profilelink.svg',height: 16.h,
                        width:16.w),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(165, 165, 165, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(width: 11.w),
              Text(
                'http://deejos.in/',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ],
          ),
          SizedBox(height:13.h),
          Row(
            children: [
              Text('Work Experience',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              SizedBox(width:10.w),
              GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>Work_Experience(),));
                  },
                  child:   Container(height:20,width:20,
                      child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          SizedBox(height:16.h),
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
              Column(crossAxisAlignment: CrossAxisAlignment.start,
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
              Column(crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          SizedBox(height: 19.h),
          Row(
            children: [
              Text('Skills',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              SizedBox(width:10.w),
              GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>Skill_Page(),));
                  },
                  child:  Container(height:20,width:20,
                      child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
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
              Row(
                children: [
                  Text(
                    'Ux research',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                 SizedBox(width:125.w),
                  TextButton( onPressed:widget.onPressed,
                      child: Text('See More...',style:GoogleFonts.inter(
                          textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 12.sp,
                              color: Color.fromRGBO(0, 163, 255, 1)
                          )
                      ),))
                ],
              ),
            ],
          ),
      ],),
    );
  }
}
