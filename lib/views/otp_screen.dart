import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
OtpFieldController _otpController=OtpFieldController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter confirmation code',
                style: TextStyle(
                    fontSize: width * 0.074,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the code we sent to',
                style: TextStyle(
                    fontSize: width * 0.037,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#646363')),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           //   SizedBox(width: width * 0.31),
              Text(
                '98745  32789',
                style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ],
          ),
SizedBox(height: height*0.000),

  Container(
  height: 42,
    child: OTPTextField(
     
     //margin: EdgeInsets.symmetric(horizontal: 4),
              controller: _otpController,
              outlineBorderRadius: 100,
             //spaceBetween: 1,
         
              length: 4,
              fieldStyle: FieldStyle.underline,
             contentPadding: EdgeInsets.all(5),
             // contentPadding:EdgeInsets.symmetric(horizontal: width*0.002),
           //),
             // width:width*0.5,
           //  width: MediaQuery.of(context).size.width,
         
           width: width*0.7,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth:25,
          
       otpFieldStyle: OtpFieldStyle(

       ),
             // outlineBorderRadius: 5,
              style: TextStyle(fontSize: width*0.1,
              fontWeight: FontWeight.w700),
              onChanged: (pin) {
                print("Changed: " + pin);
              },
              onCompleted: (pin) {
               print("Completed: " + pin);
              }
              ),
  ),
          SizedBox(
            height: height * 0.36,
          ),
          ElevatedButton(
            onPressed: () {
              //  Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ()));
            },
            child: Text(
              'Resend in 55',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
                elevation: 5,
                onPrimary: Colors.black,
                padding: EdgeInsets.all(10),
                minimumSize: Size(width * 0.7, height * 0.086),
                primary: HexColor('#F8CE61'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                )),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.007,
                width: width * 0.42,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(width * 0.92)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
