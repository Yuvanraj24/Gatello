import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Incoming_Call extends StatefulWidget {
  const Incoming_Call({Key? key}) : super(key: key);

  @override
  State<Incoming_Call> createState() => _Incoming_CallState();
}

class _Incoming_CallState extends State<Incoming_Call> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children:[
            Container(height: double.infinity,width: double.infinity,
            child: Image.network('https://images.pexels.com/photos/6442132/pexels-photo-6442132.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                fit: BoxFit.fill),
          ),
            Padding(
              padding: EdgeInsets.only(left:12,top:450),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jack Jon',style: GoogleFonts.inter(
                      textStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    fontSize:24.sp,fontWeight: FontWeight.w700
                  ),),
                  Text('Voice call',style: GoogleFonts.inter(
                      textStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                      fontSize:14.sp,fontWeight: FontWeight.w400
                  ),),
                  Padding(
                    padding:  EdgeInsets.only(left:189),
                    child: Column(
                      children: [
                      SvgPicture.asset('assets/call_assets/arrow_upward.svg'),
                      SizedBox(height: 10.h),
                      SvgPicture.asset('assets/call_assets/arrow2.svg'),
                      SizedBox(height: 10.h),
                      SvgPicture.asset('assets/call_assets/arrow3.svg'),
                    ],),
                  ),
                ],
              ),
            ),
            Positioned(bottom:15,left:170,
              child: Text('Swipe up',style: GoogleFonts.inter(
                  textStyle: TextStyle(color: Color.fromRGBO(192, 192, 192, 1),fontWeight: FontWeight.w700,
                      fontSize:14
                  )
              ),),
            )
        ]),
        floatingActionButton:
        Padding(
          padding: EdgeInsets.only(left: 31,bottom:44),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 62.w,height: 62.h,
                child: FloatingActionButton(onPressed: (){},
                  child: SvgPicture.asset('assets/call_assets/chat_call.svg'),
                  backgroundColor: Color.fromRGBO(248, 206, 97, 1),elevation: 10,
                  focusElevation:5,
                ),
              ),
      SizedBox(width: 50.w),
      Container(width: 62.w,height: 62.h,
          child: FloatingActionButton(onPressed: (){},
              child: SvgPicture.asset('assets/call_assets/callsymbol.svg'),
            backgroundColor: Color.fromRGBO(79, 141, 0, 1),elevation: 10),
      ),
              SizedBox(width: 50.w),
      Container(width: 62.w,height: 62.h,
          child: FloatingActionButton(onPressed: (){},
              child: SvgPicture.asset('assets/call_assets/calldecline - Copy.svg'),
            backgroundColor: Color.fromRGBO(255, 43, 43, 1),elevation: 10),
        )]
          )
      )
    )
    );
  }
}
