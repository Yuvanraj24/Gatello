import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
body: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  
  children: [
    SizedBox(height:height*0.2 ),
      Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Your Password?',
                style: TextStyle(
                    fontSize: width * 0.073,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
                SizedBox(height: height*0.01,),
          
            ],
          ),
            SizedBox(height:height*0.015 ),
          Text(
            'No Worries! Enter your email and we will send',
            style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w400,
            
                color: HexColor('#9A9A9A')),
          ),
           Text(
            'you a reset',
            style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w400,
                color:  HexColor('#9A9A9A')),
          ),
           SizedBox(height:height*0.063 ),
           Container(
          height: height * 0.063,
          width: width * 0.92,
          child: TextFormField(
            cursorColor: Colors.black,
     
     //   textAlign: TextAlign.center,
            decoration: InputDecoration(
             //  contentPadding: EdgeInsets.only(top: width*0.0),
              prefixIcon: Icon(Icons.mail_outline_rounded,
              color: Colors.black,
              size: width*0.064,
              ),
        
              hintText: '@email.com',
           hintStyle: TextStyle(
            
                  fontSize: width * 0.04,
                  color:HexColor('#B7B7B7'),
                  fontWeight: FontWeight.w600),
        
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color:  HexColor('#585858'), width: width * 0.004),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black, 
                      width: width * 0.004),
                  borderRadius: BorderRadius.circular(
                    5,
                  )),
            ),
          ),
        ),
        SizedBox(height: height*0.05),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              'Send request',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
               
                padding: EdgeInsets.all(10),
                minimumSize: Size(width * 0.94, height * 0.082),
                primary: HexColor('#F8CE61'),
           
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
          SizedBox(height: height*0.28,),
        Container(
height:height*0.007,
width: width*0.4,
decoration: BoxDecoration(
  color: Colors.black,
borderRadius: BorderRadius.circular(width*0.9)
),

              )
  ],
),
    );
  }
}