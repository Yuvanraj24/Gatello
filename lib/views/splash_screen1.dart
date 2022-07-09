import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Splash1 extends StatelessWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //     color: HexColor('#F8CE61'),
        //     // image: DecorationImage(
        //     //     image: AssetImage(
        //     //         'assets/splash_screen_assets/Splash.png'),

        //     //    ),
            
        //        ),
        child: Image(image: AssetImage('assets/splash_screen_assets/Splash.png')),
      ),
    );
  }
}
