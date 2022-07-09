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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
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
              SizedBox(width: width * 0.06),
              Text(
                'By continuing, you agree to Gatello\'s',
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(width: width * 0.008),
              InkWell(
                onTap: () {},
                child: Text(
                  'Terms of service',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: width * 0.06),
              Text(
                'and acknowledge our',
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(width: width * 0.008),
              InkWell(
                onTap: () {},
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: height * 0.03),
          Container(
            height: height * 0.07,
            width: width * 0.92,
            child: TextFormField(
              style: TextStyle(
                  fontSize: width * 0.045, fontWeight: FontWeight.w500),
              cursorColor: Colors.black,
              controller: phonenumber,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 7),
                prefix: Text(
                  '+91 ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.045),
                ),
                labelText: 'MOBILE NUMBER',
                labelStyle: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black, width: width * 0.004),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: width * 0.004),
                    borderRadius: BorderRadius.circular(
                      5,
                    )),
              ),
            ),
          ),
          SizedBox(height: height * 0.04),
          Container(
            height: height * 0.07,
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
                        BorderSide(color: Colors.black, width: width * 0.004),
                    borderRadius: BorderRadius.circular(
                      5,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.018,
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
                    fontSize: width * 0.035,
                  ),
                )),
          ]),
          SizedBox(height: height * 0.04),
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
                minimumSize: Size(width * 0.94, height * 0.082),
                primary: HexColor('#F8CE61'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
          SizedBox(height: height * 0.03),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Row(
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
               TextButton(onPressed: (){
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
               }, child:    Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.034),
                  ))
                ],
              )),
        ],
      ),
    );
  }
}
