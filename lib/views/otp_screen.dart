import 'dart:async';
import 'dart:convert';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/add_email.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tuple/tuple.dart';
import '../../handler/Network.dart';
import '../Helpers/StateHelper.dart';
import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../Style/Colors.dart';
import '../Style/Text.dart';
import '../core/Models/Default.dart';
import '../core/models/exception/pops_exception.dart';

class Otp extends StatefulWidget {
  String birthDay;
  String userName ;
  String name;
  String password;
  String mobileNo;
  TextEditingController otpController = TextEditingController();

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

  bool loading = false;
  ValueNotifier<Tuple4> verifyOtpValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> sendOtpValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  int _counter = 60;
  Timer? _timer;

  void _startTimer() {
    _counter = 30;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer!.cancel();
        }
      });
    });
  }
  Future<void> register(body) async {
    print(body.toString());

    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('http://3.110.105.86:2022/create/unregister'));
      request.body = json.encode({
        "name": "${widget.name}",
        "dob": "${widget.birthDay}",
        "phone": "${widget.mobileNo}"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("status code 200 success");
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
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


  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {

    String comingSms;

    try {
      comingSms = (await AltSmsAutofill().listenForSms)!;

      print('Lotus88${comingSms}');
      print('yuvan${comingSms.contains('Gatello')}');
      if(comingSms.contains('Gatello')) {
        if (!mounted) return;
        setState(() {
          _comingSms = comingSms;
          print("====>Message: ${_comingSms}");
          print("${_comingSms[32]}");
          widget.otpController?.text =
              _comingSms[20] + _comingSms[21] + _comingSms[22] + _comingSms[23]
                  + _comingSms[24] +
                  _comingSms[25]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
        });
      }
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }


    print('otp has done${ widget.otpController?.text}');
  }
  String? mobileNum;
  @override
  void initState(){
    mobileNum=getData("mobileNum");
    super.initState();
    _startTimer();
    widget.otpController = TextEditingController();
    initSmsListener();


  }
  @override
  void dispose() {
    widget.otpController!.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print('test7${verifyOtpValueNotifier.value}');

    double curWidth = MediaQuery.of(context).size.width;
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
            child: Container(
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
                        widget.mobileNo,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 16.h),
                      Container(

                        //   color: Colors.pink,

                        height: 81.h,
                        child:PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            inactiveColor: HexColor('#646363'),
                            activeColor: HexColor('#646363'),
                            selectedColor: HexColor('#646363'),
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            inactiveFillColor: Colors.white,
                            // inactiveColor: ColorUtils.greyBorderColor,
                            // selectedColor: ColorUtils.greyBorderColor,
                            selectedFillColor: Colors.white,
                            activeFillColor: Colors.white,
                            // activeColor: ColorUtils.greyBorderColor
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          enableActiveFill: true,
                          controller: widget.otpController,
                          keyboardType: TextInputType.number,

                          onCompleted: (value) {

                            value==widget.otpController?.text;


                            print('Lotus32${  value}');
                            print('Lotus33${  widget.otpController?.text}');

                            verifyOtp1(widget.mobileNo,widget.otpController!.text).then((value) => Fluttertoast.showToast(
                                msg: "OTP VERIFIED",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1)).then((value) => navigateToNext());

                            //do something or move to next screen when code complete
                          },
                          onChanged: (value) {
                            value==widget.otpController?.text;
                            // widget.otp==value;
                            print('Lotus42${  value}');
                            print('Lotus43${  widget.otpController?.text}');
                          },

                        ),

                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: otpResend(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setData('otp',widget.otpController!.text.toString() );
                          setData("page","7");
                          verifyOtp1(widget.mobileNo,widget.otpController!.text).then((value) => navigateToNext());
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
        ),
      ),
    );
  }
  navigateToNext(){
    if(verifyOtpValueNotifier.value.item1==1) {
      print("Navigate is working...!");
      var body = jsonEncode(<String, dynamic>{
        "name": widget.name.toString(),
        "dob": widget.birthDay.toString(),
        "phone": widget.mobileNo.toString(),
      });
      register(body).then((value) =>
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  AddEmail(
                    name: widget.name,
                    birthDay: widget.birthDay,
                    userName: widget.userName,
                    password: widget.password,
                    mobileNo: widget.mobileNo,
                    otp: widget.otpController.text,
                  ))));

    }
    else{
      Fluttertoast.showToast(
          msg: "Invalid Otp",

          timeInSecForIosWeb: 1);
    }
  }
  Future verifyOtp1(String phoneNumber, String otp) async {

    return await ApiHandler().apiHandler(
      valueNotifier: verifyOtpValueNotifier,
      jsonModel: defaultFromJson,
      url: verifyOTPUrl,
      requestMethod: 1,
      body: {"number": int.parse(phoneNumber), "otp": int.parse(otp)},

    );
  }
  Future<void> verifyotp() async {
    print('test7${verifyOtpValueNotifier.value.item1}');
    //print(body.toString());
    var body = jsonEncode(<String, dynamic>{
      "number": widget.mobileNo,
      "otp":widget.otpController?.text
    });

    try {
      var url = Uri.parse("http://3.108.219.188:5000/verifyotp");
      var response = await http.post(url, body: body);

      if(verifyOtpValueNotifier.value.item1==1){
        if (response.statusCode == 200) {
          print(response.body.toString());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEmail(
                name: widget.name,birthDay: widget.birthDay, userName: widget.userName,password: widget.password, mobileNo: widget.mobileNo,otp: widget.otpController!.text,

              )));
        }

      }
    } catch (e) {
      print(e.toString());
    }
  }
  Widget otpResend() {
    return Column (
      children: [
        (_counter > 0)
            ? Container()
            : Text(
          "Didn't receive OTP ?",
          style: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey), fontSize: 12)),
        ),
        TextButton(
          onPressed: (_counter > 0)
              ? null
              : () async {
            widget.otpController?.clear();
            await sendOtp(widget.mobileNo);
            _startTimer();
            initSmsListener();
          },
          child: (_counter > 0)
              ? Text(
            "Resend OTP in 00:${(_counter<=9?"0$_counter":_counter)} seconds",
            style: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey), fontSize: 12)),
          )
              : Text(
            "Send again",
            style: GoogleFonts.poppins(textStyle: textStyle(color: Color(accent), fontSize: 14)),
          ),
        )
      ],
    );
  }
}