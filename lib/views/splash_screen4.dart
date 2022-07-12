

// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:gatello/views/signup_screen.dart';

import 'package:hexcolor/hexcolor.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
       
      color: HexColor('#F8CE61'),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // SizedBox(
          //   width: width * 2,
          // ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.09),
              Text(
                'Gatello',
                style: TextStyle(fontSize: width * 0.15),
              ),
            ],
          ),
          SizedBox(height: height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                   Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Padding(
                   padding: EdgeInsets.only(bottom: 0.5),
                  child: Text(
                    'Login',
                              
                    style: TextStyle(
                      
                        color: Colors.black,
                        fontSize: width * 0.043,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                style: ElevatedButton.styleFrom(
 
              shadowColor:Colors.black ,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(width * 0.35, height * 0.072),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    )),
              ),
              SizedBox(width: width * 0.08),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.043,
                          fontWeight: FontWeight.w600),
                    ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(width * 0.35, height * 0.072),
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    )),
              ),
            ],
          )
        ]),

       
      ),
    );
  }
}
