import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Requests_Page extends StatefulWidget {
  const Requests_Page({Key? key}) : super(key: key);

  @override
  State<Requests_Page> createState() => _Requests_PageState();
}

class _Requests_PageState extends State<Requests_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
                    width:35.w,),
                ],
              )),
          title: Text('Requests',style: GoogleFonts.inter(
              textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontWeight: FontWeight.w400,fontSize:22)
          ),),
        ),
        body:ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return request_List();
          },)

    );
  }
}
Widget request_List (){
  return  Padding(
    padding: EdgeInsets.fromLTRB(12.w, 20.h, 16.w, 0.h),
    child: Column(
      children: [
        Container(padding:EdgeInsets.only(right:14),
          child: Row(
            children: [
              Container( height: 49.h,width: 50.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                        fit: BoxFit.fill)
                ),),
              SizedBox(width: 14.w),
              Text('Angelena_123',style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 16.sp,fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1)
                  )
              ),),
              Spacer(),
              Text('11:20 AM',style: GoogleFonts.inter(
                  textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.w400,fontSize:12)),)
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(top: 16),
          child: Divider(thickness:2,color: Color.fromRGBO(26, 52, 130, 0.06),indent:70,endIndent: 13),
        )
      ],
    ),
  );
}