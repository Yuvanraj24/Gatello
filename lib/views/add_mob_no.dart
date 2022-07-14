import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_email.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AddMobileNumber extends StatefulWidget {
  const AddMobileNumber({Key? key}) : super(key: key);

  @override
  State<AddMobileNumber> createState() => _AddMobileNumberState();
}

class _AddMobileNumberState extends State<AddMobileNumber> {
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
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ),
          )),
        ),
 
        body: Container(
          padding: EdgeInsets.only(
              left: 12.w, right: 12.w, top: 163.h, bottom: 35.h),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Almost done!",
                    style: GoogleFonts.gelasio(
                        textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Add your mobile",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "number?",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "You will be using this mobile number to login into",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(width: 14.h),
                  Text(
                    'your account.',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(height:16.h),
                  Container(
                    //color: Colors.blue,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                   Text(
                    'MOBILE NUMBER',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'icons/flags/png/in.png',
                                  package: 'country_icons',
                                  width: 20.w,
                                  //height: 21,
                                ),
                                SizedBox(width: 8.w),
                                Text("India",
                            style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                            color:Colors.black)),),
                              ],
                            ),
                            suffixIcon:    Image.asset(
              "assets/icons_assets/Vector (2).png",
              width:3.w,
            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          children: [
                            Container(
                               // color: Colors.blue,
                                width: currentWidth * 0.19,
                           child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding:
                                     EdgeInsets.only(top: 2, bottom: 0.1),
                            prefixIcon: Center(
                                     child: Text(
                                   "+${91}",
                                     style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                            color:Colors.black))
                                      ))),
                                )),
                            SizedBox(height: currentHeight * 0.02),
                            Container(
                              //color: Colors.cyan,
                              width: currentWidth * 0.68,
                              child: TextFormField(
                                decoration: InputDecoration(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  Text(
                    "We'll send you a text verification code.",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),

Spacer(),
                  
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEmail()));
                    },
                    child: Text(
                      'Verify mobile number',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        onPrimary: Colors.black,
                 
                        minimumSize: Size(234.w, 53.h),
                        primary: Color.fromRGBO(248, 206, 97, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
