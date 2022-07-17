import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../validator/validator.dart';

class AddEmail extends StatefulWidget {
  const AddEmail({Key? key}) : super(key: key);

  @override
  State<AddEmail> createState() => _AddEmailState();
}

class _AddEmailState extends State<AddEmail> {
  String? _email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 55.h,
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
              left: 12.w, right: 12.w, top: 163.h, bottom: 35.h),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add your email address",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    'This can help recover your account if you',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: 14.h),
                  Text(
                    'forget your password!',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Container(
                    width: 310.w,
                    child: TextFormField(
                      cursorColor: HexColor('#0B0B0B'),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#0B0B0B'))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#0B0B0B'))),
                        labelStyle: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        labelText: "EMAIL",

                      ),
                      validator: (value) => emailValidator(value),
                      onChanged: (val) {
                        _email = val;
                      },
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      print("EMAIL : $_email");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Otp()));
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
                        //  padding: EdgeInsets.all(10),
                        minimumSize: Size(234.w, 53.h),
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
}
