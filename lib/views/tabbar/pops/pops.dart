import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../../Assets/GatelloIcon.dart';
// import '../../../Authentication/Authentication.dart';
import '../../../Others/Routers.dart';
import '../../../Others/components/ExceptionScaffold.dart';
import '../../../Others/components/LottieComposition.dart';
import '../../../Others/exception_string.dart';
import '../../../Others/lottie_strings.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/SnackBar.dart';
import '../../../components/container.dart';
import '../../../components/flatButton.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
import '../../../main.dart';
import '../../profile/user_proflle.dart';
import '../test_code/Comments.dart';
import '../test_code/new_post.dart';
import 'Comments.dart';
import '../test_code/UserDetails.dart';
import '../test_code/test_new_post.dart';
import 'Requests.dart';

import 'comments.dart';
import 'interactions.dart';
import 'newpost.dart';
import 'poplikes.dart';
import 'report.dart';
import 'share.dart';
import '/core/Models/UserDetail.dart' as userDetailsModel;
import '/core/models/default.dart';
import '/core/Models/Feeds.dart';
class Story extends StatefulWidget {
  final ScrollController scrollController;
  const Story({Key? key,required this.scrollController}) : super(key: key);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> with AutomaticKeepAliveClientMixin<Story> {
  @override

  bool showThumbsUp = false;
  Future? _future;
  String? uid;
  bool get wantKeepAlive => true;
  String readmore="I love nature lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,";
  double height=38.h;
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> likeValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> deleteValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  List<PlatformFile> fileList = [];
  TextEditingController _controller=TextEditingController();
 // firestore.FirebaseFirestore instance = firestore.FirebaseFirestore.instance;
  // PreloadPageController preloadPageController = new PreloadPageController();
  // late PreloadPageController preloadPageController;
  Future<FilePickerResult?> files() async => await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mpeg4'],
      );
  bool isOnPageTurning = false;
  // int pageIndex = 0;

  Future feedsApiCall({required String uid}) async {
    print('feedsapi');
    return await ApiHandler().apiHandler(
      valueNotifier: feedsValueNotifier,
      jsonModel: feedsFromJson,
      url: feedsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }

  Future userDetailsApiCall() async {
    print('userapi');
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }

  Future likeApiCall({required String uid, required String name, required String? profileUrl, required String postId}) async {
    print('likeapi');
    return await ApiHandler().apiHandler(
      valueNotifier: likeValueNotifier,
      jsonModel: defaultFromJson,
      url: likeUrl,
      requestMethod: 1,
      body: {"user_id": uid, "username": name, "profile_url": profileUrl ?? "", "post_id": postId},
    );
  }

  Future unlikeApiCall({required String uid, required String postId}) async {
    print('unlikeapi');
    return await ApiHandler().apiHandler(
      valueNotifier: likeValueNotifier,
      jsonModel: defaultFromJson,
      url: unlikeUrl,
      requestMethod: 1,
      body: {"user_id": uid, "post_id": postId},
    );
  }

  Future deleteApiCall({required String uid, required String postId, required List<String> postsUrl}) async {
    print('deleteapi');
    return await ApiHandler().apiHandler(
      valueNotifier: deleteValueNotifier,
      jsonModel: defaultFromJson,
      url: deletePostsUrl,
      requestMethod: 1,
      body: {"user_id": uid, "post_id": postId, "posts_url": postsUrl},
    );
  }
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }
  Future<dynamic> sendData() async {
    final data1 = await _getUID();
    final data2 = await userDetailsApiCall();
    final data3=await feedsApiCall(uid:uid.toString());
    return [data1, data2, data3];
  }
  @override
  void initState() {
    _future = sendData();
    super.initState();
  }
  // _ondoubleTap() {
  //   setState(() {
  //     showThumbsUp = true;
  //     liked = true;
  //     if (showThumbsUp) {
  //       // showThumbsUp=false;
  //       Timer(const Duration(milliseconds: 400), () {
  //         setState(() {
  //           showThumbsUp = false;
  //         });
  //       });
  //     }
  //   });

  @override
  Widget build(BuildContext context) {
    int nums=0;
    super.build(context);

    return FutureBuilder(
        future: _future,
      builder: (context,_) {
        return AnimatedBuilder(
          animation: Listenable.merge([feedsValueNotifier, likeValueNotifier, deleteValueNotifier, userDetailsValueNotifier]),
          builder: (context, _) {
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (feedsValueNotifier.value.item1 == 1 || feedsValueNotifier.value.item1 == 3) {
                  print('worked1');
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),

                    body: (feedsValueNotifier.value.item1 == 1)
                        ? Column(
                          children: [
                            Container(
                              height: 77.h,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Container(
                                    height: 52.h,
                                    width: 51.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmVzc2lvbmFsfGVufDB8fDB8fA%3D%3D&w=1000&q=80'),
                                            fit: BoxFit.fill)),
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  Container(
                                    height: 52.h,
                                    width: 227.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border:
                                      Border.all(color: Color.fromRGBO(217, 217, 217, 1)),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintMaxLines: 2,
                                        hintText: 'Pop your photos, videos &\nmessages here...',hintStyle: TextStyle(
                                          fontSize: 14.sp,fontWeight: FontWeight.w400),
                                        enabledBorder:OutlineInputBorder(borderSide: BorderSide(color:Colors.transparent,width: 1),),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:  Colors.transparent,width: 1),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 14.w,
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                    //   onTap: (){
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Post(state: 0,)));
                                    // },
                                      onTap: ()async {
                                            return await files().then((value) {
                                          if (value != null && value.files.isNotEmpty) {
                                            fileList.clear();
                                            if (value.files.length < 10) {
                                              for (int i = 0; i < value.files.length; i++) {
                                                if (value.files[i].size < 52428800) {
                                                  fileList.add(value.files[i]);
                                                } else {
                                                  final snackBar = snackbar(content: "${value.files[i].name} file exceeds 50mb.");
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              }
                                              return Navigator.push(context, MaterialPageRoute(builder:
                                                  (context) =>
                                                  Post(state: 0,
                                                      fileList: fileList))).then((value) async {
                                                if (value != null) {
                                                  return await feedsApiCall(uid: uid.toString());
                                                }
                                              });
                                            } else {
                                              final snackBar = snackbar(content: "Only 10 files can be uploaded per post.");
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/pops_asset/pops_gallery.svg',
                                        width: 38.w,
                                        height: 40.h,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //
                            //   height: 77.h,
                            //   width: double.infinity,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 12.w),
                            //   child: Row(
                            //     children: [
                            //       // SizedBox(
                            //       //   width: 12.w,
                            //       // ),
                            //       Container(
                            //         height: 52.h,
                            //         width: 51.w,
                            //         decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.circular(
                            //                 5),
                            //             color: Colors.yellow,
                            //
                            //             image: DecorationImage(
                            //                 image: NetworkImage(
                            //                     'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmVzc2lvbmFsfGVufDB8fDB8fA%3D%3D&w=1000&q=80'),
                            //                 fit: BoxFit.fill)),
                            //       ),
                            //       SizedBox(
                            //         width: 7.w,
                            //       ),
                            //       Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal: 13.w,
                            //             vertical: 7.h),
                            //         height: 52.h,
                            //         width: 227.w,
                            //         decoration: BoxDecoration(
                            //           // color: Colors.blue,
                            //           borderRadius:
                            //           BorderRadius.circular(
                            //               6),
                            //           border: Border.all(
                            //               color: Color.fromRGBO(
                            //                   217, 217, 217, 1)),
                            //         ),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //           CrossAxisAlignment
                            //               .start,
                            //           children: [
                            //             // SizedBox(
                            //             //   height: 8.h,
                            //             // ),
                            //             Text(
                            //               'Pop your photos,videos &',
                            //               style: GoogleFonts.inter(
                            //                   textStyle: TextStyle(
                            //                       fontWeight:
                            //                       FontWeight
                            //                           .w400,
                            //                       color: Color
                            //                           .fromRGBO(
                            //                           152,
                            //                           152,
                            //                           152,
                            //                           1),
                            //                       fontSize:
                            //                       14.sp)),
                            //             ),
                            //
                            //             Text('messages here...',
                            //                 style: GoogleFonts.inter(
                            //                     textStyle: TextStyle(
                            //                         fontWeight:
                            //                         FontWeight
                            //                             .w400,
                            //                         color: Color
                            //                             .fromRGBO(
                            //                             152,
                            //                             152,
                            //                             152,
                            //                             1),
                            //                         fontSize:
                            //                         14.sp))),
                            //           ],
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 14.w,
                            //       ),
                            //
                            //       // IconButton(onPressed: ()
                            //       // {
                            //       //
                            //       //   Navigator.push(
                            //       //     context,
                            //       //     MaterialPageRoute(builder: (context) =>New_Post()),
                            //       //   );
                            //       //
                            //       //
                            //       //
                            //       // },
                            //       //     icon: Icon(Icons.add)),
                            //
                            //
                            //
                            //       Padding(
                            //         padding: EdgeInsets.only(
                            //             bottom: 13.h),
                            //         child: InkWell(
                            //           onTap: () {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       New_Post(state: 0,
                            //
                            //                       )),
                            //             );
                            //           },
                            //           // onTap: ()async {
                            //           //       return await files().then((value) {
                            //           //     if (value != null && value.files.isNotEmpty) {
                            //           //       fileList.clear();
                            //           //       if (value.files.length < 10) {
                            //           //         for (int i = 0; i < value.files.length; i++) {
                            //           //           if (value.files[i].size < 52428800) {
                            //           //             fileList.add(value.files[i]);
                            //           //           } else {
                            //           //             final snackBar = snackbar(content: "${value.files[i].name} file exceeds 50mb.");
                            //           //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            //           //           }
                            //           //         }
                            //           //         return Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            //           //             Post(state: 0,
                            //           //                 fileList: fileList))).then((value) async {
                            //           //           if (value != null) {
                            //           //             return await feedsApiCall(uid: uid.toString());
                            //           //           }
                            //           //         });
                            //           //       } else {
                            //           //         final snackBar = snackbar(content: "Only 10 files can be uploaded per post.");
                            //           //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            //           //       }
                            //           //     }
                            //           //   });
                            //           // },
                            //           child: SvgPicture.asset(
                            //             'assets/pops_asset/pops_gallery.svg',
                            //             width: 38.w,
                            //             height: 40.h,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: ListView.builder(

                                  shrinkWrap: true,

                                 controller: widget.scrollController,
                                 physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                  itemCount: feedsValueNotifier.value.item2.result.length,
                                  itemBuilder: (context, index) {
                                    return container(
                                      border: true,
                                      radius: 0,
                                      shadow: false,
                                      // spreadRadius: 2.5,
                                      // blurRadius: 3.5,
                                      borderColor: (themedata.value.index == 0) ? Color(dividerGrey) : Color(materialBlack),
                                      backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 54.h,
                                            width:
                                            double.infinity,
                                            decoration:
                                            BoxDecoration(
                                                color: Color
                                                    .fromRGBO(
                                                    248,
                                                    206,
                                                    97,
                                                    1)),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator
                                                        .push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserProfile(
                                                             //   uid: uid.toString(),

                                                               uid:  feedsValueNotifier.value.item2.result[index].userId.toString()
                                                              )),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                        24.9.w,
                                                      ),
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          print(
                                                              'dhina:${feedsValueNotifier.value.item2.result.length}');
                                                        },
                                                        child:
                                                        Container(
                                                          height:
                                                          38.h,
                                                          width:
                                                          38.w,
                                                          child: ClipOval(
                                                              child: CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .fill,
                                                                fadeInDuration:
                                                                const Duration(milliseconds: 400),
                                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                    Center(
                                                                      child:
                                                                      Container(
                                                                        width: 20.0,
                                                                        height: 20.0,
                                                                        child: CircularProgressIndicator(value: downloadProgress.progress),
                                                                      ),
                                                                    ),
                                                                imageUrl:feedsValueNotifier.value.item2
                                                                    .result[index]
                                                                    .profileUrl,
                                                                errorWidget: (context, url, error) => SvgPicture.asset('assets/profile_assets/no_profile.svg',fit: BoxFit.fill)
                                                              )),
                                                        ),
                                                      ),
                                                      // CircleAvatar(
                                                      //   backgroundImage: NetworkImage(
                                                      //
                                                      //       userDetailsValueNotifier.value.item2.result.profileUrl
                                                      //     // 'https://www.whatsappimages.in/wp-content/'
                                                      //     //     'uploads/2021/12/Creative-Whatsapp-Dp-Pics-Download.jpg'
                                                      //
                                                      //   ),
                                                      //   radius: 20,
                                                      // ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left:
                                                            9.45),
                                                        child:
                                                        Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              feedsValueNotifier.value.item2.result
                                                              [index].username,
                                                              style:
                                                              GoogleFonts.inter(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 16.sp, fontWeight: FontWeight.w700)),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              3.h,
                                                            ),
                                                            Text(
                                                              '23 minutes ago',
                                                              style:
                                                              GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(78, 78, 78, 1), fontSize: 10.sp)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                PopupMenuButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5)),
                                                  itemBuilder:
                                                      (context) =>
                                                  [
                                                    PopupMenuItem(
                                                      child:
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'Hide',
                                                            style:
                                                            GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child:
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'Unfollow',
                                                            style: GoogleFonts.inter(
                                                                fontWeight: FontWeight.w400,
                                                                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child:
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:
                                                                () {
                                                              showModalBottomSheet(
                                                                isScrollControlled: true,
                                                                context: context,
                                                                builder: (context) {
                                                                  return SafeArea(
                                                                    child: Container(child: Report_Page()),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child:
                                                            Text(
                                                              'Report',
                                                              style:
                                                              GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(255, 40, 40, 1))),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                          Stack(
                                              alignment: Alignment
                                                  .center,
                                            children:[ GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: (){
                                                print('lotus${   feedsValueNotifier
                                                    .value
                                                    .item2
                                                    .result[index]
                                                    .
                                                posts.toString()}');
                                                setState((){
                                                  height=38.h;
                                                });
                                              },
                                              onDoubleTap: (likeValueNotifier.value.item1 == 0)
                                                  ? null
                                                  : (feedsValueNotifier.value.item2.result[index].likesStatus == true)
                                                      ? () async {
                                                          return await unlikeApiCall(
                                                                  uid: userDetailsValueNotifier.value.item2.result.userId,
                                                                  postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                                              .whenComplete(() async {
                                                            if (likeValueNotifier.value.item1 == 1) {
                                                              if (!mounted) return;
                                                              setState(() {
                                                                feedsValueNotifier.value.item2.result[index].likesStatus = false;
                                                                feedsValueNotifier.value.item2.result[index].likesCount -= 1;

                                                              });
                                                            } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                                              final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            }

                                                          });
                                                        }
                                                      : () async {
                                                          return await likeApiCall(
                                                                  uid: userDetailsValueNotifier.value.item2.result.userId,
                                                                  name: userDetailsValueNotifier.value.item2.result.username,
                                                                  profileUrl: userDetailsValueNotifier.value.item2.result.profileUrl,
                                                                  postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                                              .whenComplete(() async {
                                                            if (likeValueNotifier.value.item1 == 1) {
                                                              if (!mounted) return;
                                                              setState(() {
                                                                feedsValueNotifier.value.item2.result[index].likesStatus = true;
                                                                feedsValueNotifier.value.item2.result[index].likesCount += 1;
                                                              });
                                                            } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                                              final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            }
                                                          });
                                                        },
                                                child: CarouselSlider
                                                    .builder(

                                                  itemCount: feedsValueNotifier
                                                      .value
                                                      .item2
                                                      .result[index]
                                                      .posts
                                                      .length,
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int itemIndex,
                                                      int pageViewIndex) =>
                                                      Container(

                                                        child: Text(
                                                            "$itemIndex"),
                                                        height: 259
                                                            .h,
                                                        width: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(

                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    feedsValueNotifier
                                                                        .value
                                                                        .item2
                                                                        .result[index]
                                                                        .
                                                                    posts[itemIndex]
                                                                ),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                  options: CarouselOptions(
                                                    enableInfiniteScroll: false,
                                                    aspectRatio: 16 /
                                                        9,
                                                    viewportFraction: 1,
                                                  ),
                                                )
                                              // child: Container(
                                              //   child: PreloadPageViewWidget(
                                              //     valueNotifier: feedsValueNotifier,
                                              //     index: index,
                                              //   //  sizingInformation: sizingInformation,
                                              //   ),
                                              // ),


                                            ),
                                              Positioned(
                                                bottom:12,
                                                left: 12.w,
                                                right: 12.w,
                                                child:AnimatedContainer(
                                                  height:height,
                                                  width: 336.w,
                                                  child:SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        height==119.h?desText():
                                                        Padding(
                                                          padding:EdgeInsets.only(left: 16,top:12),
                                                          child:Row(
                                                            children: [
                                                              Text(
                                                                readmore.substring(0,20),
                                                                style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Color.fromRGBO(
                                                                            255, 255, 255, 1),
                                                                        fontSize: 12.sp)),
                                                              ),
                                                              GestureDetector(
                                                                onTap:(){
                                                                  setState(() {
                                                                    height=119.h;
                                                                  });
                                                                },

                                                                child: Text(
                                                                  '...more',
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              255, 255, 255, 1),
                                                                          fontSize: 12.sp)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    color: Color.fromRGBO(180, 180, 180, 0.5),
                                                  ), duration:Duration(milliseconds:250),
                                                ),
                                              )]
                                          ),
                                          Container(

                                            padding: EdgeInsets
                                                .fromLTRB(
                                                12, 7, 12, 15),
                                            height: 108.h,
                                            width:
                                            double.infinity,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 16.w),
                                                    GestureDetector(
                                                        behavior: HitTestBehavior.opaque,
                                                        onTap: (likeValueNotifier.value.item1 == 0)
                                                            ? null
                                                            : (feedsValueNotifier.value.item2.result[index].likesStatus == true)
                                                                ? () async {
                                                                    return await unlikeApiCall(
                                                                            uid: userDetailsValueNotifier.value.item2.result.userId,
                                                                            postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                                                        .whenComplete(() async {
                                                                      if (likeValueNotifier.value.item1 == 1) {
                                                                        if (!mounted) return;
                                                                        setState(() {
                                                                          feedsValueNotifier.value.item2.result[index].likesStatus = false;
                                                                          feedsValueNotifier.value.item2.result[index].likesCount -= 1;
                                                                        });
                                                                      } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                                                        final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                      }
                                                                    });
                                                                  }
                                                                : () async {
                                                                    return await likeApiCall(
                                                                            uid: userDetailsValueNotifier.value.item2.result.userId,
                                                                            name: userDetailsValueNotifier.value.item2.result.username,
                                                                            profileUrl: userDetailsValueNotifier.value.item2.result.profileUrl,
                                                                            postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                                                        .whenComplete(() async {
                                                                      if (likeValueNotifier.value.item1 == 1) {
                                                                        if (!mounted) return;
                                                                        setState(() {
                                                                          feedsValueNotifier.value.item2.result[index].likesStatus = true;
                                                                          feedsValueNotifier.value.item2.result[index].likesCount += 1;
                                                                        });
                                                                      } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                                                        final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                      }
                                                                    });
                                                                  },
                                                        child: (feedsValueNotifier.value.item2.result[index].likesStatus == true)
                                                            ? Icon(
                                                            Icons
                                                                 .thumb_up_sharp,

                                                              )
                                                            : Icon(
                                                          Icons.thumb_up_outlined
                                                              )),
                                                    SizedBox(
                                                      width: 7.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          0,
                                                          5.h,
                                                          0,
                                                          0),
                                                      child: GestureDetector(
                                                        behavior: HitTestBehavior.opaque,
                                                        onTap: () async {
                                                          //dhina
                                                          // if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                                          //   return await scaffoldAlertDialogBox(
                                                          //       context: context, page: Listview(state: 0, Id:
                                                          //       feedsValueNotifier.value.item2.result[index].id.oid));
                                                          // } else {
                                                          //   Navigator.push(context,
                                                          //       MaterialPageRoute(builder: (context) =>
                                                          //       Listview(state: 0, Id: feedsValueNotifier.value.item2.result
                                                          //       [index].id.oid)));
                                                          // }
                                                        },
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            (feedsValueNotifier.value.item2.result[index].likesCount >= 2)
                                                                ? "${feedsValueNotifier.value.item2.result[index].likesCount} "
                                                                : (feedsValueNotifier.value.item2.result[index].likesCount == 1)
                                                                ? "${feedsValueNotifier.value.item2.result[index].likesCount} "
                                                                : "",
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                  fontSize: 12.sp,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Color.fromRGBO(
                                                                      51,
                                                                      51,
                                                                      51,
                                                                      1),
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 13.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          0,
                                                          6.h,
                                                          0,
                                                          0),
                                                      child:
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          Navigator
                                                              .push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>

                                                                    Comments_Page(

                                                                    postId: feedsValueNotifier.value.item2.result[index].id.oid,
                                                                    FeedData:       feedsValueNotifier
                                                                    .value
                                                                    .item2
                                                                    .result[index]
                                                                    .
                                                                posts[0].toString())
                                                            ),
                                                          );
                                                        },
                                                        child: SvgPicture
                                                            .asset(
                                                            'assets/pops_asset/pops_commentbutton.svg'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          0,
                                                          5.h,
                                                          0,
                                                          0),
                                                      child:
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          print(
                                                              'dhina:${feedsValueNotifier.value.item2.result[index].id.oid}');
                                                        },
                                                        child:
                                                        Text(
                                                          (feedsValueNotifier.value.item2.result[index].commentsCount >=
                                                              2)
                                                              ? "${feedsValueNotifier.value.item2.result[index].commentsCount}"
                                                              : (feedsValueNotifier.value.item2.result[index].commentsCount == 1)
                                                              ? "${feedsValueNotifier.value.item2.result[index].commentsCount}"
                                                              : "",
                                                          //  '3.6k',
                                                          style: GoogleFonts.inter(
                                                              textStyle: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          0,
                                                          2.h,
                                                          0,
                                                          0),
                                                      child:
                                                      GestureDetector(
                                                        onTap:
                                                            () {
                                                          showModalBottomSheet(
                                                            shape:
                                                            RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                                            context:
                                                            context,
                                                            builder:
                                                                (context) {
                                                              return Container(child: Share_Page());
                                                            },
                                                          );
                                                        },
                                                        child: SvgPicture
                                                            .asset(
                                                          'assets/pops_asset/pops_sharefinal.svg',
                                                          height:
                                                          15.h,
                                                          width:
                                                          15.w,
                                                        ),
                                                      ),

                                                    ),
Spacer(),
                                                    InkWell(
                                                      onTap: () {

                                                      },
                                                      child: SvgPicture
                                                          .asset(
                                                          'assets/pops_asset/pops_savebutton.svg'),
                                                    ),
                                                    SizedBox(width: 13.w)
                                                  ],
                                                ),
                                                SizedBox(height: 7.h),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 13.w),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  pop_Likes(Id: '62f01f551dfcc621553b119f')),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Liked by',
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 12.sp,
                                                                    color: Color.fromRGBO(0, 0, 0, 1))),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                            6.w,
                                                          ),
                                                          Container(
                                                            width:
                                                            45.w,
                                                            child:
                                                            Stack(
                                                              children: [
                                                                likedmembers(),
                                                                Positioned(
                                                                    left: 10,
                                                                    child: likedmembers()),
                                                                Positioned(
                                                                    left: 20,
                                                                    child: likedmembers())
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 7.h),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 13.w),
                                                    InkWell(
                                                      onTap: () {

                                                        Navigator
                                                            .push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Comments_Page(

                                                                  postId: feedsValueNotifier.value.item2.result[index].id.oid,
                                                                  FeedData:       feedsValueNotifier
                                                                  .value
                                                                  .item2
                                                                  .result[index]
                                                                  .
                                                              posts[0].toString())),
                                                        );
                                                      },
                                                      child: Text(
                                                        'view all comments...',
                                                        style: GoogleFonts
                                                            .inter(
                                                            textStyle: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              color: Color.fromRGBO(
                                                                  98,
                                                                  98,
                                                                  98,
                                                                  1),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ),


                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: lottieAnimation(emptyTimelineLottie),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Sorry, Your timeline is empty"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: flatButton(
                                        onPressed: () async {
                                          return await feedsApiCall(uid:uid.toString());
                                        },
                                        backgroundColor: Color(accent),
                                        textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                                        child: Text("Try Again"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      floatingActionButton:SpeedDial(
                        overlayOpacity:0,
                        spacing:17,
                        spaceBetweenChildren: 17,
                        activeIcon:Icons.keyboard_arrow_down_rounded,
                        icon: Icons.keyboard_arrow_up_rounded,
                        backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                        foregroundColor:Colors.black,
                        children: [
                          SpeedDialChild( backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                              child:SvgPicture.asset('assets/pops_asset/pings_icon.svg')
                          ),
                          SpeedDialChild(
                              onTap:() => Navigator.push(context, MaterialPageRoute(builder:
                                  (context) =>Inter_Actions())),
                              backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                              child:SvgPicture.asset('assets/pops_asset/interaction_icon.svg')
                          ),
                          SpeedDialChild( backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                  Requests_Page())),
                              child: SvgPicture.asset('assets/pops_asset/No_Request_Icon.svg',height:18.h,
                                width:18.w,)
                          )

                        ],
                      )
                  );
                } else if (feedsValueNotifier.value.item1 == 2) {
                  print('worked2');
                  if (feedsValueNotifier.value.item3 == "no timeline available") {
                    print('worked3');
                    return exceptionScaffold(
                        context: context,
                        goBack: false,
                        lottieString: emptyTimelineLottie,
                        subtitle: "Sorry, Your timeline is empty",
                        onPressed: () async {
                          return await feedsApiCall(uid: uid.toString());
                        });
                  } else {
                    print('worked4');
                    return exceptionScaffold(
                        context: context,
                        goBack: false,
                        lottieString: feedsValueNotifier.value.item2!.lottieString,
                        subtitle: feedsValueNotifier.value.item3 ?? feedsValueNotifier.value.item2!.data,
                        onPressed: () async {
                          return await feedsApiCall(uid: uid.toString());
                        });
                  }
                } else {
                  print('worked5');
                  return exceptionScaffold(
                    context: context,
                    goBack: false,
                    lottieString: feedsValueNotifier.value.item2!.lottieString,
                    subtitle: feedsValueNotifier.value.item3 ?? feedsValueNotifier.value.item2!.data,
                  );
                }
              },
            );
          },
        );
      }
    );
  }

}
Widget likedmembers() {
  return Container(
    height: 16.h,
    width: 16.w,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
                'https://www.clipartmax.com/png/small/162-1623921_stewardess-510x510-user-profile-icon-png.png'))),
  );
}
Widget desText(){
  return Column(
    children: [
      Padding(
        padding:EdgeInsets.only(left: 16,right:6,top:20),
        child: Text(
          " I love nature lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",style: GoogleFonts.inter(
            textStyle: TextStyle(
                height:1.7.h,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 12.sp)),
        ),
      ),
    ],
  );
}