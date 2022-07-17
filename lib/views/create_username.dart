import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gatello/views/set_password.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


import '../validator/validator.dart';
import 'login_screen.dart';

class CreateUsername extends StatefulWidget {
  const CreateUsername({Key? key}) : super(key: key);

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  @override
  Widget build(BuildContext context) {
 
    var googleFonts = GoogleFonts;
    return SafeArea(
      child: Scaffold(
         appBar: AppBar(
    toolbarHeight:55.h,
 
          
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
        body: Container(
          padding: EdgeInsets.only(left: 12.w, right: 12.w,
           top: 163.h, bottom: 35.h),
          child: Center(
            child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                "Create Username",
             
                     style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                       fontWeight: FontWeight.w500,
                            color:Colors.black)),
              ),
              SizedBox(height: 12.h),
           
               Text(
                    'Your friends use your username to find you',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
              SizedBox(width: 14.h),
                Text(
                    'on Gatello',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
             
              SizedBox(height:51.h),
              Row(
                children: [
                  Container(
                      width:310.w,
                    child: TextFormField(
                      cursorColor: HexColor('#0B0B0B'),
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
                        labelText: "USERNAME",
                        suffixIcon: IconButton(
                          iconSize:16.w,
                          icon: Icon(Icons.refresh),
                      
                          onPressed: () {},
                        ),
                      ),
                      validator: (value) => usernameValidator(value),
                    ),
                  ),
                  Image.asset(
                    "assets/icons_assets/green_tick_icon.png",
                    width: 16.w,
                 
                  ),
                ],
              ),
   Spacer(),
                    ElevatedButton(
              onPressed: () {
                 Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SetPassword()));
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
          

              234.w,53.h
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
    );
  }
}
