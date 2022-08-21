import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/tabbar/pops/Requests.dart';
import 'package:gatello/views/tabbar/pops/comments.dart';
import 'package:gatello/views/tabbar/pops/interactions.dart';
import 'package:gatello/views/tabbar/pops/poplikes.dart';
import 'package:gatello/views/tabbar/pops/report.dart';
import 'package:gatello/views/tabbar/pops/secondreport.dart';
import 'package:gatello/views/tabbar/pops/share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:gatello/views/tabbar/pops/report.dart';
// import 'package:gatello/views/tabbar/pops/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../../Others/Routers.dart';
import '../../../components/PreloadPageViewer.dart';
import '../../../components/SnackBar.dart';
import '../../profile/profile_details.dart';
import '../../profile/user_proflle.dart';
import '/core/models/My_Feeds.dart' as myFeedsModel;


import '../../../../Authentication/Authentication.dart';


import '../../../../core/models/exception/pops_exception.dart';

import '../../../../handler/Network.dart';

import '/core/Models/Default.dart';
import '../../../Others/exception_string.dart';


import '../../../core/models/Feeds.dart';
import 'circle_indicator.dart';
import 'newpost.dart';
import '/core/models/UserDetail.dart' as userDetailsModel;

class Pops_Page extends StatefulWidget {
  const Pops_Page({Key? key}) : super(key: key);
  @override
  State<Pops_Page> createState() => _Pops_PageState();
}
class _Pops_PageState extends State<Pops_Page> {
  TextEditingController _controllerpop =TextEditingController();
  bool liked=false;
  bool showThumbsUp=false;
  String? uid;
  ValueNotifier<Tuple4> postDetailsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> likeValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> listCommentsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  Future feedsApiCall({required String uid}) async {

    print("Getting posts for ${uid} from ${feedsUrl} ");

    return await ApiHandler().apiHandler(
      valueNotifier: feedsValueNotifier,
      jsonModel: feedsFromJson,
      url: feedsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }
  Future likeApiCall({required String uid, required String name, required String? profileUrl, required String postId}) async {
    print('3333');
    return await ApiHandler().apiHandler(
      valueNotifier: likeValueNotifier,
      jsonModel: defaultFromJson,
      url: likeUrl,
      requestMethod: 1,
      body: {"user_id": uid, "username": name,
        "profile_url": profileUrl ?? "",
        "post_id": postId},
    );
  }
  Future unlikeApiCall({required String uid, required String postId}) async {
    print('2222');
    return await ApiHandler().apiHandler(
      valueNotifier: likeValueNotifier,
      jsonModel: defaultFromJson,
      url: unlikeUrl,
      requestMethod: 1,
      body: {"user_id": uid, "post_id": postId},
    );
  }
  Future userDetailsApiCall() async {
    print('1111');
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }

  _onpressed(){
    setState((){
      liked=!liked;
    });
  }
  _ondoubleTap(){
    setState((){
      showThumbsUp =true;
      liked=true;
      if(showThumbsUp){
        // showThumbsUp=false;
        Timer(const Duration(milliseconds: 400),() {
          setState((){
            showThumbsUp=false;
          });

        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {


    // getFeeds(body);
    print("Logged in User");

    return FutureBuilder(
        future: _getUID(),
        builder: (context,_) {


          return FutureBuilder(

              future: userDetailsApiCall(),
              builder: (context,_) {

                return FutureBuilder(
                    future: feedsApiCall(uid: uid!),
                    builder: (context, snapshot) {

                      if(snapshot.connectionState ==ConnectionState.waiting){
                          return CircleIndicator();
                      }else{
                        return SafeArea(
                          child: Scaffold(
                            resizeToAvoidBottomInset: true,
                            body: Container(
                              child: Column(
                                children: [
                                  Container(

                                    height: 77.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
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
                                        SizedBox(width: 7.w),
                                        Container(padding:EdgeInsets.fromLTRB(0.w,8.h, 0.w, 0.h),
                                          height: 52.h,
                                          width: 227.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border:
                                            Border.all(color: Color.fromRGBO(217, 217, 217, 1)),
                                          ),
                                          child: TextField(
                                            cursorColor:Colors.black,
                                            controller: _controllerpop,
                                            decoration: InputDecoration(
                                              hintMaxLines: 2,
                                              hintText: 'Pop your photos, videos &\nmessages here...',hintStyle: TextStyle(
                                                fontSize: 18,fontWeight: FontWeight.w400),
                                              enabledBorder:OutlineInputBorder(borderSide: BorderSide(color:Colors.transparent,width: 1),),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:  Colors.transparent,width: 1),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.w,
                                        ),
                                          Padding(
                                            padding:  EdgeInsets.only(bottom: 13.h),
                                            child: GestureDetector(
                                              onTap:(){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) =>New_Post()),
                                                  );

                                              },
                                              child: SvgPicture.asset(
                                                'assets/pops_asset/pops_gallery.svg',
                                                width: 38.w,
                                                height: 40.h,
                                              ),
                                            ),
                                          ),

                                      ],
                                    ),
                                  ),


                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: feedsValueNotifier.value.item2.result.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 54.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(248, 206, 97, 1)),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(onTap: (){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) =>UserProfile(uid: 's8b6XInslPffQEgz8sVTINsPhcx2',
                                                          )
                                                          ),
                                                        );

                                                      },
                                                      child:
                                                        Row(children: [
                                                          SizedBox(
                                                            width: 24.9.w,
                                                          ),
                                                          Container(
                                                            height: 35.h,
                                                            width: 35.w,
                                                            child: ClipOval(
                                                                child: CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  fadeInDuration: const Duration(milliseconds: 400),
                                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                    child: Container(
                                                                      width: 20.w,
                                                                      height: 20.h,
                                                                      child: CircularProgressIndicator(value:
                                                                      downloadProgress.progress),
                                                                    ),
                                                                  ),
                                                                  imageUrl:  userDetailsValueNotifier.value.item2.result.profileUrl,
                                                                  errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                                )

                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:  EdgeInsets.only(left: 9.45),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(userDetailsValueNotifier.value.item2.result.username,
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                          color:
                                                                          Color.fromRGBO(0, 0, 0, 1),
                                                                          fontSize: 16.sp,
                                                                          fontWeight: FontWeight.w700)),
                                                                ),
                                                                SizedBox(
                                                                  height: 3.h,
                                                                ),
                                                                Text(
                                                                  '23 minutes ago',
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              78, 78, 78, 1),
                                                                          fontSize: 10.sp)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],),),

                                                      Spacer(),
                                                      PopupMenuButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5)),
                                                        itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Hide',
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              0, 0, 0, 1))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Unfollow',
                                                                  style: GoogleFonts.inter(fontWeight: FontWeight.w400,
                                                                      textStyle: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              0, 0, 0, 1))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                GestureDetector( onTap: () {
                                                                  showModalBottomSheet(isScrollControlled: true,
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return SafeArea(
                                                                        child: Container(
                                                                            child: Report_Page()),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                  child: Text(
                                                                    'Report',
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                            color: Color.fromRGBO(
                                                                                255, 40, 40, 1))),
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
                                            // GestureDetector(
                                            //   behavior: HitTestBehavior.opaque,
                                            //   onDoubleTap: (likeValueNotifier.value.item1 == 0)
                                            //       ? null
                                            //       : (feedsValueNotifier.value.item2.result[index].likesStatus == true)
                                            //       ? () async {
                                            //     return await unlikeApiCall(
                                            //         uid: userDetailsValueNotifier.value.item2.result.userId,
                                            //         postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                            //         .whenComplete(() async {
                                            //       if (likeValueNotifier.value.item1 == 1) {
                                            //         if (!mounted) return;
                                            //         setState(() {
                                            //           feedsValueNotifier.value.item2.result[index].likesStatus = false;
                                            //           feedsValueNotifier.value.item2.result[index].likesCount -= 1;
                                            //         });
                                            //       } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                            //         final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            //       }
                                            //     });
                                            //   }
                                            //       : () async {
                                            //     return await likeApiCall(
                                            //         uid: userDetailsValueNotifier.value.item2.result.userId,
                                            //         name: userDetailsValueNotifier.value.item2.result.username,
                                            //         profileUrl: userDetailsValueNotifier.value.item2.result.profileUrl,
                                            //         postId: feedsValueNotifier.value.item2.result[index].id.oid)
                                            //         .whenComplete(() async {
                                            //       if (likeValueNotifier.value.item1 == 1) {
                                            //         if (!mounted) return;
                                            //         setState(() {
                                            //           feedsValueNotifier.value.item2.result[index].likesStatus = true;
                                            //           feedsValueNotifier.value.item2.result[index].likesCount += 1;
                                            //         });
                                            //       } else if (likeValueNotifier.value.item1 == 2 || likeValueNotifier.value.item1 == 3) {
                                            //         final snackBar = snackbar(content: likeValueNotifier.value.item3.toString());
                                            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            //       }
                                            //     });
                                            //   },
                                            //   child: PreloadPageViewWidget(
                                            //     valueNotifier: feedsValueNotifier,
                                            //     index: index,
                                            //
                                            //   ),
                                            // ),
                                                Stack(

                                                    alignment:Alignment.center,children: [
                                                  GestureDetector(

                                                      onDoubleTap: (){
                                                        _ondoubleTap();

                                                        // print('Double tapped');
                                                        // if(feedsValueNotifier.value.item2.result[index].likesStatus) {
                                                        //   feedsValueNotifier.value.item2
                                                        //       .result[index]
                                                        //       .likesStatus = false;
                                                        // }
                                                        // else
                                                        // {
                                                        //
                                                        // }
                                                        if(liked==true) {
                                                          likeApiCall(
                                                              uid: uid!,
                                                              name: "akashtest",
                                                              profileUrl: "",
                                                              postId: feedsValueNotifier
                                                                  .value.item2
                                                                  .result[index]
                                                                  .id.oid
                                                          );
                                                        }
                                                        else{
                                                          unlikeApiCall(uid: uid!, postId: feedsValueNotifier.value.item2.result[index].id.oid);
                                                        }
                                                      },

                                                      child: CarouselSlider.builder(

                                                        itemCount: feedsValueNotifier.value.item2.result[index].posts.length,
                                                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5,right: 5),
                                                              child: Container(

                                                                child: Text("$itemIndex"),
                                                                height: 259.h,
                                                                width: MediaQuery.of(context).size.width,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(
                                                                            feedsValueNotifier.value.item2.result[index].
                                                                            posts[itemIndex]),
                                                                        fit: BoxFit.cover)),
                                                              ),
                                                            ),
                                                        options: CarouselOptions(
                                                          enableInfiniteScroll: false,
                                                          aspectRatio: 16/9,
                                                          viewportFraction: 1,
                                                        ),
                                                      )
                                                    // child: CarouselSlider(
                                                    //   options: CarouselOptions(
                                                    //
                                                    //     enableInfiniteScroll: false,
                                                    //   ), items: [feedsValueNotifier.value.item2.result[index].posts.length].map((i) {
                                                    //   return Builder(
                                                    //     builder: (BuildContext context) {
                                                    //       return Container(
                                                    //         child: Text("$i"),
                                                    //               height: 259.h,
                                                    //               width: double.infinity,
                                                    //               decoration: BoxDecoration(
                                                    //                   image: DecorationImage(
                                                    //                       image: NetworkImage(
                                                    //                           feedsValueNotifier.value.item2.result[index].posts[]),
                                                    //                       fit: BoxFit.fill)),
                                                    //             );
                                                    //     },
                                                    //   );
                                                    // }).toList(),
                                                    // ),
                                                  ),
                                                  showThumbsUp? Icon(Icons.thumb_up_sharp,color: Colors.white,
                                                    size: 80,


                                                  ):Container(),
                                                  // Positioned(
                                                  //     top: 61.h,
                                                  //     left: 139.w,
                                                  //     right: 139.w,
                                                  //     child: liked_Button()),
                                                  Positioned(
                                                    top: 208.h,
                                                    left: 12.w,
                                                    right: 12.w,
                                                    child: Container(
                                                      height: 38.h,
                                                      width: 336.w,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 16),
                                                            child: Text(
                                                              feedsValueNotifier.value.item2.result[index].description,
                                                              style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                      color: Color.fromRGBO(
                                                                          255, 255, 255, 1),
                                                                      fontSize: 18.sp)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        color: Color.fromRGBO(180, 180, 180, 0.5),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(28, 7, 24, 0),
                                                  height: 120.h,
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            GestureDetector(onTap: (){
                                                              _onpressed();
                                                              if(liked==true){
                                                                likeApiCall(uid: uid!,
                                                                    name:  userDetailsValueNotifier.value.item2.result.username, profileUrl: "",
                                                                    postId: feedsValueNotifier.value.item2.result[index].id.oid);}
                                                              else{
                                                                unlikeApiCall(uid: uid!,
                                                                    postId: feedsValueNotifier.value.item2.result[index].id.oid);

                                                              }
                                                            },  child:Icon( liked ? Icons.thumb_up_sharp :Icons.thumb_up_outlined,
                                                                color: Colors.black), ),
                                                            SizedBox(
                                                              width: 7.w,
                                                            ),

                                                               Padding(
                                                                 padding:  EdgeInsets.fromLTRB(0, 5.h, 0, 0),
                                                                 child: Text(
                                                                  (feedsValueNotifier.value.item2.result[index].likesCount >= 2)
                                                                      ? "${feedsValueNotifier.value.item2.result[index].likesCount}"
                                                                      : (feedsValueNotifier.value.item2.result[index].likesCount == 1)
                                                                      ? "${feedsValueNotifier.value.item2.result[index].likesCount}"
                                                                      : "No Like",
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                        color:
                                                                        Color.fromRGBO(51, 51, 51, 1),
                                                                      )),
                                                              ),
                                                               ),

                                                            SizedBox(
                                                              width: 13.w,
                                                            ),
                                                            Padding(
                                                              padding:  EdgeInsets.fromLTRB(0, 5.h, 0, 0),
                                                              child: GestureDetector(
                                                                onTap:(){
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) =>Command_page(
                                                                        postId:feedsValueNotifier.value.item2.result[index].id.oid
                                                                    )
                                                                    ),
                                                                  );
                                                                },
                                                                child: SvgPicture.asset(
                                                                    'assets/pops_asset/pops_commentbutton.svg'),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                              Padding(
                                                                padding:  EdgeInsets.fromLTRB(0, 5.h, 0, 0),
                                                                child: GestureDetector (
                                                                  onTap: (){
                                                                    print('dhina:${feedsValueNotifier.value.item2.result[index].id.oid}');
                                                                  },
                                                                  child: Text(
                                                                    (feedsValueNotifier.value.item2.result[index].commentsCount >= 2)
                                                                        ? "${feedsValueNotifier.value.item2.result[index].commentsCount}"
                                                                        : (feedsValueNotifier.value.item2.result[index].commentsCount == 1)
                                                                        ? "${feedsValueNotifier.value.item2.result[index].commentsCount}"
                                                                        : "No Comment",
                                                                  //  '3.6k',
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                          color:
                                                                          Color.fromRGBO(51, 51, 51, 1),
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),

                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Padding(
                                                              padding:  EdgeInsets.fromLTRB(0, 5.h, 0, 0),
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                    isScrollControlled: true,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                            Radius.circular(20),
                                                                            topRight:
                                                                            Radius.circular(20))),
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return Container(child: Share_Page());
                                                                    },
                                                                  );
                                                                },
                                                                  child: SvgPicture.asset(
                                                                    'assets/pops_asset/pops_sharefinal.svg',
                                                                    height: 15.h,
                                                                    width: 15.w,
                                                                  ),

                                                              ),
                                                            ),
                                                           Spacer(),
                                                            InkWell(
                                                              onTap: (){

                                                              },
                                                              child: SvgPicture.asset(
                                                                  'assets/pops_asset/pops_savebutton.svg'),
                                                            )
                                                          ],
                                                        ),

                                                      SizedBox(
                                                       height: 7.h,
                                                      ),
                                                       GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) =>pop_Likes(Id:'62f01f551dfcc621553b119f')
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Liked by',
                                                                style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                        fontSize: 12.sp,
                                                                        color: Color.fromRGBO(
                                                                            0, 0, 0, 1))),
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              Container(
                                                                width: 45.w,
                                                                child: Stack(
                                                                  children: [
                                                                    likedmembers(),
                                                                    Positioned(
                                                                        left: 10,
                                                                        child: likedmembers()),
                                                                    Positioned(
                                                                        left: 20, child: likedmembers())
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      SizedBox(height: 3.h),
                                                         Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) =>Command_page(
                                                                      postId:feedsValueNotifier.value.item2.result[index].id.oid
                                                                  )
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                'view all comments...',
                                                                style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                                      color: Color.fromRGBO(98, 98, 98, 1),
                                                                    )),
                                                              ),
                                                            )
                                                          ],
                                                        ), Spacer(),
                                                      Divider(
                                                        thickness: 1,
                                                        indent: 12,
                                                        endIndent: 12,
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
                              ),
                            ),
                              floatingActionButton:SpeedDial(
                                overlayOpacity:0,
                                spacing:17,
                                spaceBetweenChildren: 17,
                                activeIcon:Icons.keyboard_arrow_up_rounded,
                                icon: Icons.keyboard_arrow_down_rounded,
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
                                      child: SvgPicture.asset('assets/pops_asset/pop_request.svg',height:18.h,
                                        width:18.w,)
                                  )

                                ],
                              )
                          ),
                          );


                      }
                    }
                );
              }
          );
        }
    );
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
  Future<void> _getUID() async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid=sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }
}




