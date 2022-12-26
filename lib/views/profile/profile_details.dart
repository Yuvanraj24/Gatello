
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/profile/editprofile.dart';
import 'package:gatello/views/profile/profileformtest.dart';
import '/core/models/default.dart' as defaultModel;

import 'package:gatello/views/profile/see_more.dart';
import 'package:gatello/views/tabbar/pops/circle_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Others/components/ExceptionScaffold.dart';
import '../../Others/lottie_strings.dart';
import '../../Style/Colors.dart';
import '/core/models/My_Feeds.dart' as myFeedsModel;
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import 'bio_dialog.dart';
import '/core/models/profile_detail.dart'as profileDetailsModel ;
import 'followers.dart';
class Profile extends StatefulWidget {
  final String? userId;

  const Profile({Key? key, this.userId}) : super(key: key);

  @override
  State<Profile> createState() => ProfileState();
}
class ProfileState extends State<Profile> {
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue1;
  Future? _future;
  String? uid;
  TextEditingController biogController=TextEditingController();
  String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);
  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier =
  ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null",null));
  ValueNotifier<Tuple4> myFeedsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));

  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));
  int i = 0;
  List localVideoPostList=[];
  List localImagePostList=[];
  Future profileDetailsApiCall() async {
    print('profile api called');
    print('dhina:${widget.userId} ');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel:profileDetailsModel.profileDetailsFromJson,
      url: 'http://3.110.105.86:4000/view/profile',
      requestMethod: 1,
      body: {
        "user_id": (widget.userId != null)
            ? widget.userId
            : uid,
        "followee_id": ""
      },
    );
  }
  Future profileDetailUpdateApiCall() async {
    print('editApi1 called');
    // ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultModel.defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile",
        requestMethod: 1,
        body: {
          "user_id": widget.userId,
          "about": biogController.text,

        });
  }
  updateFirestore(){
    FirebaseFirestore instance =FirebaseFirestore.instance;
    instance.collection('user-detail').doc(widget.userId).update({
      "about":biogController.text,


    });
  }
  // @override
  // void initState() {
  //
  //   profileDetailsApiCall();
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   profileDetailsValueNotifier.dispose();
  //   super.dispose();
  // }
  // Future feedsApiCall() async {
  //   return await ApiHandler().apiHandler(
  //     valueNotifier: feedsValueNotifier,
  //     jsonModel: myFeedsModel.myFeedsFromJson,
  //     url: myFeedsUrl,
  //     requestMethod: 1,
  //     body: {"user_id":  's8b6XInslPffQEgz8sVTINsPhcx2'},
  //   );
  // }
  Future myFeedsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: myFeedsValueNotifier,
      jsonModel: myFeedsModel.myFeedsFromJson,
      url: myFeedsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }
  Future<dynamic> sendDatas() async {
    final data1=await _getUID();
    final data2 = await profileDetailsApiCall();
      final data3 = await myFeedsApiCall();
    return [data1,data2,data3];
  }

  void initState() {
    sendDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('uid1${widget.userId}');
    print('uid2${uid}');

    return AnimatedBuilder(animation:   Listenable.merge([profileDetailsValueNotifier,myFeedsValueNotifier]), builder: (context,_){
      if (profileDetailsValueNotifier.value.item1 == 1) {
  String profilePic='http://3.110.105.86:4000/${profileDetailsValueNotifier
      .value
      .item2.result
      .profileDetails
      .profileUrl.toString()}';
        String coverImg=  'http://3.110.105.86:4000/${profileDetailsValueNotifier
            .value
            .item2.result
            .profileDetails
            .coverUrl.toString()}';
        String city=profileDetailsValueNotifier
            .value
            .item2.result
            .profileDetails
            .city.toString();
        String userName= profileDetailsValueNotifier
            .value.item2.result.profileDetails
            .username.toString();
        String name=profileDetailsValueNotifier
            .value.item2.result.profileDetails
            .name.toString();
        String job= profileDetailsValueNotifier
            .value
            .item2.result
            .profileDetails
            .job.toString();
        String company=profileDetailsValueNotifier
            .value
            .item2
            .result
            .profileDetails
            .company.toString();
        String biog=profileDetailsValueNotifier
            .value.item2.result.profileDetails.about.toString();
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {


                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                          'assets/profile_assets/back_button.svg',
                          height: 30.h,
                          width: 30.w),
                    ),
                  ],
                ),
              ),
              title: Row(
                children: [
                  Text(
                    userName.toString(),
                    // 'Suresh Offical',

                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                  SizedBox(width: 7.w),
                  Container(
                    height: 14.h,
                    width: 14.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 163, 255, 1)),
                    child: Icon(Icons.check_rounded,
                        size: 12,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                    iconSize: 30,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    itemBuilder: (context) =>
                    [
                      PopupMenuItem(
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileForm(uid: widget.userId.toString())));
                            },
                            child: Text(
                              'Settings',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(
                                          0, 0, 0, 1))),
                            ),
                          ),
                        ),
                      )
                    ])
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(

                    height: 190.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        (coverImg.isNotEmpty)
                            ? CachedNetworkImage(

                          fadeInDuration:
                          const Duration(
                              milliseconds:
                              400),
                          imageBuilder:
                              (context,
                              imageProvider) =>
                              Container(
                                height: 119.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        imageProvider,
                                        fit: BoxFit.fill)
                                ),
                              ),
                          progressIndicatorBuilder:
                              (context, url,
                              downloadProgress) =>
                              Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress
                                        .progress),
                              ),
                          imageUrl: coverImg,
                          errorWidget:
                              (context, url,
                              error) =>
                              Container(
                                height: 119.h,
                                width: double.infinity,
                                decoration: BoxDecoration(

                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/noProfile.jpg"),
                                      fit: BoxFit
                                          .cover

                                  ),
                                ),
                              ),
                        )
                            : Container(
                          height: 119.h,
                          width: double.infinity,
                          decoration: BoxDecoration(

                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/noProfile.jpg"),
                                  fit: BoxFit
                                      .cover)),
                          //   child: Image.asset("assets/noProfile.jpg")
                        ),

                        Positioned(
                          right: 12.w,
                          top: 85.h,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Edit_Profile(uid: widget.userId.toString(), company: company, coverPic: coverImg,
                                            job: job, city: city, profilePic: profilePic,name: name,)
                                  ));
                            },
                            child: Container(
                              height: 23.h,
                              width: 23.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/profile_assets/edittoolblack.svg',
                                      height: 15,
                                      width: 15),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      248, 206, 97, 1),
                                  border: Border.all(
                                      color: Color.fromRGBO(
                                          255, 255, 255, 1),
                                      width: 1),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 90.h,
                          left: 21,
                          child:   (  profilePic!= null)
                              ? CachedNetworkImage(
                            imageBuilder:
                                (context,
                                imageProvider) =>
                                Container(
                                  width: 92.w,
                                  height: 92.h,
                                  decoration:
                                  BoxDecoration(
                                      shape: BoxShape
                                          .circle,
                                      image: DecorationImage(
                                          image:
                                          imageProvider,
                                          fit: BoxFit.fill),
                                      border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))
                                  ),
                                ),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 400),
                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(value: downloadProgress.progress),
                              ),
                            ),
                            imageUrl: profilePic,
                            errorWidget: (context, url, error) =>     Container(
                              width: 92.w,
                              height: 92.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape
                                      .circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/noProfile.jpg")
                                  ),
                                  border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))
                              ),
                            ),
                          )
                              : Container(
                            width: 92.w,
                            height: 92.h,
                            decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/noProfile.jpg"),
                                    fit: BoxFit
                                        .cover),
                                border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))

                            ),
                            //   child: Image.asset("assets/noProfile.jpg")
                          ),
                        ),
                        Positioned(
                          left: 87.w,
                          top: 150.h,
                          child: Container(
                            height: 23.h,
                            width: 23.w,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Edit_Profile(uid: widget.userId.toString(), company: company, coverPic: coverImg,
                                              job: job, city: city, profilePic: profilePic,name: name,)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/profile_assets/edittoolblack.svg',
                                      height: 15,
                                      width: 15),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    248, 206, 97, 1),
                                border: Border.all(
                                    color: Color.fromRGBO(
                                        255, 255, 255, 1),
                                    width: 1),
                                shape: BoxShape.circle),
                          ),
                        ),
                        Positioned(
                          top: 138.h,
                          left: 140.w,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      child: Column(
                                        children: [
                                          Text(
                                            profileDetailsValueNotifier
                                                .value
                                                .item2
                                                .result
                                                .profileDetails
                                                .postsCount
                                                .toString(),
                                            // 'fff',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          ),
                                          Text(
                                            'Pops',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 12
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          ),
                                        ],
                                      ),
                                      onTap: () {},
                                    ),
                                    SizedBox(width: 39.w),
                                    InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            profileDetailsValueNotifier
                                                .value
                                                .item2
                                                .result
                                                .profileDetails
                                                .followingCount
                                                .toString(),
                                            // 'ggg',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          ),
                                          Text(
                                            'Following',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 12
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 25.w),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (
                                                  context) =>
                                                  Followers_Page(
                                                      Id: profileDetailsValueNotifier
                                                          .value
                                                          .item2
                                                          .result
                                                          .profileDetails
                                                          .userId.toString(), userName: userName.toString(), followersCount:  profileDetailsValueNotifier
                                                      .value
                                                      .item2
                                                      .result
                                                      .profileDetails
                                                      .followersCount
                                                      .toString(), followingCount: profileDetailsValueNotifier
                                                      .value
                                                      .item2
                                                      .result
                                                      .profileDetails
                                                      .followingCount
                                                      .toString())),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            profileDetailsValueNotifier
                                                .value
                                                .item2
                                                .result
                                                .profileDetails
                                                .followersCount
                                                .toString(),
                                            //  'jjj',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          ),
                                          Text(
                                            'Followers',
                                            style: GoogleFonts
                                                .inter(
                                                textStyle: TextStyle(
                                                    fontSize: 12
                                                        .sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: Color
                                                        .fromRGBO(
                                                        0, 0, 0,
                                                        1))),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 27, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profileDetailsValueNotifier
                                  .value.item2.result
                                  .profileDetails.name.toString(),
                              // 'hh',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(
                                          0, 0, 0, 1))),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            18)),
                                    primary: Color.fromRGBO(
                                        255, 255, 255, 1),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Edit_Profile(uid: widget.userId.toString(), company: company, coverPic: coverImg,
                                                  job: job, city: city, profilePic: profilePic,name: name,)));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'EDIT',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight
                                                    .w400,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 163, 255,
                                                    1))),
                                      ),
                                      SvgPicture.asset(
                                          'assets/profile_assets/Edit_tool.svg')
                                    ],
                                  )),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 25.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      165, 165, 165, 0.9),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.location_on_sharp,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 11.w),
                            RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style,
                                    children: [
                                      TextSpan(
                                          text: 'Lives in ',
                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14,
                                                  color:
                                                  Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  decoration:
                                                  TextDecoration
                                                      .none))),
                                      TextSpan(
                                          text:
                                          (  city.contains('null')?'none':city),

                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0,
                                                      0.5),
                                                  decoration:
                                                  TextDecoration
                                                      .none)))
                                    ])),
                          ],
                        ),
                        SizedBox(height: 9.h),
                        Row(
                          children: [
                            Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        165, 165, 165, 0.9),
                                    shape: BoxShape.circle),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/profile_assets/proffesion.svg',
                                        height: 12.h,
                                        width: 12.w),
                                  ],
                                )),
                            SizedBox(width: 11.w),
                            RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style,
                                    children: [
                                      TextSpan(
                                          text: 'Job ',
                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14,
                                                  color:
                                                  Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  decoration:
                                                  TextDecoration
                                                      .none))),
                                      TextSpan(
                                          text:
                                          (  job.contains('null')?'none':job),

                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0,
                                                      0.5),
                                                  decoration:
                                                  TextDecoration
                                                      .none)))
                                    ])),
                          ],
                        ),
                        SizedBox(height: 9.h),
                        Row(
                          children: [
                            Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        165, 165, 165, 0.9),
                                    shape: BoxShape.circle),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/profile_assets/proffesion.svg',
                                        height: 12.h,
                                        width: 12.w),
                                  ],
                                )),
                            SizedBox(width: 11.w),
                            RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style,
                                    children: [
                                      TextSpan(
                                          text: 'Working at ',
                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14,
                                                  color:
                                                  Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  decoration:
                                                  TextDecoration
                                                      .none))),
                                      TextSpan(
                                          text:  (  company.contains('null')?'none':company),
                                          style: GoogleFonts
                                              .inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0,
                                                      0.5),
                                                  decoration:
                                                  TextDecoration
                                                      .none)))
                                    ])),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Text('Biog',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight
                                          .w700,
                                      color: Color.fromRGBO(
                                          0, 0, 0, 1)),
                                )),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        insetPadding: EdgeInsets.only(left: 12, right: 12),
                                        titlePadding: EdgeInsets.all(0),
                                        title: Container(

                                          width:336.w,height:323.h,decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8)
                                        ),child: Column(children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:16,top:17,right:17),
                                            child: Row(children: [
                                              Text('Biog',  style: GoogleFonts.inter(
                                                      textStyle: TextStyle(fontSize:20.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color:
                                                          Color.fromRGBO(0, 0, 0, 1))

                                                  ),),
                                              Spacer(),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:  EdgeInsets.only(
                                                              top: 7, left: 9, bottom: 6),
                                                          child: Text(
                                                            'Public',
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 10.sp,
                                                                    color: Color.fromRGBO(0, 0, 0, 1))),
                                                            // overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  items: items
                                                      .map((item) => DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Container(
                                                      child: Center(
                                                        child: Text(
                                                            item,
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                  fontSize: 10.sp,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                                      .toList(),
                                                  value: selectedValue1,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedValue1 = value as String;
                                                    });
                                                  },
                                                  icon: Padding(
                                                    padding:  EdgeInsets.only(right: 10),
                                                    child: Icon(
                                                      Icons.keyboard_arrow_down_rounded,
                                                      size: 20,
                                                      color: Color.fromRGBO(12, 16, 29, 1),
                                                    ),
                                                  ),
                                                  iconSize: 14,
                                                  buttonHeight: 30,
                                                  buttonWidth: 90,
                                                  buttonDecoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      color: Color.fromRGBO(248, 206, 97, 1)),
                                                  itemHeight:30,
                                                  dropdownMaxHeight: 130,
                                                  dropdownWidth: 90,
                                                  buttonElevation: 0,
                                                  dropdownElevation: 0,
                                                  dropdownDecoration: BoxDecoration(
                                                    color: Color.fromRGBO(255, 255, 255, 1),
                                                  ),
                                                  scrollbarAlwaysShow: false,
                                                ),
                                              ),
                                              SizedBox(width: 10.w,),
                                              GestureDetector(onTap: (){
                                                Navigator.pop(context);
                                              },
                                                child: Text('Cancel',style: GoogleFonts.inter(textStyle: TextStyle(
                                                    fontSize:14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 163, 255, 1)
                                                )),),
                                              )
                                            ],),
                                          ),
                                          Container(padding:EdgeInsets.only(left:18,top:40,right:18),
                                            child: Column(
                                              children: [
                                                Text('Your professional ',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                                                    fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 0, 0,0.5)))),
                                              TextField(
                                                controller: biogController,
cursorColor: Color.fromRGBO(102, 102, 102, 1),
                                                keyboardType: TextInputType.multiline,
                                                minLines: 1,//Normal textInputField will be displayed
                                                maxLines: 5,//
                                               decoration: InputDecoration(
                                                  border: InputBorder.none,

                                                ),// when user presses enter it will adapt to it
                                              ),
                                                // Row(
                                                //   children: [
                                                //     Text('Your professional ',style:GoogleFonts.inter(textStyle: TextStyle(fontSize:14.sp,
                                                //         fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 0, 0,0.5)))),
                                                //
                                                //
                                                //     Container(
                                                //       height:26.h,width:101.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                                                //       child:  Container(
                                                //         color: Colors.blue,
                                                //         height:25.h,width:130.w,
                                                //         child: TextField(
                                                //           autofocus: true,
                                                //
                                                //           cursorColor:Colors.black,
                                                //           decoration: InputDecoration(
                                                //
                                                //             enabledBorder: OutlineInputBorder(
                                                //                 borderSide: BorderSide(color: Colors.transparent),
                                                //                 borderRadius: BorderRadius.circular(10)),
                                                //             focusedBorder: OutlineInputBorder(
                                                //                 borderSide: BorderSide(
                                                //                     width: 1.w,
                                                //                     color: Colors.transparent),
                                                //                 borderRadius: BorderRadius.circular(10)),
                                                //           ),),
                                                //       ),)
                                                //   ],
                                                // ),
                                                SizedBox(height:17.h),





                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(bottom:17),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(elevation: 0,
                                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                  primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(302.w,36.h),
                                                ),
                                                onPressed: (){
                                                            profileDetailUpdateApiCall();
                                                            updateFirestore();
                                                  Navigator.pop(context);
                                                }, child: Text('Save',style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(0, 0, 0, 1),fontSize:20,fontWeight: FontWeight.w700
                                                )
                                            ),)),
                                          ),
                                        ],),
                                        ),
                                      );

                                    });
                              },
                              child: Container(

                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                      'assets/profile_assets/Edit_tool.svg',
                                      color:
                                           Color.fromRGBO(
                                          0, 163, 255, 1))),
                            ),
                          ],
                        ),
                        i == 1
                            ? Text('')
                            : Column(
                          children: [
                            SizedBox(height: 7.h),
                            Text(
                              (  biog.contains('null')?'none':biog),
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.5))),
                            ),
                            Divider(
                                thickness: 1.w,
                                color: Color.fromRGBO(
                                    228, 228, 228, 1),
                                indent: 22,
                                endIndent: 18),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  i = 1;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 285,
                                    bottom: 10,
                                    top: 5),
                                child: Text(
                                  'See More...',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight
                                              .w400,
                                          fontSize: 12.sp,
                                          color: Color.fromRGBO(
                                              0, 163, 255, 1))),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  i == 1
                      ? SeeMoreText(
                      onPressed: () {
                        setState(() {
                          i = 0;
                        });
                      },
                      phone:
                      profileDetailsValueNotifier
                          .value.item2.result.profileDetails.phone.toString(),

                      email:
                      profileDetailsValueNotifier
                          .value.item2.result.profileDetails.email.toString(),
                      uid: uid.toString(),
                      biog: biog,
                      gender:profileDetailsValueNotifier
                          .value.item2.result.profileDetails.gender.toString(),
                      dob:profileDetailsValueNotifier
                          .value.item2.result.profileDetails.dob.toString(),
                      valueNotifier:profileDetailsValueNotifier

                  )
                      : Column(
                    children: [
                      TabBar(
                          indicator: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors
                                          .transparent))),
                          unselectedLabelStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(
                                      0, 0, 0, 1))),
                          unselectedLabelColor:
                          Color.fromRGBO(151, 145, 145, 1),
                          labelColor: Color.fromRGBO(0, 0, 0, 1),
                          labelStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(
                                      0, 0, 0, 1))),
                          tabs: [
                            Text('All Pops'),
                            Text('Photo Pops'),
                            Text('Video Pops'),
                          ]),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: TabBarView(children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20),

                            child:(myFeedsValueNotifier.value.item1 == 1)? GridView.builder(
                              itemCount: myFeedsValueNotifier
                                  .value.item2.result.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, gridIndex) {

                                        if(myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts[0]
                                            .toString()
                                            .contains("jpg")||
                                            myFeedsValueNotifier
                                                .value
                                                .item2
                                                .result[gridIndex]
                                                .posts[0]
                                                .toString()
                                                .contains("png")
                                           ) {
                                      print('yeah its works');
                                      localImagePostList.add(
                                              myFeedsValueNotifier
                                                  .value
                                                  .item2
                                                  .result[gridIndex]
                                                  .posts[0]

                                          );

                                        }
                                        if(myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts[0]
                                            .toString()
                                            .contains("mp4")||myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts[0]
                                            .toString()
                                            .contains("mpeg4")
                                        ) {
                                          print('yeah its works');
                                          localVideoPostList.add(
                                              myFeedsValueNotifier
                                                  .value
                                                  .item2
                                                  .result[gridIndex]
                                                  .posts[0]

                                          );

                                        }
                                return GestureDetector(
                                  behavior: HitTestBehavior
                                      .opaque,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Profile()));
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      (myFeedsValueNotifier
                                          .value
                                          .item2
                                          .result[gridIndex]
                                          .posts[0]
                                          .toString()
                                          .contains("mp4") ||
                                          myFeedsValueNotifier
                                              .value
                                              .item2
                                              .result[gridIndex]
                                              .posts[0]
                                              .toString()
                                              .contains("mpeg4"))
                                          ? Stack(
                                        children: [
                                          Container(
                                            color: Color(
                                                materialBlack),
                                          ),
                                          Center(
                                              child: Container(
                                                height: 60.h,
                                                width: 60.w,
                                                child: Icon(
                                                  Icons
                                                      .play_arrow_rounded,
                                                  size: 45,
                                                  color:
                                                  Color.fromRGBO(
                                                      248,
                                                      206,
                                                      97,
                                                      1),
                                                ),
                                                decoration:
                                                BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    color: Color
                                                        .fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1)),
                                              ))
                                        ],
                                      )
                                          : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                        const Duration(
                                            milliseconds:
                                            400),
                                        progressIndicatorBuilder:
                                            (context, url,
                                            downloadProgress) =>
                                            Center(
                                              child: Container(
                                                width: 20.0,
                                                height: 20.0,
                                                child: CircularProgressIndicator(
                                                    value:
                                                    downloadProgress
                                                        .progress),
                                              ),
                                            ),
                                        imageUrl:
                                        myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts[0],
                                        errorWidget: (context,
                                            url, error) =>
                                            Image.asset(
                                                "assets/noProfile.jpg",
                                                fit:
                                                BoxFit.cover),
                                      ),
                                      // : CachedNetworkImage(
                                      //     fadeInDuration: const Duration(milliseconds: 400),
                                      //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                      //       child: Container(
                                      //         width: 20.0,
                                      //         height: 20.0,
                                      //         child: CircularProgressIndicator(value: downloadProgress.progress),
                                      //       ),
                                      //     ),
                                      //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
                                      //     fit: BoxFit.cover,
                                      //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                      //   ),
                                      (myFeedsValueNotifier
                                          .value
                                          .item2
                                          .result[gridIndex]
                                          .posts
                                          .length >
                                          1)
                                          ? Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Icon(
                                            Icons
                                                .collections_rounded,
                                            color: Color(white),
                                            size: 15,
                                          ))
                                          : Container()
                                    ],
                                  ),
                                );
                              },
                            )
                                :(myFeedsValueNotifier.value.item1==2)?
                            CircleIndicator() : CircleIndicator()
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 20),

                              child:(myFeedsValueNotifier.value.item1 == 1)?
                              GridView.builder(
                                itemCount: localImagePostList.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, gridIndex) {

                                  return GestureDetector(
                                    behavior: HitTestBehavior
                                        .opaque,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile()));
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        (myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts[0]
                                            .toString()
                                            .contains("jpg") ||
                                            myFeedsValueNotifier
                                                .value
                                                .item2
                                                .result[gridIndex]
                                                .posts[0]
                                                .toString()
                                                .contains("png"))

                                            ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          fadeInDuration:
                                          const Duration(
                                              milliseconds:
                                              400),
                                          progressIndicatorBuilder:
                                              (context, url,
                                              downloadProgress) =>
                                              Center(
                                                child: Container(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: CircularProgressIndicator(
                                                      value:
                                                      downloadProgress
                                                          .progress),
                                                ),
                                              ),
                                          imageUrl:
                                          myFeedsValueNotifier
                                              .value
                                              .item2
                                              .result[gridIndex]
                                              .posts[0],
                                          errorWidget: (context,
                                              url, error) =>
                                              Image.asset(
                                                  "assets/noProfile.jpg",
                                                  fit:
                                                  BoxFit.cover),
                                        )
                                            :SizedBox(),
                                        // : CachedNetworkImage(
                                        //     fadeInDuration: const Duration(milliseconds: 400),
                                        //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                        //       child: Container(
                                        //         width: 20.0,
                                        //         height: 20.0,
                                        //         child: CircularProgressIndicator(value: downloadProgress.progress),
                                        //       ),
                                        //     ),
                                        //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
                                        //     fit: BoxFit.cover,
                                        //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                        //   ),

                                      ],
                                    ),
                                  );
                                },
                              )
                                  :(myFeedsValueNotifier.value.item1==2)?
                              CircleIndicator() : CircleIndicator()
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 20),

                              child:(myFeedsValueNotifier.value.item1 == 1)?
                              GridView.builder(
                                itemCount: localVideoPostList.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, gridIndex) {

                                  return GestureDetector(
                                    behavior: HitTestBehavior
                                        .opaque,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile()));
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        (
                                            myFeedsValueNotifier
                                                .value
                                                .item2
                                                .result[gridIndex]
                                                .posts[0]
                                                .toString()
                                                .contains("mp4")||

                                                myFeedsValueNotifier
                                                    .value
                                                    .item2
                                                    .result[gridIndex]
                                                    .posts[0]
                                                    .toString()
                                                    .contains("mpeg4")
                                        )
                                            ? Stack(
                                          children: [
                                            Container(
                                              color: Color(
                                                  materialBlack),
                                            ),
                                            Center(
                                                child: Container(
                                                  height: 60.h,
                                                  width: 60.w,
                                                  child: Icon(
                                                    Icons
                                                        .play_arrow_rounded,
                                                    size: 45,
                                                    color:
                                                    Color.fromRGBO(
                                                        248,
                                                        206,
                                                        97,
                                                        1),
                                                  ),
                                                  decoration:
                                                  BoxDecoration(
                                                      shape: BoxShape
                                                          .circle,
                                                      color: Color
                                                          .fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1)),
                                                ))
                                          ],
                                        )
                                            : SizedBox(),
                                        // : CachedNetworkImage(
                                        //     fadeInDuration: const Duration(milliseconds: 400),
                                        //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                        //       child: Container(
                                        //         width: 20.0,
                                        //         height: 20.0,
                                        //         child: CircularProgressIndicator(value: downloadProgress.progress),
                                        //       ),
                                        //     ),
                                        //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
                                        //     fit: BoxFit.cover,
                                        //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                        //   ),
                                        (myFeedsValueNotifier
                                            .value
                                            .item2
                                            .result[gridIndex]
                                            .posts
                                            .length >
                                            1)
                                            ? Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Icon(
                                              Icons
                                                  .collections_rounded,
                                              color: Color(white),
                                              size: 15,
                                            ))
                                            : Container()
                                      ],
                                    ),
                                  );
                                },
                              )
                                  :(myFeedsValueNotifier.value.item1==2)?
                              CircleIndicator() : CircleIndicator()
                          ),

// GridView.builder(
//     gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
//     itemCount: myFeedsValueNotifier.value.item2.result.length,
//     itemBuilder: (context, gridIndex){
// return CachedNetworkImage(
//   fit: BoxFit.cover,
//   fadeInDuration: const Duration(milliseconds: 400),
//   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//     child: Container(
//       width: 20.0,
//       height: 20.0,
//       child: CircularProgressIndicator(value: downloadProgress.progress),
//     ),
//   ),
//   imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//   errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
// );
//
//     }),
//                           GridView.builder(
//                               itemCount: 3,
//                               shrinkWrap: true,
//                               itemBuilder:
//                                   (BuildContext context,
//                                   int index) {
//                                 return Image.network(
//                                     'https://wallpaperaccess.com/full/33115.jpg',
//                                     fit: BoxFit.fill);
//                               },
//                               gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   crossAxisSpacing: 3,
//                                   mainAxisSpacing: 3)),


                        ]),
                        height: 400,
                        //height of TabBarView
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5))),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
      else if (profileDetailsValueNotifier.value.item1 == 2) {


        print('111');
        return exceptionScaffold(
            context: context,
            lottieString: profileDetailsValueNotifier.value.item2
                .lottieString,
            subtitle: profileDetailsValueNotifier.value.item3 ??
                profileDetailsValueNotifier.value.item2.data,
            onPressed: () async {
              return await profileDetailsApiCall();
            });
      }
      else if (profileDetailsValueNotifier.value.item1 == 3) {
        print('222');
        return exceptionScaffold(
            context: context,
            lottieString: invalidLottie,
            subtitle: profileDetailsValueNotifier.value.item3,
            onPressed: () async {
              return await profileDetailsApiCall();
            });
      }
      else {
        print('333');
        return CircleIndicator();
        // return exceptionScaffold(
        //   context: context,
        //   lottieString: profileDetailsValueNotifier.value.item2.lottieString,
        //   subtitle: profileDetailsValueNotifier.value.item2.data,
        // );
      }
    });

  }
}

showConfirmationDialog(BuildContext context) {
  showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return BioDialog(

      );
    },
  );
}