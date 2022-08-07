import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class nopops_Request extends StatefulWidget {
  const nopops_Request({Key? key}) : super(key: key);

  @override
  State<nopops_Request> createState() => _nopops_RequestState();
}

class _nopops_RequestState extends State<nopops_Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back,color: Color.fromRGBO(12, 16, 29, 1),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:240,left:130),
        child: Column(
          children: [
            Container(
              width: 112.w,height: 112.h,decoration: BoxDecoration(
              border: Border.all(width: 1.w),shape: BoxShape.circle
            ),),
            SizedBox(height: 15.h),
            Text('No Pops requests',style:GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w700,fontSize: 24.sp,
            color: Color.fromRGBO(0, 0, 0, 1))),)
          ],
        ),
      ),
    );
  }
}
