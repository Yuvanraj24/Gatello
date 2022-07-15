import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _firstName;
  String? _lastName;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
    toolbarHeight:55.h,
 
          
      leading: Center(
            child: 
           TextButton(onPressed: (){
              Navigator.pop(context);
           }, child: Text('Back',
         
           style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                         fontWeight: FontWeight.w600,
                            color:Colors.black)),
              ),
             )
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
        
             bottom:37.h, 
             left: 12.w,right: 12.w),
          child: Column(
     
            children: [
             Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'What\'s Your Name?',
                 
                     style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                       fontWeight: FontWeight.w500,
                            color:Colors.black)),
                  ),
                ],
              ),
              SizedBox(height:14.h),
             
               Text(
                    'Add your name so that your friends can find you',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#646363'))),
                  ),
               SizedBox(height: 39.h),
               Container(
                height: 42.h,
                width: 336.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize:12.sp,
                       fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
             
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8.h),
                  
                  
                    labelText: 'First Name',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                        borderRadius: BorderRadius.circular(6)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black, width: 1.w),
                       borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
               SizedBox(height: 30.h),
              Container(
                height: 42.h,
                width: 336.w,
                child: TextFormField(
                  style: TextStyle(
                      fontSize:10.sp,
                       fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
              
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8.h),
                  
                 
                    labelText: 'Last Name',
                    labelStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                        borderRadius: BorderRadius.circular(6)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.w),
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
               SizedBox(height: 12.h),
                  Text(
                'By tapping "Sign Up", you acknowledge & agree',
          
                       style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
              ),
              
             SizedBox(height: 5.h),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
             Text(
                    'to  our',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                   SizedBox(width: 5.w),
               
                 InkWell(
                    onTap: () {
    
                    },
                    child:  Text(
                    'Terms of Service',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
                  ),
                    SizedBox(width: 5.w),
                    Text(
                    'and',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                        fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#646363'))),
                  ),
                 SizedBox(width: 5.w),
                    InkWell(
                    onTap: () {
    
                    },
                    child:  Text(
                    'Privacy Policy',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                           fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#00A3FF'))),
                  ),
                  ),
                ],
              ),
           SizedBox(height:225.h),
                 ElevatedButton(
                    onPressed: () {
                       Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateUsername()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                        onPrimary: Colors.black,
                     //   padding: EdgeInsets.all(10),
                        minimumSize: Size(234.w, 
                       53.h),
                     
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
}
//   Container _lastNamecon(double height, double width) {
    
//     return     
//         Container(
//                 height: 42.h,
//                 width: 336.w,
//                 child: TextFormField(
//                   style: TextStyle(
//                       fontSize:12.sp,
//                        fontWeight: FontWeight.w500),
//                   cursorColor: Colors.black,
              
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(left: 8.h),
                  
                 
//                     labelText: 'First Name',
//                     labelStyle: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black, width: 1.w),
//                         borderRadius: BorderRadius.circular(5.w)),
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black, width: 1.w),
//                         borderRadius: BorderRadius.circular(5.w)),
//                   ),
//                 ),
//               );
//   }

//   Container _firstNamecon(double height, double width) {
//     return Container(
//                 height: 42.h,
//                 width: 336.w,
//                 child: TextFormField(
//                   style: TextStyle(
//                       fontSize:12.sp,
//                        fontWeight: FontWeight.w500),
//                   cursorColor: Colors.black,
             
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(left: 8.h),
                  
                  
//                     labelText: 'Last Name',
//                     labelStyle: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black, width: 1.w),
//                         borderRadius: BorderRadius.circular(5.w)),
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black, width: 1.w),
//                         borderRadius: BorderRadius.circular(5.w)),
//                   ),
//                 ),
//               );
//   }
// }
