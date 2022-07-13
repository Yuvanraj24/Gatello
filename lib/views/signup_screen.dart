import 'package:flutter/material.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
    //toolbarHeight: 6.87.h,
  // toolbarHeight: 19500/55.h,
          
      leading: Center(
            child: 
           TextButton(onPressed: (){
              Navigator.pop(context);
           }, child: Text('Back',
         
           style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 1.87.h,
                         fontWeight: FontWeight.w600,
                            color:Colors.black)),
              ),
             )
          ),
        ),
        body: Container(
          child: Column(
     
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'What\'s Your Name?',
                 
                     style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 4.25.h,
                       fontWeight: FontWeight.w500,
                            color:Colors.black)),
                  ),
                ],
              ),
              SizedBox(height: 1.75.h),
             
               Text(
                    'Add your name so that your friends can find you',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
               SizedBox(height: 4.87.h),
               _firstNamecon(height, width),
               SizedBox(height: 3.75.h),
               _lastNamecon(height, width),
               SizedBox(height: 1.5.h),
                  Text(
                'By tapping "Sign Up", you acknowledge & agree',
          
                       style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
              ),
              
              // SizedBox(height: 0.6.h),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
             Text(
                    'to  our',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                   SizedBox(width: 0.55.w),
               
                 InkWell(
                    onTap: () {
    
                    },
                    child:  Text(
                    'Terms of Service',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
                  ),
                    SizedBox(width: 0.55.w),
                    Text(
                    'and',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                 SizedBox(width: 0.55.w),
                    InkWell(
                    onTap: () {
    
                    },
                    child:  Text(
                    'Privacy Policy',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.62.h,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
                  ),
                ],
              ),
           SizedBox(height:28.2.h),
                 ElevatedButton(
                    onPressed: () {
                       Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateUsername()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.all(10),
                        minimumSize: Size(6.5.w, 
                       6.62.h),
                     
                        primary: HexColor('#F8CE61'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                  ),
               
                
  
            ],
          ),
        ),
      ),
    );
  }

  Container _lastNamecon(double height, double width) {
    
    return     
        Container(
                height: 5.25.h,
         
                width: 93.3.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
              
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                  
                    labelText: 'First Name',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black, width: 0.28.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 0.28.w),
                        borderRadius: BorderRadius.circular(1.3.w)),
                  ),
                ),
              );
  }

  Container _firstNamecon(double height, double width) {
    return Container(
                height: 5.25.h,
                width: 93.3.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
              
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                   
                    labelText: 'Last Name',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black, width: 0.28.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 0.28.w),
                        borderRadius: BorderRadius.circular(1.3.w)),
                  ),
                ),
              );
  }
}
