import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../utils/fire_auth.dart';
import '../validator/validator.dart';

class AddEmail extends StatefulWidget {
  String birthDay = "";
  String userName = "";
  String name = "";
  String password = "";
  String mobileNo = "";
  String otp = "";
  String? email;
  AddEmail({
    required this.name,
    required this.userName,
    required this.birthDay,
    required this.password,
    required this.mobileNo,
    required this.otp,
  });


  @override
  State<AddEmail> createState() => _AddEmailState();
}

class _AddEmailState extends State<AddEmail> {
    final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController =TextEditingController();
  String? _email;
  @override
  Widget build(BuildContext context) {
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
        body: Form(
         // autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 150.h, bottom: 35.h),
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(width: 14.h),
                    Text(
                      'forget your password!',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
//                     Form(
//   autovalidate: true,
//   child: TextFormField(
//     validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
//   ),
// ),
                    Container(
                      width: 310.w,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
            validator: (value)=>emailValidator(value),
                        controller: _emailController,

                        onChanged: (val) {
                          widget.email = _emailController.text.toString();
                        },
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
                        // validator: (value) => emailValidator(value),
                        // onChanged: (val) {
                        //   _email = val;
                        // },
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                       // print("EMAIL : $_email");
                        if (_formKey.currentState!.validate()) {
            Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddProfilePic()));
        } else {
          return null;
        }

//         Form(
//   autovalidate: true,
//   child: TextFormField(
//     validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
//   ),
// )
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
      ),
    );
  }
    registerFirebase(name, email, password) async {
      User? user = await FireAuth.registerUsingEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      var body = jsonEncode(<String, dynamic>{
        "user_id": user!.uid,
        "name": widget.name,
        "phone": "+91${widget.mobileNo}",
        "member": "Since ${DateTime.now().year}",
        "email": widget.email,
        "username": widget.userName,
        "password": widget.password,
      });

      if (user != null) {
        register(body);
        print("succeed");
      }
      // else if(){

      // }
      else {
        print("error in passing mongoDB");
      }
    }

    Future<void> register(var body) async {
      print(body.toString());

      try {
        var url = Uri.parse("http://3.108.219.188:5000/signup");
        var response = await http.post(url, body: body);

        if (response.statusCode == 200) {
          print(response.body.toString());
        } else {
          print(response.statusCode);
        }
      } catch (e) {
        print(e.toString());
      }
    }
}
