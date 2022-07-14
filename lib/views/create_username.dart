import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gatello/views/set_password.dart';


import 'login_screen.dart';

class CreateUsername extends StatefulWidget {
  const CreateUsername({Key? key}) : super(key: key);

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
                          toolbarHeight: 55.h,
          leading: Center(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: currentWidth * 0.038,
                  fontWeight: FontWeight.w600),
            ),
          )),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 11.w, right: 18.w,
           top: 163.h, bottom: 35.h),
          child: Center(
            child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                "Create Username",
                style: TextStyle(
                  fontSize: 34.h,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Your friends use your username to find you",
                style: TextStyle(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 84, 37, 37)),
              ),
              SizedBox(width: 5.h),
              Text(
                "on Gatello",
                style: TextStyle(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(100, 99, 99, 1)),
              ),
              SizedBox(height:51.h),
              Row(
                children: [
                  Container(
                    width: currentWidth * 0.82,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 15.h),
                        labelText: "USERNAME",
                        suffixIcon: IconButton(
                          iconSize: currentWidth * 0.07,
                          icon: Icon(Icons.refresh),
                          // splashRadius: 5,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: currentHeight * 0.02),
                  Text(
                    "Your friends use your username to find you",
                    style: TextStyle(
                        fontSize: currentWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(100, 99, 99, 1)),
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
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.h,
                    fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(
               //     currentWidth * 0.7, 
               //   currentHeight * 0.086

              234.w,53.h
                  ),
                
                primary: Color.fromRGBO(248, 206, 97, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  )),
            ),
                  SizedBox(height: currentHeight*0.03,),
    //         Container(

    //           // height: currentHeight*0.3,
    //           // width: currentWidth*0.7,
    // height:6.62.h,
    // width: 6.5.w,
  
    // decoration: BoxDecoration(
    //   color: Colors.black,
    // borderRadius: BorderRadius.circular(currentWidth*0.9)
    // ),
    
    //             )
            ]),
          ),
        ),
      ),
    );
  }
}
