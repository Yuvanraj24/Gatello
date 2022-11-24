// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gatello/views/profile/editprofile.dart';
// import 'package:gatello/views/profile/see_more.dart';
// import 'package:gatello/views/tabbar/pops/circle_indicator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Others/components/ExceptionScaffold.dart';
// import '../../Others/lottie_strings.dart';
// import '../../Style/Colors.dart';
// import '/core/models/My_Feeds.dart' as myFeedsModel;
// import 'package:intl/intl.dart';
// import 'package:tuple/tuple.dart';
// import '../../Others/Routers.dart';
// import '../../Others/exception_string.dart';
// import '../../core/models/exception/pops_exception.dart';
// import '../../handler/Network.dart';
// import 'bio_dialog.dart';
// import '/core/models/profile_detail.dart' as profileDetailsModel;
// import 'followers.dart';
//
// class Profile extends StatefulWidget {
//   final String? userId;
//
//   const Profile({Key? key, this.userId}) : super(key: key);
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   Future? _future;
//   String? uid;
//   String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);
//   ValueNotifier<Tuple4> myFeedsValueNotifier = ValueNotifier<Tuple4>(
//       Tuple4(0, exceptionFromJson(loading), "Loading", null));
//   ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(
//       Tuple4(0, exceptionFromJson(loading), "Loading", null));
//
//   ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(
//       Tuple4(0, exceptionFromJson(loading), "Loading", null));
//   int i = 0;
//
//   Future profileDetailsApiCall() async {
//     print('dhina:${widget.userId} ');
//     return await ApiHandler().apiHandler(
//       valueNotifier: profileDetailsValueNotifier,
//       jsonModel: profileDetailsModel.profileDetailsFromJson,
//       url: profileDetailsUrl,
//       requestMethod: 1,
//       body: {
//         "user_id": (widget.userId != null)
//             ? widget.userId
//             : uid,
//         "followee_id": ""
//       },
//     );
//   }
//
//   // @override
//   // void initState() {
//   //
//   //   profileDetailsApiCall();
//   //   super.initState();
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   profileDetailsValueNotifier.dispose();
//   //   super.dispose();
//   // }
//   // Future feedsApiCall() async {
//   //   return await ApiHandler().apiHandler(
//   //     valueNotifier: feedsValueNotifier,
//   //     jsonModel: myFeedsModel.myFeedsFromJson,
//   //     url: myFeedsUrl,
//   //     requestMethod: 1,
//   //     body: {"user_id":  's8b6XInslPffQEgz8sVTINsPhcx2'},
//   //   );
//   // }
//   Future myFeedsApiCall() async {
//     return await ApiHandler().apiHandler(
//       valueNotifier: myFeedsValueNotifier,
//       jsonModel: myFeedsModel.myFeedsFromJson,
//       url: myFeedsUrl,
//       requestMethod: 1,
//       body: {"user_id": uid},
//     );
//   }
//   Future<void> _getUID() async {
//     print('uidapi');
//     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//     uid = sharedPrefs.getString("userid");
//     print("ShardPref ${uid}");
//   }
//   Future<dynamic> sendDatas() async {
//     final data1=await _getUID();
//     final data2 = await profileDetailsApiCall();
//     final data3 = await myFeedsApiCall();
//     return [data1,data2, data3];
//   }
//
//   void initState() {
//     _future = sendDatas();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _future,
//         builder: (context, _) {
//    return   AnimatedBuilder(
//           animation: Listenable.merge([profileDetailsValueNotifier]),
//           builder: (context, value) {
//             return ResponsiveBuilder(builder: (context, snapshot) {
//
//               if (profileDetailsValueNotifier.value.item1 == 1) {
//
//           return DefaultTabController(
//             length: 3,
//             initialIndex: 1,
//             child: Scaffold(
//               appBar: AppBar(
//                 leading: GestureDetector(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: SvgPicture.asset(
//                             'assets/profile_assets/back_button.svg',
//                             height: 30.h,
//                             width: 30.w),
//                       ),
//                     ],
//                   ),
//                 ),
//                 title: Row(
//                   children: [
//                     Text(
//                       profileDetailsValueNotifier
//                           .value.item2.result.profileDetails.username,
//                       // 'Suresh Offical',
//
//                       style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Color.fromRGBO(0, 0, 0, 1))),
//                     ),
//                     SizedBox(width: 7.w),
//                     Container(
//                       height: 14.h,
//                       width: 14.w,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color.fromRGBO(0, 163, 255, 1)),
//                       child: Icon(Icons.check_rounded,
//                           size: 12, color: Color.fromRGBO(255, 255, 255, 1)),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   PopupMenuButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(2)),
//                       iconSize: 30,
//                       icon: Icon(
//                         Icons.more_vert,
//                         color: Colors.black,
//                       ),
//                       itemBuilder: (context) => [
//                             PopupMenuItem(
//                               child: Center(
//                                 child: Text(
//                                   'Settings',
//                                   style: GoogleFonts.inter(
//                                       textStyle: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 14,
//                                           color: Color.fromRGBO(0, 0, 0, 1))),
//                                 ),
//                               ),
//                             )
//                           ])
//                 ],
//               ),
//               body: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 176.h,
//                       width: double.infinity,
//                       child: Stack(
//                         children: [
//                           Container(
//                             height: 119.h,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: NetworkImage(
//                                         'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
//                                     fit: BoxFit.fill)),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 85,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Edit_Profile()));
//                               },
//                               child: Container(
//                                 height: 23.h,
//                                 width: 23.w,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                         'assets/profile_assets/edittoolblack.svg',
//                                         height: 15,
//                                         width: 15),
//                                   ],
//                                 ),
//                                 decoration: BoxDecoration(
//                                     color: Color.fromRGBO(248, 206, 97, 1),
//                                     border: Border.all(
//                                         color: Color.fromRGBO(255, 255, 255, 1),
//                                         width: 1),
//                                     shape: BoxShape.circle),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 92,
//                             left: 21,
//                             child: Container(
//                               height: 94.h,
//                               width: 93.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                         profileDetailsValueNotifier.value.item2
//                                             .result.profileDetails.profileUrl,
//                                       ),
//                                       fit: BoxFit.fill),
//                                   border: Border.all(
//                                       color: Color.fromRGBO(255, 255, 255, 1),
//                                       width: 2),
//                                   shape: BoxShape.circle),
//                             ),
//                           ),
//                           Positioned(
//                             left: 108,
//                             top: 155,
//                             child: Container(
//                               height: 23.h,
//                               width: 23.w,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               Edit_Profile()));
//                                 },
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                         'assets/profile_assets/edittoolblack.svg',
//                                         height: 15,
//                                         width: 15),
//                                   ],
//                                 ),
//                               ),
//                               decoration: BoxDecoration(
//                                   color: Color.fromRGBO(248, 206, 97, 1),
//                                   border: Border.all(
//                                       color: Color.fromRGBO(255, 255, 255, 1),
//                                       width: 1),
//                                   shape: BoxShape.circle),
//                             ),
//                           ),
//                           Positioned(
//                             top: 146,
//                             left: 170,
//                             child: Container(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       InkWell(
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               profileDetailsValueNotifier
//                                                   .value
//                                                   .item2
//                                                   .result
//                                                   .profileDetails
//                                                   .postsCount
//                                                   .toString(),
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             ),
//                                             Text(
//                                               'Pops',
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 12.sp,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             ),
//                                           ],
//                                         ),
//                                         onTap: () {},
//                                       ),
//                                       SizedBox(width: 39.w),
//                                       InkWell(
//                                         onTap: () {},
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               profileDetailsValueNotifier
//                                                   .value
//                                                   .item2
//                                                   .result
//                                                   .profileDetails
//                                                   .followingCount
//                                                   .toString(),
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             ),
//                                             Text(
//                                               'Following',
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 12.sp,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(width: 25.w),
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     Followers_Page(
//                                                         Id: profileDetailsValueNotifier
//                                                             .value
//                                                             .item2
//                                                             .result
//                                                             .profileDetails
//                                                             .userId)),
//                                           );
//                                         },
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               profileDetailsValueNotifier
//                                                   .value
//                                                   .item2
//                                                   .result
//                                                   .profileDetails
//                                                   .followersCount
//                                                   .toString(),
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             ),
//                                             Text(
//                                               'Followers',
//                                               style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       fontSize: 12.sp,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Color.fromRGBO(
//                                                           0, 0, 0, 1))),
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 27, top: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 profileDetailsValueNotifier
//                                     .value.item2.result.profileDetails.name,
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 20.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                               Spacer(),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 12),
//                                 child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       elevation: 1,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18)),
//                                       primary: Color.fromRGBO(255, 255, 255, 1),
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   Edit_Profile()));
//                                     },
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           'EDIT',
//                                           style: GoogleFonts.inter(
//                                               textStyle: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.w400,
//                                                   color: Color.fromRGBO(
//                                                       0, 163, 255, 1))),
//                                         ),
//                                         SvgPicture.asset(
//                                             'assets/profile_assets/Edit_tool.svg')
//                                       ],
//                                     )),
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 height: 25.h,
//                                 width: 25.w,
//                                 decoration: BoxDecoration(
//                                     color: Color.fromRGBO(165, 165, 165, 0.9),
//                                     shape: BoxShape.circle),
//                                 child: Icon(Icons.location_on_sharp,
//                                     color: Colors.white),
//                               ),
//                               SizedBox(width: 11.w),
//                               RichText(
//                                   text: TextSpan(
//                                       style: DefaultTextStyle.of(context).style,
//                                       children: [
//                                     TextSpan(
//                                         text: 'Lives in ',
//                                         style: GoogleFonts.inter(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: 14,
//                                                 color:
//                                                     Color.fromRGBO(0, 0, 0, 1),
//                                                 decoration:
//                                                     TextDecoration.none))),
//                                     TextSpan(
//                                         text: profileDetailsValueNotifier.value
//                                             .item2.result.profileDetails.city,
//                                         style: GoogleFonts.inter(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 14,
//                                                 color: Color.fromRGBO(
//                                                     0, 0, 0, 0.5),
//                                                 decoration:
//                                                     TextDecoration.none)))
//                                   ])),
//                             ],
//                           ),
//                           SizedBox(height: 9.h),
//                           Row(
//                             children: [
//                               Container(
//                                   height: 25.h,
//                                   width: 25.w,
//                                   decoration: BoxDecoration(
//                                       color: Color.fromRGBO(165, 165, 165, 0.9),
//                                       shape: BoxShape.circle),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SvgPicture.asset(
//                                           'assets/profile_assets/proffesion.svg',
//                                           height: 12.h,
//                                           width: 12.w),
//                                     ],
//                                   )),
//                               SizedBox(width: 11.w),
//                               Text(
//                                 profileDetailsValueNotifier
//                                     .value.item2.result.profileDetails.job,
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 9.h),
//                           Row(
//                             children: [
//                               Container(
//                                   height: 25.h,
//                                   width: 25.w,
//                                   decoration: BoxDecoration(
//                                       color: Color.fromRGBO(165, 165, 165, 0.9),
//                                       shape: BoxShape.circle),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SvgPicture.asset(
//                                           'assets/profile_assets/proffesion.svg',
//                                           height: 12.h,
//                                           width: 12.w),
//                                     ],
//                                   )),
//                               SizedBox(width: 11.w),
//                               RichText(
//                                   text: TextSpan(
//                                       style: DefaultTextStyle.of(context).style,
//                                       children: [
//                                     TextSpan(
//                                         text: 'Working at ',
//                                         style: GoogleFonts.inter(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: 14,
//                                                 color:
//                                                     Color.fromRGBO(0, 0, 0, 1),
//                                                 decoration:
//                                                     TextDecoration.none))),
//                                     TextSpan(
//                                         text: profileDetailsValueNotifier
//                                             .value
//                                             .item2
//                                             .result
//                                             .profileDetails
//                                             .company,
//                                         style: GoogleFonts.inter(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 14,
//                                                 color: Color.fromRGBO(
//                                                     0, 0, 0, 0.5),
//                                                 decoration:
//                                                     TextDecoration.none)))
//                                   ])),
//                             ],
//                           ),
//                           SizedBox(height: 14.h),
//                           Row(
//                             children: [
//                               InkWell(
//                                 onTap: () {},
//                                 child: Text('Biog',
//                                     style: GoogleFonts.inter(
//                                       textStyle: TextStyle(
//                                           fontSize: 20.sp,
//                                           fontWeight: FontWeight.w700,
//                                           color: Color.fromRGBO(0, 0, 0, 1)),
//                                     )),
//                               ),
//                               SizedBox(width: 10.w),
//                               GestureDetector(
//                                 onTap: () {
//                                   Future.delayed(Duration(seconds: 0),
//                                       () => showConfirmationDialog(context));
//                                 },
//                                 child: Container(
//                                     height: 20,
//                                     width: 20,
//                                     child: SvgPicture.asset(
//                                         'assets/profile_assets/Edit_tool.svg',
//                                         color: i == 1
//                                             ? Color.fromRGBO(0, 163, 255, 1)
//                                             : Colors.transparent)),
//                               ),
//                             ],
//                           ),
//                           i == 1
//                               ? Text('')
//                               : Column(
//                                   children: [
//                                     SizedBox(height: 7.h),
//                                     Text(
//                                       'Your professional bio is an important piece of ...',
//                                       style: GoogleFonts.inter(
//                                           textStyle: TextStyle(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: 14.sp,
//                                               color: Color.fromRGBO(
//                                                   0, 0, 0, 0.5))),
//                                     ),
//                                     Divider(
//                                         thickness: 1.w,
//                                         color: Color.fromRGBO(228, 228, 228, 1),
//                                         indent: 22,
//                                         endIndent: 18),
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           i = 1;
//                                         });
//                                       },
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 285, bottom: 10, top: 5),
//                                         child: Text(
//                                           'See More...',
//                                           style: GoogleFonts.inter(
//                                               textStyle: TextStyle(
//                                                   fontWeight: FontWeight.w400,
//                                                   fontSize: 12.sp,
//                                                   color: Color.fromRGBO(
//                                                       0, 163, 255, 1))),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                         ],
//                       ),
//                     ),
//                     i == 1
//                         ? SeeMoreText(
//                             onPressed: () {
//                               setState(() {
//                                 i = 0;
//                               });
//                             },
//                             phone: profileDetailsValueNotifier
//                                 .value.item2.result.profileDetails.phone,
//                             email: profileDetailsValueNotifier
//                                 .value.item2.result.profileDetails.email,
//                           )
//                         : Column(
//                             children: [
//                               TabBar(
//                                   indicator: BoxDecoration(
//                                       color: Colors.transparent,
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.transparent))),
//                                   unselectedLabelStyle: GoogleFonts.inter(
//                                       textStyle: TextStyle(
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color.fromRGBO(0, 0, 0, 1))),
//                                   unselectedLabelColor:
//                                       Color.fromRGBO(151, 145, 145, 1),
//                                   labelColor: Color.fromRGBO(0, 0, 0, 1),
//                                   labelStyle: GoogleFonts.inter(
//                                       textStyle: TextStyle(
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w700,
//                                           color: Color.fromRGBO(0, 0, 0, 1))),
//                                   tabs: [
//                                     Text('All Pops'),
//                                     Text('Photo Pops'),
//                                     Text('Video Pops'),
//                                   ]),
//                               Container(
//                                 padding: EdgeInsets.only(top: 10),
//                                 child: TabBarView(children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 20),
//                                     child: GridView.builder(
//                                       itemCount: myFeedsValueNotifier
//                                           .value.item2.result.length,
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 3,
//                                               mainAxisSpacing: 5,
//                                               crossAxisSpacing: 5),
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemBuilder: (context, gridIndex) {
//                                         return GestureDetector(
//                                           behavior: HitTestBehavior.opaque,
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Profile()));
//                                           },
//                                           child: Stack(
//                                             alignment: Alignment.center,
//                                             fit: StackFit.expand,
//                                             children: [
//                                               (myFeedsValueNotifier
//                                                           .value
//                                                           .item2
//                                                           .result[gridIndex]
//                                                           .posts[0]
//                                                           .toString()
//                                                           .contains("mp4") ||
//                                                       myFeedsValueNotifier
//                                                           .value
//                                                           .item2
//                                                           .result[gridIndex]
//                                                           .posts[0]
//                                                           .toString()
//                                                           .contains("mpeg4"))
//                                                   ? Stack(
//                                                       children: [
//                                                         Container(
//                                                           color: Color(
//                                                               materialBlack),
//                                                         ),
//                                                         Center(
//                                                             child: Container(
//                                                           height: 60.h,
//                                                           width: 60.w,
//                                                           child: Icon(
//                                                             Icons
//                                                                 .play_arrow_rounded,
//                                                             size: 45,
//                                                             color:
//                                                                 Color.fromRGBO(
//                                                                     248,
//                                                                     206,
//                                                                     97,
//                                                                     1),
//                                                           ),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                                   shape: BoxShape
//                                                                       .circle,
//                                                                   color: Color
//                                                                       .fromRGBO(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           1)),
//                                                         ))
//                                                       ],
//                                                     )
//                                                   : CachedNetworkImage(
//                                                       fit: BoxFit.cover,
//                                                       fadeInDuration:
//                                                           const Duration(
//                                                               milliseconds:
//                                                                   400),
//                                                       progressIndicatorBuilder:
//                                                           (context, url,
//                                                                   downloadProgress) =>
//                                                               Center(
//                                                         child: Container(
//                                                           width: 20.0,
//                                                           height: 20.0,
//                                                           child: CircularProgressIndicator(
//                                                               value:
//                                                                   downloadProgress
//                                                                       .progress),
//                                                         ),
//                                                       ),
//                                                       imageUrl:
//                                                           myFeedsValueNotifier
//                                                               .value
//                                                               .item2
//                                                               .result[gridIndex]
//                                                               .posts[0],
//                                                       errorWidget: (context,
//                                                               url, error) =>
//                                                           Image.asset(
//                                                               "assets/noProfile.jpg",
//                                                               fit:
//                                                                   BoxFit.cover),
//                                                     ),
//                                               // : CachedNetworkImage(
//                                               //     fadeInDuration: const Duration(milliseconds: 400),
//                                               //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                               //       child: Container(
//                                               //         width: 20.0,
//                                               //         height: 20.0,
//                                               //         child: CircularProgressIndicator(value: downloadProgress.progress),
//                                               //       ),
//                                               //     ),
//                                               //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//                                               //     fit: BoxFit.cover,
//                                               //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
//                                               //   ),
//                                               (myFeedsValueNotifier
//                                                           .value
//                                                           .item2
//                                                           .result[gridIndex]
//                                                           .posts
//                                                           .length >
//                                                       1)
//                                                   ? Positioned(
//                                                       top: 5,
//                                                       right: 5,
//                                                       child: Icon(
//                                                         Icons
//                                                             .collections_rounded,
//                                                         color: Color(white),
//                                                         size: 15,
//                                                       ))
//                                                   : Container()
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   // GridView.builder(
//                                   //     itemCount:5,
//                                   //   //  feedsValueNotifier.value.item2.result.length,
//                                   //     shrinkWrap:true,
//                                   //     itemBuilder: ( context,index){
//                                   //
//                                   //       return InkWell(
//                                   //         onTap: (){
//                                   //           print('dhina:${ feedsValueNotifier.value.item2.result[index].posts[index]}');
//                                   //         },
//                                   //         child: Image.network(
//                                   //            // feedsValueNotifier.value.item2.result[index].posts[index],
//                                   //             'https://wallpaperaccess.com/full/33115.jpg',
//                                   //            // 'https://z.com/full/33115.jpg',
//                                   //             fit:BoxFit.fill),
//                                   //       );},
//                                   //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
//                                   //         crossAxisSpacing:3,mainAxisSpacing:3)),
//
// // GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
// //     itemCount: myFeedsValueNotifier.value.item2.result.length,
// //     itemBuilder: (context, gridIndex){
// // return CachedNetworkImage(
// //   fit: BoxFit.cover,
// //   fadeInDuration: const Duration(milliseconds: 400),
// //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
// //     child: Container(
// //       width: 20.0,
// //       height: 20.0,
// //       child: CircularProgressIndicator(value: downloadProgress.progress),
// //     ),
// //   ),
// //   imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
// //   errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
// // );
// //
// //     }),
//                                   GridView.builder(
//                                       itemCount: 5,
//                                       shrinkWrap: true,
//                                       itemBuilder:
//                                           (BuildContext context, int index) {
//                                         return Image.network(
//                                             'https://wallpaperaccess.com/full/33115.jpg',
//                                             fit: BoxFit.fill);
//                                       },
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 3,
//                                               crossAxisSpacing: 3,
//                                               mainAxisSpacing: 3)),
//
//                                   GridView.builder(
//                                       itemCount: 5,
//                                       shrinkWrap: true,
//                                       itemBuilder:
//                                           (BuildContext context, int index) {
//                                         return Image.network(
//                                             'https://wallpaperaccess.com/full/33115.jpg',
//                                             fit: BoxFit.fill);
//                                       },
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 3,
//                                               crossAxisSpacing: 3,
//                                               mainAxisSpacing: 3)),
//                                 ]),
//                                 height: 400,
//                                 //height of TabBarView
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                         top: BorderSide(
//                                             color: Colors.grey, width: 0.5))),
//                               )
//                             ],
//                           )
//                   ],
//                 ),
//               ),
//             ),
//           );
//               }
//               else if (profileDetailsValueNotifier.value.item1 == 2) {
//                 print('111');
//                 return exceptionScaffold(
//                     context: context,
//                     lottieString: profileDetailsValueNotifier.value.item2.lottieString,
//                     subtitle: profileDetailsValueNotifier.value.item3 ?? profileDetailsValueNotifier.value.item2.data,
//                     onPressed: () async {
//                       return await profileDetailsApiCall();
//                     });
//               }
//               else if (profileDetailsValueNotifier.value.item1 == 3) {
//                 print('222');
//                 return exceptionScaffold(
//                     context: context,
//                     lottieString: invalidLottie,
//                     subtitle: profileDetailsValueNotifier.value.item3,
//                     onPressed: () async {
//                       return await profileDetailsApiCall();
//                     });
//               }
//               else {
//                 print('333');
//                 return CircleIndicator();
//                 // return exceptionScaffold(
//                 //   context: context,
//                 //   lottieString: profileDetailsValueNotifier.value.item2.lottieString,
//                 //   subtitle: profileDetailsValueNotifier.value.item2.data,
//                 // );
//               }
//             });
//           });
//         });
//   }
// }
//
// showConfirmationDialog(BuildContext context) {
//   showDialog(
//     // barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return BioDialog();
//     },
//   );
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/profile/editprofile.dart';


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
import '/core/models/profile_detail.dart' as profileDetailsModel;
import 'followers.dart';


class Profile extends StatefulWidget {
  final String? userId;

  const Profile({Key? key, this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future? _future;
  String? uid;
  String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);
  ValueNotifier<Tuple4> myFeedsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));

  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));
  int i = 0;

  Future profileDetailsApiCall() async {
    print('dhina:${widget.userId} ');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: profileDetailsUrl,
      requestMethod: 1,
      body: {
        "user_id": (widget.userId != null)
            ? widget.userId
            : uid,
        "followee_id": ""
      },
    );
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
    _future = sendDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return AnimatedBuilder(
                animation: Listenable.merge([profileDetailsValueNotifier]),
                builder: (context, value) {
                  return ResponsiveBuilder(builder: (context, snapshot) {
                    if (profileDetailsValueNotifier.value.item1 == 1) {
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
                                  profileDetailsValueNotifier
                                      .value.item2.result.profileDetails
                                      .username,
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
                                  height: 176.h,
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 119.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                                                fit: BoxFit.fill)),
                                      ),
                                      Positioned(
                                        right: 12,
                                        top: 85,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Edit_Profile()));
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
                                        top: 92,
                                        left: 21,
                                        child: Container(
                                          height: 94.h,
                                          width: 93.w,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    profileDetailsValueNotifier
                                                        .value.item2
                                                        .result.profileDetails
                                                        .profileUrl.toString(),

                                                  ),
                                                  fit: BoxFit.fill),
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  width: 2),
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      Positioned(
                                        left: 108,
                                        top: 155,
                                        child: Container(
                                          height: 23.h,
                                          width: 23.w,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Edit_Profile()));
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
                                        top: 146,
                                        left: 170,
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
                                                                        .userId.toString())),
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
                                                              Edit_Profile()));
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
                                                        profileDetailsValueNotifier
                                                            .value
                                                            .item2.result
                                                            .profileDetails
                                                            .city.toString(),

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
                                          Text(
                                            profileDetailsValueNotifier
                                                .value.item2.result
                                                .profileDetails.job.toString(),
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
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
                                                        text: profileDetailsValueNotifier
                                                            .value
                                                            .item2
                                                            .result
                                                            .profileDetails
                                                            .company.toString(),
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
                                          InkWell(
                                            onTap: () {},
                                            child: Text('Biog',
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1)),
                                                )),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () {

                                            },
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                child: SvgPicture.asset(
                                                    'assets/profile_assets/Edit_tool.svg',
                                                    color: i == 1
                                                        ? Color.fromRGBO(
                                                        0, 163, 255, 1)
                                                        : Colors.transparent)),
                                          ),
                                        ],
                                      ),
                                      i == 1
                                          ? Text('')
                                          : Column(
                                        children: [
                                          SizedBox(height: 7.h),
                                          Text(
                                            'Your professional bio is an important piece of ...',
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
                                      .value.item2.result.profileDetails.phone,

                                  email:
                                  profileDetailsValueNotifier
                                      .value.item2.result.profileDetails.email,
uid: uid.toString(),
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
                                          // child: GridView.builder(
                                          //   itemCount: myFeedsValueNotifier
                                          //       .value.item2.result.length,
                                          //   gridDelegate:
                                          //   SliverGridDelegateWithFixedCrossAxisCount(
                                          //       crossAxisCount: 3,
                                          //       mainAxisSpacing: 5,
                                          //       crossAxisSpacing: 5),
                                          //   physics: NeverScrollableScrollPhysics(),
                                          //   shrinkWrap: true,
                                          //   itemBuilder: (context, gridIndex) {
                                          //     return GestureDetector(
                                          //       behavior: HitTestBehavior
                                          //           .opaque,
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     Profile()));
                                          //       },
                                          //       child: Stack(
                                          //         alignment: Alignment.center,
                                          //         fit: StackFit.expand,
                                          //         children: [
                                          //           (myFeedsValueNotifier
                                          //               .value
                                          //               .item2
                                          //               .result[gridIndex]
                                          //               .posts[0]
                                          //               .toString()
                                          //               .contains("mp4") ||
                                          //               myFeedsValueNotifier
                                          //                   .value
                                          //                   .item2
                                          //                   .result[gridIndex]
                                          //                   .posts[0]
                                          //                   .toString()
                                          //                   .contains("mpeg4"))
                                          //               ? Stack(
                                          //             children: [
                                          //               Container(
                                          //                 color: Color(
                                          //                     materialBlack),
                                          //               ),
                                          //               Center(
                                          //                   child: Container(
                                          //                     height: 60.h,
                                          //                     width: 60.w,
                                          //                     child: Icon(
                                          //                       Icons
                                          //                           .play_arrow_rounded,
                                          //                       size: 45,
                                          //                       color:
                                          //                       Color.fromRGBO(
                                          //                           248,
                                          //                           206,
                                          //                           97,
                                          //                           1),
                                          //                     ),
                                          //                     decoration:
                                          //                     BoxDecoration(
                                          //                         shape: BoxShape
                                          //                             .circle,
                                          //                         color: Color
                                          //                             .fromRGBO(
                                          //                             255,
                                          //                             255,
                                          //                             255,
                                          //                             1)),
                                          //                   ))
                                          //             ],
                                          //           )
                                          //               : CachedNetworkImage(
                                          //             fit: BoxFit.cover,
                                          //             fadeInDuration:
                                          //             const Duration(
                                          //                 milliseconds:
                                          //                 400),
                                          //             progressIndicatorBuilder:
                                          //                 (context, url,
                                          //                 downloadProgress) =>
                                          //                 Center(
                                          //                   child: Container(
                                          //                     width: 20.0,
                                          //                     height: 20.0,
                                          //                     child: CircularProgressIndicator(
                                          //                         value:
                                          //                         downloadProgress
                                          //                             .progress),
                                          //                   ),
                                          //                 ),
                                          //             imageUrl:
                                          //             myFeedsValueNotifier
                                          //                 .value
                                          //                 .item2
                                          //                 .result[gridIndex]
                                          //                 .posts[0],
                                          //             errorWidget: (context,
                                          //                 url, error) =>
                                          //                 Image.asset(
                                          //                     "assets/noProfile.jpg",
                                          //                     fit:
                                          //                     BoxFit.cover),
                                          //           ),
                                          //           // : CachedNetworkImage(
                                          //           //     fadeInDuration: const Duration(milliseconds: 400),
                                          //           //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                          //           //       child: Container(
                                          //           //         width: 20.0,
                                          //           //         height: 20.0,
                                          //           //         child: CircularProgressIndicator(value: downloadProgress.progress),
                                          //           //       ),
                                          //           //     ),
                                          //           //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
                                          //           //     fit: BoxFit.cover,
                                          //           //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                          //           //   ),
                                          //           (myFeedsValueNotifier
                                          //               .value
                                          //               .item2
                                          //               .result[gridIndex]
                                          //               .posts
                                          //               .length >
                                          //               1)
                                          //               ? Positioned(
                                          //               top: 5,
                                          //               right: 5,
                                          //               child: Icon(
                                          //                 Icons
                                          //                     .collections_rounded,
                                          //                 color: Color(white),
                                          //                 size: 15,
                                          //               ))
                                          //               : Container()
                                          //         ],
                                          //       ),
                                          //     );
                                          //   },
                                          // ),
                                        ),
                                        GridView.builder(
                                            itemCount:5,
                                          //  feedsValueNotifier.value.item2.result.length,
                                            shrinkWrap:true,
                                            itemBuilder: ( context,index){

                                              return InkWell(
                                                onTap: (){
                                                  print('dhina:${ feedsValueNotifier.value.item2.result[index].posts[index]}');
                                                },
                                                child: Image.network(
                                                   // feedsValueNotifier.value.item2.result[index].posts[index],
                                                    'https://wallpaperaccess.com/full/33115.jpg',
                                                   // 'https://z.com/full/33115.jpg',
                                                    fit:BoxFit.fill),
                                              );},
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                                                crossAxisSpacing:3,mainAxisSpacing:3)),

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
                                        GridView.builder(
                                            itemCount: 5,
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Image.network(
                                                  'https://wallpaperaccess.com/full/33115.jpg',
                                                  fit: BoxFit.fill);
                                            },
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 3,
                                                mainAxisSpacing: 3)),

                                        GridView.builder(
                                            itemCount: 5,
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Image.network(
                                                  'https://wallpaperaccess.com/full/33115.jpg',
                                                  fit: BoxFit.fill);
                                            },
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 3,
                                                mainAxisSpacing: 3)),
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
                });
          }
          else{
            return CircleIndicator();
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