// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'package:gatello/views/tabbar/pops/pops.dart';
//
// import 'package:google_fonts/google_fonts.dart';
//
// class Third_Page extends StatefulWidget {
//   const Third_Page({Key? key}) : super(key: key);
//
//   @override
//   State<Third_Page> createState() => _Third_PageState();
// }
//
// class _Third_PageState extends State<Third_Page> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           padding: EdgeInsets.only(left: 12.w, top: 16.h, right: 12.w),
//           color: Colors.white,
//           child: Column(
//             children: [
//               Divider(
//                 endIndent: 164,
//                 indent: 164,
//                 thickness: 2,
//                 color: Color.fromRGBO(0, 0, 0, 1),
//               ),
//               Text(
//                 'Report',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         decoration: TextDecoration.none,
//                         color: Color.fromRGBO(0, 0, 0, 1),
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20.sp)),
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Divider(
//                 thickness: 1,
//                 indent: 12,
//                 endIndent: 12,
//               ),
//               SizedBox(
//                 height: 28.h,
//               ),
//               Container(
//                 height: 108.h,
//                 width: 108.w,
//                 child: Icon(
//                   Icons.check,
//                   size: 70,
//                 ),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color.fromRGBO(248, 206, 97, 0.69)),
//               ),
//               SizedBox(
//                 height: 28.h,
//               ),
//               Text(
//                 'Thanks for letting us Know',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 20.sp,
//                         color: Color.fromRGBO(0, 0, 0, 1),
//                         fontWeight: FontWeight.w700)),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               Text(
//                 'To Understand problems that people are',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 14.sp,
//                         color: Color.fromRGBO(124, 124, 124, 1),
//                         fontWeight: FontWeight.w400)),
//               ),
//               Text(
//                 'having with spam on Gatello.',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 14.sp,
//                         color: Color.fromRGBO(124, 124, 124, 1),
//                         fontWeight: FontWeight.w400)),
//               ),
//
//               SizedBox(
//                 height: 171.h,
//               ),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                     primary: Color.fromRGBO(248, 206, 97, 1),
//                     fixedSize: Size(194.w, 43.h),
//                   ),
//                   onPressed: () {
//                      Navigator.pop(context,MaterialPageRoute(builder: (context) => Pops_Page()));
//                   },
//                   child: Text(
//                     'OK',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             color: Color.fromRGBO(0, 0, 0, 1),
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w700)),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//     ;
//   }
// }


import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
class Responbuilder extends StatefulWidget {
  const Responbuilder({Key? key}) : super(key: key);

  @override
  State<Responbuilder> createState() => _ResponbuilderState();
}

class _ResponbuilderState extends State<Responbuilder> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        print('1');
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          print('2');
          return Container(color:Colors.blue);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          print('3');
          return Container(color:Colors.red);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
          print('4');
          return Container(color:Colors.yellow);
        }
        print('5');
        return Container(color:Colors.purple);
      },


    );
  }
}