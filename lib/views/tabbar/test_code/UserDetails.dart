// import 'dart:typed_data';
//
// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tuple/tuple.dart';
// import '../../../Others/Routers.dart';
// import '../../../Others/components/ExceptionScaffold.dart';
// import '../../../Others/components/LottieComposition.dart';
// import '../../../Others/exception_string.dart';
// import '../../../Others/lottie_strings.dart';
// import '../../../Style/Colors.dart';
// import '../../../Style/Text.dart';
// import '../../../components/ScaffoldDialog.dart';
// import '../../../components/SnackBar.dart';
// import '../../../components/container.dart';
// import '../../../components/flatButton.dart';
// import '../../../core/Models/Default.dart';
// import '../../../core/models/exception/pops_exception.dart';
// import '../../../handler/Network.dart';
// import '../../../main.dart';
// import '../../test_code/Search.dart';
// import '../chats/personal_chat_screen/ChatPage.dart';
// import '../pops/circle_indicator.dart';
// import '/core/models/My_Feeds.dart' as myFeedsModel;
// // import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '/core/models/profile_detail.dart'as profileDetailsModel ;
//
// class UserDetails_Page extends StatefulWidget {
//   final String uid;
//   final bool goBack;
//   const UserDetails_Page({Key? key, required this.uid, this.goBack = true}) : super(key: key);
//
//   @override
//   _UserDetails_PageState createState() => _UserDetails_PageState();
// }
//
// class _UserDetails_PageState extends State<UserDetails_Page> with AutomaticKeepAliveClientMixin<UserDetails_Page> {
//  String? uid;
//  Future? _future;
//   @override
//   bool get wantKeepAlive => true;
//   ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
//   ValueNotifier<Tuple4> myFeedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
//   ValueNotifier<Tuple4> followValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
//
//   Future profileDetailsApiCall() async {
//     Map<String, String> body = {};
//     if (widget.uid == uid) {
//
//       body = {"user_id": uid.toString(), "followee_id": ""};
//     } else {
//
//       body = {"user_id": widget.uid, "followee_id": uid.toString()};
//     }
//     return await ApiHandler().apiHandler(
//       valueNotifier: profileDetailsValueNotifier,
//       jsonModel: profileDetailsModel.profileDetailsFromJson,
//       url: profileDetailsUrl,
//       requestMethod: 1,
//       body: body,
//     );
//   }
//   Future followApiCall() async {
//     return await ApiHandler().apiHandler(
//       valueNotifier: followValueNotifier,
//       jsonModel: defaultFromJson,
//       url: followUrl,
//       requestMethod: 1,
//       // body: {"user_id": widget.uid, "following_id": getUID()},
//       body: {"user_id": uid, "following_id": widget.uid},
//     );
//   }
//
//   Future unfollowApiCall() async {
//     return await ApiHandler().apiHandler(
//       valueNotifier: followValueNotifier,
//       jsonModel: defaultFromJson,
//       url: unfollowUrl,
//       requestMethod: 1,
//       body: {"user_id":uid, "following_id": widget.uid},
//     );
//   }
//
//   Future myFeedsApiCall() async {
//     return await ApiHandler().apiHandler(
//       valueNotifier: myFeedsValueNotifier,
//       jsonModel: myFeedsModel.myFeedsFromJson,
//       url: myFeedsUrl,
//       requestMethod: 1,
//       body: {"user_id": widget.uid},
//     );
//   }
//  Future<void> _getUID() async {
//    print('uidapi');
//    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    uid = sharedPrefs.getString("userid");
//    print("ShardPref ${uid}");
//  }
//   Future<dynamic> userCheck() async{
//     final data1 = await _getUID();
//     final data2 = await profileDetailsApiCall();
//     final data3 = await myFeedsApiCall();
//     // final data4 = await followApiCall();
//     // final data5=await unfollowApiCall();
//     return [data1,data2,data3,];
//   }
//
//
//   @override
//   void initState() {
//  _future=userCheck();
//     super.initState();
//   }
//
//   // initialiser() async {
//   //   await myFeedsApiCall();
//   //   await profileDetailsApiCall();
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return SafeArea(
//         child: FutureBuilder(
//           future: _future,
//           builder: (context,_) {
//             return AnimatedBuilder(
//       animation: Listenable.merge([profileDetailsValueNotifier, myFeedsValueNotifier, followValueNotifier]),
//       builder: (context, _) {
//             return ResponsiveBuilder(
//               builder: (context, sizingInformation) {
//                 if (profileDetailsValueNotifier.value.item1 == 1 || profileDetailsValueNotifier.value.item1 == 3) {
//                   return Scaffold(
//                     backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
//                     resizeToAvoidBottomInset: false,
//                     appBar: AppBar(
//                       centerTitle: false,
//                       automaticallyImplyLeading: false,
//                       elevation: 0,
//                       actions: [
//                         (sizingInformation.deviceScreenType != DeviceScreenType.desktop)
//                             ? IconButton(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 hoverColor: Colors.transparent,
//                                 onPressed: () async {
//                                   // if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//                                   //   return await scaffoldAlertDialogBox(
//                                   //       context: context,
//                                   //       page: SearchPage(
//                                   //         state: 6,
//                                   //         sizingInformation: sizingInformation,
//                                   //       ));
//                                   // } else {
//                                   //   Navigator.push(
//                                   //       context,
//                                   //       MaterialPageRoute(
//                                   //           builder: (context) => SearchPage(
//                                   //                 state: 6,
//                                   //                 sizingInformation: sizingInformation,
//                                   //               )));
//                                   // }
//                                 },
//                                 icon: Icon(Icons.search))
//                             : GestureDetector(
//                                 // onTap: () async {
//                                 //   if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//                                 //     return await scaffoldAlertDialogBox(
//                                 //         context: context,
//                                 //         page: SearchPage(
//                                 //           state: 6,
//                                 //           sizingInformation: sizingInformation,
//                                 //         ));
//                                 //   } else {
//                                 //     Navigator.push(
//                                 //         context,
//                                 //         MaterialPageRoute(
//                                 //             builder: (context) => SearchPage(
//                                 //                   state: 6,
//                                 //                   sizingInformation: sizingInformation,
//                                 //                 )));
//                                 //   }
//                                 // },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: container(
//                                       shadow: false,
//                                       border: false,
//                                       backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
//                                       height: 50,
//                                       width: 300,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 8.0),
//                                             child: Icon(
//                                               Icons.search,
//                                               color: (themedata.value.index == 0) ? Color(materialBlack) : Color(lightGrey),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 8.0),
//                                             child: Text(
//                                               "Search Person",
//                                               style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey))),
//                                             ),
//                                           )
//                                         ],
//                                       )),
//                                 )),
//                         // IconButton(
//                         //     splashColor: Colors.transparent,
//                         //     highlightColor: Colors.transparent,
//                         //     hoverColor: Colors.transparent,
//                         //     onPressed: () {
//                         //       Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
//                         //     },
//                         //     icon: Icon(Icons.more_vert))
//                       ],
//                       title: (sizingInformation.deviceScreenType != DeviceScreenType.desktop)
//                           ? InkWell(
//                         onTap: (){
//                           print('lotus${uid}');
//                         },
//                             child: Text(
//                                 profileDetailsValueNotifier.value.item2.result.profileDetails.username,
//                                 style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//                               ),
//                           )
//                           : Image.asset(
//                               "assets/briefLogo.png",
//                               height: 20,
//                             ),
//                       leading: IconButton(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         hoverColor: Colors.transparent,
//                         onPressed: () => Navigator.maybePop(context),
//                         icon: Icon(
//                           Icons.chevron_left,
//                         ),
//                       ),
//                     ),
//                     body: Align(
//                       alignment: Alignment.center,
//                       child: ConstrainedBox(
//                         constraints:
//                             BoxConstraints(maxWidth: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? MediaQuery.of(context).size.width / 2.5 : double.infinity),
//                         child: container(
//                           border: true,
//                           radius: 0,
//                           shadow: false,
//                           margin: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? EdgeInsets.all(20) : EdgeInsets.zero,
//                           // spreadRadius: 2.5,
//                           // blurRadius: 3.5,
//                           borderColor: (themedata.value.index == 0) ? Color(dividerGrey) : Color(materialBlack),
//                           backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//                           child: Column(
//                             children: [
//                               (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
//                                   ? Container(
//                                       height: kToolbarHeight,
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 20),
//                                         child: Text(
//                                           profileDetailsValueNotifier.value.item2.result.profileDetails.username,
//                                           style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//                                         ),
//                                       ))
//                                   : Container(),
//                               Expanded(
//                                 child: RefreshIndicator(
//                                   onRefresh: () async => await _future,
//                                   child: LayoutBuilder(builder: (context, constraints) {
//                                     return SingleChildScrollView(
//                                       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//                                       child: ConstrainedBox(
//                                         constraints: constraints.copyWith(minHeight: constraints.maxHeight, maxHeight: double.infinity),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                                           child: (profileDetailsValueNotifier.value.item1 == 1)
//                                               ? Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                       children: [
//                                                         Container(
//                                                           height: 75,
//                                                           width: 75,
//                                                           child: ClipOval(
//                                                             child: (profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl != null)
//                                                                 // ? Image.network(
//                                                                 //     profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl,
//                                                                 //     fit: BoxFit.cover,
//                                                                 //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                                                                 //       if (loadingProgress == null) return child;
//                                                                 //       return Center(
//                                                                 //         child: CircularProgressIndicator(
//                                                                 //           value: loadingProgress.expectedTotalBytes != null
//                                                                 //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                                                                 //               : null,
//                                                                 //         ),
//                                                                 //       );
//                                                                 //     },
//                                                                 //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//                                                                 //   )
//                                                                 ? CachedNetworkImage(
//                                                                     fit: BoxFit.cover,
//                                                                     fadeInDuration: const Duration(milliseconds: 400),
//                                                                     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                                       child: Container(
//                                                                         width: 20.0,
//                                                                         height: 20.0,
//                                                                         child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                                       ),
//                                                                     ),
//                                                                     imageUrl: profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl,
//                                                                     errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//                                                                   )
//                                                                 : Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//
//                                                             // child: CachedNetworkImage(
//                                                             //   fadeInDuration: const Duration(milliseconds: 400),
//                                                             //   height: 75,
//                                                             //   width: 75,
//                                                             //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                             //     child: Container(
//                                                             //       width: 20.0,
//                                                             //       height: 20.0,
//                                                             //       child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                             //     ),
//                                                             //   ),
//                                                             //   imageUrl: profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl,
//                                                             //   fit: BoxFit.cover,
//                                                             //   errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
//                                                             // ),
//                                                           ),
//                                                         ),
//                                                         Padding(
//                                                           padding: const EdgeInsets.only(left: 50),
//                                                           child: Row(
//                                                             mainAxisAlignment: MainAxisAlignment.start,
//                                                             children: [
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(left: 10, right: 10),
//                                                                 child: Column(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Text(
//                                                                       profileDetailsValueNotifier.value.item2.result.profileDetails.postsCount.toString(),
//                                                                       style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                                     ),
//                                                                     Text(
//                                                                       "Posts",
//                                                                       style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               GestureDetector(
//                                                                 behavior: HitTestBehavior.opaque,
//                                                                 onTap: () async {
//                                                                   // if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//                                                                   //   return await scaffoldAlertDialogBox(
//                                                                   //       context: context,
//                                                                   //       page: Listview(state: 1, Id: profileDetailsValueNotifier.value.item2.result.profileDetails.userId));
//                                                                   // } else {
//                                                                   //   Navigator.push(
//                                                                   //       context,
//                                                                   //       MaterialPageRoute(
//                                                                   //           builder: (context) =>
//                                                                   //               Listview(state: 1, Id: profileDetailsValueNotifier.value.item2.result.profileDetails.userId)));
//                                                                   // }
//                                                                 },
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(left: 10, right: 10),
//                                                                   child: Column(
//                                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                                     children: [
//                                                                       Text(
//                                                                         profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount.toString(),
//                                                                         style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                                       ),
//                                                                       Text(
//                                                                         "Followers",
//                                                                         style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               GestureDetector(
//                                                                 behavior: HitTestBehavior.opaque,
//                                                                 onTap: () async {
//                                                                   // if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//                                                                   //   return await scaffoldAlertDialogBox(
//                                                                   //       context: context,
//                                                                   //       page: Listview(state: 2, Id: profileDetailsValueNotifier.value.item2.result.profileDetails.userId));
//                                                                   // } else {
//                                                                   //   Navigator.push(
//                                                                   //       context,
//                                                                   //       MaterialPageRoute(
//                                                                   //           builder: (context) =>
//                                                                   //               Listview(state: 2, Id: profileDetailsValueNotifier.value.item2.result.profileDetails.userId)));
//                                                                   // }
//                                                                 },
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(left: 10, right: 10),
//                                                                   child: Column(
//                                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                                     children: [
//                                                                       Text(
//                                                                         profileDetailsValueNotifier.value.item2.result.profileDetails.followingCount.toString(),
//                                                                         style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                                       ),
//                                                                       Text(
//                                                                         "Following",
//                                                                         style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//
//                                                     (uid != widget.uid)
//                                                         ? Padding(
//                                                             padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                                             child: Row(
//                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                               children: [
//                                                                 Flexible(
//                                                                   child: flatButton(
//                                                                       onPressed: (followValueNotifier.value.item1 == 0)
//                                                                           ? null
//                                                                           : (profileDetailsValueNotifier.value.item2.result.isFollowing)
//                                                                               ? () {
//                                                                                   return unfollowApiCall().whenComplete(() async {
//                                                                                     if (followValueNotifier.value.item1 == 1) {
//                                                                                       if (!mounted) return;
//                                                                                       setState(() {
//                                                                                         profileDetailsValueNotifier.value.item2.result.isFollowing = false;
//                                                                                         profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount -= 1;
//                                                                                       });
//                                                                                     } else if (followValueNotifier.value.item1 == 2 || followValueNotifier.value.item1 == 3) {
//                                                                                       final snackBar = snackbar(content: followValueNotifier.value.item3.toString());
//                                                                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                                                     }
//                                                                                   });
//                                                                                 }
//                                                                               : () {
//                                                                                   return followApiCall().whenComplete(() async {
//                                                                                     if (followValueNotifier.value.item1 == 1) {
//                                                                                       if (!mounted) return;
//                                                                                       setState(() {
//                                                                                         profileDetailsValueNotifier.value.item2.result.isFollowing = true;
//                                                                                         profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount += 1;
//                                                                                       });
//                                                                                     } else if (followValueNotifier.value.item1 == 2 || followValueNotifier.value.item1 == 3) {
//                                                                                       final snackBar = snackbar(content: followValueNotifier.value.item3.toString());
//                                                                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                                                     }
//                                                                                   });
//                                                                                 },
//                                                                       size: Size(MediaQuery.of(context).size.width, 45),
//                                                                       backgroundColor: Colors.pink,
//                                                                       child: Text(
//                                                                         (profileDetailsValueNotifier.value.item2.result.isFollowing) ? "Unfollow" : "Follow",
//                                                                         style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: Color(materialBlack))),
//                                                                       )
//                                                                       ),
//                                                                 ),
//                                                                 (!kIsWeb)
//                                                                     ? SizedBox(
//                                                                         width: 10,
//                                                                       )
//                                                                     : Container( color: Colors.black,),
//                                                                 (!kIsWeb)
//                                                                     ? Flexible(
//                                                                         child: flatButton(
//                                                                             onPressed: () {
//                                                                               Navigator.push(context,
//                                                                                   MaterialPageRoute(builder: (context) => ChatPage(uid:uid.toString(), puid: widget.uid, state: 0)));
//                                                                             },
//                                                                             size: Size(MediaQuery.of(context).size.width, 45),
//                                                                             border: true,
//                                                                             textbuttonBackgroundColor: Color(white),
//                                                                             child: Text(
//                                                                               "Message",
//                                                                               style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
//                                                                             )),
//                                                                       )
//                                                                     : Container( color: Colors.black,),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         : Container(
//                                                       color: Colors.black,
//
//                                                     ),
//                                                     (myFeedsValueNotifier.value.item1 == 1)
//                                                         ? Padding(
//                                                             padding: const EdgeInsets.only(top: 20),
//                                                             child: GridView.builder(
//                                                               itemCount: myFeedsValueNotifier.value.item2.result.length,
//                                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
//                                                                   mainAxisSpacing: 5, crossAxisSpacing: 5),
//                                                               physics: NeverScrollableScrollPhysics(),
//                                                               shrinkWrap: true,
//                                                               itemBuilder: (context, gridIndex) {
//                                                                 return GestureDetector(
//                                                                   behavior: HitTestBehavior.opaque,
//                                                                   onTap: () {
//                                                                     //dhina
//                                                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => Timeline(
//                                                                     //     uid: widget.uid, scrollIndex: gridIndex)));
//                                                                   },
//                                                                   child: Stack(
//                                                                     alignment: Alignment.center,
//                                                                     fit: StackFit.expand,
//                                                                     children: [
//                                                                       (myFeedsValueNotifier.value.item2.result[gridIndex].posts[0].toString().contains("mp4") ||
//                                                                               myFeedsValueNotifier.value.item2.result[gridIndex].posts[0].toString().contains("mpeg4"))
//                                                                           ? Stack(
//                                                                               children: [
//                                                                                 Container(
//                                                                                   color: Color(materialBlack),
//                                                                                 ),
//                                                                                 Center(
//                                                                                     child: Icon(
//                                                                                   Icons.play_arrow_rounded,
//                                                                                   size: 75,
//                                                                                   color: Color(white),
//                                                                                 ))
//                                                                               ],
//                                                                             )
//                                                                           // ? FutureBuilder(
//                                                                           //     future: getThumb(myFeedsValueNotifier.value.item2.result[gridIndex].posts[0]),
//                                                                           //     builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
//                                                                           //       if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//                                                                           //         return Image.memory(
//                                                                           //           snapshot.data!,
//                                                                           //           fit: BoxFit.cover,
//                                                                           //         );
//                                                                           //       } else if (snapshot.connectionState == ConnectionState.waiting) {
//                                                                           //         return Center(
//                                                                           //           child: Container(
//                                                                           //             width: 20.0,
//                                                                           //             height: 20.0,
//                                                                           //             child: CircularProgressIndicator(),
//                                                                           //           ),
//                                                                           //         );
//                                                                           //       } else {
//                                                                           //         return Image.asset("assets/errorImage.jpg", fit: BoxFit.cover);
//                                                                           //       }
//                                                                           //     })
//                                                                           // : Image.network(
//                                                                           //     myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//                                                                           //     fit: BoxFit.cover,
//                                                                           //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                                                                           //       if (loadingProgress == null) return child;
//                                                                           //       return Center(
//                                                                           //         child: CircularProgressIndicator(
//                                                                           //           value: loadingProgress.expectedTotalBytes != null
//                                                                           //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                                                                           //               : null,
//                                                                           //         ),
//                                                                           //       );
//                                                                           //     },
//                                                                           //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//                                                                           //   ),
//                                                                           : CachedNetworkImage(
//                                                                               fit: BoxFit.cover,
//                                                                               fadeInDuration: const Duration(milliseconds: 400),
//                                                                               progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                                                 child: Container(
//                                                                                   width: 20.0,
//                                                                                   height: 20.0,
//                                                                                   child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                                                 ),
//                                                                               ),
//                                                                               imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//                                                                               errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//                                                                             ),
//                                                                       // : CachedNetworkImage(
//                                                                       //     fadeInDuration: const Duration(milliseconds: 400),
//                                                                       //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                                       //       child: Container(
//                                                                       //         width: 20.0,
//                                                                       //         height: 20.0,
//                                                                       //         child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                                       //       ),
//                                                                       //     ),
//                                                                       //     imageUrl: myFeedsValueNotifier.value.item2.result[gridIndex].posts[0],
//                                                                       //     fit: BoxFit.cover,
//                                                                       //     errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
//                                                                       //   ),
//                                                                       (myFeedsValueNotifier.value.item2.result[gridIndex].posts.length > 1)
//                                                                           ? Positioned(
//                                                                               top: 5,
//                                                                               right: 5,
//                                                                               child: Icon(
//                                                                                 Icons.collections_rounded,
//                                                                                 color: Color(white),
//                                                                                 size: 15,
//                                                                               ))
//                                                                           : Container()
//                                                                     ],
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             ),
//                                                           )
//                                                         : (myFeedsValueNotifier.value.item1 == 2)
//                                                             ? Center(
//                                                                 child: SingleChildScrollView(
//                                                                   physics: NeverScrollableScrollPhysics(),
//                                                                   child: Column(
//                                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                                     children: [
//                                                                       lottieAnimation(myFeedsValueNotifier.value.item2!.lottieString),
//                                                                       flatButton(
//                                                                         onPressed: () async {
//                                                                           return await myFeedsApiCall();
//                                                                         },
//                                                                         backgroundColor: Color(accent),
//                                                                         textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
//                                                                         child: Text("Try Again"),
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             : (myFeedsValueNotifier.value.item1 == 3)
//                                                                 ? (myFeedsValueNotifier.value.item2.status == "ERROR")
//                                                                     ? Center(
//                                                                         child: SingleChildScrollView(
//                                                                         physics: NeverScrollableScrollPhysics(),
//                                                                         child: Column(
//                                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                                           children: [lottieAnimation(invalidLottie),
//                                                                             Text(myFeedsValueNotifier.value.item3)],
//                                                                         ),
//                                                                       ))
//                                                                     : Center(
//                                                                         child: SingleChildScrollView(
//                                                                           physics: NeverScrollableScrollPhysics(),
//                                                                           child: Column(
//                                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                                             children: [
//                                                                               lottieAnimation(alertLottie),
//                                                                               Text(myFeedsValueNotifier.value.item3),
//                                                                               flatButton(
//                                                                                 onPressed: () async {
//                                                                                   return await myFeedsApiCall();
//                                                                                 },
//                                                                                 backgroundColor: Color(accent),
//                                                                                 textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
//                                                                                 child: Text("Try Again"),
//                                                                               )
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                       )
//                                                                 : Center(child: SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: lottieAnimation(loadingLottie))),
//                                                   ],
//                                                 )
//                                               : Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     lottieAnimation(invalidLottie),
//                                                     Text(myFeedsValueNotifier.value.item3),
//                                                     flatButton(
//                                                       onPressed: () async {
//                                                         return await myFeedsApiCall();
//                                                       },
//                                                       backgroundColor: Color(accent),
//                                                       textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
//                                                       child: Text("Try Again"),
//                                                     )
//                                                   ],
//                                                 ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else if (profileDetailsValueNotifier.value.item1 == 2) {
//                   return exceptionScaffold(
//                       context: context,
//                       goBack: widget.goBack,
//                       lottieString: profileDetailsValueNotifier.value.item2!.lottieString,
//                       subtitle: profileDetailsValueNotifier.value.item3 ?? profileDetailsValueNotifier.value.item2!.data,
//                       onPressed: () async {
//                         return await _future;
//                       });
//                 } else {
//                   print('yyyyyyyyyy');
//
//                   return exceptionScaffold(
//                     context: context,
//                     lottieString: profileDetailsValueNotifier.value.item2!.lottieString,
//                     subtitle: profileDetailsValueNotifier.value.item3 ?? profileDetailsValueNotifier.value.item2!.data,
//                   );
//                 }
//               },
//             );
//       },
//     );
//           }
//         ));
//   }
// }
