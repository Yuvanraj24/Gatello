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
              left: 12.w, right: 12.w, top: 122.h, bottom: 35.h),
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
                  SizedBox(height: 12.h),
                  Text(
                    "Add your mobile",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "number?",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "You will be using this mobile number to login into",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'your account.',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
                  SizedBox(height: 16.h),
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
                        Container(
                         // color: Colors.pink.shade100,
                         height: 43.h,
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#0B0B0B'))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(
                                        '#0B0B0B',
                                      ),
                                      width: 1.12.w)),
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
                                  Text(
                                    "India",
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ),
                                ],
                              ),
                              suffixIcon: Image.asset(
                                "assets/icons_assets/down_arrow.png",
                                width: 3.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              //   color: Colors.blue,
                                // height: 80,
                                width: 51.w,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor('#0B0B0B'), width: 1.12.w)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor('#0B0B0B'), width: 1.12.w)),
                                      prefixIcon: Center(
                                          child: Text("+${91}",
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      fontSize: 14.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black))))),
                                )),
                            SizedBox(
                              width: 20.w,
                            ),
                            Container(
                              // color: Colors.cyan,
                              width: 265.w,
                              child: TextFormField(
                                cursorWidth: 2,
                                cursorColor: HexColor('#0B0B0B'),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor('#0B0B0B'), width: 1.12.w)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor('#0B0B0B'), width: 1.12.w)),
                                  // disabledBorder: UnderlineInputBorder(
                                  //     borderSide: BorderSide(color:HexColor('#0B0B0B'))
                                  //   ),
                                ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddEmail()));
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
