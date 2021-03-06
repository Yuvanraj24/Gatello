import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {
  String birthDay = "";
  String userName = "";
  String name = "";
  String password = "";
  String mobileNo = "";
  String? otp;

  Otp({
    required this.name,
    required this.userName,
    required this.birthDay,
    required this.password,
    required this.mobileNo,
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  OtpFieldController _otpController = OtpFieldController();
  String otpText = "";
  
  @override
  Widget build(BuildContext context) {

    // double height = MediaQuery.of(context).size.height;
    double curWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        
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
          padding: EdgeInsets.only(
              left: 12.w, right: 12.w, top: 150.h, bottom: 35.h),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Enter confirmation code",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    'Enter the code we sent to',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '98745 32789',
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ),
                //  SizedBox(height: 13.h),
                  //    Container(
                  //   height: 81.h,
                  //   child: OTPTextField(
                  //     isDense: true,

                  //     controller: _otpController,

                  //     length: 6,

                  //     fieldStyle: FieldStyle.underline,
                  //     contentPadding: EdgeInsets.all(17.h),

                  //     width: curWidth * 0.68,

                  //     fieldWidth: 46.w,
                  //     otpFieldStyle: OtpFieldStyle(
                  //       backgroundColor: Colors.transparent,
                  //       borderColor: Colors.pink,
                  //       focusBorderColor: Colors.black,
                  //       enabledBorderColor: Colors.black,
                  //       errorBorderColor: Colors.red,
                  //     ),
                  //     // outlineBorderRadius: 5,
                  //     style: GoogleFonts.inter(
                  //         textStyle: TextStyle(
                  //             fontSize: 32.sp,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.black)),
                  //     onChanged: (pin) {},
                  //     onCompleted: (pin) {
                  //   //    widget.otp = pin;
                  //       //return pressEvent();
                  //     },
                  //   ),
                  // ),
                  Container(
                   
                 //   color: Colors.pink,
                    height: 81.h,
                    child: OTPTextField(
                 keyboardType: TextInputType.number,
                   // textFieldAlignment: MainAxisAlignment.spaceBetween,
                  //    isDense: true,

                      controller: _otpController,
                      length: 6,
                      fieldStyle: FieldStyle.underline,
                     // contentPadding: EdgeInsets.all(17.h),
                      width: curWidth * 0.88,
                      fieldWidth: 50.w,
                      otpFieldStyle: OtpFieldStyle(                       
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.pink,
                        focusBorderColor: Colors.black,
                        enabledBorderColor: Colors.black,
                        errorBorderColor: Colors.red,
                      ),
                      // outlineBorderRadius: 5,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      onChanged: (pin) {},
                      onCompleted: (pin) {
                        widget.otp = pin;
                        //return pressEvent();
                      },
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      print(widget.name);
                      print(widget.birthDay);
                      print(widget.userName);
                      print(widget.password);
                      print(widget.mobileNo);
                      print(widget.otp);

                      verifyotp();
                    },
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        onPrimary: Colors.black,
                        minimumSize: Size(234.w, 48.h),
                        primary: Color.fromRGBO(248, 206, 97, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
  
  Widget pressEvent() {
    return Container();
  }

  Future<void> verifyotp() async {
    //print(body.toString());
    var body = jsonEncode(<String, dynamic>{
      "number": widget.mobileNo,
      "otp":widget.otp
    });

    try {
      var url = Uri.parse("http://3.108.219.188:5000/verifyotp");
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        print(response.body.toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddEmail(
              name: widget.name,birthDay: widget.birthDay, userName: widget.userName,password: widget.password, mobileNo: widget.mobileNo,otp: widget.otp.toString(),

            )));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
