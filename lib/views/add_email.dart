import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gatello/Authentication/Authentication.dart';
import 'package:gatello/views/tabbar/account_success.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tuple/tuple.dart';
import '../Helpers/StateHelper.dart';
import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../core/Models/Default.dart';
import '../core/models/exception/pops_exception.dart';
import '../handler/Network.dart';
import '../utils/fire_auth.dart';
import '../validator/validator.dart';

class AddEmail extends StatefulWidget {
  String birthDay;
  String userName;
  String name;
  String password;
  String mobileNo;
  String otp ;
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

  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));

  Uint8List? userPicture;
  String? userPictureFileName;


  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController =TextEditingController();
  String? _email;
  String? token;
  getFcmToken()
  async{
    token= await getFCMToken();
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  var url;

  String? otp;
  @override
  void initState() {
    otp=getData("otp");


  }
  @override
  Widget build(BuildContext context) {

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
                    //Navigator.pop(context);
                  },
                  child: GestureDetector(onTap:() {
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
                  ),
                )),
          ),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: DoubleBackToCloseApp(

              snackBar: SnackBar(
                content: Text("Tap again to close app"),

              ),
              child: Form(
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
                              validator: (value)=>emailValidator(value!),
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
                              print("EMAIL : $_email");

                              if (_formKey.currentState!.validate() && _emailController.text.contains("@")) {
                                registerFirebase(widget.userName, widget.email, widget.password,);
                                profileDetailUpdateApiCallFormData();
                                // Navigator.push(context, PageTransition(
                                //     duration: Duration(milliseconds: 120),
                                //     type: PageTransitionType.rightToLeft, child:
                                //     Acountsuccess(mobileNo: widget.mobileNo ,username: widget.userName,password: widget.password, name: widget.name,birthDay: widget.birthDay,email: widget.email, uid: user?.uid)));
                                // AddProfilePic(mobileNo: widget.mobileNo ,username: widget.userName,password: widget.password, name: widget.name,birthDay: widget.birthDay,email: widget.email, uid: user?.uid),));

                              } else {
                                Fluttertoast.
                              showToast(msg: "Enter a valid Email ID");
                                return null;
                              }

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
          ),
        ),
      ),
    );
  }
  User? user;
  registerFirebase(name, email, password,) async {
    user = await FireAuth.registerUsingEmailPassword(
      name: name,
      email: email,
      password: password,
    );
    var body = jsonEncode(<String, dynamic>{
      "user_id": user?.uid,
      "name": widget.name,
      "phone": "+91${widget.mobileNo}",
      "member": "Since ${DateTime.now().year}",
      "dob" : "10/12/2000",
      "email": widget.email,
      "username": widget.userName,
      "password": widget.password,
      "profile_url": "https://c4.wallpaperflare.com/wallpaper/297/288/1009/5bd320d590bcf-wallpaper-preview.jpg"
    });

    if (user != null) {
      String uid=user!.uid;
      register(body);
      print("this is a body : ${body}");
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      await instance.collection("user-detail").doc(uid).set({
        "uid": uid,
        "name": widget.name,
        "username": widget.userName,
        "email": widget.email,
        "description": null,
        "createdAt": timestamp,
        "updatedAt": null,
        "phone": widget.mobileNo,
        "designation": null,
        "status": null,
        "chattingWith": null,
        "callStatus": false,
        "token": token,
        "lastseenStatus": true,
        "onlineStatus": true,
        "readRecieptStatus": true,
        "city": null,
        "company": null,
        "job": null,
        "college": null,
        "high_school": null,
        "interest":null,
        "relationship_status":null,
        "about": null,
        "dob":widget.birthDay,
        "blockList" : [],
        "blockedByList" : []

        // "blocked": null,
        // "userList": null
      });
      print("succeed");
    }
    // else if(){

    // }
    else {
      print("error in passing mongoDB");
    }
  }

  Future<void> add_dob_pic(var bod)async {
    print(bod.toString());
  }

  Future profileDetailUpdateApiCallFormData() async {
    print("Update api is called...!");
    var uid = user!.uid;
    return await ApiHandler()
        .apiHandler(valueNotifier: profileDetailsUpdateValueNotifier, jsonModel: defaultFromJson, url: editprofileUrl + "?profile_url=", requestMethod: 1, formData: [
      Tuple4("profile_file", userPicture!, "Image", "Jpeg")
    ],
        formBody: {
          "user_id": uid,
          "username": widget.userName,
          "name": widget.name,
          // "phone": countryCode + " " + phoneTextEditingController.text,
          "phone": "+91${widget.mobileNo}",
          "dob": widget.birthDay,
          "email": _emailController.text.toString(),
          "designation": "",
          "city": "",
          "member": "Since ${DateTime.now().year}",
          "company": "",
          "job": "",
          "college": "",
          "high_school": "",
          "interest": "",
          // "relationship_status": relationshipStatusTextEditingController.text,
          "relationship_status": "In Love...",
          "about": "",
        });
  }

  Future<void> register(var body) async {
    print(body.toString());

    try {
      var url = Uri.parse("http://3.108.219.188:5000/signup");
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        print(response.body.toString());
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        String status = map['status'];
        print("STATUS:"+status);
        if(status=="OK")
        {
          print("MONGO SUCCESS");
          Fluttertoast.showToast(
              msg: "Sign-Up Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1);

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>

          //  AddProfilePic(mobileNo: widget.mobileNo ,username: widget.userName,password: widget.password, name: widget.name,birthDay: widget.birthDay,email: widget.email, uid: user?.uid),), (route) => false);
          Acountsuccess(mobileNo: widget.mobileNo ,username: widget.userName,password: widget.password, name: widget.name,birthDay: widget.birthDay,email: widget.email, uid: user?.uid),), (route) => false);
        }
        else
        {
          // FireAuth.deleteUser(user);
        }


      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

}