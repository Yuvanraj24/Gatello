import 'package:flutter/material.dart';
import 'package:gatello/views/invite_friends.dart';
import 'package:gatello/views/otp_screen.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({Key? key}) : super(key: key);

  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
                          toolbarHeight: currentHeight*0.07,
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
          padding: EdgeInsets.only(
              left: currentWidth * 0.06,
              right: currentWidth * 0.06,
              top: currentHeight * 0.2,
              bottom: currentHeight * 0.01),
          child: Column(children: [
            Text(
              "Add profile photo",
              style: TextStyle(
                fontSize: currentHeight * 0.0345,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(height: currentHeight * 0.01),
            Text(
              "Add a profile photo so that your friends know its you.",
              style: TextStyle(
                  fontSize: currentHeight * 0.015,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            SizedBox(height: currentHeight * 0.09),
            Image.asset(
              "assets/profile_page/profile_pic_logo.png",
              width: currentWidth * 0.48,
            ),
            SizedBox(height: currentHeight * 0.16),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Add a photo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: currentWidth * 0.045,
                    fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(currentWidth * 0.7, currentHeight * 0.086),
                  primary: Color.fromRGBO(248, 206, 97, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  )),
            ),
            TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    //fixedSize: Size(currentWidth*0.2, currentHeight*0.010),
                    primary: Color.fromRGBO(0, 0, 0, 0.44)),
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: currentWidth * 0.05),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: currentHeight * 0.007,
                  width: currentWidth * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(currentWidth * 0.9)),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
