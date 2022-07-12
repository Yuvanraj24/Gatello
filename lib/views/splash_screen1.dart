import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Splash1 extends StatelessWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: HexColor('#F8CE61'),
            image: DecorationImage(
                image: AssetImage(
                    'assets/glogo/WhatsApp Image 2022-06-30 at 1.53 1.png'),

               ),
            
               ),
   
      ),
    );
  }
}
