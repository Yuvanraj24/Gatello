import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../Authentication/Authentication.dart';
import '../../../Helpers/DateTimeHelper.dart';
import '../../../Others/Routers.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/SnackBar.dart';
import '/core/models/default.dart';
import '/core/models/Comments.dart'as commentsModel;
import '/core/models/UserDetail.dart'as userDetailsModel;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../../Others/exception_string.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
class Command_page extends StatefulWidget {
  final String postId;
  const Command_page({Key? key,required this.postId}) : super(key: key);
  @override
  State<Command_page> createState() => _Command_pageState();
}
class _Command_pageState extends State<Command_page> {
  String commentText='';
  String replyText='';
  bool isReply = false;
  int commentIndex = 0;
   String? postId;
  String? uid;
  bool postEnable = false;
  FocusNode focusNode = FocusNode();
  TextEditingController commentTextEditingController = TextEditingController();
 // TextEditingController _controller = TextEditingController();
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> listCommentsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> createCommentValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> postDetailsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
   ValueNotifier<Tuple4> replyCommentValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  Future createCommentApiCall() async {
    return await ApiHandler().apiHandler(
        valueNotifier: createCommentValueNotifier,
        jsonModel: defaultFromJson,
        url: createCommentUrl,
        requestMethod: 1,

      body: {
        "post_id": widget.postId,
        "user_id": userDetailsValueNotifier.value.item2.result.userId,
        "profile_pic": userDetailsValueNotifier.value.item2.result.profileUrl ?? "",
        "username": userDetailsValueNotifier.value.item2.result.username,
        "content": commentTextEditingController.text,
        "time_stamp": DateTime.now().toString()
      },
    );
  }
  Future listCommentsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: listCommentsValueNotifier,
      jsonModel: commentsModel.commentsFromJson,
      url: commentsListUrl,
      requestMethod: 1,
      body: {"post_id": widget.postId},
    );
  }
  Future userDetailsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }
   Future replyCommentApiCall({required String commentId}) async {
     return await ApiHandler().apiHandler(
       valueNotifier: replyCommentValueNotifier,
       jsonModel: defaultFromJson,
       url: replyCommentUrl,
       requestMethod: 1,
       body: {
         "comment_id": commentId,
         "user_id": userDetailsValueNotifier.value.item2.result.userId,
         "profile_pic": userDetailsValueNotifier.value.item2.result.profileUrl ?? "",
         "username": userDetailsValueNotifier.value.item2.result.username,
         "content": commentTextEditingController.text
       },
     );
   }

   Future<void> _getUID() async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid=sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }
  // @override
  // void initState() {
  //   initialiser();
  //   commentTextEditingController.addListener(() {
  //     if (commentTextEditingController.text.trim() == "") {
  //       if (!mounted) return;
  //       setState(() {
  //         postEnable = false;
  //       });
  //     } else {
  //       if (!mounted) return;
  //       setState(() {
  //         postEnable = true;
  //       });
  //     }
  //   });
  //   super.initState();
  // }
  //
  // initialiser() async {
  //   await userDetailsApiCall();
  //   await listCommentsApiCall();
  // }
  //
  // @override
  // void dispose() {
  //   commentTextEditingController.dispose();
  //   userDetailsValueNotifier.dispose();
  //   listCommentsValueNotifier.dispose();
  //   createCommentValueNotifier.dispose();
  //  // replyCommentValueNotifier.dispose();
  //   focusNode.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {


                    return FutureBuilder(
                      future:_getUID() ,
                      builder: (context,_) {

                        return FutureBuilder(
                          future: userDetailsApiCall(),
                          builder: (context,_) {
                            return FutureBuilder(
                              future: createCommentApiCall(),
                              builder: (context,_) {
                                return FutureBuilder(
                                  future:listCommentsApiCall() ,
                                  builder: (context,_) {
                                    return FutureBuilder(
                                      future: replyCommentApiCall(commentId: listCommentsValueNotifier.
                                      value.item2.result[commentIndex].
                                      id.oid),
                                      builder: (context,_) {
                                        return Scaffold(
                                          appBar: AppBar(
                                            leading:
                                            GestureDetector(
                                                onTap:(){
                                                  Navigator.pop(context);
                                                },
                                                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment:CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset('assets/pops_asset/back_icon.svg',height:35.h,
                                                      width:35.w,),
                                                  ],
                                                )),
                                            title: InkWell(
                                              onTap: (){
                                                print('dhina:${userDetailsValueNotifier.value.item2.result.userId}');
                                              },
                                              child: Text(
                                                'Comments',
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.w400,
                                                        color: Color.fromRGBO(12, 16, 29, 1))),
                                              ),
                                            ),
                                          ),
                                           body:
                                                    Column(
                                                     children: [
                                                       SizedBox(height:11.h),
                                                      Container(
                                                        height: 80.h,
                                                        width: 330.w,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Color.fromRGBO(214, 214, 214, 1)),
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left:13,right:8),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 54.h,
                                                                width: 57.w,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(
                                                                            'https://www.setaswall.com/wp-content/uploads/2021/01/Captain-America-Wallpaper-1080x1920-002.jpg'),
                                                                        fit: BoxFit.fill)),
                                                              ),
                                                              Container(height: 50.h,width: 150.w,
                                                                child: TextField(
                                                                  controller: commentTextEditingController,
                                                                  decoration: InputDecoration(
                                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)
                                                                    ),
                                                                    hintText: '@ thewebions',
                                                                    hintStyle: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                            fontSize: 12.sp,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Color.fromRGBO(0, 0, 0, 1))),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    elevation: 0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    primary: Color.fromRGBO(248, 206, 97, 1),
                                                                    fixedSize: Size(58.w, 22.h),
                                                                  ),
                                                                  onPressed: () {
                                                                    onPressed: (
                                                                        postEnable == false ||
                                                                            createCommentValueNotifier.value.item1 == 0 ||
                                                                            replyCommentValueNotifier.value.item1 == 0)
                                                                        ? null
                                                                        : (isReply)
                                                                        ? () async {

                                                                      return await replyCommentApiCall(
                                                                          commentId: listCommentsValueNotifier.
                                                                          value.item2.result[commentIndex].
                                                                          id.oid)
                                                                          .whenComplete(() async {
                                                                        print('1111');
                                                                        if (replyCommentValueNotifier.value.item1 == 1) {
                                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                                          if (!mounted) return;
                                                                          setState(() {
                                                                            isReply = false;
                                                                            commentTextEditingController.clear();
                                                                            valueResetter(replyCommentValueNotifier);
                                                                          });
                                                                          return await listCommentsApiCall();
                                                                        } else if (replyCommentValueNotifier.value.item1 == 2 ||
                                                                            replyCommentValueNotifier.value.item1 == 3) {
                                                                          final snackBar = snackbar(content: replyCommentValueNotifier.value.item3);
                                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                        }
                                                                      });
                                                                    }
                                                                        : () async {
                                                                      print('2222');
                                                                      return await createCommentApiCall().whenComplete(() async {
                                                                        isReply = false;
                                                                        if (createCommentValueNotifier.value.item1 == 1) {
                                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                                          if (!mounted) return;
                                                                          setState(() {
                                                                            commentTextEditingController.clear();
                                                                            valueResetter(createCommentValueNotifier);
                                                                          });
                                                                          return await listCommentsApiCall();
                                                                        } else if (createCommentValueNotifier.
                                                                        value.item1 == 2 || createCommentValueNotifier.value.item1 == 3) {
                                                                          final snackBar = snackbar(content: createCommentValueNotifier.value.item3);
                                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                        }
                                                                      });
                                                                    };
                                                                  },
                                                                  child: Text(
                                                                    'Post',
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                            color: Color.fromRGBO(0, 0, 0, 1),
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w700)),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),



                                                      // Padding(
                                                      //   padding:  EdgeInsets.only(top:11,left: 12,right: 12),
                                                      //   child: TextField(
                                                      //     controller: commentTextEditingController,
                                                      //     decoration: InputDecoration(
                                                      //       prefix: Container(
                                                      //         height: 54.h,
                                                      //         width: 57.w,
                                                      //         decoration: BoxDecoration(
                                                      //             color: Colors.black,
                                                      //             borderRadius: BorderRadius.circular(5),
                                                      //             image: DecorationImage(
                                                      //                 image: NetworkImage(
                                                      //                     'https://images.unsplash.com/photo-1546587348-d12660c30c50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1174&q=80'),
                                                      //                 fit: BoxFit.fill)),
                                                      //       ),
                                                      //
                                                      //       suffix:         ElevatedButton(
                                                      //           style: ElevatedButton.styleFrom(
                                                      //             elevation: 0,
                                                      //             shape: RoundedRectangleBorder(
                                                      //                 borderRadius: BorderRadius.circular(5)),
                                                      //             primary: Color.fromRGBO(248, 206, 97, 1),
                                                      //             fixedSize: Size(80.w,20),
                                                      //           ),
                                                      //
                                                      //           // onPressed: (){
                                                      //           //
                                                      //           //   setState(() {
                                                      //           //     commentText=commentTextEditingController.text.toString();
                                                      //           //   });
                                                      //           // },
                                                      //           onPressed: (
                                                      //               postEnable == false ||
                                                      //               createCommentValueNotifier.value.item1 == 0 ||
                                                      //               replyCommentValueNotifier.value.item1 == 0)
                                                      //               ? null
                                                      //               : (isReply)
                                                      //               ? () async {
                                                      //
                                                      //             return await replyCommentApiCall(
                                                      //                 commentId: listCommentsValueNotifier.
                                                      //                 value.item2.result[commentIndex].
                                                      //                 id.oid)
                                                      //                 .whenComplete(() async {
                                                      //                   print('1111');
                                                      //               if (replyCommentValueNotifier.value.item1 == 1) {
                                                      //                 FocusManager.instance.primaryFocus?.unfocus();
                                                      //                 if (!mounted) return;
                                                      //                 setState(() {
                                                      //                   isReply = false;
                                                      //                   commentTextEditingController.clear();
                                                      //                   valueResetter(replyCommentValueNotifier);
                                                      //                 });
                                                      //                 return await listCommentsApiCall();
                                                      //               } else if (replyCommentValueNotifier.value.item1 == 2 ||
                                                      //                   replyCommentValueNotifier.value.item1 == 3) {
                                                      //                 final snackBar = snackbar(content: replyCommentValueNotifier.value.item3);
                                                      //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      //               }
                                                      //             });
                                                      //           }
                                                      //               : () async {
                                                      //             print('2222');
                                                      //             return await createCommentApiCall().whenComplete(() async {
                                                      //               isReply = false;
                                                      //               if (createCommentValueNotifier.value.item1 == 1) {
                                                      //                 FocusManager.instance.primaryFocus?.unfocus();
                                                      //                 if (!mounted) return;
                                                      //                 setState(() {
                                                      //                   commentTextEditingController.clear();
                                                      //                   valueResetter(createCommentValueNotifier);
                                                      //                 });
                                                      //                 return await listCommentsApiCall();
                                                      //               } else if (createCommentValueNotifier.
                                                      //               value.item1 == 2 || createCommentValueNotifier.value.item1 == 3) {
                                                      //                 final snackBar = snackbar(content: createCommentValueNotifier.value.item3);
                                                      //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      //               }
                                                      //             });
                                                      //           },
                                                      //           child: Center(
                                                      //             child: Text(
                                                      //               'Post',
                                                      //               style: GoogleFonts.inter(
                                                      //                   textStyle: TextStyle(
                                                      //                       color: Color.fromRGBO(0, 0, 0, 1),
                                                      //                       fontSize: 18.sp,
                                                      //                       fontWeight: FontWeight.w700)),
                                                      //             ),
                                                      //           )
                                                      //       ),
                                                      //
                                                      //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                                                      //           borderSide: BorderSide(width: 1.w,color: Color.fromRGBO(214, 214, 214, 1))),
                                                      //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                                                      //           borderSide: BorderSide(width: 1.w,color: Color.fromRGBO(214, 214, 214, 1))),
                                                      //       contentPadding: EdgeInsets.all(17),
                                                      //       hintText: '@ thewebions',
                                                      //       hintStyle: GoogleFonts.inter(
                                                      //           textStyle: TextStyle(
                                                      //               color: Color.fromRGBO(0, 0, 0, 1),
                                                      //               fontWeight: FontWeight.w400)),
                                                      //     ),
                                                      //   ),
                                                      // ),





                                                      Expanded(
                                                        child: ListView.builder(
                                                           itemCount: listCommentsValueNotifier.value.item2.result.length,
                                                          //  itemCount: 5,
                                                            itemBuilder: (context, commentIndex) {
                                                              return Padding(
                                                                padding:  EdgeInsets.only(top: 16, left: 2),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 22.w,
                                                                    ),
                                                                    Container(
                                                                      height: 32.h,
                                                                      width: 32.w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          image: DecorationImage(fit:BoxFit.fill,
                                                                              image: NetworkImage(
                                                                                  listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.profilePic
                                                                              ))),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10.w,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.only(left: 3),
                                                                          child: Text(listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.username,
                                                                            style: GoogleFonts.inter(
                                                                                textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp,
                                                                                    color: Color.fromRGBO(0, 0, 0, 1))),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10.h),
                                                                        Text(
                                                              commentTextEditingController.text.toString(),
                                                            //  commentText,
                                                                             // commentTextEditingController.text.toString(),
                                                          //    listCommentsValueNotifier.value.item2.result.content,
                                                                          style: GoogleFonts.inter(
                                                                              textStyle: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: 14.sp,
                                                                                  color: Color.fromRGBO(45, 45, 45, 1))),
                                                                        ),
                                                                        SizedBox(height: 10.h),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(left: 4),
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                'assets/pops_asset/pops_likebutton.svg',
                                                                                color: Color.fromRGBO(112, 112, 112, 1),
                                                                              ),
                                                                              SizedBox(width: 41.w),
                                                                              InkWell(
                                                                                onTap: (){
                                                                                  setState(() {
                                                                                    replyText=commentTextEditingController.text.toString();
                                                                                  });
                                                                                },
                                                                                child: Text(
                                                              replyText,
                                                                                  style: GoogleFonts.inter(
                                                                                      textStyle: TextStyle(
                                                                                          color: Color.fromRGBO(108, 108, 108, 1),
                                                                                          fontWeight: FontWeight.w700,
                                                                                          fontSize: 16)),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 120.w,
                                                                    ),
                                                                    Text(
                                                                      getDateTime(datetime: listCommentsValueNotifier.value.item2.result[commentIndex].timeStamp),
                                                                    //  'Just now',
                                                                      style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 15.sp,
                                                                              color: Color.fromRGBO(161, 161, 161, 1))),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      )

                                                    ],
                                                  )

                                        );
                                      }
                                    );
                                  }
                                );
                              }
                            );
                          }
                        );
                      }
                    );


  }

}
