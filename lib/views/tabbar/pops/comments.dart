import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '/Models/Comments.dart'as commentsModel;



import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../../Models/Default.dart';
import '../../../Others/exception_string.dart';
import '../../../Others/route.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
class Command_page extends StatefulWidget {
  const Command_page({Key? key}) : super(key: key);
  @override
  State<Command_page> createState() => _Command_pageState();
}
class _Command_pageState extends State<Command_page> {

  TextEditingController commentTextEditingController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  ValueNotifier<Tuple4> listCommentsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> createCommentValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(-1, exceptionFromJson(alert), "Null", null));
  Future createCommentApiCall() async {
    return await ApiHandler().apiHandler(
        valueNotifier: createCommentValueNotifier,
        jsonModel: defaultFromJson,
        url: createCommentUrl,
        requestMethod: 1,
        body: {
          "post_id": "6215ec017abcbe8d47377836",
          "user_id":"s8b6XInslPffQEgz8sVTINsPhcx2",
          "profile_pic":"",
          "username":"akashtest",
          "content":commentTextEditingController.text,
          "time_stamp":"234e23432"
        }
    );
  }
  // Future listCommentsApiCall() async {
  //   return await ApiHandler().apiHandler(
  //     valueNotifier: listCommentsValueNotifier,
  //     jsonModel: commentsModel.commentsFromJson,
  //     url: commentsListUrl,
  //     requestMethod: 1,
  //     body: {"post_id":"6215ec017abcbe8d47377836"},
  //   );
  // }
  String? posturl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Color.fromRGBO(12, 16, 29, 1),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(12, 16, 29, 1))),
        ),
      ),
      body:
    Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:11,left: 12,right: 12),
            child: TextField(

              controller: _controller,
              onChanged: (value){

                commentTextEditingController=  _controller;
              },
              decoration: InputDecoration(
                prefix: Container(
                  height: 54.h,
                  width: 57.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1546587348-d12660c30c50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1174&q=80'),
                          fit: BoxFit.fill)),
                ),
                suffix:    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      primary: Color.fromRGBO(248, 206, 97, 1),
                      fixedSize: Size(80.w,20),
                    ),
                    onPressed: () {

                      createCommentApiCall();
                    },
                    child: Center(
                      child: Text(
                        'Post',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700)),
                      ),
                    )),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1.w,color: Color.fromRGBO(214, 214, 214, 1))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1.w,color: Color.fromRGBO(214, 214, 214, 1))),
                  contentPadding: EdgeInsets.all(17),
                  hintText: '@ thewebions',
                  hintStyle: GoogleFonts.inter(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w400)),
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
         // itemCount: listCommentsValueNotifier.value.item2.result.length,
itemCount: 5,
                itemBuilder: (context, commentIndex) {
                  return comment_Section();
                }),
          )

        ],
      ),
    );
  }

}
Widget comment_Section() {
  // ValueNotifier<Tuple4> listCommentsValueNotifier = ValueNotifier<Tuple4>
  //   (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  //var listCommentsValueNotifier;
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 2),
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
              color: Colors.yellow,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      'http://www.goodmorningimagesdownload.com/wp-content/uploads/2021/07/1080p-New-Cool-Whatsapp-Dp-Profile-Images-pictures-hd-1-300x300.jpg'))),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                'hh',
              //  listCommentsValueNotifier.value.item2.result.username,

                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'dvv',
             // listCommentsValueNotifier.value.item2.result.content,
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(45, 45, 45, 1))),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/pops_asset/pops_likebutton.svg',
                    color: Color.fromRGBO(112, 112, 112, 1),
                  ),
                  SizedBox(width: 41.w),
                  Text(
                    'Reply',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(108, 108, 108, 1),
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
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
          'Just now',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  color: Color.fromRGBO(161, 161, 161, 1))),
        )
      ],
    ),
  );
}
