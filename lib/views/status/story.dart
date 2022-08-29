import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'others_status.dart';

class Stories extends StatefulWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    List statusprofile=["https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg",
      "https://dl.memuplay.com/new_market/img/com.vicman.newprofilepic.icon.2022-06-07-21-33-07.png",
      "https://www.seekpng.com/png/detail/506-5061704_cool-profile-avatar-picture-cool-picture-for-profile.png"];

    List name=["Deena","Krishna","Ragu"];

    List time=["6.45","7.12","5.23"];
    return Scaffold(
      body:Container(
        padding:EdgeInsets.fromLTRB(12.w,15.h,12.w,0.h),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Padding(
              padding:EdgeInsets.fromLTRB(21.w,0.h,21.w,0.h),
              child: Row(children:[
                Container(height:27.h,width:143.w,decoration:BoxDecoration(
                    color:Color.fromRGBO(248, 206, 97, 1),
                    borderRadius:BorderRadius.circular(5)),
                  child:Center(
                    child: Text("Ping Status",style:GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight:FontWeight.w400,fontSize:14.sp,color:Colors.transparent
                    )),),
                  ),),
                SizedBox(width:8.w),
                Container(height:27.h,width:143.w,decoration:BoxDecoration(
                    color:Color.fromRGBO(248, 206, 97, 1),
                    borderRadius:BorderRadius.circular(5)),
                  child:Center(
                    child: Text("Pop Status",style:GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight:FontWeight.w400,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                    )),),
                  ),
                )],),
            ),
            SizedBox(height:15.h),
            Divider(color:Color.fromRGBO(242, 242, 242, 1),thickness:1.5.w),
            SizedBox(height:12.h),
            Row(mainAxisAlignment:MainAxisAlignment.center,
              children: [GestureDetector(onTap:(){Navigator.push(context,MaterialPageRoute(builder:
                  (context) => statusViewed()));},
                child: Column(children: [
                  Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                      image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                          fit:BoxFit.fill),
                      border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                  SizedBox(height:4.h),
                  Text("My story",style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                  ))),
                  SizedBox(height:4.h),
                  Text("Today at 6:00am",style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                  ))),
                ]),
              ),
              ],
            ), SizedBox(height:10.h),
            Text("Recent updates",style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
            ))),
            Expanded(
              child: ListView.builder(
                physics:BouncingScrollPhysics(),
                itemCount:statusprofile.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) {
                        return Otherstatus();
                      },));
                    },
                    onLongPress:() {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          shape:RoundedRectangleBorder(
                              borderRadius:BorderRadius.circular(20)),
                          title:Text('Mute status',style:TextStyle(fontWeight:FontWeight.w700,
                              fontSize:20.sp,color:Color.fromRGBO(0,0,0,1))),
                          content:Text(''),
                          actions: [
                            TextButton(
                              onPressed: () {Navigator.pop(context);},
                              child: Text('Cancel',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                                  color:Color.fromRGBO(0, 163, 255, 1))),
                            ),
                            TextButton(onPressed: () {  },
                              child: Text('OK',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                                  color:Color.fromRGBO(0, 0, 0, 1))),
                            )
                          ],
                        );
                      });
                    },
                    child: Container(height:98.h,width:double.infinity.w,
                      color:Colors.transparent,
                      // padding:EdgeInsets.fromLTRB(0.w,8.h,0.w,18.h),
                      child:Row(
                        children: [
                          Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                              image:DecorationImage(image: NetworkImage
                                (statusprofile[index]),
                                  fit:BoxFit.fill),
                              border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                          SizedBox(width:15.w),
                          Column(crossAxisAlignment:CrossAxisAlignment.start,
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                                  fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                                Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                                    fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                                )))])
                        ],),

                    ),
                  );
                },),
            ),
            Text("Viewed",style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
            ))),

          ],),),
      floatingActionButton:FloatingActionButton(
        backgroundColor:Color.fromRGBO(248, 206, 97, 1),
        child:SvgPicture.asset('assets/status_assets/camera_icon.svg'),
        onPressed: () {},
      ),
    );
  }

  Widget statusViewed(){
    return Scaffold(
      body:Stack(
          children:[Container(height:double.infinity.h,width:double.infinity.w,decoration:BoxDecoration(
              image:DecorationImage(image:NetworkImage('https://images.unsplash.com/photo-1589419621083-1ead66c96fa7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWlja2V5JTIwbW91c2V8ZW58MHx8MHx8&w=1000&q=80'),
                  fit:BoxFit.fill)
          ),),
            Positioned(top:28.h,left:10.w,
              child: Row(children: [
                GestureDetector(onTap:() {
                  Navigator.pop(context);
                },
                    child: SvgPicture.asset('assets/status_assets/back_icon.svg',height:40.h,width:40.w)),
                SizedBox(width:10.w),
                Container(height:60.h,width:60.w,decoration:BoxDecoration(shape:BoxShape.circle,
                    image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                        fit:BoxFit.fill),
                    border:Border.all(width:1.5.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                SizedBox(width:10.w),
                Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text('My status',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                        fontSize:14.sp,color:Color.fromRGBO(255, 255, 255, 1))),
                    SizedBox(height:5.h),
                    Text('Today at 6:00am',style:GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(255, 255, 255, 1)
                    )))
                  ],)
              ]),
            ),
            Positioned(bottom:23.h,left:170.w,right:170.w,
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                        context: context, builder:(context) {
                        return viwersList();
                      },);
                    },
                    child: Column(
                      children: [SvgPicture.asset('assets/status_assets/statusview_icon.svg'),
                        SizedBox(height:5.h),
                        Text('10',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w700,
                            fontSize:18.sp)),

                      ],
                    )))
          ]),
    );
  }

  Widget viwersList(){
    return Container(
      height:44.h,width:double.infinity.w,decoration:BoxDecoration(
        color:Color.fromRGBO(248, 206, 97, 1)),
      child:Padding(
        padding:EdgeInsets.fromLTRB(12.w,0.h,34.w,0.h),
        child: Row(children: [
          Text('Viewed by 32  ',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
              fontSize:12.sp,color:Color.fromRGBO(0,0,0,1))),
          Spacer(),
          SvgPicture.asset('assets/status_assets/delete_icon.svg')
        ]),
      ),
    );
  }

}
