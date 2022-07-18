import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/validator/validator.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:gatello/views/splash_screen4.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  final _formkey = GlobalKey<FormState>();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: Form(
          key: _formkey,
          child: Container(
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
                      'Reset Your Password?',
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
                  'Enter a new password',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#9A9A9A'))),
                ),

                SizedBox(height: 31.h),
                Container(
                  height: 41.h,
                  width: 336.w,
                  child: TextFormField(
                    controller: _newPasswordController,
                 
                      validator: (value) => resetPasswordValidator(value: value),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      errorStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 163, 255, 1))),
                      contentPadding:
                          EdgeInsets.only(top: 13, bottom: 14, left: 27),
                      hintText: 'New password',
                      hintStyle: GoogleFonts.roboto(
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
                          borderSide: BorderSide(
                              color: HexColor('#585858'), width: 1.w),
                          borderRadius: BorderRadius.circular(5.w)),
                      suffixIcon: Container(
                        child: Image(
                          image: AssetImage(
                              'assets/icons_assets/visibility_icon.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
     
                Container(
                  height: 41.h,
                  width: 336.w,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (_confirmPasswordController.text ==
                          _newPasswordController.text) {
                        return null;
                      } else {
                        return 'Both password must match';
                      }
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 13, bottom: 14, left: 27),
                      hintText: 'Confirm password',
                      hintStyle: GoogleFonts.roboto(
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
                          borderSide: BorderSide(
                              color: HexColor('#585858'), width: 1.w),
                          borderRadius: BorderRadius.circular(5.w)),
                      suffixIcon: Container(
                        child: Image(
                          image: AssetImage(
                              'assets/icons_assets/visibility_icon.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                ElevatedButton(
                  onPressed: () {
                    

                    if (_formkey.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())
                              );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Text("Login Failed"),
                            );
                          });
                    }
                  },
                  child: Text(
                    'Confirm',
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
      ),
    );
  }
}
