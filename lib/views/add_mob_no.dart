import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../core/Models/Default.dart';
import '../core/models/exception/pops_exception.dart';
import '../handler/Network.dart';
import '../validator/validator.dart';

class AddMobileNumber extends StatefulWidget {
  String birthDay;
  String userName;
  String name;
  String password ;
  String? mobileNo;

  AddMobileNumber({
    required this.name,
    required this.userName,
    required this.birthDay,
    required this.password,
  });

  @override
  State<AddMobileNumber> createState() => _AddMobileNumberState();
}


class _AddMobileNumberState extends State<AddMobileNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumber =TextEditingController();
  String countryCode = '+91';

  ValueNotifier<Tuple4> sendOtpValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
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
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(
                  left: 12.w, right: 12.w, top: 100.h, bottom: 35.h),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Almost done!",
                        style: GoogleFonts.gelasio(
                            textStyle: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Add your mobile",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "number?",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "You will be using this mobile number to login into",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'your account.',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        //color: Colors.blue,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MOBILE NUMBER',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                      color:Colors.black)),
                            ),
                            Container(
                              // color: Colors.pink.shade100,
                              height: 43.h,
                              child: TextFormField(
                                enabled: false,

                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: HexColor('#0B0B0B'),
                                        //  width: 3.w
                                      )),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: HexColor(
                                          '#0B0B0B',
                                        ),
                                        //  width: 3.w
                                      )),
                                  prefixIcon: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'icons/flags/png/in.png',
                                        package: 'country_icons',
                                        width: 20.w,
                                        //height: 21,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "India",
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 12.h,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  suffixIcon: Image.asset(
                                    "assets/icons_assets/down_arrow.png",
                                    width: 3.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Container(
                                    width: 51.w,
                                    child: TextFormField(
                                      enabled:false,
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: HexColor('#0B0B0B'),
                                                  width: 1.12.w
                                              )
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: HexColor('#0B0B0B'),
                                                  width: 1.12.w
                                              )),
                                          prefixIcon: Center(
                                              child: Text("+${91}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 14.h,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: Colors.black))))),
                                    )),
                                SizedBox(width: 20.w),
                                Container(
                                  width: 265.w,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      controller: _mobileNumber,
                                      onChanged: (val) {
                                        widget.mobileNo = _mobileNumber.text.toString();
                                      },
                                      cursorWidth: 2,
                                      cursorColor: HexColor('#0B0B0B'),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: HexColor('#0B0B0B'),
                                                width: 1.12.w)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: HexColor('#0B0B0B'),
                                                width: 1.12.w)),
                                        // disabledBorder: UnderlineInputBorder(
                                        //     borderSide: BorderSide(color:HexColor('#0B0B0B'))
                                        //   ),
                                      ),
                                      validator: (value) => phoneValidator(
                                          countryCode + " " + value!)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 26.h),
                      Text(
                        "We'll send you a text verification code.",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          sendOtp(widget.mobileNo!);
                          if (_formKey.currentState!.validate()) {
                            print(widget.name);
                            print(widget.birthDay);
                            print(widget.userName);
                            print(widget.password);
                            print(widget.mobileNo);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Otp(
                                      name: widget.name,
                                      birthDay: widget.birthDay,
                                      userName: widget.userName,
                                      password: widget.password,
                                      mobileNo: widget.mobileNo.toString(),

                                    )));
                          } else {
                            return null;
                          }
                        },
                        child: Text(
                          'Verify mobile number',
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
        ),
      ),
    );
  }

  Future sendOtp(String phoneNumber) async {
    return await ApiHandler().apiHandler(
      valueNotifier: sendOtpValueNotifier,
      jsonModel: defaultFromJson,
      url: sendOTPUrl,
      requestMethod: 1,
      body: {"number": int.parse(phoneNumber)},
    );
  }

  Future<void> sendotp() async {
    //print(body.toString());
    var body = jsonEncode(<String, dynamic>{
      "number": widget.mobileNo,
    });

    try {
      var url = Uri.parse("http://3.108.219.188:5000/sendotp");
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