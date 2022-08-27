// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Authentication/Authentication.dart';
import '../../../Helpers/DateTimeHelper.dart';
import '../../../Others/Routers.dart';
import '../../../Others/components/ExceptionScaffold.dart';
import '../../../Others/components/LottieComposition.dart';
import '../../../Others/exception_string.dart';
import '../../../Others/lottie_strings.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/DescriptionText.dart';
import '../../../components/SnackBar.dart';
import '../../../components/TextField.dart';
import '../../../components/flatButton.dart';
import '../../../core/Models/Default.dart';
import '../../../core/Models/Feeds.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
import '../../../main.dart';
import '/core/models/Comments.dart'as commentsModel;
import '/core/models/UserDetail.dart'as userDetailsModel;

class Comments_Page extends StatefulWidget {
  final String postId;
  final FeedData;
  Comments_Page({Key? key, required this.postId,required this.FeedData}) : super(key: key);

  @override
  _Comments_PageState createState() => _Comments_PageState();
}

class _Comments_PageState extends State<Comments_Page> {
  String? uid;
  Future?  _future;
  int commentIndex = 0;
  FocusNode focusNode = FocusNode();
  bool postEnable = false;
  bool isReply = false;
  ValueNotifier<Tuple4> listCommentsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> createCommentValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> replyCommentValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  TextEditingController commentTextEditingController = TextEditingController();

  Future userDetailsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id":uid},
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

  //call after user details
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
  //call after user details
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
  Future feedsApiCall() async {
    print('feedsapi');
    return await ApiHandler().apiHandler(
      valueNotifier: feedsValueNotifier,
      jsonModel: feedsFromJson,
      url: feedsUrl,
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
  Future<dynamic> commentCheck() async{
    final data1 = await _getUID();
    final data2 = await userDetailsApiCall();
    final data3 = await listCommentsApiCall();
    final data4=await feedsApiCall();
    return [data1,data2,data3,data4];
  }
  @override
  void initState() {
    _future=commentCheck();
    commentTextEditingController.addListener(() {
      if (commentTextEditingController.text.trim() == "") {
        if (!mounted) return;
        setState(() {
          postEnable = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          postEnable = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    commentTextEditingController.dispose();
    userDetailsValueNotifier.dispose();
    listCommentsValueNotifier.dispose();
    createCommentValueNotifier.dispose();
    replyCommentValueNotifier.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _future,
          builder: (context,_) {
            return AnimatedBuilder(
              animation: Listenable.merge([
                userDetailsValueNotifier,
                listCommentsValueNotifier,
                createCommentValueNotifier,
                replyCommentValueNotifier,
              ]),
              builder: (context, _) {
                return ResponsiveBuilder(builder: (context, sizingInformation) {
                  print('77777777777');
                  if (userDetailsValueNotifier.value.item1 == 1) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        isReply = false;
                        commentTextEditingController.clear();
                        focusNode.unfocus();
                      },
                      child: Scaffold(
                        // resizeToAvoidBottomInset: false,
                          backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                          appBar: AppBar(
                            centerTitle: false,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            title: (sizingInformation.deviceScreenType != DeviceScreenType.desktop)
                                ? InkWell(
                              onTap: (){
                                print('lotus${widget.FeedData}');
                              },
                              child: Text(
                                "Comments",
                                style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              ),
                            )
                                : Image.asset(
                              "assets/briefLogo.png",
                              height: 20,
                            ),
                            leading: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.chevron_left,
                              ),
                            ),
                          ),
                          body: Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
                                        ? MediaQuery.of(context).size.width / 2.5 : double.infinity),
                                child: Padding(
                                  padding: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? EdgeInsets.all(10) : EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Color.fromRGBO(214, 214, 214, 1)),
                                              borderRadius: BorderRadius.circular(5)),
                                          padding:  EdgeInsets.fromLTRB(12.w, 13.h, 8.w, 13.h),

                                          height: 80.h,
                                          width: 351.w,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 54.h,
                                                width: 57.w,
                                                decoration: BoxDecoration(

                                                  borderRadius: BorderRadius.circular(5),

                                                ),
                                                child: Image.network( widget.FeedData.toString(),fit: BoxFit.cover,),

                                              ),
                                              Flexible(
                                                child: textField(
                                                    focusNode: focusNode,
                                                    textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
                                                    textEditingController: commentTextEditingController,
                                                    // hintText: '@ thewebions',
                                                    // hintStyle: GoogleFonts.inter(
                                                    //     textStyle: TextStyle(
                                                    //         fontSize: 12.sp,
                                                    //         fontWeight: FontWeight.w400,
                                                    //         color: Color.fromRGBO(0, 0, 0, 1))),
                                                    // hintText: "Enter Comments",
                                                    border: false,
                                                    filled: false),
                                              ),
                                              ElevatedButton(style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)),
                                                primary: Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(58.w, 22.h),),
                                                  onPressed: (
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
                                                      if (replyCommentValueNotifier.value.item1 == 1) {
                                                        // FocusManager.instance.primaryFocus?.unfocus();
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isReply = false;
                                                          commentTextEditingController.clear();
                                                          valueResetter(replyCommentValueNotifier);
                                                        });
                                                        return await listCommentsApiCall();
                                                      } else if (replyCommentValueNotifier.value.item1 == 2 || replyCommentValueNotifier.value.item1 == 3) {
                                                        final snackBar = snackbar(content: replyCommentValueNotifier.value.item3);
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }
                                                    });
                                                  }
                                                      : () async {
                                                    return await createCommentApiCall().whenComplete(() async {
                                                      isReply = false;
                                                      if (createCommentValueNotifier.value.item1 == 1) {
                                                        //  FocusManager.instance.primaryFocus?.unfocus();
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
                                                  },
                                                  child: Text(
                                                    "Post",
                                                    style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12,
                                                        color: Color.fromRGBO(0, 163, 255, 1)
                                                      //  color: (postEnable) ? Color(accent) : Color(grey)
                                                    )),
                                                  )),

                                            ],
                                          ),
                                        ),
                                      ),
                                      (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
                                          ? Container(
                                          height: kToolbarHeight,
                                          alignment: Alignment.centerLeft,
                                          color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(
                                              "Comments",
                                              style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                            ),
                                          ))
                                          : Container(),
                                      Divider(height: 1, thickness: 1),
                                      Expanded(
                                        child: Container(
                                          color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                          child: RefreshIndicator(
                                            onRefresh: () async => await _future,
                                            child: (listCommentsValueNotifier.value.item1 == 1)
                                                ? Column(
                                              children: [



                                                Expanded(
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints.expand(),
                                                    child: ListView.separated(
                                                      reverse: true,
                                                      separatorBuilder: (context, i) => Divider(
                                                        thickness: 1,
                                                      ),
                                                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                      shrinkWrap: true,
                                                      itemCount: listCommentsValueNotifier.value.item2.result.length,
                                                      itemBuilder: (context, commentIndex) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      behavior: HitTestBehavior.opaque,
                                                                      onTap: () {
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder: (context) =>
                                                                        //             UserDetails(uid: listCommentsValueNotifier.
                                                                        //             value.item2.result[commentIndex].postedBy.userId)));
                                                                      },
                                                                      child: Container(
                                                                        height: 50,
                                                                        width: 50,
                                                                        child: ClipOval(
                                                                          child: (listCommentsValueNotifier.value.item2.result
                                                                          [commentIndex].postedBy.profilePic != null)
                                                                          // ? Image.network(
                                                                          //     listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.profilePic,
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
                                                                          //     errorBuilder: (context, error, stackTrace) =>
                                                                          //         Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                                          //   )
                                                                              ? CachedNetworkImage(
                                                                            fit: BoxFit.cover,
                                                                            fadeInDuration: const Duration(milliseconds: 400),
                                                                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                              child: Container(
                                                                                width: 20.0,
                                                                                height: 20.0,
                                                                                child: CircularProgressIndicator(value: downloadProgress.progress),
                                                                              ),
                                                                            ),
                                                                            imageUrl: listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.profilePic,
                                                                            errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                                          )
                                                                              : Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),

                                                                          // child: CachedNetworkImage(
                                                                          //   fadeInDuration: const Duration(milliseconds: 400),
                                                                          //   height: 50,
                                                                          //   width: 50,
                                                                          //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                          //     child: Container(
                                                                          //       width: 20.0,
                                                                          //       height: 20.0,
                                                                          //       child: CircularProgressIndicator(value: downloadProgress.progress),
                                                                          //     ),
                                                                          //   ),
                                                                          //   imageUrl: listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.profilePic,
                                                                          //   fit: BoxFit.cover,
                                                                          //   errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                                                          // ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              GestureDetector(
                                                                                behavior: HitTestBehavior.opaque,
                                                                                onTap: () {
                                                                                  // Navigator.push(
                                                                                  //     context,
                                                                                  //     MaterialPageRoute(
                                                                                  //         builder: (context) => UserDetails(
                                                                                  //             uid: listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.userId)));
                                                                                },
                                                                                child: DescriptionText(
                                                                                  text: listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.username,
                                                                                  index: 100,
                                                                                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Text(
                                                                                  getDateTime(datetime: listCommentsValueNotifier.value.item2.result[commentIndex].timeStamp) +
                                                                                      " ago",
                                                                                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, fontWeight: FontWeight.w100)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 5),
                                                                            child: Text(
                                                                              listCommentsValueNotifier.value.item2.result[commentIndex].content,
                                                                              style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 10),
                                                                            child: Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  behavior: HitTestBehavior.opaque,
                                                                                  onTap: () {
                                                                                    focusNode.requestFocus();
                                                                                    commentTextEditingController.clear();
                                                                                    isReply = true;
                                                                                    commentIndex = commentIndex;
                                                                                    // FocusScope.of(context).requestFocus(focusNode);
                                                                                    // FocusManager.instance.primaryFocus?.requestFocus(focusNode);
                                                                                    if (!mounted) return;
                                                                                    setState(() {
                                                                                      commentTextEditingController.text =
                                                                                      "@ ${listCommentsValueNotifier.value.item2.result[commentIndex].postedBy.username} ";
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "Reply",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: textStyle(fontSize: 12, fontWeight: FontWeight.w200, color: Color(commentBlue)),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                (listCommentsValueNotifier.value.item2.result[commentIndex].replies.length != 0)
                                                                                    ? Padding(
                                                                                  padding: const EdgeInsets.only(left: 20),
                                                                                  child: GestureDetector(
                                                                                    behavior: HitTestBehavior.opaque,
                                                                                    onTap: () {
                                                                                      if (!mounted) return;
                                                                                      setState(() {
                                                                                        listCommentsValueNotifier.value.item2.result[commentIndex].isExpanded =
                                                                                        !listCommentsValueNotifier.value.item2.result[commentIndex].isExpanded;
                                                                                      });
                                                                                    },
                                                                                    child: Text(
                                                                                      "View ${listCommentsValueNotifier.value.item2.result[commentIndex].replies.length} Replies",
                                                                                      style: GoogleFonts.poppins(
                                                                                        textStyle: textStyle(
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w200,
                                                                                            textDecoration: TextDecoration.underline),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                                    : Container(),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              (listCommentsValueNotifier.value.item2.result[commentIndex].isExpanded == true &&
                                                                  listCommentsValueNotifier.value.item2.result[commentIndex].replies.length != 0)
                                                                  ? Padding(
                                                                padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                                                child: ListView.separated(
                                                                    separatorBuilder: (context, i) => SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: listCommentsValueNotifier.value.item2.result[commentIndex].replies.length,
                                                                    itemBuilder: (context, replyIndex) {
                                                                      return Container(
                                                                        width: MediaQuery.of(context).size.width,
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            GestureDetector(
                                                                              behavior: HitTestBehavior.opaque,
                                                                              onTap: () {
                                                                                // Navigator.push(
                                                                                //     context,
                                                                                //     MaterialPageRoute(
                                                                                //         builder: (context) => UserDetails(
                                                                                //             uid: listCommentsValueNotifier
                                                                                //                 .value.item2.result[commentIndex].replies[replyIndex].userId)));
                                                                              },
                                                                              child: Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                child: ClipOval(
                                                                                    child: (listCommentsValueNotifier
                                                                                        .value.item2.result[commentIndex].replies[replyIndex].profilePic !=
                                                                                        null)
                                                                                    // ? Image.network(
                                                                                    //     listCommentsValueNotifier
                                                                                    //         .value.item2.result[commentIndex].replies[replyIndex].profilePic,
                                                                                    //     fit: BoxFit.cover,
                                                                                    //     loadingBuilder:
                                                                                    //         (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                    //       if (loadingProgress == null) return child;
                                                                                    //       return Center(
                                                                                    //         child: CircularProgressIndicator(
                                                                                    //           value: loadingProgress.expectedTotalBytes != null
                                                                                    //               ? loadingProgress.cumulativeBytesLoaded /
                                                                                    //                   loadingProgress.expectedTotalBytes!
                                                                                    //               : null,
                                                                                    //         ),
                                                                                    //       );
                                                                                    //     },
                                                                                    //     errorBuilder: (context, error, stackTrace) =>
                                                                                    //         Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                                                    //   )
                                                                                        ? CachedNetworkImage(
                                                                                      fit: BoxFit.cover,
                                                                                      fadeInDuration: const Duration(milliseconds: 400),
                                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                                        child: Container(
                                                                                          width: 20.0,
                                                                                          height: 20.0,
                                                                                          child: CircularProgressIndicator(value: downloadProgress.progress),
                                                                                        ),
                                                                                      ),
                                                                                      imageUrl: listCommentsValueNotifier
                                                                                          .value.item2.result[commentIndex].replies[replyIndex].profilePic,
                                                                                      errorWidget: (context, url, error) =>
                                                                                          Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                                                    )
                                                                                        : Image.asset("assets/noProfile.jpg", fit: BoxFit.cover)),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    behavior: HitTestBehavior.opaque,
                                                                                    onTap: () {
                                                                                      // Navigator.push(
                                                                                      //     context,
                                                                                      //     MaterialPageRoute(
                                                                                      //         builder: (context) => UserDetails(
                                                                                      //             uid: listCommentsValueNotifier
                                                                                      //                 .value.item2.result[commentIndex].replies[replyIndex].userId)));
                                                                                    },
                                                                                    child: Text(
                                                                                      listCommentsValueNotifier.value.item2.result[commentIndex].replies[replyIndex].username,
                                                                                      style: GoogleFonts.poppins(
                                                                                          textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                    child: Text(
                                                                                      listCommentsValueNotifier.value.item2.result[commentIndex].replies[replyIndex].content,
                                                                                      style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                              )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )
                                                : (listCommentsValueNotifier.value.item1 == 2)
                                                ? Center(
                                              child: SingleChildScrollView(
                                                physics: NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    lottieAnimation(listCommentsValueNotifier.value.item2!.lottieString),
                                                    flatButton(
                                                      onPressed: () async {
                                                        return await listCommentsApiCall();
                                                      },
                                                      backgroundColor: Color(accent),
                                                      textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                                                      child: Text("Try Again"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                                : (listCommentsValueNotifier.value.item1 == 3)
                                                ? (listCommentsValueNotifier.value.item2.status == "ERROR" && listCommentsValueNotifier.value.item3 == "no comments available")
                                                ? Column(
                                              children: [
                                                Expanded(child: Center(child: Text("No comments !"))),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                                                  child: Column(
                                                    children: [
                                                      Divider(thickness: 1, height: 1),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: textField(
                                                                focusNode: focusNode,
                                                                textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12)),
                                                                textEditingController: commentTextEditingController,
                                                                hintText: "Enter Comments",
                                                                border: false,
                                                                filled: false),
                                                          ),
                                                          TextButton(
                                                              onPressed: (
                                                                  postEnable == false ||
                                                                      createCommentValueNotifier.value.item1 == 0 ||
                                                                      replyCommentValueNotifier.value.item1 == 0)
                                                                  ? null
                                                                  : (isReply)
                                                                  ? () async {
                                                                return await replyCommentApiCall(
                                                                    commentId: listCommentsValueNotifier.value.
                                                                    item2.result[commentIndex].id.oid
                                                                )
                                                                    .whenComplete(() async {
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
                                                                  } else if (createCommentValueNotifier.value.item1 == 2 ||
                                                                      createCommentValueNotifier.value.item1 == 3) {
                                                                    final snackBar = snackbar(content: createCommentValueNotifier.value.item3);
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                "Post",
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: textStyle(fontSize: 12, color: (postEnable) ? Color(accent) : Color(grey))),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(thickness: 1, height: 1),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Center(
                                              child: SingleChildScrollView(
                                                physics: NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    lottieAnimation(alertLottie),
                                                    Text(listCommentsValueNotifier.value.item3),
                                                    flatButton(
                                                      onPressed: () async {
                                                        return await listCommentsApiCall();
                                                      },
                                                      backgroundColor: Color(accent),
                                                      textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                                                      child: Text("Try Again"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                                : Center(child: SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: lottieAnimation(loadingLottie))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
                    );
                  } else if (userDetailsValueNotifier.value.item1 == 2) {
                    print('11111111');
                    return exceptionScaffold(
                        context: context,
                        lottieString: userDetailsValueNotifier.value.item2!.lottieString,
                        subtitle: userDetailsValueNotifier.value.item3 ?? userDetailsValueNotifier.value.item2!.data,
                        onPressed: () async {
                          return await _future;
                        });
                  } else if (userDetailsValueNotifier.value.item1 == 3) {
                    print('2222222222222');
                    return exceptionScaffold(
                        context: context,
                        lottieString: invalidLottie,
                        subtitle: userDetailsValueNotifier.value.item3,
                        onPressed: () async {
                          return await _future;
                        });
                  } else {
                    print('333333333333');
                    return exceptionScaffold(
                      context: context,
                      lottieString: userDetailsValueNotifier.value.item2!.lottieString,
                      subtitle: userDetailsValueNotifier.value.item3 ?? userDetailsValueNotifier.value.item2!.data,
                    );
                  }
                });
              },
            );
          }
      ),
    );
  }
}
