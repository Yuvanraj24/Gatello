import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';

import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding:
              EdgeInsets.only(bottom: 220.h, top: 188.h, left: 12.w, right: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Gatello',
                    style: TextStyle(
                      fontSize: 25.sp,
                    ),
                  )
                ],
              ),
              SizedBox(height: 19.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By continuing, you agree to Gatello\'s',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Terms of service',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#00A3FF'))),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'and acknowledge our',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Privacy Policy.',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#00A3FF'))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 23.h,
              ),
              Container(
                height: 42.h,
                width: 336.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize:15.sp, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  controller: phonenumber,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    prefix: Text(
                      '+91 ',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    labelText: 'MOBILE NUMBER',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                       // borderRadius: BorderRadius.circular(5.w)
                   borderRadius: BorderRadius.circular(6)
                      ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                      //  borderRadius: BorderRadius.circular(5.w)
                      borderRadius: BorderRadius.circular(6)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Container(
                height: 42.h,
                width: 336.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize:12.sp,
                       fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  controller: phonenumber,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8.h),
                  
                    suffixIcon: Icon(
                      Icons.visibility,
                      size: 18.sp,
                      color: Colors.black,
                    ),
                    labelText: 'Password',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                         borderRadius: BorderRadius.circular(6)
                        ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                        borderRadius: BorderRadius.circular(6)
                        ),
                  ),
                ),
              ),
              SizedBox(height: 13.h),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  child: Text(
                    'Forgot Password?',
                    // style: TextStyle(
                    //   fontSize:1.5.h,
                    //   fontWeight: FontWeight.w400,
                    //   color: HexColor('#00A3FF')
                    // ),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
onTap:(){

   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
}

                ),
              ]),
              SizedBox(height: 13.h),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Login',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.all(10),
                    minimumSize: Size(336.w, 43.h),
                    primary: HexColor('#F8CE61'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
              ),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to Gatello?',
                    // style: TextStyle(
                    //   color: Colors.black,
                    //   fontWeight: FontWeight.w400,
                    // fontSize: 1.6.h
                    // ),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
