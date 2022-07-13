import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var hh = 5.23.h;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding:
              EdgeInsets.only(top: 23.h, bottom: 3.75.h, left: 3.w, right: 3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(height: height*0.27),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to gatello',
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 3.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  )
                ],
              ),
              SizedBox(height: 2.37.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By continuing, you agree to Gatello\'s',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: width * 0.008),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Terms of service',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 1.62.h,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#00A3FF'))),
                    ),
                  )
                ],
              ),
              SizedBox(height: 0.6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'and acknowledge our',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: width * 0.0085),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Privacy Policy',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 1.62.h,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#00A3FF'))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 2.75.h,
              ),
              Container(
                height: 5.25.h,
                width: 93.3.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  controller: phonenumber,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    prefix: Text(
                      '+91 ',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 1.87.h,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    labelText: 'MOBILE NUMBER',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black, width: 0.32.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 0.28.w),
                        borderRadius: BorderRadius.circular(1.3.w)),
                  ),
                ),
              ),
              SizedBox(height: 3.5.h),
              Container(
                height: 5.25.h,
                width: 93.3.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  controller: password,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    suffixIcon: Icon(
                      Icons.visibility,
                      size: 2.h,
                      color: Colors.black,
                    ),
                    labelText: 'PASSWORD',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black, width: 0.28.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 0.28.w),
                        borderRadius: BorderRadius.circular(1.3.w)),
                  ),
                ),
              ),
              SizedBox(height: 1.6.h),
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
                            fontSize: 1.5.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
                ),
              ]),
              SizedBox(height: 1.6.h),
              ElevatedButton(
                onPressed: () {
                  print("$height");
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 2.12.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(93.3.w, 5.37.h),
                    primary: HexColor('#F8CE61'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.018),
                    )),
              ),
              SizedBox(height: 2.75.h),
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
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: width * 0.008),
                  InkWell(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 1.6.h,
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
