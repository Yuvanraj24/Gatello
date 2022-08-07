import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/tabbar/pops/thirdreport.dart';


import 'package:google_fonts/google_fonts.dart';


class Second_Report extends StatefulWidget {
  const Second_Report({Key? key}) : super(key: key);

  @override
  State<Second_Report> createState() => _Second_ReportState();
}

class _Second_ReportState extends State<Second_Report> {
  TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(left: 12.w,top:16.h,right: 12.w),
          color: Colors.white,
          child: Column(
            children: [
              Divider(
                endIndent: 164,
                indent: 164,
                thickness: 2,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              Text(
                'Report',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
              SizedBox(
                height: 14.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Why are you reporting this post?',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            decoration: TextDecoration.none,
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w700,
                            fontSize:16.sp)),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                maxLines: 10,
                controller: _controller,
                decoration: InputDecoration(
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(width: 1,
                        color: Color.fromRGBO(181, 181, 181, 1)),
                      borderRadius: BorderRadius.circular(10)
                  ) ,
                  hintText: 'Type here...',hintStyle: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color:Color.fromRGBO(165, 165, 165, 1),fontWeight: FontWeight.w400,fontSize: 16.sp)),
                    border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1,
                    color: Color.fromRGBO(181, 181, 181, 1)
                  ),
                  borderRadius: BorderRadius.circular(10)
                )
                ),
              ),
              SizedBox(
                height: 213.h,
              ),
              ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                primary: Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(194.w, 43.h),
              ),
                  onPressed: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context) => Third_Page(),));
                  }, child: Text('Send',style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),fontSize: 16.sp,fontWeight: FontWeight.w700
                      )
                  ),)),
            ],
          ),
        ),
      ),
    );
  }
}
