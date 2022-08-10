import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Skill_Page extends StatefulWidget {
  const Skill_Page({Key? key}) : super(key: key);

  @override
  State<Skill_Page> createState() => _Skill_PageState();
}

class _Skill_PageState extends State<Skill_Page> {
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset('assets/profile_assets/back_button.svg',
            height: 24.h, width: 24.w),
        title: Text(
          'Skills',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1))),
        ),
        actions: [
          Icon(Icons.more_vert,color:Color.fromRGBO(0,0,0,1),size:30)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:31,top:21,right:12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:31.h),
            Row(
              children: [
                Text('Website',style: GoogleFonts.inter(
                    fontSize:20.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                ),),SizedBox(width:118.w),
                IconButton(onPressed: (){}, icon:Icon(Icons.add,color: Colors.black,),),
                Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 7, left: 9, bottom: 6),
                            child: Text(
                              'Public',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                      color: Color.fromRGBO(0, 0, 0, 1))),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Color.fromRGBO(12, 16, 29, 1),
                      ),
                    ),
                    iconSize: 14,
                    buttonHeight: 30,
                    buttonWidth: 86,
                    buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color.fromRGBO(248, 206, 97, 1)),
                    itemHeight: 40,
                    // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 90,
                    dropdownWidth: 90,
                    buttonElevation: 0,
                    dropdownElevation: 0,
                    dropdownDecoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    scrollbarAlwaysShow: false,
                  ),
                )
              ],
            ),
            SizedBox(height:31.h),
            Row(children: [ Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
              Text(
              'Marketing Strategy',
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1))),),],),
            SizedBox(height:20.h),
          Row(children: [Container(
            height: 12.h,
            width: 12.w,
            decoration: BoxDecoration(
                color: Color.fromRGBO(165, 165, 165, 0.9),
                shape: BoxShape.circle),
          ),SizedBox(width:18.w),
            Text(
            'Ux research',
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 0, 0, 1))),
          ),],),
            SizedBox(height:20.h),
            Row(children: [ Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
              Text(
                'Marketing Strategy',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1))),),],),
            SizedBox(height:20.h),
            Row(children: [Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
              Text(
                'Ux research',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),],),
            SizedBox(height:20.h),
            Row(children: [ Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
              Text(
                'Marketing Strategy',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1))),),],),
            SizedBox(height:20.h),
            Row(children: [Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
              Text(
                'Ux research',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),],),
            SizedBox(height:10.h),
            Row(children: [Container(
              height: 12.h,
              width: 12.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 165, 165, 0.9),
                  shape: BoxShape.circle),
            ),SizedBox(width:18.w),
             Padding(
               padding: const EdgeInsets.only(bottom:10),
               child: Container(height:19.h,width:1.w,color: Colors.black,),
             )],),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom:14),
              child: Column(children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(336.w,47.h),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('Save',style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),fontSize:20,fontWeight: FontWeight.w700
                    )
                ),)),
                Divider(thickness:2.w,indent:140,endIndent:137,color: Color.fromRGBO(0,0,0,1),)
              ],),
            ),
        ],),
      ),
    );
  }
}
