import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:google_fonts/google_fonts.dart';

class Acountsuccess extends StatefulWidget {
  var uid;
  var mobileNo;
  var password;
  var username;
  var name;
  var birthDay;
  var email;
  Acountsuccess({
    required this.uid,
    required this.mobileNo,
    required this.username,
    required this.password,
    required this.birthDay,
    required this.name,
    required this.email
});

  @override
  State<Acountsuccess> createState() => _AcountsuccessState();
}

class _AcountsuccessState extends State<Acountsuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: GestureDetector(onTap:() {
                Navigator.pop(context);
              },
                child: Text(
                  'Back', style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black)),
                ),
              ),
            )),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(height:87.h),
              Container(height:170.h,width:170.w,decoration:BoxDecoration(shape:BoxShape.circle,color:Color.fromRGBO(248, 206, 97, 1)),
        child:Icon(Icons.done_rounded,size:120,),),
              SizedBox(height:27.h),
              Text("Account Created",style:GoogleFonts.fredoka(  textStyle: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
          ),
              Text("Successfully",style:GoogleFonts.fredoka(  textStyle: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
              ),
              Spacer(),
              ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProfilePic(mobileNo: widget.mobileNo ,username: widget.username,password: widget.password, name: widget.name,birthDay: widget.birthDay,email: widget.email, uid: widget.uid),));
            },
            child: Text(
              'Continue',
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
        ]),
      ),
    );
  }
}
