import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Info_Page extends StatefulWidget {
  const Info_Page({Key? key}) : super(key: key);

  @override
  State<Info_Page> createState() => _Info_PageState();
}
TextEditingController _info1=TextEditingController();
TextEditingController _info2=TextEditingController();
TextEditingController _info3=TextEditingController();


class _Info_PageState extends State<Info_Page> {
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset:false,
      appBar: AppBar(
        leading: GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/profile_assets/back_button.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
        title: Text(
          'info',
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
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:29,top:15,right:17),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                      children:[
                        TextSpan(text: 'Gender : ',style: GoogleFonts.inter(textStyle: TextStyle(
                            fontWeight: FontWeight.w700,fontSize:16.sp,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                        TextDecoration.none
                        ))),
                        TextSpan(text:'Male',style: GoogleFonts.inter(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,fontSize:16.sp,color: Color.fromRGBO(0, 0, 0,1),decoration:
                        TextDecoration.none
                        )))
                      ])),
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
              Padding(
                padding: const EdgeInsets.only(top:8,left:37),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text('Male',style: GoogleFonts.inter(textStyle: TextStyle(
                    fontWeight: FontWeight.w400,fontSize:16.sp,color: Color.fromRGBO(0, 0, 0,1),decoration:
                    TextDecoration.none
                    ))),SizedBox(height:12.h),
                    Text('Female',style: GoogleFonts.inter(textStyle: TextStyle(
                        fontWeight: FontWeight.w400,fontSize:16.sp,color: Color.fromRGBO(165, 165, 165, 1),decoration:
                    TextDecoration.none
                    ))),SizedBox(height:12.h),
                    Text('Other',style: GoogleFonts.inter(textStyle: TextStyle(
                        fontWeight: FontWeight.w400,fontSize:16.sp,color: Color.fromRGBO(165, 165, 165, 1),decoration:
                    TextDecoration.none
                    ))),
                  ],
                ),
              ),
            ],),
          ),
          Divider(thickness:1,indent:12,endIndent:12,color: Color.fromRGBO(235, 235, 235, 1),),
          Padding(
            padding: const EdgeInsets.only(left:29,right:17,top:8),
            child: Column(
              children: [
                Row(
                  children: [
                   Text('Birthday',style: GoogleFonts.inter(
                     fontSize:16.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                   ),),
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
                SizedBox(height:11.h),
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(165, 165, 165, 0.9),
                          shape: BoxShape.circle),
                      child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/profile_assets/bornon.svg',height: 15.h,
                          width:15.w),
                        ],
                      )
                    ),
                    SizedBox(width: 11.w),
                    RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                        children:[
                          TextSpan(text: 'Born on ',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w700,fontSize:14.sp,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                          TextDecoration.none
                          ))),
                          TextSpan(text:'December 6th 2000',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w400,fontSize:14.sp,color: Color.fromRGBO(0, 0, 0,1),decoration:
                          TextDecoration.none
                          )))
                        ])),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:10.h),
          Divider(thickness:1,indent:12,endIndent:12,color: Color.fromRGBO(235, 235, 235, 1),),
          Padding(
            padding: const EdgeInsets.only(left:29,right:17,top:8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Language',style: GoogleFonts.inter(
                        fontSize:16.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                    ),),
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
                SizedBox(height:11.h),
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(165, 165, 165, 0.9),
                          shape: BoxShape.circle),
                      child:  Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(165, 165, 165, 0.9),
                              shape: BoxShape.circle),
                          child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/profile_assets/profilelanguage.svg',height: 15.h,
                                  width:15.w),
                            ],
                          )
                      ),
                    ),
                    SizedBox(width: 11.w),
                    RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                        children:[
                          TextSpan(text: 'I speak ',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w700,fontSize:14.sp,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                          TextDecoration.none
                          ))),
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(bottom:0),
                      child: Container( height:30.h,width:200.w,color:Colors.transparent,
                        child:  Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: TextField(
                            cursorColor: Colors.black,cursorHeight:20.h,
                            controller:_info1,
                            decoration: InputDecoration(
                              hintText: '',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w,
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                            ),),
                        ),
                       ),
                    )
                  ],
                ),
              ],
            ),
          ), SizedBox(height:10.h),
          Divider(thickness:1,indent:12,endIndent:12,color: Color.fromRGBO(235, 235, 235, 1),),
          Padding(
            padding: const EdgeInsets.only(left:29,right:17,top:8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Mobile number',style: GoogleFonts.inter(
                        fontSize:16.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                    ),),
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
                SizedBox(height:11.h),
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(165, 165, 165, 0.9),
                          shape: BoxShape.circle),
                      child: Column(crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/profile_assets/profilecall.svg',height: 16.h,
                              width:16.w),
                        ],
                      ),
                    ),
                    SizedBox(width: 11.w),
                    RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                        children:[
                          TextSpan(text: '+91 ',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w400,fontSize:14.sp,color: Color.fromRGBO(0, 0, 0, 1),decoration:
                          TextDecoration.none
                          ))),
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(bottom:0),
                      child: Container( height:30.h,width:200.w,color:Colors.transparent,
                        child:  Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: TextField(
                            cursorColor: Colors.black,cursorHeight:20.h,
                            controller:_info2,
                            decoration: InputDecoration(
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w,
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                            ),),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:10.h),
          Divider(thickness:1,indent:12,endIndent:12,color: Color.fromRGBO(235, 235, 235, 1),),
          Padding(
            padding: const EdgeInsets.only(left:29,right:17,top:8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Email',style: GoogleFonts.inter(
                        fontSize:16.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                    ),),
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
                SizedBox(height:11.h),
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(165, 165, 165, 0.9),
                          shape: BoxShape.circle),
                      child: Icon(Icons.mail_outline,
                          color: Colors.white),
                    ),
                    SizedBox(width: 11.w),
                    Padding(
                      padding: const EdgeInsets.only(bottom:0),
                      child: Container( height:30.h,width:200.w,color:Colors.transparent,
                        child:  Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: TextField(
                            cursorColor: Colors.black,cursorHeight:20.h,
                            controller:_info3,
                            decoration: InputDecoration(
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w,
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                            ),),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}
