import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/profile/see_more.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../Others/components/ExceptionScaffold.dart';
import '../../Style/Colors.dart';
import '../../Style/Text.dart';
import '../../components/SnackBar.dart';
import '../../components/flatButton.dart';
import '../../core/Models/Default.dart';
import '../tabbar/chats/personal_chat_screen/ChatPage.dart';
import '../tabbar/pops/circle_indicator.dart';
import '/core/models/My_Feeds.dart' as myFeedsModel;
import '../../Authentication/Authentication.dart';
import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '/core/models/profile_detail.dart'as profileDetailsModel ;
import '/core/models/My_Feeds.dart' as myFeedsModel;
class UserProfile extends StatefulWidget {
  final String uid;
  final bool goBack;
  const UserProfile({Key? key ,required this.uid,this.goBack = true}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}
class _UserProfileState extends State<UserProfile> {
   String? uid;
Future? _future;
  String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> myFeedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> followValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  int i=0;

  Future profileDetailsApiCall() async {
    Map<String, String> body = {};
    if (widget.uid == uid.toString()) {
      body = {"user_id":uid.toString(), "followee_id": ""};
    } else {
      body = {"user_id": widget.uid, "followee_id": uid.toString()};
    }
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: profileDetailsUrl,
      requestMethod: 1,
      body: body,
    );
  }
  // Future followApiCall() async {
  //   return await ApiHandler().apiHandler(
  //     valueNotifier: followValueNotifier,
  //     jsonModel: defaultFromJson,
  //     url: followUrl,
  //     requestMethod: 1,
  //     // body: {"user_id": widget.uid, "following_id": getUID()},
  //     body: {"user_id": getUID(), "following_id": widget.uid},
  //   );
  // }
  //
  // Future unfollowApiCall() async {
  //   return await ApiHandler().apiHandler(
  //     valueNotifier: followValueNotifier,
  //     jsonModel: defaultFromJson,
  //     url: unfollowUrl,
  //     requestMethod: 1,
  //     body: {"user_id": getUID(), "following_id": widget.uid},
  //   );
  // }
  Future myFeedsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: myFeedsValueNotifier,
      jsonModel: myFeedsModel.myFeedsFromJson,
      url: myFeedsUrl,
      requestMethod: 1,
      body: {"user_id": widget.uid},
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
    return [data1,data2, data3];
  }

  void initState() {
    _future = sendDatas();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: FutureBuilder(
          future:_future,
          builder: (context,snapshot) {
if(snapshot.hasData) {
  return AnimatedBuilder(
    animation: Listenable.merge([
      profileDetailsValueNotifier,
      myFeedsValueNotifier,
      followValueNotifier
    ]),
    builder: (context, _) {
      return ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (profileDetailsValueNotifier.value.item1 == 1 ||
              profileDetailsValueNotifier.value.item1 == 3) {
            return DefaultTabController(length: 3, initialIndex: 0,
              child: Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(onTap: () {
                    Navigator.pop(context);
                  },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/profile_assets/back_button.svg',
                            height: 30.h, width: 30.w),
                      ],
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        profileDetailsValueNotifier.value.item2
                            .result.profileDetails.username
                            .toString(),
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
                            color: Color.fromRGBO(
                                255, 255, 255, 1)),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                          'assets/profile_assets/commentnotifi.svg',
                          height: 25.h,
                          width: 25.w)
                    ],
                  ),
                  actions: [
                    PopupMenuButton(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                        iconSize: 30,
                        icon: Icon(
                          Icons.more_vert, color: Colors.black,),
                        itemBuilder: (context) =>
                        [
                          PopupMenuItem(child: Text(
                            'Settings', style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(0, 0, 0, 1))
                          ),),)
                        ])
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 176.h, width: double.infinity,
                        child: Stack(
                          children: [ Container(
                            height: 119.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                                    fit: BoxFit.fill)),
                          ),
                            Positioned(
                              top: 92,
                              left: 21,
                              child: Container(
                                height: 94.h,
                                width: 93.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          profileDetailsValueNotifier
                                              .value.item2.result
                                              .profileDetails
                                              .profileUrl,),
                                        fit: BoxFit.fill),
                                    border: Border.all(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 1),
                                        width: 2),
                                    shape: BoxShape.circle),
                              ),
                            ),
                            Positioned(top: 146, left: 170,
                              child: Container(child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        profileDetailsValueNotifier
                                            .value.item2.result
                                            .profileDetails
                                            .postsCount.toString(),
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight
                                                    .w700,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      ),
                                      SizedBox(width: 39.w),
                                      Text(
                                        profileDetailsValueNotifier
                                            .value.item2.result
                                            .profileDetails
                                            .followersCount
                                            .toString(),
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight
                                                    .w700,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      ),
                                      SizedBox(width: 42.w),
                                      Text(
                                        profileDetailsValueNotifier
                                            .value.item2.result
                                            .profileDetails
                                            .followingCount
                                            .toString(),
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight
                                                    .w700,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Pops',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight
                                                    .w400,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      ),
                                      SizedBox(width: 32.w),
                                      Text(
                                        'Following',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight
                                                    .w400,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      ),
                                      SizedBox(width: 25.w),
                                      Text(
                                        'Followers',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight
                                                    .w400,
                                                color: Color
                                                    .fromRGBO(
                                                    0, 0, 0, 1))),
                                      )
                                    ],
                                  ),
                                ],),),
                            ),
                          ],
                        ),),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 27, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profileDetailsValueNotifier.value
                                      .item2.result.profileDetails
                                      .name,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight
                                              .w700,
                                          color: Color.fromRGBO(
                                              0, 0, 0, 1))),
                                ),
                                Spacer(),
// Padding(
//   padding: const EdgeInsets.only(right:35),
//   child: ElevatedButton(
//       style: ElevatedButton.styleFrom(elevation: 0,
//         shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(180.w,29.h),
//       ),
//       onPressed: (){}, child: Text('Follow',style: GoogleFonts.inter(
//       textStyle: TextStyle(
//           color: Color.fromRGBO(0, 0, 0, 1),fontSize:15,fontWeight: FontWeight.w700
//       )
//   ),)),
// ),
// Padding(
//   padding: const EdgeInsets.only(top: 10, bottom: 10),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Flexible(
//         child: flatButton(
//             onPressed: (followValueNotifier.value.item1 == 0)
//                 ? null
//                 : (profileDetailsValueNotifier.value.item2.result.isFollowing)
//                 ? () {
//               return unfollowApiCall().whenComplete(() async {
//                 if (followValueNotifier.value.item1 == 1) {
//                   if (!mounted) return;
//                   setState(() {
//                     profileDetailsValueNotifier.value.item2.result.isFollowing = false;
//                     profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount -= 1;
//                   });
//                 } else if (followValueNotifier.value.item1 == 2 || followValueNotifier.value.item1 == 3) {
//                   final snackBar = snackbar(content: followValueNotifier.value.item3.toString());
//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 }
//               });
//             }
//                 : () {
//               return followApiCall().whenComplete(() async {
//                 if (followValueNotifier.value.item1 == 1) {
//                   if (!mounted) return;
//                   setState(() {
//                     profileDetailsValueNotifier.value.item2.result.isFollowing = true;
//                     profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount += 1;
//                   });
//                 } else if (followValueNotifier.value.item1 == 2 || followValueNotifier.value.item1 == 3) {
//                   final snackBar = snackbar(content: followValueNotifier.value.item3.toString());
//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 }
//               });
//             },
//             size: Size(MediaQuery.of(context).size.width, 45),
//             backgroundColor: Color(accent),
//             child: Text(
//               (profileDetailsValueNotifier.value.item2.result.isFollowing) ? "Unfollow" : "Follow",
//               style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: Color(materialBlack))),
//             )
//         ),
//       ),
//       (!kIsWeb)
//           ? SizedBox(
//         width: 10,
//       )
//           : Container(),
//       (!kIsWeb)
//           ? Flexible(
//         child: flatButton(
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => ChatPage(uid: getUID(), puid: widget.uid, state: 0)));
//             },
//             size: Size(MediaQuery.of(context).size.width, 45),
//             border: true,
//             textbuttonBackgroundColor: Color(white),
//             child: Text(
//               "Message",
//               style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
//             )),
//       )
//           : Container(),
//     ],
//   ),
// )
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
                                  child: Icon(
                                      Icons.location_on_sharp,
                                      color: Colors.white),
                                ),
                                SizedBox(width: 11.w),
                                RichText(text: TextSpan(
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style,
                                    children: [
                                      TextSpan(text: 'Lives in ',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0, 1),
                                                  decoration:
                                                  TextDecoration
                                                      .none
                                              ))),
                                      TextSpan(
                                          text: profileDetailsValueNotifier
                                              .value.item2.result
                                              .profileDetails.city,
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  decoration:
                                                  TextDecoration
                                                      .none
                                              )))
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
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/profile_assets/proffesion.svg'
                                            , height: 12.h,
                                            width: 12.w),
                                      ],
                                    )
                                ),
                                SizedBox(width: 11.w),
                                Text(
                                  profileDetailsValueNotifier.value
                                      .item2.result.profileDetails
                                      .job,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight
                                              .w400,
                                          color: Color.fromRGBO(
                                              0, 0, 0, 1))),
                                ),
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
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/profile_assets/proffesion.svg'
                                            , height: 12.h,
                                            width: 12.w),
                                      ],
                                    )
                                ),
                                SizedBox(width: 11.w),
                                RichText(text: TextSpan(
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style,
                                    children: [
                                      TextSpan(text: 'Working at ',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0, 1),
                                                  decoration:
                                                  TextDecoration
                                                      .none
                                              ))),
                                      TextSpan(
                                          text: profileDetailsValueNotifier
                                              .value.item2.result
                                              .profileDetails
                                              .company,
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  fontSize: 14,
                                                  color: Color
                                                      .fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  decoration: TextDecoration
                                                      .none
                                              )))
                                    ])),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                Text(
                                  'Biog',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight
                                              .w700,
                                          color: Color.fromRGBO(
                                              0, 0, 0, 1))),
                                ),
                              ],
                            ),
                            i == 1 ? Text('') :
                            Column(
                              children: [
                                SizedBox(height: 7.h),
                                Text(
                                  'Your professional bio is an important piece of ...',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight
                                              .w400,
                                          fontSize: 14.sp,
                                          color: Color.fromRGBO(
                                              0, 0, 0, 0.5)
                                      )
                                  ),),
                                Divider(thickness: 1.w,
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
                                    child: Text('See More...',
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .w400,
                                              fontSize: 12.sp,
                                              color: Color.fromRGBO(
                                                  0, 163, 255, 1)
                                          )
                                      ),),
                                  ),
                                ),
                              ],
                            )
                          ],),
                      ),
                      i == 1 ? SeeMoreText(onPressed: () {
                        setState(() {
                          i = 0;
                        });
                      },
                          email: profileDetailsValueNotifier.value
                              .item2.result.profileDetails.email,
                          phone: profileDetailsValueNotifier.value
                              .item2.result.profileDetails.phone) :
                      Column(
                        children: [
                          TabBar(indicator: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(bottom: BorderSide(
                                  color: Colors.transparent
                              ))
                          ),
                              unselectedLabelStyle: GoogleFonts
                                  .inter(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(
                                          0, 0, 0, 1))),
                              unselectedLabelColor: Color.fromRGBO(
                                  151, 145, 145, 1),
                              labelColor: Color.fromRGBO(
                                  0, 0, 0, 1),
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
                              GridView.builder(
                                  itemCount: myFeedsValueNotifier
                                      .value.item2.result.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior
                                          .opaque,
                                      onTap: () {
//dhina
// Navigator.push(context, MaterialPageRoute(builder: (context) => Timeline(
//     uid: widget.uid, scrollIndex: gridIndex)));
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        fit: StackFit.expand,
                                        children: [
                                          (myFeedsValueNotifier
                                              .value.item2
                                              .result[index]
                                              .posts[0]
                                              .toString()
                                              .contains("mp4") ||
                                              myFeedsValueNotifier
                                                  .value.item2
                                                  .result[index]
                                                  .posts[0]
                                                  .toString()
                                                  .contains(
                                                  "mpeg4"))
                                              ? Stack(
                                            children: [
                                              Container(
                                                color: Color(
                                                    materialBlack),
                                              ),
                                              Center(
                                                  child: Icon(
                                                    Icons
                                                        .play_arrow_rounded,
                                                    size: 75,
                                                    color: Color(
                                                        white),
                                                  ))
                                            ],
                                          )
// ? FutureBuilder(
//     future: getThumb(myFeedsValueNotifier.value.item2.result[gridIndex].posts[0]),
//     builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
//       if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//         return Image.memory(
//           snapshot.data!,
//           fit: BoxFit.cover,
//         );
//       } else if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(
//           child: Container(
//             width: 20.0,
//             height: 20.0,
//             child: CircularProgressIndicator(),
//           ),
//         );
//       } else {
//         return Image.asset("assets/errorImage.jpg", fit: BoxFit.cover);
//       }
//     })
// : Image.network(
//     myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//     fit: BoxFit.cover,
//     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//       if (loadingProgress == null) return child;
//       return Center(
//         child: CircularProgressIndicator(
//           value: loadingProgress.expectedTotalBytes != null
//               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//               : null,
//         ),
//       );
//     },
//     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//   ),
                                              : CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            fadeInDuration: const Duration(
                                                milliseconds: 400),
                                            progressIndicatorBuilder: (context,
                                                url,
                                                downloadProgress) =>
                                                Center(
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                                  ),
                                                ),
                                            imageUrl: myFeedsValueNotifier
                                                .value.item2
                                                .result[index]
                                                .posts[0],
                                            errorWidget: (context,
                                                url, error) =>
                                                Image.asset(
                                                    "assets/noProfile.jpg",
                                                    fit: BoxFit
                                                        .cover),
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
                                              .value.item2
                                              .result[index].posts
                                              .length > 1)
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
// return Image.network('https://wallpaperaccess.com/full/33115.jpg',fit:BoxFit.fill);
                                  },
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3)),
                              GridView.builder(
                                  itemCount: 30, shrinkWrap: true,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Image.network(
                                        'https://wallpaperaccess.com/full/33115.jpg',
                                        fit: BoxFit.fill);
                                  },
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3)),
                              GridView.builder(
                                  itemCount: 30, shrinkWrap: true,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Image.network(
                                        'https://wallpaperaccess.com/full/33115.jpg',
                                        fit: BoxFit.fill);
                                  },
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3)),
                            ]),
                            height: 400, //height of TabBarView
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5))),)
                        ],
                      )


                    ],
                  ),
                ),
              ),
            );
          }
          else if (profileDetailsValueNotifier.value.item1 == 2) {
            return CircleIndicator();
            // return exceptionScaffold(
            //     context: context,
            //     goBack: widget.goBack,
            //     lottieString: profileDetailsValueNotifier.value.item2!.lottieString,
            //     subtitle: profileDetailsValueNotifier.value.item3 ?? profileDetailsValueNotifier.value.item2!.data,
            //     onPressed: () async {
            //       return await _future;
            //     });
          } else {
            print('yyyyyyyy');
            return CircleIndicator();
            // return exceptionScaffold(
            //   context: context,
            //   lottieString: profileDetailsValueNotifier.value.item2!.lottieString,
            //   subtitle: profileDetailsValueNotifier.value.item3 ?? profileDetailsValueNotifier.value.item2!.data,
            // );
          }
        },
      );
    },
  );
}
else{return CircleIndicator();}
          }
        ));

  }
}
