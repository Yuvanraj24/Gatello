// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gatello/views/create_username.dart';
// import 'package:gatello/views/login_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';

// import '../validator/validator.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formkey = GlobalKey<FormState>();
//   TextEditingController _firstName = TextEditingController();
//   TextEditingController _lastName = TextEditingController();
//   // String? _firstName;
//   // String? _lastName;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           toolbarHeight: 55.h,
//           leading: Center(
//               child: TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               'Back',
//               style: GoogleFonts.roboto(
//                   textStyle: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black)),
//             ),
//           )),
//         ),
//         body: Form(
//           key: _formkey,
//           child: Container(
//             padding: EdgeInsets.only(bottom: 37.h, left: 12.w, right: 12.w),
//             child: Column(
//               children: [
//                 Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'What\'s Your Name?',
//                       style: GoogleFonts.fredoka(
//                           textStyle: TextStyle(
//                               fontSize: 28.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black)),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 14.h),
//                 Text(
//                   'Add your name so that your friends can find you',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 13.h,
//                           fontWeight: FontWeight.w500,
//                           color: HexColor('#646363'))),
//                 ),
//                 SizedBox(height: 39.h),
//                 Container(
//                   //  color: Colors.blue,
//                   height: 42.h,
//                   width: 336.w,
//                   child: TextFormField(
//                     controller: _firstName,

//                    // validator: (value) {
//                       //         if (value!.isNotEmpty && value.length >=2) {
//                       //           return null;
//                       //         }

//                       //         else if(value.length <2 && value.isNotEmpty){
//                       // return 'name too short';
//                       //         }
//               //      },
//                     style:
//                         TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(left: 8.h),
//                       labelText: 'First Name',
//                       labelStyle: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.w),
//                           borderRadius: BorderRadius.circular(6)),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.w),
//                           borderRadius: BorderRadius.circular(6)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 Container(
//                   height: 42.h,
//                   width: 336.w,
//                   child: TextFormField(
//                     // validator: (value) {
//                     //   if (value!.isNotEmpty && value.length >= 1) {
//                     //     return null;
//                     //   } else {
//                     //     return 'name too short';
//                     //   }
//                     // },
//                     controller: _lastName,
//                     // validator: (value){
//                     //   if (value!.isEmpty) {
//                     //     return 'Please enter your name';
//                     //   } else {
//                     //     return null;
//                     //   }
//                     // },
//                     style:
//                         TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
//                     cursorColor: Colors.black,

//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(left: 8.h),
//                       labelText: 'Last Name',
//                       labelStyle: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.w),
//                           borderRadius: BorderRadius.circular(6)),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.w),
//                           borderRadius: BorderRadius.circular(6)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'By tapping "Sign Up", you acknowledge & agree',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.w400,
//                           color: HexColor('#646363'))),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'to  our',
//                       style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w400,
//                               color: HexColor('#646363'))),
//                     ),
//                     SizedBox(width: 5.w),
//                     InkWell(
//                       onTap: () {},
//                       child: Text(
//                         'Terms of Service',
//                         style: GoogleFonts.inter(
//                             textStyle: TextStyle(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: HexColor('#00A3FF'))),
//                       ),
//                     ),
//                     SizedBox(width: 5.w),
//                     Text(
//                       'and',
//                       style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w400,
//                               color: HexColor('#646363'))),
//                     ),
//                     SizedBox(width: 5.w),
//                     InkWell(
//                       onTap: () {},
//                       child: Text(
//                         'Privacy Policy',
//                         style: GoogleFonts.inter(
//                             textStyle: TextStyle(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: HexColor('#00A3FF'))),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 225.h),
//                 ElevatedButton(
//                   onPressed: () {
//                    Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => CreateUsername()));

//                     // if (_formkey.currentState!.validate()) {
//                     //   Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //           builder: (context) => CreateUsername()));
//                     // } else {
//                     //   showDialog(
//                     //       context: context,
//                     //       builder: (context) {
//                     //         return Dialog(
//                     //           child: Text("Login Failed"),
//                     //         );
//                     //       });
//                     // }
//                   },
//                   child: Text(
//                     'Sign Up',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                       elevation: 5,
//                       onPrimary: Colors.black,
//                       //   padding: EdgeInsets.all(10),
//                       minimumSize: Size(234.w, 53.h),
//                       primary: HexColor('#F8CE61'),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(35),
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// //   Container _lastNamecon(double height, double width) {

// //     return
// //         Container(
// //                 height: 42.h,
// //                 width: 336.w,
// //                 child: TextFormField(
// //                   style: TextStyle(
// //                       fontSize:12.sp,
// //                        fontWeight: FontWeight.w500),
// //                   cursorColor: Colors.black,

// //                   decoration: InputDecoration(
// //                     contentPadding: EdgeInsets.only(left: 8.h),

// //                     labelText: 'First Name',
// //                     labelStyle: GoogleFonts.inter(
// //                         textStyle: TextStyle(
// //                             fontSize: 12.sp,
// //                             fontWeight: FontWeight.w400,
// //                             color: Colors.black)),
// //                     focusedBorder: OutlineInputBorder(
// //                         borderSide: BorderSide(color: Colors.black, width: 1.w),
// //                         borderRadius: BorderRadius.circular(5.w)),
// //                     enabledBorder: OutlineInputBorder(
// //                         borderSide: BorderSide(color: Colors.black, width: 1.w),
// //                         borderRadius: BorderRadius.circular(5.w)),
// //                   ),
// //                 ),
// //               );
// //   }

// //   Container _firstNamecon(double height, double width) {
// //     return Container(
// //                 height: 42.h,
// //                 width: 336.w,
// //                 child: TextFormField(
// //                   style: TextStyle(
// //                       fontSize:12.sp,
// //                        fontWeight: FontWeight.w500),
// //                   cursorColor: Colors.black,

// //                   decoration: InputDecoration(
// //                     contentPadding: EdgeInsets.only(left: 8.h),

// //                     labelText: 'Last Name',
// //                     labelStyle: GoogleFonts.inter(
// //                         textStyle: TextStyle(
// //                             fontSize: 12.sp,
// //                             fontWeight: FontWeight.w400,
// //                             color: Colors.black)),
// //                     focusedBorder: OutlineInputBorder(
// //                         borderSide: BorderSide(color: Colors.black, width: 1.w),
// //                         borderRadius: BorderRadius.circular(5.w)),
// //                     enabledBorder: OutlineInputBorder(
// //                         borderSide: BorderSide(color: Colors.black, width: 1.w),
// //                         borderRadius: BorderRadius.circular(5.w)),
// //                   ),
// //                 ),
// //               );
// //   }
// // }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/birthday_on_gatello.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:gatello/views/select_birthday.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../validator/validator.dart';



class SignUpScreen extends StatefulWidget {
  String? first;
  String? last;

  SignUpScreen({this.first, this.last});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  // String? _firstName;
  // String? _lastName;



  String phone = '9764873648';
  var body = jsonEncode(<String, dynamic>{
    "user_id": "CnqkRPtZkrVp5QnEGGhqQbkVJmC10011",
    "name": 'dhina',
    "phone": "8678939278",
    "member": "since 2021",
    "email": "iamakashrajasingh@gmail.com",
    "username": "iamkashrajasingh",
    "password": "Pass@2022",
  });
  Future<void> login() async {
    print(body.toString());

    try {
      var url = Uri.parse("http://3.108.219.188:5000/signup");
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        print(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
//    Future<void> login(String  name,phone)async{
//     try{
//       Response response = await post(Uri.parse("http://3.108.219.188:5000/signup"),
//       // body: {
//       //   'name' :name,
//       //   'phone':phone
//       // }
//       );
//       if (response.statusCode==200) {
//         print('Success');
//       } else {
//         print('failed');

//       }
//     }
// catch(e){
// print(e.toString());
// }

//   }
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
        body: Form(
          key: _formkey,
          child: Container(
            padding: EdgeInsets.only(
                top: 120.h, bottom: 35.h, left: 12.w, right: 12.w),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'What\'s Your Name?',
                      style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 7.5.h),
                Text(
                  'Add your name so that your friends can find you.',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor('#646363'))),
                ),
                SizedBox(height: 25.h),
                Container(
                  //  color: Colors.blue,
                  height: 42.h,
                  width: 336.w,
                  child: TextFormField(
                    controller: _firstName,
                    onChanged: (val) {
                      widget.first = _firstName.text.toString();
                    },

                    // validator: (value) {
                    //         if (value!.isNotEmpty && value.length >=2) {
                    //           return null;
                    //         }

                    //         else if(value.length <2 && value.isNotEmpty){
                    // return 'name too short';
                    //         }
                    //      },
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.h),
                      labelText: 'FIRST NAME',
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(6)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Container(
                  height: 42.h,
                  width: 336.w,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty && value.length >= 1) {
                        return null;
                      } else {
                        return 'name too short';
                      }
                    },
                    controller: _lastName,
                    onChanged: (val) {
                      widget.last = _lastName.text.toString();
                    },
                    // validator: (value){
                    //   if (value!.isEmpty) {
                    //     return 'Please enter your name';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.h),
                      labelText: 'LAST NAME',
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(6)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'By tapping "Sign Up", you acknowledge & agree',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#646363'))),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'to  our',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#646363'))),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Terms of Service',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: HexColor('#00A3FF'))),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'and',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
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
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: HexColor('#00A3FF'))),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(27)),
                    fixedSize: Size(234.w, 50.h)),
                  onPressed: () {
                    if (widget.first!.isNotEmpty && widget.last!.isNotEmpty) {
                      String name = "${widget.first}" +
                          " " +
                          "${widget.last}";

                      print("${widget.first}" +
                          " " +
                          "${widget.last}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectBirthday(name: "${name}",)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Text("Sign-Up Failed"),
                            );
                          });
                    }

                   },
                  child: Text(
                    'Sign Up',style:GoogleFonts.inter(fontWeight:FontWeight.w600,fontSize:14.sp,
                  color:Colors.black)),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }


}
