import 'package:flutter/material.dart';
import 'package:gatello/views/splash_screen1.dart';
import 'package:gatello/views/splash_screen3.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';


class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);
  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
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
                        fontSize: width * 0.044,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700),
                  ),
                  onTap: (){
                    //  Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => Splash1()));
                  },
             )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/splash2_image/Group 651.png'),
                  width: width * 0.88,
                  height: height * 0.58,
                ),
              ],
            ),
            Spacer(),
            
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage('assets/right_arrow_button/Frame 226.png'),
                    width: width * 0.13,
                    height: height * 0.13,
                  ),
                ],
              ),
              onTap: (){
                       Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Splash3()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gatello/views/splash_screen4.dart';

// import 'package:hexcolor/hexcolor.dart';
// import 'package:introduction_screen/introduction_screen.dart';

// class Splash2 extends StatefulWidget {
//   const Splash2({Key? key}) : super(key: key);

//   @override
//   State<Splash2> createState() => _Splash2State();
// }

// class _Splash2State extends State<Splash2> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return IntroductionScreen(
//       // controlsPosition: Position(bottom: 100),
//       // controlsPadding: EdgeInsets.only(right: 7, left: 7, top: 10),
//       globalBackgroundColor: Colors.green[50],
//       pages: [
//         PageViewModel(
//           titleWidget: 
//            Row(
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
//           bodyWidget: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                 image: AssetImage('assets/splash2_image/Group 651.png'),
//                 width: width * 0.80,
//                 height: height * 0.58,
//               ),
//             ],
//           ),
//         ),
//        PageViewModel(
//           titleWidget: 
//            Row(
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
//           bodyWidget: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                 image: AssetImage('assets/splash3_image/Group 657.png'),
//                 width: width * 0.80,
//                 height: height * 0.58,
//               ),
//             ],
//           ),
//         ),
//       ],
//       done: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           GestureDetector(child: const Icon(Icons.arrow_forward, color: Colors.black),
//           onTap: (){
//            Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Splash4()));
//           },),
       
//        ],
//       ),
//       onDone: () {
//         Splash4();
//       },
//       skipOrBackFlex: 0,
//       nextFlex: 0,
//       showBackButton: true,
//       back: const Icon(Icons.arrow_back, color: Colors.black),
//       // skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600,
//       // color: Colors.black)),
//       next: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           const Icon(Icons.arrow_forward, color: Colors.black),
//         ],
//       ),
// showNextButton: false,
//       curve: Curves.slowMiddle,
//       dotsDecorator: DotsDecorator(
//         shape:RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(width*0.008)) ,
//         size: Size(width*0.024,height*0.011),
//         activeColor: HexColor('#F8CE61'),
//         activeSize: Size(width*0.060, height*0.011),
//         spacing:EdgeInsets.all(2.5) ,
//     activeShape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(width*0.030))
//       ),
//    controlsPosition:Position(bottom: 5,top: 8,right: 163,left:0),
//    controlsPadding: EdgeInsets.all(0),
//     );
//   }
// }
