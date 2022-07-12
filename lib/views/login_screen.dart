import 'package:flutter/material.dart';
import 'package:gatello/views/signup_screen.dart';

import 'package:hexcolor/hexcolor.dart';

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
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height*0.267),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(
                      fontSize: width*0.067,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Gatello',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           
              Text(
                'By continuing, you agree to Gatello\'s',
                style: TextStyle(
                  fontSize: width * 0.037,
                ),
              ),
              SizedBox(width: width * 0.008),
              InkWell(
                onTap: () {},
                child: Text(
                  'Terms of service',
                  style: TextStyle(
                    fontSize: width * 0.037,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
            SizedBox(height: height * 0.0045),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              Text(
                'and acknowledge our',
                style: TextStyle(
                  fontSize: width * 0.037,
                ),
              ),
              SizedBox(width: width * 0.0085),
              InkWell(
                onTap: () {},
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: width * 0.037,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: height * 0.028),
          Container(
            height: height * 0.052,
            width: width * 0.92,
            child: TextFormField(
              style: TextStyle(
                  fontSize: width * 0.045, fontWeight: FontWeight.w500),
              cursorColor: Colors.black,
              controller: phonenumber,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 4),
                prefix: Text(
                  '+91 ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.034),
                ),
                labelText: 'MOBILE NUMBER',
                labelStyle: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black,
                       width: width * 0.003),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black,
                         width: width * 0.004),
                    borderRadius: BorderRadius.circular(
                      width*0.015
                    )),
              ),
            ),
          ),
          SizedBox(height: height * 0.035),
          Container(
            height: height * 0.052,
            width: width * 0.92,
            child: TextFormField(
              style: TextStyle(
                  fontSize: width * 0.045, fontWeight: FontWeight.w500),
              cursorColor: Colors.black,
              controller: password,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 7),
                suffixIcon: Icon(
                  Icons.visibility,
                  size: width * 0.05,
                  color: Colors.black,
                ),
                labelText: 'PASSWORD',
                labelStyle: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(
                        color: Colors.black, 
                        width: width * 0.004),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(
                          color: Colors.black,
                           width: width * 0.004),
                    borderRadius: BorderRadius.circular(
                      width*0.015,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.016,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(5, 5),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()));
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: width * 0.0348,
                    fontWeight: FontWeight.w400
                  ),
                )),
          ]),
          SizedBox(height: height * 0.016),
          ElevatedButton(
            onPressed: () {
             
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
               
                padding: EdgeInsets.all(10),
                minimumSize: Size(width * 0.96, height * 0.073),
                primary: HexColor('#F8CE61'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width*0.018),
                )),
          ),
          SizedBox(height: height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New to Gatello?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: width*0.034
                ),
              ),
           SizedBox(width: width * 0.008),
           InkWell(
             child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.034),
                ),
           )
            ],
          ),
        ],
      ),
    );
  }
}
