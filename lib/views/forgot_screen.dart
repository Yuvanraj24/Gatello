import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.07,
          leading: Center(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ),
          )),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 95.h, left: 12.w, right: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage('assets/forgot_scren_image/Group 677.png'),
              
                width: 92.w,
              ),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Your Password?',
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 9.h),
                ],
              ),
              Text(
                'No Worries! Enter your email and we will send',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: HexColor('#9A9A9A'))),
              ),
              SizedBox(height: 4.h),
              Text(
                'you a reset',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: HexColor('#9A9A9A'))),
              ),
              SizedBox(height: 25.h),
              Container(
                height: 41.h,
                width: 336.w,
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 13, bottom: 14, left: 27),
                    prefixIcon: Container(
                 
                      child: Image(
                        image: AssetImage('assets/email_image/Group 680.png'),
                        // width: width*0.05,height: height*0.05
                      ),
                    ),
                    hintText: '@email.com',
                    hintStyle:
                 

                        GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: HexColor('#B7B7B7'))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor('#585858'),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(5.w)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#585858'), width: 1.w),
                        borderRadius: BorderRadius.circular(5.w)),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context,

                  //     MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Send request',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(336, 43),
                    primary: HexColor('#F8CE61'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
