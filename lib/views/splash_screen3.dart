import 'package:flutter/material.dart';
import 'package:gatello/views/splash_screen2.dart';
import 'package:gatello/views/splash_screen4.dart';

import 'package:hexcolor/hexcolor.dart';


class Splash3 extends StatefulWidget {
  const Splash3({Key? key}) : super(key: key);
  @override
  State<Splash3> createState() => _Splash3State();
}

class _Splash3State extends State<Splash3> {
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(right: 7, left: 7, top: 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               GestureDetector(
                 child: Text(
                    'Skip',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: width * 0.0445,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700),
                  ),
                  onTap:(){
                     Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Splash4()));
                  },
               )
              ],
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/splash3_image/splash3_image.png'),
                  width: width * 0.88,
                  height: height * 0.58,
                ),
              ],
            ),

            Spacer(),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Image(
                    image: AssetImage('assets/splash3_image/left_arrow.png'),
                    width: width * 0.13,
                    height: height * 0.13,
                  ),
                  onTap: (){
         Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Splash2()));
                  },
                ),
                     GestureDetector(
                       child: Image(
                  image: AssetImage('assets/splash2_image/right_arrow.pngg'),
                  width: width * 0.13,
                  height: height * 0.13,
                ),
                onTap: (){
         Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Splash4()));
                },
                     ),
                
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// class Splash3 extends StatefulWidget {
//   const Splash3({Key? key}) : super(key: key);

//   @override
//   State<Splash3> createState() => _Splash3State();
// }
// class _Splash3State extends State<Splash3> {
//   @override
//   Widget build(BuildContext context) {
//         double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//    return IntroductionScreen(
// pages: [
// PageViewModel(
// bodyWidget: 
//  Container(
//       padding: EdgeInsets.only(right: 7, left: 7, top: 10),
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 'Skip',
//                 style: TextStyle(
//                     decoration: TextDecoration.none,
//                     fontSize: width * 0.0445,
//                     color: Colors.black45,
//                     fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: height * 0.015,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                 image: AssetImage('assets/left_arrow/Group 659.png'),
//                 width: width * 0.88,
//                 height: height * 0.58,
//               ),
//             ],
//           ),
//           Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Image(
//                 image: AssetImage('assets/right_arrow/Frame 226.png'),
//                 width: width * 0.13,
//                 height: height * 0.13,
//               ),
//             ],
//           ),
//         ],
//       ),
//     )
// ),

// ],
//    );
//   }
// }

