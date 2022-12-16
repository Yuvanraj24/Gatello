import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import '../../core/models/Comments.dart';
import '/core/models/Follow_List.dart' as followListModel;
import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
class Followers_Page extends StatefulWidget {
  final String Id;
  final String userName;
  final String followersCount;
  final String followingCount;
//  final int state;

  const Followers_Page({Key? key,required this.Id,required this.userName,required this.followersCount,required this.followingCount}) : super(key: key);
  @override
  State<Followers_Page> createState() => _Followers_PageState();
}
class _Followers_PageState extends State<Followers_Page> {
  bool follow=false;
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> followerListValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> followingValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  TextEditingController _followercontroller=TextEditingController();
  Future followerListApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: followerListValueNotifier,
      jsonModel: followListModel.followListFromJson,
      url: followerListUrl,
      requestMethod: 1,
      body: {"user_id": widget.Id},
    );
  }
  Future followingListApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: followingValueNotifier,
      jsonModel: followListModel.followListFromJson,
      url: followingListUrl,
      requestMethod: 1,
      body: {"user_id": widget.Id},
    );
  }
  @override
  void initState() {
    followerListApiCall();
    followingListApiCall();

    super.initState();
  }

  // Future initialiser() async {
  //   if (widget.state == 0) {
  //    // return await likeListApiCall();
  //   } else if (widget.state == 1) {
  //     return await followerListApiCall();
  //   } else {
  //     return await followingListApiCall();
  //   }
  // }

  @override
  void dispose() {
    // likeListValueNotifier.dispose();
    followerListValueNotifier.dispose();
    followingValueNotifier.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: DefaultTabController(length: 2,initialIndex:0,
          child: Scaffold(
            appBar: AppBar(
              leading:  GestureDetector(onTap:(){Navigator.pop(context);},
                child: Column(mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/profile_assets/back_button.svg',
                        height: 30.h, width:30.w),
                  ],
                ),
              ),
              title: Row(
                children: [
                  InkWell(
                    onTap: (){print('dhina:${profileDetailsValueNotifier.value.item2.result.profileDetails.followersCount}');},
                    child: Text(
                      widget.userName,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                  SizedBox(width: 11.w),
                  Container(
                    height: 14.h,
                    width: 14.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 163, 255, 1)),
                    child: Icon(Icons.check_rounded,
                        size: 12, color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
              actions: [
                Icon(Icons.more_vert,color:Color.fromRGBO(0,0,0,1),size:30)
              ],
            ),

            body: Container(padding:
            EdgeInsets.only(left:12,right:12,top:14),
              child: Column(children: [
                Container(height:31.h,width:335.w,decoration: BoxDecoration(
                    color:Color.fromRGBO(217, 217, 217, 1),borderRadius: BorderRadius.circular(5)
                ),
                    child:Row(children: [
                      SizedBox(width:18.w),
                      Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/profile_assets/searchicon.svg',height:18.h,
                            width:18.w,),
                        ],
                      ),
                      Container(
                        //padding: EdgeInsets.only(top:19,left:18),
                        height:35.h,width:200.w,
                        child: TextField(

                          controller:_followercontroller,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:10.h,left: 10.w),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w,
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText:'Search',hintStyle:GoogleFonts.inter(
                              textStyle:TextStyle(fontWeight:FontWeight.w400,fontSize: 14.sp,
                                  color: Color.fromRGBO(118, 118, 118, 1))
                          )
                          ),),
                      )
                    ],)
                ),
                Container(
                  child: TabBar(
                      indicator:BoxDecoration(border:Border(bottom:BorderSide(
                          color:Colors.amber,width: 5
                      ))),
                      tabs: [

                        Tab(child:
                        Text('${widget.followersCount} Followers',style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight: FontWeight.bold,fontSize:15.sp,
                            color:Color.fromRGBO(0,0,0,1)
                        )),)),

                        Tab(child:
                        Text('${widget.followingCount} Following',style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight: FontWeight.bold,fontSize:15.sp,
                            color:Color.fromRGBO(0,0,0,1)
                        )),))
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top:10),
                    child: TabBarView(children: [

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: followerListApiCall(),
                                builder: (context,_) {
                                  return ListView.builder(

                                      shrinkWrap: true,

                                      itemCount: followerListValueNotifier.value.item2.result.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:  EdgeInsets.only(top:22),
                                          child: Container(height:75.h,width:double.infinity,decoration: BoxDecoration(
                                              color:Color.fromRGBO(248, 206, 97, 0.28),borderRadius:BorderRadius.circular(7)
                                          ),
                                            child:Padding(
                                              padding:  EdgeInsets.only(left:9,right:16),
                                              child: Row(children: [
                                                Container(
                                                  child: (followerListValueNotifier.value.item2.result[index].profilePic != null)
                                                      ? CachedNetworkImage(
                                                    imageUrl: followerListValueNotifier.value.item2.result[index].profilePic,
                                                    imageBuilder:
                                                        (context, imageProvider) =>
                                                        Container(
                                                          width: 50.w,
                                                          height: 50.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                    placeholder: (context, url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) =>
                                                        Icon(Icons.error),
                                                  )
                                                      :
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/noProfile.jpg"),
                                                            fit: BoxFit
                                                                .cover)),
                                                    //   child: Image.asset("assets/noProfile.jpg")
                                                  ),

                                                ),
                                                SizedBox(width:13),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Mary Jane',

                                                      style: GoogleFonts.inter(

                                                          textStyle: TextStyle(
                                                              fontSize: 16.sp,fontWeight: FontWeight.w700,
                                                              color: Color.fromRGBO(0, 0, 0, 1)
                                                          )
                                                      ),),
                                                    Text(

                                                      followerListValueNotifier.value.item2.result[index].name,

                                                      style: GoogleFonts.inter(
                                                          textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                              color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                                                          )
                                                      ),),
                                                  ],
                                                ),
                                                Spacer(),
                                                ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  primary: Color.fromRGBO(255, 255, 255, 1),fixedSize: Size(76.w, 32.h),
                                                ),
                                                    onPressed: (){

                                                    }, child: Text('Take out',style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            color: Color.fromRGBO(255, 0, 0, 1),fontSize: 12,fontWeight: FontWeight.w700
                                                        )
                                                    ),)),

                                              ],),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                }
                            )
                          ],
                        ),
                      ),

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            // Container(child:Padding(
                            //   padding:  EdgeInsets.only(left:9,right:16),
                            //   child: Row(children: [
                            //     Container(
                            //       height: 57.h,width: 57.w,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(7),
                            //           image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                            //               fit: BoxFit.fill)
                            //       ),
                            //     ),
                            //     SizedBox(width:13),
                            //     Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text('Peter Parker',style: GoogleFonts.inter(
                            //             textStyle: TextStyle(
                            //                 fontSize: 16.sp,fontWeight: FontWeight.w700,
                            //                 color: Color.fromRGBO(0, 0, 0, 1)
                            //             )
                            //         ),),
                            //         Text('Peter',style: GoogleFonts.inter(
                            //             textStyle: TextStyle(fontWeight: FontWeight.w400,
                            //                 color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                            //             )
                            //         ),),
                            //         Text('In contact',style: GoogleFonts.inter(
                            //             textStyle: TextStyle(fontWeight: FontWeight.w400,
                            //                 color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                            //             )
                            //         ),),
                            //       ],
                            //     ),
                            //     Spacer(),
                            //     ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                            //       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            //       primary: Color.fromRGBO(255, 255, 255, 1),fixedSize: Size(76.w, 32.h),
                            //     ),
                            //         onPressed: (){}, child: Text('Follow',style: GoogleFonts.inter(
                            //             textStyle: TextStyle(
                            //                 color: Color.fromRGBO(0, 163, 255, 1),fontSize: 12,fontWeight: FontWeight.w700
                            //             )
                            //         ),)),
                            //
                            //   ],),
                            // ),
                            //   height:75.h,width:double.infinity,decoration: BoxDecoration(
                            //       color:Color.fromRGBO(248, 206, 97, 1),borderRadius:BorderRadius.circular(7)
                            //   ),
                            // ),
                            FutureBuilder(
                                future:followingListApiCall(),
                                builder: (context,_) {
                                  return ListView.builder(

                                      shrinkWrap: true,
                                      itemCount:followingValueNotifier.value.item2.result.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:  EdgeInsets.only(top:22),
                                          child: Container(height:75.h,width:double.infinity,decoration: BoxDecoration(
                                              color:Color.fromRGBO(248, 206, 97, 0.28),borderRadius:BorderRadius.circular(7)
                                          ),
                                            child:Padding(
                                              padding:  EdgeInsets.only(left:9,right:16),
                                              child: Row(children: [
                                                Container(
                                                  child: (followingValueNotifier.value.item2.result[index].profilePic != null)
                                                      ? CachedNetworkImage(
                                                    imageUrl: followingValueNotifier.value.item2.result[index].profilePic,
                                                    imageBuilder:
                                                        (context, imageProvider) =>
                                                        Container(
                                                          width: 50.w,
                                                          height: 50.h,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                    placeholder: (context, url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) =>
                                                        Icon(Icons.error),
                                                  )
                                                      :
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/noProfile.jpg"),
                                                            fit: BoxFit
                                                                .cover)),
                                                    //   child: Image.asset("assets/noProfile.jpg")
                                                  ),

                                                ),
                                                SizedBox(width:13),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Mary Jane',style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            fontSize: 16.sp,fontWeight: FontWeight.w700,
                                                            color: Color.fromRGBO(0, 0, 0, 1)
                                                        )
                                                    ),),
                                                    Text(    followingValueNotifier.value.item2.result[index].name,style: GoogleFonts.inter(
                                                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                            color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                                                        )
                                                    ),),
                                                  ],
                                                ),
                                                Spacer(),
                                                ElevatedButton(

                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      elevation: 0,
                                                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      primary: Color.fromRGBO(255, 255, 255, 1),fixedSize: Size(76.w, 32.h),
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        follow=!follow;
                                                      });
                                                    }, child: Text(follow==true?'Follow':'Following',style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        color: Color.fromRGBO(0, 163, 255, 1),fontSize: 12,fontWeight: FontWeight.w700
                                                    )
                                                ),)),

                                              ],),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ]
              ),
            ),
          )
      ),
    );
  }
}