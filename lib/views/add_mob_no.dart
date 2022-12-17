import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import '../Helpers/StateHelper.dart';
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

enum ButtonState{init,loading,done}
class _AddMobileNumberState extends State<AddMobileNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumber =TextEditingController();
  String countryCode = '+91';
  ButtonState state=ButtonState.init;
  bool isAnimating=true;
  ValueNotifier<Tuple4> sendOtpValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  String? password;
  @override
  void initState() {
    password=getData("password");


  }
  @override
  Widget build(BuildContext context) {
    final isStretched=isAnimating||state==ButtonState.init;
    final isDone=state==ButtonState.done;
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                        SizedBox(height: 30.h),
                        Text(
                          "A six digit Verification code will be sent to the above\nmobile number via SMS.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(

                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#646363'))),
                        ),
                        Spacer(),
                        AnimatedContainer(
                          height: 70,
                          width: state==ButtonState.init?200:70,
                          curve: Curves.easeIn,
                          onEnd: ()=> setState(() =>isAnimating=!isAnimating ),
                          duration: Duration(milliseconds: 500),

                          child:isStretched? AwesomeButton(context) : CircleButton(isDone),),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton AwesomeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: ()async {

        if (_formKey.currentState!.validate()) {
          sendOtp(widget.mobileNo!);
          setState(()=>state= ButtonState.loading);
          await Future.delayed(Duration(seconds: 2));
          setState(()=>state= ButtonState.done);
          await Future.delayed(Duration(seconds: 2));
          setState(()=>state= ButtonState.init);
          setData("mobileNum", widget.mobileNo.toString());
          setData("page","6");
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
    );
  }

  Future sendOtp(String phoneNumber) async {
    print('otp sentt');
    return await ApiHandler().apiHandler(
      valueNotifier: sendOtpValueNotifier,
      jsonModel: defaultFromJson,
      url: sendOTPUrl,
      requestMethod: 1,
      body: {"number": int.parse(phoneNumber)},
    );
  }

  Widget CircleButton(bool isDone){

    return Container(decoration: BoxDecoration(shape: BoxShape.circle,
        color:isDone?Colors.green:Color.fromRGBO(248, 206, 97, 1) ),
        child: Center(child:isDone?Icon(Icons.done,color: Colors.white,)
            : CircularProgressIndicator(color: Colors.black,)));
  }
}