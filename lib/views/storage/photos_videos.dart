import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Photos extends StatefulWidget {
  const Photos({Key? key}) : super(key: key);
  @override
  State<Photos> createState() => _PhotosState();
}
class _PhotosState extends State<Photos> {
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
                  Text('Photos',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
                  SizedBox(width:5.w),
                  Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp)))]),
                SizedBox(height:12.h),
                Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
                SizedBox(height:6.h),
              ])),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4,
                  crossAxisSpacing:4,mainAxisSpacing:4),
              itemBuilder: (context, index) {
                return Container(
                  child:Image.network('https://i.pinimg.com/originals/76/30/92/76309217422ce2812f5150a4496a1571.jpg'
                      ,fit:BoxFit.fill),
                );
              },),
          )
        ],
      ),
    );
  }
}


class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);
  @override
  State<Videos> createState() => _VideosState();
}
class _VideosState extends State<Videos> {
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
                  Text('Videos',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
                  SizedBox(width:5.w),
                  Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp)))]),
                SizedBox(height:12.h),
                Divider(thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
                SizedBox(height:6.h),
              ])),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4,
                  crossAxisSpacing:4,mainAxisSpacing:4),
              itemBuilder: (context, index) {
                return Stack(
                  children:[ Container(height:91.h,width:91.w,
                    child:Image.network('https://i.pinimg.com/originals/76/30/92/76309217422ce2812f5150a4496a1571.jpg'
                        ,fit:BoxFit.fill),
                  ),
                    Center(child: SvgPicture.asset('assets/storage_assets/play_icon.svg'))
               ] );
              },),
          )
        ],
      ),
    );
  }
}

