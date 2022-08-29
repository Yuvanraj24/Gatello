import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);
  @override
  State<Audio> createState() => _AudioState();
}
class _AudioState extends State<Audio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset('assets/storage_assets/back-icon.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
        title: Text('Storage', style: GoogleFonts.inter(textStyle: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
        actions: [PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
            itemBuilder: (context) => [
              PopupMenuItem(child: Center(child: Text('Settings',style: GoogleFonts.inter(textStyle:
              TextStyle(fontWeight: FontWeight.w400,fontSize:14, color: Color.fromRGBO(0,0,0,1))
              ))))])],
      ),
      body: Column(
        children: [
          Container(padding:EdgeInsets.fromLTRB(12.w,24.h,12.w,0.h),
              child:Column(children: [
                Row(children: [
                  Text('Audios',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
                  SizedBox(width:5.w),
                  Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp)))]),
                SizedBox(height:12.h),
                Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
              ])),
          Expanded(
           child:ListView.builder(itemBuilder: (context, index) {
             return Padding(
               padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w,0.h),
               child: Column(
                 children: [
                   Row(children: [
                     Column(children: [
                       SvgPicture.asset('assets/storage_assets/audio_icon.svg'),
                       SizedBox(height:18.h),
                       Text('Audio',style:GoogleFonts.inter(textStyle:TextStyle(
                           fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                     ],),
                     SizedBox(width:51.w),
                     Column(children: [
                       SvgPicture.asset('assets/storage_assets/audio_icon.svg'),
                       SizedBox(height:18.h),
                       Text('Audio',style:GoogleFonts.inter(textStyle:TextStyle(
                           fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                     ],),
                     SizedBox(width:51.w),
                     Column(children: [
                       SvgPicture.asset('assets/storage_assets/audio_icon.svg'),
                       SizedBox(height:18.h),
                       Text('Audio',style:GoogleFonts.inter(textStyle:TextStyle(
                           fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                     ],),
                   ],
                   ),
                   SizedBox(height:18.h),
                   Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
                 ],
               ),
             );
           },),
          )
        ],
      ),
    );
  }
}


class Document extends StatefulWidget {
  const Document({Key? key}) : super(key: key);

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset('assets/storage_assets/back-icon.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
        title: Text('Storage', style: GoogleFonts.inter(textStyle: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
        actions: [PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
            itemBuilder: (context) => [
              PopupMenuItem(child: Center(child: Text('Settings',style: GoogleFonts.inter(textStyle:
              TextStyle(fontWeight: FontWeight.w400,fontSize:14, color: Color.fromRGBO(0,0,0,1))
              ))))])],
      ),
      body: Column(
        children: [
          Container(padding:EdgeInsets.fromLTRB(12.w,24.h,12.w,0.h),
              child:Column(children: [
                Row(children: [
                  Text('Documents',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
                  SizedBox(width:5.w),
                  Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp)))]),
                SizedBox(height:12.h),
                Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
              ])),
          Expanded(
            child:ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w,0.h),
                child: Column(
                  children: [
                    Row(children: [
                      Column(children: [
                        SvgPicture.asset('assets/storage_assets/documents.svg'),
                        SizedBox(height:18.h),
                        Text('Document',style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                      ],),
                      SizedBox(width:51.w),
                      Column(children: [
                        SvgPicture.asset('assets/storage_assets/documents.svg'),
                        SizedBox(height:18.h),
                        Text('Document',style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                      ],),
                      SizedBox(width:51.w),
                      Column(children: [
                        SvgPicture.asset('assets/storage_assets/documents.svg'),
                        SizedBox(height:18.h),
                        Text('Document',style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
                      ],),
                    ],
                    ),
                    SizedBox(height:18.h),
                    Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
                  ],
                ),
              );
            },),
          )
        ],
      ),
    );
  }
}
