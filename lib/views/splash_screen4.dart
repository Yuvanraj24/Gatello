

// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:gatello/views/signup_screen.dart';

import 'package:hexcolor/hexcolor.dart';
 import 'package:sizer/sizer.dart';

import 'login_screen.dart';

class Splash4 extends StatefulWidget {
  const Splash4({Key? key}) : super(key: key);

  @override
  State<Splash4> createState() => _Splash4State();
}

class _Splash4State extends State<Splash4> {
 // final Color color = HexColor.fromHex('#aabbcc');
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        body: Container(
          
      //    padding: EdgeInsets.only(
      //     left: 17.5.w,right: 17.5.w,

      //  top: 40.h,
      //    bottom:30.h
      //    ),
      //   color: HexColor('#F8CE61'),
      //     child: Column(mainAxisAlignment: 
      //     MainAxisAlignment.center, children: [
      //       // SizedBox(
      //       //   width: width * 2,
      //       // ),
            
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //         // SizedBox(height: height*0.61),
      //           Text(
      //             'Gatello',
      //             style: TextStyle(fontSize: 2.h),
      //           ),
      //         ],
      //       ),
      //    SizedBox(height: 9.h),
      //       Row(
      //        // mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           ElevatedButton(
      //             onPressed: () {
      //                Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => LoginScreen()));
      //             },
      //             child: Text(
      //               'Login',
                              
      //               style: TextStyle(
                      
      //                   color: Colors.black,
      //                  //  fontSize:height*0.021,
      //                    fontSize:2.1.h ,
      //                   fontWeight: FontWeight.w700),
      //             ),
      //             style: ElevatedButton.styleFrom(
     
      //           shadowColor:Colors.black ,
      //                 onPrimary: Colors.black,
      //                 padding: EdgeInsets.all(10),
      //                 minimumSize: Size(29.4.w, 1.9.h),
      //                 primary: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(35),
      //                 )),
      //           ),
      //          SizedBox(width:3.63.w),
      //           ElevatedButton(
      //             onPressed: () {
      //               Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => SignUpScreen()));
      //             },
      //             child: Text(
      //                 'Sign Up',
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize:2.1.h,
      //                     fontWeight: FontWeight.w600),
      //               ),
      //             style: ElevatedButton.styleFrom(
      //                 padding: EdgeInsets.all(10),
      //                 minimumSize: Size(29.4.w, 1.9.h),
      //                 primary: Colors.black,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(35),
      //                 )),
      //           ),
      //         ],
      //       )
      //     ]),
    
         color: Colors.blue,

         height: 5.h,
         width: 4.w,
        ),
      ),
    );
  }
}
