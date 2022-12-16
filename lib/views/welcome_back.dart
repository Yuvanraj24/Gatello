import 'package:flutter/material.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/select_birthday.dart';
import 'package:gatello/views/set_password.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Helpers/StateHelper.dart';
import 'add_email.dart';
import 'add_mob_no.dart';
import 'add_profile_pic.dart';
import 'otp_screen.dart';
class WelcomeBack extends StatefulWidget {
  const WelcomeBack({Key? key}) : super(key: key);

  @override
  State<WelcomeBack> createState() => _WelcomeBackState();
}


class _WelcomeBackState extends State<WelcomeBack> {
  final storedData=GetStorage();
  String? name;
  String? dob;
  String? userName;
  String? password;
  String? mobileNum;
  String? otp;
  @override
  void initState() {
    print('init called');

    name=getData("name1");
    dob=getData("dob");
    userName=getData("userName");
 password=getData("password");
    mobileNum=getData("mobileNum");
    otp=getData("otp");
  //  pageNo=getData("page");

    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(resizeToAvoidBottomInset:false,

      body:
      Container(
        padding: EdgeInsets.only(
            top: 100.h, bottom: 45.h, left: 12.w, right: 12.w),
        child: Column(children: [
Image.asset('assets/welcomeback.png',height: 280.h,width:280.w),
SizedBox(height: 10.h,),

          Text(
            "Welcome Back",

            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w400,
                    color:Colors.black)),
          ),

          Text(
            name.toString(),

            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w700,
                    color:Colors.black)),
          ),
         Spacer(),
        ElevatedButton(
            onPressed: () {
              String data=getData('page');
              switch(data.toString()){

                case "2":{

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectBirthday(name:name.toString() )));
                }

                break;
                case "3":{

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateUsername(birthDay: dob.toString(), name:name.toString())));
                }
                break;
                case "4":{

                  print('namedata${name.toString()}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetPassword(name: name.toString(), birthDay: dob.toString(), userName:userName.toString() )));
                }
                break;
                case '5':{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMobileNumber(name: name.toString(), birthDay: dob.toString(), userName:userName.toString() ,password: password.toString(),)));
                }
                break;
                case '6':{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMobileNumber(name: name.toString(), birthDay: dob.toString(), userName:userName.toString() ,password: password.toString(),)));
                }
                break;
                case '7':{
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEmail(
                        name: name.toString(), birthDay: dob.toString(), userName:userName.toString() ,password: password.toString(),
                        mobileNo:mobileNum.toString(),otp: otp.toString(),

                      )));
                }
                break;
                case '8':{
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AddProfilePic(   name: name.toString(), birthDay: dob.toString(),password: password.toString(),
                  //     mobileNo:mobileNum.toString(),
                  //     email: widget.email,
                  //     uid: widget.uid
                  // ),));
                }
                break;
                default:{
                  print('failed');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                }
              }

            },
            style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(27)),
                fixedSize: Size(234.w, 50.h)),
            child: Text(
              "Continue",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            )
        ),
          SizedBox(height: 15.h),
GestureDetector(
  onTap: (){
    storedData.erase();
    Navigator.pop(context);
  },
  child:   Row(

    mainAxisAlignment: MainAxisAlignment.center,

    children: [

    Icon(Icons.refresh),

      SizedBox(width:3.w),

      Text(

        "Roll back",

        style: GoogleFonts.inter(

            textStyle: TextStyle(

                fontSize: 14.sp,

                fontWeight: FontWeight.w600,

                color: Color.fromRGBO(248, 206, 97, 1))),

      )

  ],),
)


      ],),)
      //Center(child: Text('Welcome Back'),),

    );
  }
}
