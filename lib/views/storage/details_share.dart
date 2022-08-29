import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
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
        title: Text('Details', style: GoogleFonts.inter(textStyle: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
        actions: [PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
            itemBuilder: (context) => [
              PopupMenuItem(child: Center(child: Text('Settings',style: GoogleFonts.inter(textStyle:
              TextStyle(fontWeight: FontWeight.w400,fontSize:14, color: Color.fromRGBO(0,0,0,1))
              ))))])],
      ),
      body: Container(padding: EdgeInsets.fromLTRB(12.w,12.h,12.w,0.h),
        child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
        Container(height:190.h,width:351.w,decoration:BoxDecoration(
          image: DecorationImage(image:NetworkImage(
              'https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bmF0dXJhbHxlbnwwfHwwfHw%3D&w=1000&q=80'),fit:BoxFit.fill),
            borderRadius:BorderRadius.circular(8)),
        ),
          SizedBox(height:11.h),
          Text('File Name : Family image 1', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
          SizedBox(height:22.h),
          Text('Type', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(144, 144, 144, 1)))),
          Text('Image', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
          SizedBox(height:18.h),
          Text('Location', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(144, 144, 144, 1)))),
          Text('Family', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
          SizedBox(height:18.h),
          Text('Size', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(144, 144, 144, 1)))),
          Text('2.5 MB', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
          SizedBox(height:18.h),
          Text('Date when you upload ', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(144, 144, 144, 1)))),
          Text('2 May 2022', style: GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
      ],),),
    );
  }
}



class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);
  @override
  State<Share> createState() => _ShareState();
}
class _ShareState extends State<Share> {
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
        title: Text('Share to', style: GoogleFonts.inter(textStyle: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
        actions: [PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
            itemBuilder: (context) => [
              PopupMenuItem(child: Center(child: Text('Settings',style: GoogleFonts.inter(textStyle:
              TextStyle(fontWeight: FontWeight.w400,fontSize:14, color: Color.fromRGBO(0,0,0,1))
              ))))])],
      ),
      body:ListView.builder(shrinkWrap:true,itemCount:10,
        itemBuilder:(context, index) {
        return Container(padding:EdgeInsets.fromLTRB(15.w, 25.h, 0.w, 0.h),
          child:Row(children: [Container(height:44.h,width:44.w,decoration:BoxDecoration(
            shape:BoxShape.circle,image:DecorationImage(image:NetworkImage(
            'https://i.pinimg.com/564x/2a/9d/83/2a9d83480cac09d81a6afb709f89319b.jpg'))
        ),),
          SizedBox(width:25.w),
          Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Text('Angelena', style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700, color: Color.fromRGBO(0, 0, 0, 1)))),
            Text('Business account', style: GoogleFonts.inter(textStyle: TextStyle(
                fontSize: 10.sp, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 0.5)))),
          ],
          ),
        ],),
        );
      },),
      floatingActionButton:FloatingActionButton(
        onPressed: () {  },
        backgroundColor:Color.fromRGBO(248, 206, 97, 1),
      child:SvgPicture.asset('assets/storage_assets/forward_icon.svg',height:30.h,
      width:30.w),),
    );
  }
}
