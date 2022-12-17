import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/add_mob_no.dart';

import 'package:gatello/views/set_password.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';


import '../Helpers/StateHelper.dart';
import '../handler/regex.dart';
import '../validator/validator.dart';
import 'login_screen.dart';

class SetPassword extends StatefulWidget {
  String birthDay;
  String userName;
  String name;
  String? password;
  SetPassword({
    required this.name,
    required this.birthDay,
    required this.userName,
  });

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class  _SetPasswordState extends State<SetPassword> {
  bool isHidden= true;

  String passwordPattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  final _formKey = GlobalKey<FormState>();
  TextEditingController _setPassword =TextEditingController();

  String? userName;
  @override
  void initState() {
    userName=getData("username");


  }
  @override
  Widget build(BuildContext context) {
   // final currentWidth = MediaQuery.of(context).size.width;
  
    var googleFonts = GoogleFonts;
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
           appBar: AppBar(
        leading: Center(
              child:
             TextButton(onPressed: (){
                Navigator.pop(context);
             }, child: Text('Back',
               style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                           fontWeight: FontWeight.w600,
                              color:Colors.black)),
                ),
               )
            ),
          ),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 1.w,
                 top: 150.h, bottom: 35.h),
                child: Center(
                  child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      "Set a password",
                           style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                                  fontSize: 28.sp,
                             fontWeight: FontWeight.w500,
                                  color:Colors.black)),
                    ),
                    SizedBox(height: 12.h),

                     Text(
                          "Just make sure it's at least 8 characters",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#646363'))),
                        ),
                    SizedBox(width: 14.h),
                      Text(
                          'long.',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#646363'))),
                        ),

                   SizedBox(height: 40.h),
                    Row(
                      children: [
                        Container(

                        width:310.w,
                          child: TextFormField(
                            maxLength: 20,
                              controller: _setPassword,
                              obscureText: isHidden,
                              onChanged: (value) {
                                widget.password = _setPassword.text.toString();
                                if(_setPassword.text.length > 8){
                                  print("Password is OK");
                                }else{
                                  print("password is waste");
                                }
                                setState(() {

                                });
                              },
                            cursorColor:HexColor('#0B0B0B'),
                            decoration: InputDecoration(
                               enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: HexColor('#0B0B0B'))),
                                       focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: HexColor('#0B0B0B'))),

                              labelStyle:   GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                              labelText: "PASSWORD",

                              suffixIcon: Container(

                                width:160.w,
                                child: Row(
                                  children: [
                                    Spacer(),

                                    IconButton(
                                      padding: EdgeInsets.only(bottom:3,left: 130),
                                          alignment: Alignment.bottomCenter,
                                      iconSize:20.w,
                                    icon:     isHidden?Icon(Icons.visibility_off, size: 18.sp,color: Colors.black):
                                    Icon(Icons.visibility, size: 18.sp,color: Colors.black),

                                      onPressed: () {
                                        setState(() {
                                          isHidden=!isHidden;
                                        });
                                      },
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 24.h
                                        ),



                                        child:(regex(pattern: passwordPattern, input: _setPassword.text) == true || _setPassword.text.isEmpty == true) ?SvgPicture.asset('assets/icons_assets/green_tick.svg',width: 16.w,):SvgPicture.asset('assets/error_icon.svg',width: 16.w,)

                                    ),
                                  ],
                                ),
                              ),

                            ),

                          validator: (value) {


                                if (value == null || regex(pattern: passwordPattern, input: value) == false) {

                                    return 'Must be atleast 8 Characters, Symbols & Numbers';


                                }else {


                                  return null;
                                  // passwordValidator(value: value);
                                }
                                },
                          ),

                        ),



                      ],
                    ),

                                   SizedBox(height: 6.h),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Text(
                      'Must be at 8 characters and contain at least\none letter,one symbol & one number.',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: HexColor('#00A3FF'))),
                    ),
                                 ],
                               ),
               Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (regex(pattern: passwordPattern, input: _setPassword.text) == true) {
                              print("Name : ${widget.name}");
                              print("Birthday : ${widget.birthDay}");
                              print("Username : ${widget.userName}");
                              print("Password : ${widget.password}");
                              setData("password", widget.password.toString());
                              setData("page","5");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddMobileNumber(name: widget.name,birthDay: widget.birthDay, userName: widget.userName,password: widget.password.toString(),)));

                            } else {

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
                          style:
                          ElevatedButton.styleFrom(
                              elevation: 5,
                              onPrimary: Colors.black,
                              //  padding: EdgeInsets.all(10),
                              minimumSize: Size(


                                  234.w,48.h
                              ),

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
    );
  }
}
