import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/set_password.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../validator/validator.dart';
import 'login_screen.dart';
class CreateUsername extends StatefulWidget {
  String birthDay;
  String name;
  String? userName;
  CreateUsername({
    required this.birthDay,
    required this.name,
  });

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {

  var userList;
  String status="null";

  @override
  void initState() {
    fetchUsers();
  }

  fetchUsers()async
  {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("user-detail").get();
    userList = querySnapshot.docs;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var googleFonts = GoogleFonts;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(
                  left: 12.w, right: 12.w, top: 150.h, bottom: 35.h),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Create Username",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Your friends use your username to find you',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                      SizedBox(width: 14.h),
                      Text(
                        'on Gatello',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                      SizedBox(height: 40.h),
                      Container(
                        width: 310.w,
                        child: TextFormField(
                          maxLength: 20,
                          controller: _userName,
                          onChanged: (text){
                            widget.userName = _userName.text.toString();
                            print("show user-name : ${ widget.userName}");

                            if(_userName.text.contains(" ")||_userName.text.contains(".")||_userName.text.contains("_")){
                              Fluttertoast.showToast(msg: "Space is not allowed in User-Name");
                            }

                            for(int i=0;i<userList.length;i++) {
                              print(text);

                              print("if(${text}==${userList[i]["username"]})");
                             if(_userName.text.isEmpty){

                               setState(() {
                                 status ="null";
                               });

                             }
                              else if(text==userList[i]["username"])
                              {
                                print("username exists");
                                setState(() {
                                  status="exists";
                                });
                                break;
                              }
                              else{
                                print("username available");
                                setState(() {
                                  status="available";
                                });
                              }
                            }
                          },

                          cursorColor: HexColor('#0B0B0B'),
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(bottom: 2),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black)),

                            labelStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            labelText: "USERNAME",
                            errorText: status == "null"? "": "User-name is $status",
                            errorStyle: TextStyle(
                              color: status == "available"?Colors.green:Colors.red
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black)),
                            errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black)),
                            suffixIcon: Flexible(
                              child: Container(
                                width:160.w,
                                child: Row(
                                  children: [
                                    Spacer(),

                                    // IconButton(
                                    //   padding: EdgeInsets.only(bottom: 3,left: 30),
                                    //   alignment: Alignment.bottomCenter,
                                    //   iconSize: 20.w,
                                    //   icon: Icon(Icons.refresh, color: Colors.black),
                                    //   onPressed: () {},
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20,left: 10),
                                      child:
                                      (status == "null" && _userName.text.contains(" ") == false && _userName.text.contains(".") == false && _userName.text.contains("_") == false)?
                                          null:
                                      (status == "exists" || _userName.text.contains(" ")||_userName.text.contains(".")||_userName.text.contains("_"))?
                                      //SvgPicture.asset('assets/icons_assets/wrong.svg',width: 16.w,)
                                      Icon(Icons.close,
                                      color: Colors.red,):
                                      SvgPicture.asset('assets/icons_assets/green_tick.svg',width: 16.w,),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ),
                          //validator: (value) => usernameValidator(value),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          print(widget.name);
                          print(widget.birthDay);
                          print("this is username : ${widget.userName}");

                          if (status == "available" && _userName.text.contains(" ") == false && _userName.text.contains(".") == false && _userName.text.contains("_") == false) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetPassword(
                                      name: widget.name,
                                      birthDay: widget.birthDay,
                                      userName: widget.userName.toString(),
                                    )));
                          } else {
                            return null;
                          }
                        },
                        child: Text(
                          'Continue',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
                        style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(27)),
                            fixedSize: Size(234.w, 50.h)),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}