import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/handler/SharedPrefHandler.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:gatello/views/welcome_back.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/Authentication.dart';
import '../Helpers/StateHelper.dart';
import '../main.dart';
import '../validator/validator.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  String? mob;
  String? pw;



  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name;
  @override
  void initState() {
    name = getData("name1") ;// TODO: implement initState
    super.initState();
    check_if_already_login();

  }


  late SharedPreferences logindata;
  late bool newuser;
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.push(context, PageTransition(
          duration: Duration(milliseconds: 120),
          type: PageTransitionType.rightToLeft, child:Tabbar()));
    }
  }


  bool isHidden= true;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  FirebaseFirestore instance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return  GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Form(
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
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                         // border: InputBorder.none,
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
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
                          ),
                          focusedErrorBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              // borderRadius: BorderRadius.circular(5.w)
                              borderRadius: BorderRadius.circular(6)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.w),
                              //  borderRadius: BorderRadius.circular(5.w)
                              borderRadius: BorderRadius.circular(6)
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
                          ),
                          focusedErrorBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black, width: 1.w),
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
                          if(_formkey.currentState!.validate()){
                            var body = jsonEncode(<String, dynamic>{
                              "credential_1": "+91${widget.mob}",
                              "password": widget.pw,
                            });
                            if(signin(body)==null){
                              CircularProgressIndicator();
                            }
                            signin(body);
                          }
                          else{
                            return null;
                          }
                          //loginFirebase(widget.mob, widget.pw);


                          // String username = _mobileNumber.text;
                          // String password = _password.text;
                          // if (username == jsonEncode(<String, dynamic>{"credential_1": "+91${widget.mob}"}) && password == jsonEncode(<String, dynamic>{"password": widget.pw})) {
                          //   print("username : ${username} - password : ${password}" );
                          //   print('Successfull');
                          //   logindata.setBool('login', false);
                          //   logindata.setString('username', username);
                          //   Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) => Tabbar()));
                          // }
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
                              print('yyyyyy');
                              String data=getData('page');
                              print('Lotus76${data.toString()}');

                              switch(data.toString()){

                                case "2":{
                                  print('namedata${name.toString()}');
                                  print('success');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }

                                break;
                                case "3":{

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                case "4":{
                                  print('namedata${name.toString()}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                case '5':{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                case '6':{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                case '7':{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                case '8':{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeBack()));
                                }
                                break;
                                default:{
                                  print('failed');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()));
                                }
                              }
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
          ),
        );
   
  }

  Future<void> signin(var body) async {

    print(body.toString());
    print(body);

    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('http://3.110.105.86:4000/login'));
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      request.body = json.encode({
        "username": "+91${widget.mob}",
        "password": widget.pw,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();


      if (response.statusCode == 200) {
        print("The Body -- ${request.body}");

        print("status code 200 success");
        //print("Res ${await response.stream.bytesToString()}");
        var resp = await response.stream.bytesToString();
        Map<String, dynamic> map = json.decode(resp.toString());
        String status = map['status'];
        print("STATUS:"+status);
        //print(await response.stream.bytesToString());

        if(status == "OK")
        {
          print('okkkkkkkkkkkkk');
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
          String username = _mobileNumber.text;
          logindata.setBool('login', false);
          logindata.setString('username', username);

          SharedPrefHandler sharedPrefHandler=new SharedPrefHandler();
          sharedPrefHandler.writeUserInfo(map1['user_id'], map1['email'], map1['root_folder_id']);
          await instance.collection("user-detail").doc(map1['user_id']).update({"token": await getFCMToken()});
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => Tabbar()));


        }else{
          print("Message is from Login Api : ${jsonEncode(map['message'])}");
          Fluttertoast.showToast(
              msg: "${map['message']}",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1);
        }
      }
      else {
        print("Response of rp : ${response.reasonPhrase}");
      }
    } catch (e) {
      print("hello this is  ${e.toString()}");
    }
  }

  shared()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', 'password');
    print(prefs.setString('mobile', 'password'));
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 120),
        type: PageTransitionType.rightToLeft, child: Tabbar()));
  }
}