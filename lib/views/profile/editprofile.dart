import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({Key? key}) : super(key: key);

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Edit Profile',
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
      body:Padding(
        padding:  EdgeInsets.only(right:12,left:12,top:15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Cover photo',style: GoogleFonts.inter(
              textStyle: TextStyle(fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(70, 70, 70, 1),fontSize: 20
              ))),
          SizedBox(height:15.h),
          Stack(
            children:[ Container(height:168.h,width:double.infinity,decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(8),image:DecorationImage(image:
            NetworkImage('https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
            fit: BoxFit.fill)
            ),),
              Positioned(right:10,bottom: 10,
                child: Container(height:23.h,width:23.w,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/profile_assets/edittoolblack.svg',
                          height:15,width:15),
                    ],
                  ),
                  decoration:BoxDecoration(
                  color:Color.fromRGBO(248, 206, 97, 1),shape: BoxShape.circle
                ),),
              )
            ]
          ),
            SizedBox(height:20.h),
          Text('Profile picture',style: GoogleFonts.inter(
              textStyle: TextStyle(fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(70, 70, 70, 1),fontSize: 20
              ))),
            SizedBox(height:10.h),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children:[ Container(height:154.h,width:156.w,decoration: BoxDecoration(
                  shape:BoxShape.circle, image:DecorationImage(image:
                NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80'),
                    fit: BoxFit.fill)
                ),),
                  Positioned(right:0,bottom:9,
                    child: Container(height:43.h,width:43.w,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/profile_assets/edittoolblack.svg',
                              height:26,width:26),
                        ],
                      ),
                      decoration:BoxDecoration(
                        color:Color.fromRGBO(248, 206, 97, 1),shape: BoxShape.circle
                    ),),
                  ),]
              ),
            ],
          ),
            SizedBox(height:16.h),
            Center(
              child: Text('Name',style: GoogleFonts.inter(
                  textStyle: TextStyle(fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.6),fontSize: 20
                  ))),
            ),
           Padding(
             padding: EdgeInsets.only(left:27,top:8),
             child: Column(children: [
               Row(
                 children: [
                   Container(
                     height: 25.h,
                     width: 25.w,
                     decoration: BoxDecoration(
                         color: Color.fromRGBO(165, 165, 165, 0.9),
                         shape: BoxShape.circle),
                     child: Icon(Icons.location_on_sharp,
                         color: Colors.white),
                   ),
                   SizedBox(width: 11.w),
                   RichText(
                       text: TextSpan(style:DefaultTextStyle.of(context).style,
                       children:[
                         TextSpan(text: 'Lives in ',style: GoogleFonts.inter(textStyle: TextStyle(
                             fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                         TextDecoration.none
                         ))),
                         TextSpan(text:'Chennai',style: GoogleFonts.inter(textStyle: TextStyle(
                             fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
                         TextDecoration.none
                         )))
                       ])),
                   Spacer(),
                   TextButton(onPressed: (){}, child:Text('EDIT',style: GoogleFonts.inter(
                       fontSize: 14.sp,
                       fontWeight: FontWeight.w400,
                       color: Color.fromRGBO(0, 163, 255, 1)
                   ),))
                 ],
               ),
               SizedBox(height: 2.h),
               Row(
                 children: [
                   Container(
                     height: 25.h,
                     width: 25.w,
                     decoration: BoxDecoration(
                         color: Color.fromRGBO(165, 165, 165, 0.9),
                         shape: BoxShape.circle),
                     child:
                    Column(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/profile_assets/proffesion.svg'
                        ,height:12.h,width:12.w),
                      ],
                    )
                   ),
                   SizedBox(width: 11.w),
                   Text(
                     'Designer',
                     style: GoogleFonts.inter(
                         textStyle: TextStyle(
                             fontSize: 14.sp,
                             fontWeight: FontWeight.w400,
                             color: Color.fromRGBO(0, 0, 0, 1))),
                   ),
                 ],
               ),
               SizedBox(height: 9.h),
               Row(
                 children: [
                   Container(
                     height: 25.h,
                     width: 25.w,
                     decoration: BoxDecoration(
                         color: Color.fromRGBO(165, 165, 165, 0.9),
                         shape: BoxShape.circle),
                     child:
                     Column(crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         SvgPicture.asset('assets/profile_assets/proffesion.svg'
                             ,height:12.h,width:12.w),
                       ],
                     )
                   ),
                   SizedBox(width: 11.w),
                   RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                       children:[
                         TextSpan(text: 'Working at ',style: GoogleFonts.inter(textStyle: TextStyle(
                             fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                         TextDecoration.none
                         ))),
                         TextSpan(text:'Deejos arvhitects Pvt Ltd',style: GoogleFonts.inter(textStyle: TextStyle(
                             fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
                         TextDecoration.none
                         )))
                       ])),
                 ],
               ),
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
            ),)),
            Padding(
              padding: EdgeInsets.only(top:10,bottom:12),
              child: Divider(thickness:2.w,indent:140,endIndent:137,color: Color.fromRGBO(0,0,0,1),),
            )
        ],
        ),
      ),
    );
  }
}
