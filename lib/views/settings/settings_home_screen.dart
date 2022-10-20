import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/settings/privacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../Authentication/Authentication.dart';
import '../../Database/StorageManager.dart';
import '../../Firebase/Writes.dart';
import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../components/AlertDialogBox.dart';
import '../../components/AssetPageView.dart';
import '../../components/SnackBar.dart';
import '../../core/Models/Default.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '../login_screen.dart';
import '../tabbar/pops/circle_indicator.dart';
import '/core/models/profile_detail.dart'as userDetailsModel;
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );

  late SharedPreferences logindata;
  late String username;

  String? userId;
  bool logoutLoading = false;
  Future? _future;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));

  ValueNotifier<Tuple4> logoutValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  Future logoutApiCall({required String uid}) async {
    return await ApiHandler().apiHandler(
      valueNotifier: logoutValueNotifier,
      jsonModel: defaultFromJson,
      url: logoutUrl,
      requestMethod: 1,
      body: {"user_id": uid, "notification_token": ""},
    );
  }
  Future profileDetailsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: userDetailsModel.profileDetailsFromJson,
      url: profileDetailsUrl,
      requestMethod: 1,
      body: {"user_id": userId, "followee_id": ""},
    );
  }

  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userId = sharedPrefs.getString("userid");

    print("ShardPref ${userId}");
  }
  Future<dynamic> sendData() async {
    final data1 = await _getUID();
    final data2 = await profileDetailsApiCall();

    return [data1, data2];
  }
  @override
  void initState() {
    _future = sendData();

    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: FutureBuilder(
          future:_future,
          builder: (context,snap) {

            if(profileDetailsValueNotifier.value.item1 == 1 ||
                profileDetailsValueNotifier.value.item1 == 3) {

              return Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Column(
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
                    'Settings',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(12, 16, 29, 1)
                        )),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 12.w,right: 12.w,top: 20.h),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, top: 13.h),
                          child: Container(
                            width: 55.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                                border: Border.all(width: 2,color: Color.fromRGBO(248, 206, 97,1 )),
                                shape: BoxShape.circle,
                                image: (profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl!=null)?
                                DecorationImage(image: NetworkImage(profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl),fit: BoxFit.cover):
                                DecorationImage(image: AssetImage('assets/profile_page/profile_pic_logo.png'),fit: BoxFit.cover)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, top: 13.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileDetailsValueNotifier.value.item2.result.profileDetails.name,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(0, 0, 0, 1)
                                    )),
                              ),
                              Text(
                                profileDetailsValueNotifier.value.item2.result.profileDetails.username,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(156, 156, 156, 1)
                                    )),
                              ),


                            ],),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: ElevatedButton(onPressed: ()async{
                            String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                            return await gallery().then((value) async {
                              if (value != null && value.files.first.size<52428800) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AssetPageView(
                                          fileList: value.files,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            TaskSnapshot taskSnapshot = await Write(uid: userId).groupProfile(
                                                file: value.files.first.bytes!,
                                                fileName: timestamp,
                                                contentType: "image/" + value.files.first.extension!, guid: '');
                                            String url = await taskSnapshot.ref.getDownloadURL();

                                            await instance
                                                .collection("user-detail")
                                                .doc()
                                                .set({"pic": url, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()}, SetOptions(merge: true));
                                          },
                                        )));
                              } else {
                                final snackBar = snackbar(content: "File size is greater than 50MB");
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });
                          },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                onPrimary: Colors.black,
                                minimumSize: Size(50.w, 28.h),
                                primary: Color.fromRGBO(248, 206, 97, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),

                            child: Text(
                              'Edit',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(0, 0, 0, 1)
                                  )),
                            ),),
                        )
                      ],),
                      SizedBox(height: 20.h,),
                      Divider(indent:5, endIndent:5, height: 1.h,),
                      SizedBox(height: 20.h,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatSettings()

                            ),
                          );
                        },
                        child: ListTile(leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                "assets/settngs/account_icon.svg"
                              //, fit: BoxFit.cover,
                              // height:35.h,
                              // width: 35.w,
                            ),
                          ],
                        ),
                          title: Text(
                            'Account',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(0, 0, 0, 1)
                                )),
                          ),
                          subtitle: Text(
                            'Privacy, change number, delete account',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(135, 135, 135, 1)
                                )),
                          ),
                        ),
                      ),
                      ListTile(leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/tabbar_icons/pings_icon.svg",
                            //, fit: BoxFit.cover,
                            height: 25.h,
                            width: 25.w,
                          ),
                        ],
                      ),
                        title: Text(
                          'Pings & Pops',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1)
                              )),
                        ),
                        subtitle: Text(
                          'Wallpaper, language, Pings backup',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(135, 135, 135, 1)
                              )),
                        ),
                      ),
                      ListTile(leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none_outlined,
                              color: Color.fromRGBO(0, 0, 0, 1))
                          // SvgPicture.asset(
                          //       "assets/settngs/account_icon.svg"
                          //   //, fit: BoxFit.cover,
                          //   // height:35.h,
                          //   // width: 35.w,
                          // ),
                        ],
                      ),
                        title: Text(
                          'Notifications',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1)
                              )),
                        ),
                        subtitle: Text(
                          'Message, group & tones',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(135, 135, 135, 1)
                              )),
                        ),
                      ),
                      ListTile(leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.help_center_outlined,
                              color: Color.fromRGBO(0, 0, 0, 1))
                        ],
                      ),
                        title: Text(
                          'Help',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1)
                              )),
                        ),
                        subtitle: Text(
                          'Help center, contact us, privacy policy',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(135, 135, 135, 1)
                              )),
                        ),
                      ),
                      ListTile(leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt_outlined,
                              color: Color.fromRGBO(0, 0, 0, 1))
                          // SvgPicture.asset(
                          //       "assets/settngs/saved.svg"
                          //   //, fit: BoxFit.cover,
                          //   // height:35.h,
                          //   // width: 35.w,
                          // ),
                        ],
                      ),
                        title: Text(
                          'Saved',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1)
                              )),
                        ),

                      ),
                      ListTile(leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.dark_mode_outlined,
                              color: Color.fromRGBO(0, 0, 0, 1))
                        ],
                      ),
                        title: Text(
                          'Dark mode',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 1)
                              )),
                        ),

                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (logoutLoading)
                            ? null
                            : () async {
                          return await alertDialogBox(context: context,
                              title: "Going back?",
                              subtitle: "Do you want to stop creating your account?",
                              widgets: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        if (!mounted) return null;
                                        setState(() {
                                          logoutLoading = true;
                                        });
                                        await setVisitedFlag(false);
                                        return await logoutApiCall(
                                            uid: userId.toString())
                                            .whenComplete(() async {
                                          if (logoutValueNotifier.value.item1 == 1) {
                                            FirebaseFirestore instance = FirebaseFirestore
                                                .instance;
                                            await instance.collection("user-detail")
                                                .doc(userId.toString())
                                                .update({"token": null});
                                            await signOut();

                                            logindata.setBool('login', true);
                                            Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()), (
                                                    route) => false);
                                          } else
                                          if (logoutValueNotifier.value.item1 == 2 ||
                                              logoutValueNotifier.value.item1 == 3) {
                                            if (!mounted) return null;
                                            setState(() {
                                              logoutLoading = false;
                                            });
                                            final snackBar = snackbar(
                                                content: logoutValueNotifier.value
                                                    .item3);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        });
                                      } catch (e) {
                                        if (!mounted) return null;
                                        setState(() {
                                          logoutLoading = false;
                                        });
                                        final snackBar = snackbar(
                                            content: e.toString());
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            snackBar);
                                      }



                                    },
                                    child: Text("Yes")),
                              ]);
                        },
                        child: ListTile(leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_outlined,
                                color: Color.fromRGBO(0, 0, 0, 1))
                          ],
                        ),
                          title: Text(
                            'Log out',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(0, 0, 0, 1)
                                )),
                          ),

                        ),
                      ),

                    ],),
                  ),
                ),
              );
            }
            else if(profileDetailsValueNotifier.value.item1 == 2){
              return CircleIndicator();
            }
            else{
              return CircleIndicator();
            }
          }
      ),
    );
  }
}