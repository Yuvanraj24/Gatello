
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';


import 'login_screen.dart';

class Splash4 extends StatefulWidget {
  const Splash4({Key? key}) : super(key: key);

  @override
  State<Splash4> createState() => _Splash4State();
}

class _Splash4State extends State<Splash4> {
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          
         padding: EdgeInsets.only(
        

      top:275.h,
       bottom:100.h
         ),
        color: HexColor('#F8CE61'),
          child: Column(
          children: [
            Text(
              'Gatello',
             // style: TextStyle(fontSize: 77.7.h),
              style: GoogleFonts.inter(
                        textStyle: TextStyle(
                         fontSize: 58.h,
                         fontWeight: FontWeight.w400,
                            color:Colors.black)),
            ),
            SizedBox(height: 63.h),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  
                  onPressed: () {
                     Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                                
                                   style: GoogleFonts.inter(
                          textStyle: TextStyle(
                           fontSize: 12.5 .h,
                           fontWeight: FontWeight.w600,
                              color:Colors.black)),
                    ),
                  ),
                  style: ElevatedButton.styleFrom( 
                  elevation: 0,
                      onPrimary: Colors.black,
                      padding: EdgeInsets.all(10),
                      minimumSize: Size(106.w, 39.h),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      )),
                ),
       SizedBox(width:22.w),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        'Sign Up',
                           style: GoogleFonts.inter(
                          textStyle: TextStyle(
                           fontSize: 12.h,
                           fontWeight: FontWeight.w600,
                              color:HexColor('#FFFFFF'))),
                      ),
                  ),
                  style: ElevatedButton.styleFrom(
                    
          elevation: 0,  
                  minimumSize: Size(106.w, 39.h),
                 
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      )),
                ),
              ],
            )
          ]),
   
        ),
      ),
    );
  }
}
