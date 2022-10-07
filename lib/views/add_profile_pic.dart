import 'dart:io';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/login_screen.dart';

import 'package:gatello/views/otp_screen.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'contact_list.dart';
import 'invitefriends.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({Key? key}) : super(key: key);
  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {

  File? image;
  Future pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final temporaryImage = File(image.path);
      setState(() {
        this.image = temporaryImage;
      });
    } on PlatformException catch (e) {
      print('unable to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        
          leading: Center(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ),
          )),
        ),
        body: Container(
          padding:
              EdgeInsets.only(left: 12.w,
              right: 12.w,
              top: 150.h,
           bottom: 51.h
              ),
          child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  "Add profile photo",
                  style: GoogleFonts.fredoka(
                      textStyle: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add a profile photo so that your friends know its you.',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: HexColor('#646363'))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                // CircleAvatar(
                //   radius: 50,
                //   backgroundColor: Colors.transparent,
                //   backgroundImage: (userPicture != null)
                //       ? Image.memory(userPicture!).image
                //       : (widget.userPicture != null)
                //       ? Image.network(widget.userPicture!).image
                //       : AssetImage("assets/noProfile.jpg"),
                // ),
                Image.asset(
                  "assets/profile_page/profile_pic_logo.png",
                  width: 165.w,
                ),

                Spacer(),
                ElevatedButton(
                  onPressed: () {
                      pickimage();

                  },
                  child: Text(
                    'Add a photo',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      onPrimary: Colors.black,
                      //  padding: EdgeInsets.all(10),
                      minimumSize: Size(234.w, 48.h),
                      primary: Color.fromRGBO(248, 206, 97, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      )),
                ),
                SizedBox(
                  height: 23.h,
                ),
                InkWell(
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: HexColor('#646363')),

                  ),
                  onTap: (){
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>InviteFriends(state: 0)
                        ));*/

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>LoginScreen()
                        ));
                  },
                )
              ]),
        ),
      ),
    );
  }


}
