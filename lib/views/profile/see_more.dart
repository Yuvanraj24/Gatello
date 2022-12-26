import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/profile/info.dart';
import 'package:gatello/views/profile/link.dart';
import 'package:gatello/views/profile/profile_details.dart';
import 'package:gatello/views/profile/skill.dart';
import 'package:gatello/views/profile/workexperience.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '/core/models/profile_detail.dart' as profileDetailsModel;
import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../core/Models/Default.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';

class SeeMoreText extends StatefulWidget {
  final VoidCallback? onPressed;
  String phone;
  String email;
  String? uid;
  String  biog;
  String gender;
  String dob;
  final ValueNotifier<Tuple4> valueNotifier;
  SeeMoreText({Key? key,required this.onPressed,required this.phone,
    required this.email,this.uid,required this.biog,required this.gender, required this.dob,required this.valueNotifier}) : super(key: key);

  @override
  State<SeeMoreText> createState() => _TextsuState();
}

class _TextsuState extends State<SeeMoreText> {

  int i=0;
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  Future profileDetailsApiCall() async {
    print('profile api called');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: 'http://3.110.105.86:4000/view/profile',
      requestMethod: 1,
      body: {"user_id": (widget.uid != null) ? widget.uid : widget.uid, "followee_id": ""},
    );
  }
  @override
  void initState(){
    profileDetailsApiCall();
  }

  @override
  Widget build(BuildContext context) {
    var localDate = DateTime.parse(widget.dob).toLocal();


    var inputFormat = DateFormat('yyyy-MM-dd 00:00:00.000');
    var inputDate = inputFormat.parse(localDate.toString());


    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    //   DateTime dateTime = dateFormat.parse("2019-07-19 8:40:23");
    print('uid for seemore${widget.uid}');
    // print('phnum${profileDetailsValueNotifier.value.item2.result.profileDetails.phone}');
    return Container(
      padding: EdgeInsets.only(right:30,left: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Biog',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)))),
              SizedBox(width:10.w),
              GestureDetector(
                onTap:(){
         showDialog(context: context, builder: (context){
            return AlertDialog(

            );
         });
                },
                child:  Container(height:20,width:20,
                    child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          Text(widget.biog.contains('null')?'none':widget.biog,
            style: GoogleFonts.inter(
              textStyle: TextStyle(fontSize:13.5.sp,
                  fontWeight: FontWeight.w400,color:
              Color.fromRGBO(0, 0, 0, 0.5)
              )

          ),),

          SizedBox(height:30.h),

          Row(
            children: [
              Text('Info',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)))),
              SizedBox(width:10.w),
              GestureDetector(
                onTap:(){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Info_Page(uid: widget.uid.toString(),

                      ),));
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
              InkWell(
                onTap: (){
                  profileDetailsApiCall();
                },
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
              Text(

                widget.gender.isEmpty?'none':widget.gender,
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

                outputDate.contains('null')?'none':outputDate,
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
                widget.phone.contains('null')?'none':widget.phone,


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
                widget.email.contains('null')?'none':widget.email,
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
                      MaterialPageRoute(builder: (context) =>Link_Page(uid: widget.uid.toString()),));
                },
                child:  Container(height:20,width:20,
                    child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          SizedBox(height:13.h),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.valueNotifier.value.item2.result.profileDetails.website.length,
              itemBuilder: (context,index){
                return  Padding(
                  padding:  EdgeInsets.only(bottom:13.h),
                  child: Row(
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
                          widget.valueNotifier.value.item2.result.profileDetails.website[index].toString(),
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),


                      ),

                    ],
                  ),
                );
              }),
          SizedBox(height:13.h),
          Row(
            children: [
              Text('Work Experience',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                  fontWeight: FontWeight.w700,color: Color.fromRGBO(0, 0, 0,1)),)  ),
              SizedBox(width:10.w),
              GestureDetector(
                onTap:(){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>Work_Experience(uid:widget.uid.toString()),));
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
                      MaterialPageRoute(builder: (context) =>Skill_Page(uid:widget.uid.toString()),));
                },
                child:  Container(height:20,width:20,
                    child: SvgPicture.asset('assets/profile_assets/Edit_tool.svg')),),
            ],
          ),
          SizedBox(height: 19.h),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.valueNotifier.value.item2.result.profileDetails.skills.length,
              itemBuilder: (context,index){
                return  Padding(
                  padding:  EdgeInsets.only(bottom:13.h),
                  child: Row(
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
                          widget.valueNotifier.value.item2.result.profileDetails.skills[index].toString(),
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),
                      ),
                    ],
                  ),
                );
              }),


        ],),
    );
  }
}
