import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/storage/all_files.dart';
import 'package:gatello/views/storage/photos_videos.dart';
import 'package:google_fonts/google_fonts.dart';

import 'audio_document.dart';

class Storage extends StatefulWidget {
  const Storage({Key? key}) : super(key: key);
  @override
  State<Storage> createState() => _StorageState();
}
class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SingleChildScrollView(
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [ClipPath(
            clipper:CustomClipPath(),
            child: Stack(
              children:[ Container(height:278.h,width:double.infinity.w,
              decoration:BoxDecoration(color:Color.fromRGBO(255, 214, 108, 1))),
            ]),
          ),

        Padding(padding:EdgeInsets.fromLTRB(10.w, 4.h, 0.w, 0.h),
          child: Text('File type',style:GoogleFonts.inter(textStyle:TextStyle(
            fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:18.sp
          )),),),

            Container(padding:EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
              child:Column(children: [GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) =>Allstorage()));},
                child: Container(padding:EdgeInsets.fromLTRB(18.w,14.h, 16.w, 0.h),
                  height:82.h,width:332.w, decoration:BoxDecoration(borderRadius:
                BorderRadius.circular(8), boxShadow:[BoxShadow(color: Colors.white,spreadRadius:3)]),
                child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(children: [SvgPicture.asset('assets/storage_assets/all_files.svg'),SizedBox(width:11.w),
                      Text('All files',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp)),),
                      SizedBox(width:5.w),
                      Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp))),
                      Spacer(),
                      Text('2.3 GB',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(139, 139, 139, 1),fontSize:14.sp))),
                      PopupMenuButton(shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Trash',style: GoogleFonts.inter(textStyle: TextStyle(fontWeight:
                              FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1))),
                            ),
                          ),
                          PopupMenuItem(
                            child: Text('Help and feedback', style: GoogleFonts.inter(fontWeight: FontWeight.w400,
                                  textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                            ),
                          ),
                          PopupMenuItem(child: Text('Upgrade storage', style: GoogleFonts.inter(fontWeight: FontWeight.w400,
                                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)))))])]),
                      SizedBox(height:18.h), Container(height:7.h,width:200.w,color:Colors.green),
                  ],),),
              ),
            ],),),
            Container(padding:EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
              child:Column(children: [GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) =>Photos()));},
                child: Container(padding:EdgeInsets.fromLTRB(18.w,14.h, 16.w, 0.h),
                  height:82.h,width:332.w, decoration:BoxDecoration(borderRadius:
                  BorderRadius.circular(8), boxShadow:[BoxShadow(color: Colors.white,spreadRadius:3)]),
                  child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(children: [SvgPicture.asset('assets/storage_assets/photos_icon.svg'),SizedBox(width:11.w),
                      Text('Photos',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp)),),
                      SizedBox(width:5.w),
                      Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp))),
                      Spacer(),
                      Text('2.3 GB',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(139, 139, 139, 1),fontSize:14.sp))),
                   ]),
                    SizedBox(height:18.h), Container(height:7.h,width:200.w,color:Colors.green),
                  ],),),
              ),
              ],),),
            Container(padding:EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
              child:Column(children: [GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) =>Videos()));},
                child: Container(padding:EdgeInsets.fromLTRB(18.w,14.h, 16.w, 0.h),
                  height:82.h,width:332.w, decoration:BoxDecoration(borderRadius:
                  BorderRadius.circular(8), boxShadow:[BoxShadow(color: Colors.white,spreadRadius:3)]),
                  child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(children: [SvgPicture.asset('assets/storage_assets/videos_icon.svg'),SizedBox(width:11.w),
                      Text('Videos',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp)),),
                      SizedBox(width:5.w),
                      Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp))),
                      Spacer(),
                      Text('2.3 GB',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(139, 139, 139, 1),fontSize:14.sp))),
                  ]),
                    SizedBox(height:18.h), Container(height:7.h,width:200.w,color:Colors.green),
                  ],),),
              ),
              ],),),
            Container(padding:EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
              child:Column(children: [GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) =>Document()));},
                child: Container(padding:EdgeInsets.fromLTRB(18.w,14.h, 16.w, 0.h),
                  height:82.h,width:332.w, decoration:BoxDecoration(borderRadius:
                  BorderRadius.circular(8), boxShadow:[BoxShadow(color: Colors.white,spreadRadius:3)]),
                  child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(children: [SvgPicture.asset('assets/storage_assets/document_icon.svg'),SizedBox(width:11.w),
                      Text('Documents',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp)),),
                      SizedBox(width:5.w),
                      Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp))),
                      Spacer(),
                      Text('2.3 GB',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(139, 139, 139, 1),fontSize:14.sp))),
                     ]),
                    SizedBox(height:18.h), Container(height:7.h,width:200.w,color:Colors.green),
                  ],),),
              ),
              ],),),
            Container(padding:EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
              child:Column(children: [GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) =>Audio()));},
                child: Container(padding:EdgeInsets.fromLTRB(18.w,14.h, 16.w, 0.h),
                  height:82.h,width:332.w, decoration:BoxDecoration(borderRadius:
                  BorderRadius.circular(8), boxShadow:[BoxShadow(color: Colors.white,spreadRadius:3)]),
                  child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(children: [SvgPicture.asset('assets/storage_assets/document_icon.svg'),SizedBox(width:11.w),
                      Text('Audios',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp)),),
                      SizedBox(width:5.w),
                      Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp))),
                      Spacer(),
                      Text('2.3 GB',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w500,color:Color.fromRGBO(139, 139, 139, 1),fontSize:14.sp))),
                    ]),
                    SizedBox(height:18.h), Container(height:7.h,width:200.w,color:Colors.green),
                  ],),),
              ),
              ],),),

            Container(padding:EdgeInsets.fromLTRB(28.w,28.h,0.w,0.h),
              height:150.h,width:double.infinity.w,decoration:
              BoxDecoration(color:Color.fromRGBO(255, 214, 108, 1)),
            child:Column(children: [
              Row(children:[
                SvgPicture.asset('assets/storage_assets/back-icon.svg',
                    height: 30.h, width:30.w),SizedBox(width:21.w),
                Container(padding:EdgeInsets.fromLTRB(20.w,11.h,0.h,0.w),
                  height:36.h,width:265.w,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),color:Color.fromRGBO(255, 255, 255, 1)),
                  child:TextField(cursorColor:Colors.black,
                      decoration:InputDecoration(
                    hintText:"Search...",hintStyle:GoogleFonts.inter(
                    textStyle:TextStyle(fontWeight:FontWeight.w400,fontSize:12.sp,
                    color: Color.fromRGBO(171, 168, 168, 1))),
                    enabledBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(40),borderSide:BorderSide(width:0.w
                      ,color:Colors.transparent)),
                    focusedBorder:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(40),borderSide:BorderSide(width:0.w
                        ,color:Colors.transparent)),
                  )),
                )
              ]),
              Row(children: [
                Container(height:31.h,width:81.w,color:Color.fromRGBO(255, 214, 108, 1),)
              ],)
            ],),)
        ],
      ),
    ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path>{
  @override
  Path getClip (Size size){
    double w= size.width;
    double h=size.height;

    final path =Path();
    path.lineTo(2,240);
    path.quadraticBezierTo(w*0.01,h,w,h);
    path.lineTo(w,0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return false;
  }
}