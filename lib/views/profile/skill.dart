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
  int _count = 0;
  @override
  void iniState(){
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset:false,
      appBar: AppBar(
        leading:  GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/profile_assets/back_button.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
        title: Text(
          'Skills',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1))),
        ),
        actions: [
          PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
              itemBuilder: (context) => [
                PopupMenuItem(child: Center(
                  child: Text('Settings',style: GoogleFonts.inter(
                      textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize:14,
                          color: Color.fromRGBO(0,0,0,1))
                  ),),
                ),)
              ])
        ],
      ),
      body:Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(left:31,top:22,right:12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Skills',style: GoogleFonts.inter(
                        fontSize:20.sp,color: Color.fromRGBO(0,0,0,1),fontWeight: FontWeight.w700
                    ),),SizedBox(width:118.w),
                    IconButton(onPressed: ()async{
                      setState(() {
                        _count++;
                      });
                    }, icon:Icon(Icons.add,color: Colors.black,),),
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
                          child: Container(
                            child: Center(
                              child: Text(
                                  item,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                      )
                                  )
                              ),
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
                        buttonWidth: 90,
                        buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color.fromRGBO(248, 206, 97, 1)),
                        itemHeight:30,
                        // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                        dropdownMaxHeight: 130,
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
                SizedBox(height:30.h),
                ListView.builder(
                    shrinkWrap:true,
                    itemCount:_count,
                    itemBuilder: (context,index){
                      return _row(index);
                    }),
                SizedBox(height:30.h),
              ],),
          ),
          Spacer(),
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
          ),)),SizedBox(height:8.h),
          Padding(
            padding: const EdgeInsets.only(bottom:12),
            child: Divider(thickness:2.w,indent:140,endIndent:137,color: Color.fromRGBO(0,0,0,1),),
          ),
        ],
      ),
    );
  }
}


_row(int index){
  return Row(
    children: [
      Container(
        height: 12.h,
        width: 12.w,
        decoration: BoxDecoration(
            color: Color.fromRGBO(165, 165, 165, 0.9),
            shape: BoxShape.circle),
      ),
      SizedBox(width:14.w),
      Expanded(child: TextFormField(autofocus: true,
        cursorColor:Colors.black,
        decoration:InputDecoration(
            focusedBorder:OutlineInputBorder(borderSide:BorderSide(color:Colors.transparent)),
            enabledBorder:OutlineInputBorder(borderSide:BorderSide(color:Colors.transparent))
        ),
      ))
    ],
  );
}