import 'dart:convert';
//import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/handler/SharedPrefHandler.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/Authentication.dart';
import '../validator/validator.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {

  String? mob;
  String? pw;


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHidden= true;
  String? userId;
    final _formkey = GlobalKey<FormState>();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userId = sharedPrefs.getString("userid");

    print("ShardPref ${userId}");
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formkey,
          child: Container(
            padding:EdgeInsets.only(bottom: 180.h, top: 120.h, left: 12.w, right: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Welcome to',
                      style: GoogleFonts.fredoka(textStyle: TextStyle(
                              fontSize: 24.sp,fontWeight: FontWeight.w500,color: Colors.black)),
                    ),
                    SizedBox(width: 8.w),
                    Text('Gatello', style: TextStyle(fontSize: 25.sp))
                  ],
                ),
                SizedBox(height: 19.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By continuing, you agree to Gatello\'s',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: height*0.016,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Terms of service',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: height*0.016,
                                fontWeight: FontWeight.w400,
                                color: HexColor('#00A3FF'))),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'and acknowledge our',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: height*0.016,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Privacy Policy.',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                            fontSize: height*0.016,
                                fontWeight: FontWeight.w400,
                                color: HexColor('#00A3FF'))),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 23.h,
                ),
                Container(
                  height: 42.h,
                  width: 336.w,
                  child: TextFormField(
              keyboardType:TextInputType.number ,
   validator: (value) => phoneValidator(value),
                    style: TextStyle(
                        fontSize:13.sp, fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    controller: _mobileNumber,
                    onChanged: (val){
                        widget.mob = _mobileNumber.text.toString();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      prefix: Text(
                        '+91 ',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: HexColor('#646363'))),
                      ),
                      labelText: 'MOBILE NUMBER',
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.w),
                         // borderRadius: BorderRadius.circular(5.w)
                     borderRadius: BorderRadius.circular(6)
                        ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.w),
                           //  borderRadius: BorderRadius.circular(5.w)
                        borderRadius: BorderRadius.circular(6)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
             




//                   validator: (value){
// if (value!.isEmpty) {
//   return 'Please enter your number';

// } else {

//   return null;
  
// }

//                   },
            // validator: (value) {
            //             if (value!.length >= 8) {
            //               if (RegExp(r'^[0-9]+$').hasMatch(value) &&
            //                   RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            //                 return null;
            //               }
            //             } else {
            //               return 'Must be at 8 characters and contain at least one Letter, one number ';
            //             }
            //           },
                      //      validator: (value) {
                      //   if (_password.text ==
                      //       _mobileNumber.text) {
                      //     return null;
                      //   } else {
                      //     return 'Both password must match';
                      //   }
                      // },
                         Container(
                  height: 42.h,
                  width: 336.w,
                  child: TextFormField(

                 validator: (value)=> passwordValidator(value: value),
                    style: TextStyle(
                        fontSize:13.sp,
                         fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    obscureText:isHidden,
                    controller:_password,
                    onChanged: (val){
                        widget.pw = _password.text.toString();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.h),
                      suffixIcon: GestureDetector(
                        onTap:() {
                           setState(() {
                             isHidden=!isHidden;
                           });
                        },
                        child:isHidden?Icon(Icons.visibility_off, size: 18.sp,color: Colors.black):
                        Icon(Icons.visibility, size: 18.sp,color: Colors.black)),
                      labelText: 'PASSWORD',
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.w),
                           borderRadius: BorderRadius.circular(6)
                          ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(6)
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 13.h),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  InkWell(child: Text('Forgot Password?',
                      style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 11.sp,
                          fontWeight: FontWeight.w400, color: HexColor('#00A3FF')))),
        onTap:(){
           Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
        }
        
                  ),
                ]),
                SizedBox(height: 13.h),
                ElevatedButton(

                  onPressed: () {
                    //loginFirebase(widget.mob, widget.pw);

                    var body = jsonEncode(<String, dynamic>{
                      "credential_1": "+91${widget.mob}",
                      "password": widget.pw,
                      "notification_token": ""
                    });
                    if(signin(body)==null){
                      CircularProgressIndicator();
                    }
                    signin(body);

                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                      // padding: EdgeInsets.all(10),
                      minimumSize: Size(336.w, 43.h),
                      primary: HexColor('#F8CE61'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to Gatello?',
                      // style: TextStyle(
                      //   color: Colors.black,
                      //   fontWeight: FontWeight.w400,
                      // fontSize: 1.6.h
                      // ),
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Future<void> signin(var body) async {
      print(body.toString());

      try {
        print('Login Working');
        var url = Uri.parse("http://3.108.219.188:5000/login");
        var response = await http.post(url, body: body);


        final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        if (response.statusCode == 200) {
          print(response.body.toString());
          Map<String, dynamic> map = jsonDecode(response.body.toString());
          String status = map['status'];
          print("STATUS:"+status);
          if(status=="OK")
          {
            Fluttertoast.showToast(
                msg: "Login Success",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1);
            final SharedPreferences prefs = await _prefs;
            String resultJson=jsonEncode(map['result']);
            print(jsonEncode(map['result']));
            Map<String, dynamic> map1 = jsonDecode(resultJson);
            print("LOGIN RESPONSE");
            // prefs.setString("userid",  map1['user_id']);
            // prefs.setString("email",  map1['email']);
            // prefs.setString("root_folder_id",  map1['root_folder_id']);

            SharedPrefHandler sharedPrefHandler=new SharedPrefHandler();
            sharedPrefHandler.writeUserInfo(map1['user_id'], map1['email'], map1['root_folder_id']);
          //  await instance.collection("user-detail").doc(map1['user_id']).update({"token": await getFCMToken()});
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => Tabbar()));


          }

        } else {
          print("hello ${response.statusCode}");
        }
      } catch (e) {
        print("hello this is  ${e.toString()}");
      }
    }
    shared()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('mobile', 'password');
      print(prefs.setString('mobile', 'password'));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => Tabbar()));
    }
}