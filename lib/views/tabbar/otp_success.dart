import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../add_email.dart';
class OtpSuccess extends StatefulWidget {
  String birthDay;
  String userName;
  String name;
  String password;
  String mobileNo;
  String otp ;
  String? email;
  OtpSuccess({
    required this.name,
    required this.userName,
    required this.birthDay,
    required this.password,
    required this.mobileNo,
    required this.otp,
  });


  @override
  State<OtpSuccess> createState() => _OtpSuccessState();
}

class _OtpSuccessState extends State<OtpSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Center(
        //     child: TextButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       child: GestureDetector(onTap:() {
        //         Navigator.pop(context);
        //       },
        //         child: Text(
        //           'Back', style: GoogleFonts.roboto(
        //               textStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        //         ),
        //       ),
        //     )),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(height:87.h),
              Image.asset('assets/account_created.gif'),
              //       Container(height:170.h,width:170.w,decoration:BoxDecoration(shape:BoxShape.circle,color:Color.fromRGBO(248, 206, 97, 1)),
              // child:Icon(Icons.done_rounded,size:120,),),
              SizedBox(height:27.h),
              Text("Otp Verified",style:GoogleFonts.fredoka(  textStyle: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
              ),
              Text("Successfully",style:GoogleFonts.fredoka(  textStyle: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
              ),
              Spacer(),
              Padding(
                padding:  EdgeInsets.only(bottom: 35.h),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddEmail(
                          name: widget.name,birthDay: widget.birthDay, userName: widget.userName,
                          password: widget.password, mobileNo: widget.mobileNo,otp: widget.otp,

                        )));
                  },
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      onPrimary: Colors.black,
                      //  padding: EdgeInsets.all(10),
                      minimumSize: Size(234.w, 48.h),
                      primary: Color.fromRGBO(248, 206, 97, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      )),
                ),
              ),
            ]),
      ),
    );
  }
}
