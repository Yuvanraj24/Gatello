import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Others/components/LottieComposition.dart';
import '../../../Others/lottie_strings.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../main.dart';


class ChatSettings extends StatefulWidget {
  const ChatSettings({Key? key}) : super(key: key);

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  String? uid;
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid").toString();
    print("ShardPref ${uid}");
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future:_getUID() ,
          builder: (context,_) {
            return Scaffold(
              backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    crossAxisAlignment: CrossAxisAlignment
                        .center,
                    children: [
                      SvgPicture.asset(
                        'assets/pops_asset/back_button.svg',
                        height: 30.h,
                        width: 30.w,),
                    ],
                  ),
                ),
                title: Text(
                  'Privacy',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(12, 16, 29, 1)
                      )),
                ),
              ),
              body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w,right: 23.w,top: 20.h),
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: instance.collection("user-detail").doc(uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.active) {
                            return Column(children: [
                              Row(children: [Text(
                                'Ping privacy',
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(0, 163, 255, 1)
                                    )),
                              )]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Show online status',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(0, 0,0,1)
                                        )),
                                  ),
                                  SizedBox(
                                    height: 45.h,width: 50.w,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Switch(
                                        materialTapTargetSize: MaterialTapTargetSize.padded,
                                        value: snapshot.data!.data()!["onlineStatus"] ?? false,
                                        onChanged: (bool value) async {
                                          if (value == true) {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "onlineStatus": true,
                                            }, SetOptions(merge: true));
                                          } else {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "onlineStatus": false, "lastseenStatus": false,
                                            }, SetOptions(merge: true));
                                          }
                                        },
                                        inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
                                        inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
                                        activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
                                        activeColor: Color.fromRGBO(0, 163, 255, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Show last seen status',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(0, 0,0,1)
                                        )),
                                  ),
                                  SizedBox(
                                    height: 45.h,
                                    width: 50.w,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child:  Switch(
                                        value: snapshot.data!.data()!["lastseenStatus"] ?? false,
                                        onChanged: (bool value) async {
                                          if (value == true) {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "lastseenStatus": true,
                                            }, SetOptions(merge: true));
                                          } else {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "lastseenStatus": false,
                                            }, SetOptions(merge: true));
                                          }
                                        },
                                        inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
                                        inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
                                        activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
                                        activeColor: Color.fromRGBO(0, 163, 255, 1),
                                      ),),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Read receipts',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(0, 0,0,1)
                                        )),
                                  ),
                                  SizedBox(
                                    height: 45.h,
                                    width: 50.w,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child:  Switch(
                                        value: snapshot.data!.data()!["readRecieptStatus"] ?? false,
                                        onChanged: (bool value) async {
                                          if (value == true) {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "readRecieptStatus": true,
                                            }, SetOptions(merge: true));
                                          } else {
                                            await instance.collection("user-detail").doc(uid).set({
                                              "readRecieptStatus": false,
                                            }, SetOptions(merge: true));
                                          }
                                        },
                                        inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
                                        inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
                                        activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
                                        activeColor: Color.fromRGBO(0, 163, 255, 1),
                                      ),
                                    ),)
                                ],
                              ),
                            ]);
                          } else {
                            return Container(
                                color: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                                child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          lottieAnimation(loadingLottie),
                                          Text("Loading",
                                              style: GoogleFonts.poppins(
                                                  textStyle:
                                                  textStyle(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index != 0) ? Color(lightGrey) : Color(materialBlack)))),
                                        ],
                                      ),
                                    )));
                          }
                        }),
                  )),
            );
          }
      ),
    );
  }
}