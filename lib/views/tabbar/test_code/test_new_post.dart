import 'dart:io';
import 'dart:typed_data';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../../Others/Routers.dart';
import '../../../Others/Structure.dart';
import '../../../Others/components/ExceptionScaffold.dart';
import '../../../Others/exception_string.dart';
import '../../../Others/lottie_strings.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/SnackBar.dart';
import '../../../components/TextFormField.dart';
import '../../../components/VideoPlayerContainer.dart';
import '../../../core/Models/Default.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
import '../../../main.dart';
import '../../../validator/validator.dart';
import '/core/Models/UserDetail.dart' as userDetailsModel;
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';


class Post extends StatefulWidget {

  ///*0->create post; 1->edit post
  final int state;
  //*state=0
  final List<PlatformFile>? fileList;
  //*state=1
  final List<String>? stringList;
  final String? description;
  final String? postId;

  const Post({Key? key, required this.state, this.postId, this.description, this.fileList, this.stringList}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Future? _future;
  String? uid;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool initLoading = true;
  List<PlatformFile> fileList = [];
  List<String> fileUrlList = [];

  ValueNotifier<Tuple4> createPostValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> updatePostValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));

  PageController pageController = PageController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  int currentPageIndex = 0;

  Future userDetailsApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id":uid},
    );
  }
  Future createPostApiCall({required String uid, required String name, required String? profilePic,
    required String description}) async {
    String url = '?user_id=$uid&username=$name&profile_url=$profilePic&description=$description';
    List<Tuple4<String, Uint8List, String, String>> formData = [];
    for (int i = 0; i < fileList.length; i++) {
      if (fileList[i].extension!.contains('mp4') || fileList[i].extension!.contains('mpeg4')) {
        formData.add(Tuple4("posts", fileList[i].bytes!, 'Video', "Mp4"));
      } else {
        formData.add(Tuple4("posts", fileList[i].bytes!, 'Image', 'Jpeg'));
      }
    }
    return await ApiHandler().apiHandler(
      valueNotifier: createPostValueNotifier,
      jsonModel: defaultFromJson,
      url: createPostsUrl + url,
      requestMethod: 1,
      formData: formData,
    );
  }

  Future updatePostApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: updatePostValueNotifier,
      jsonModel: defaultFromJson,
      url: editPostsUrl,
      requestMethod: 1,
      body: {"user_id": uid, "post_id": widget.postId!,
        "description": descriptionTextEditingController.text},
    );
  }

  Future<FilePickerResult?> files() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mpeg4'],
      );
  initialiser() async {
    if (widget.state == 0 && widget.fileList != null) {
      fileList = widget.fileList!;
      if (!mounted) return;
      setState(() {
        initLoading = false;
      });
    } else if (widget.state == 1 && widget.stringList != null && widget.description != null) {
      fileUrlList = widget.stringList!;
      if (!mounted) return;
      setState(() {
        descriptionTextEditingController.text = widget.description!;
        initLoading = false;
      });
    }
  }

  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }

  Future<dynamic> sendData() async {

final data1=await _getUID();
final data2=await initialiser();
    // final data2 = await userDetailsApiCall();
    // final data3=await updatePostApiCall();
    return [data1,data2];

  }
  @override
  void initState() {
_future=sendData();
// if (widget.state == 0 && fileList != null) {
//   print('55555555');
//   fileList = fileList;
//   if (!mounted) return;
//   setState(() {
//     initLoading = false;
//   });
//   print(6666);
// } else if (widget.state == 1 && widget.stringList != null && widget.description != null) {
//   print('7777777777');
//   fileUrlList = widget.stringList!;
//   if (!mounted) return;
//   setState(() {
//     descriptionTextEditingController.text = widget.description!;
//     initLoading = false;
//   });
// }
    super.initState();
  }


  @override
  void dispose() {
    createPostValueNotifier.dispose();
    updatePostValueNotifier.dispose();
    userDetailsValueNotifier.dispose();
    descriptionTextEditingController.dispose();
    pageController.dispose();
    fileList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
          animation: Listenable.merge([createPostValueNotifier, userDetailsValueNotifier]),
          builder: (context, _) {
            if (initLoading == false) {
              return FutureBuilder(
                future: _future,
                builder: (context,_) {
                  return Scaffold(
                      backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                      appBar: AppBar(
                        centerTitle: false,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: (widget.state == 0)
                            ? InkWell(
                          onTap: (){
                            print('lotus${ userDetailsValueNotifier.value.item2.result.username}');
                          },
                              child: Text(
                          "Create Post",
                          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                            )
                            : Text(
                          "Edit Post",
                          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                      body: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.center,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 800.0),
                              child: Column(
                                children: [

                                  // InkWell(
                                  //   onTap: () async {
                                  //     return await files().then((value) {
                                  //
                                  //       if (value != null && value.files.isNotEmpty) {
                                  //
                                  //         fileList.clear();
                                  //         if (value.files.length < 10) {
                                  //
                                  //           for (int i = 0; i < value.files.length; i++) {
                                  //
                                  //             if (value.files[i].size < 52428800) {
                                  //
                                  //               fileList.add(value.files[i]);
                                  //
                                  //             } else {
                                  //
                                  //               final snackBar = snackbar(content: "${value.files[i].name} file exceeds 50mb.");
                                  //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  //             }
                                  //           }
                                  //           // return Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //           //     Post(state: 0, fileList: fileList))).then((value) async {
                                  //           //   if (value != null) {
                                  //           //     return await feedsApiCall(uid: getUID());
                                  //           //   }
                                  //           // }
                                  //           // );
                                  //         } else {
                                  //           final snackBar = snackbar(content: "Only 10 files can be uploaded per post.");
                                  //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  //         }
                                  //       }
                                  //     });
                                  //   },
                                  //   child: Text(
                                  //     'Add photo and videos',
                                  //     style: GoogleFonts.inter(
                                  //         fontWeight: FontWeight.w400,
                                  //         fontSize: 16.sp,
                                  //         color: Color.fromRGBO(0, 0, 0, 1)),
                                  //   ),
                                  // ),
                                  (widget.state == 0)
                                      ? Flexible(
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: (){print('Lotus:${fileList.length.toString()}');},
                                          child: PageView.builder(
                                              controller: pageController,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: fileList.length,
                                              onPageChanged: (page) {
                                                if (!mounted) return;
                                                setState(() {
                                                  currentPageIndex = page;
                                                });
                                              },
                                              itemBuilder: (context, pageIndex) {
                                                return (fileList[pageIndex].extension!.contains("mp4") ||
                                                    fileList[pageIndex].extension!.contains("mpeg4"))
                                                    ? VideoPlayerContainer(
                                                  videoUrl: fileList[pageIndex].path!,
                                                )
                                                    : Image.memory(
                                                  fileList[pageIndex].bytes!,
                                                  fit: BoxFit.contain,
                                                );
                                              }),
                                        ),
                                        (fileList.length != 0 && fileList.length != 1)
                                            ? Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                MaterialButton(
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(20),
                                                    shape: CircleBorder(),
                                                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                                    onPressed: () {
                                                      pageController.previousPage(duration: kDuration, curve: kCurve);
                                                    },
                                                    child: Icon(
                                                      Icons.keyboard_arrow_left,
                                                      color: (themedata.value.index == 0) ? Color(black) : Color(white),
                                                    )),
                                                MaterialButton(
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(20),
                                                    shape: CircleBorder(),
                                                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                                    onPressed: () {
                                                      pageController.nextPage(duration: kDuration, curve: kCurve);
                                                    },
                                                    child: Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: (themedata.value.index == 0) ? Color(black) : Color(white),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                            : Container(),
                                        Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Chip(
                                              backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                                              label: Text(
                                                "${currentPageIndex + 1}" + "/" + "${fileList.length}",
                                                style: GoogleFonts.poppins(
                                                    textStyle: textStyle(
                                                      fontSize: 10,
                                                    )),
                                              ),
                                            ))
                                      ],
                                    ),
                                  )
                                      : Flexible(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        PageView.builder(
                                            controller: pageController,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: fileUrlList.length,
                                            onPageChanged: (page) {
                                              if (!mounted) return;
                                              setState(() {
                                                currentPageIndex = page;
                                              });
                                            },
                                            itemBuilder: (context, pageIndex) {
                                              // return VideoPlayerContainer(
                                              //   videoUrl: blobToUrl(fileList[pageIndex].bytes!, "Video/mpeg4"),
                                              // );
                                              return (fileUrlList[pageIndex].contains("mp4") || fileUrlList[pageIndex].contains("mpeg4"))
                                                  ? VideoPlayerContainer(
                                                videoUrl: fileUrlList[pageIndex],
                                              )
                                              // : Image.network(
                                              //     fileUrlList[pageIndex],
                                              //     fit: BoxFit.cover,
                                              //   );
                                                  : CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                fadeInDuration: const Duration(milliseconds: 400),
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                                  ),
                                                ),
                                                imageUrl: fileUrlList[pageIndex],
                                                errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                                              );
                                            }),
                                        (fileUrlList.length != 0 && fileUrlList.length != 1)
                                            ? Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                MaterialButton(
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(20),
                                                    shape: CircleBorder(),
                                                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                                    onPressed: () {
                                                      pageController.previousPage(duration: kDuration, curve: kCurve);
                                                    },
                                                    child: Icon(
                                                      Icons.keyboard_arrow_left,
                                                      color: (themedata.value.index == 0) ? Color(black) : Color(white),
                                                    )),
                                                MaterialButton(
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(20),
                                                    shape: CircleBorder(),
                                                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                                    onPressed: () {
                                                      pageController.nextPage(duration: kDuration, curve: kCurve);
                                                    },
                                                    child: Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: (themedata.value.index == 0) ? Color(black) : Color(white),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                            : Container(),
                                        Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Chip(
                                              backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                                              label: Text(
                                                "${currentPageIndex + 1}" + "/" + "${fileUrlList.length}",
                                                style: GoogleFonts.poppins(
                                                    textStyle: textStyle(
                                                      fontSize: 10,
                                                    )),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Form(
                                            key: _formKey,
                                            child: textFormField(

                                              // errorStyle: GoogleFonts.poppins(textStyle: textStylusernamee(fontsize: 12, color: Color(white))),
                                                textStyle: GoogleFonts.poppins(textStyle: textStyle()),
                                                textEditingController: descriptionTextEditingController,
                                                hintText: "Add a description",
                                                hintStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey))),
                                                border: false,
                                                maxLines: 5,
                                                autofocus: true,
                                                fillColor: (themedata.value.index == 0) ? Color(white) : Color(lightBlack),
                                                validator: (value) => defaultValidator(value: value,
                                                    type: "Description")
                                            ),
                                          ),
                                        ),
                                        // ElevatedButton(
                                        //     style: ElevatedButton.styleFrom(
                                        //       elevation: 0,
                                        //       shape: RoundedRectangleBorder(
                                        //           borderRadius: BorderRadius.circular(5)),
                                        //       primary: Color.fromRGBO(248, 206, 97, 1),
                                        //       fixedSize: Size(194.w, 43.h),
                                        //     ),
                                        //     onPressed: () {
                                        //       print('lotus:${fileList.length}');
                                        //       // params =
                                        //       //     "?user_id=${uid}&username=${username}&profile_url=${profile_url}&description=${description}";
                                        //       // print(params);
                                        //       // print("Description : $description");
                                        //       // var body = jsonEncode(<String, dynamic>{});
                                        //       // createPost(body);
                                        //       onPressed: (isLoading)
                                        //           ? null
                                        //           : (widget.state == 0)
                                        //           ? () async {
                                        //         if (!mounted) return;
                                        //         setState(() {
                                        //           isLoading = true;
                                        //         });
                                        //         if (_formKey.currentState!.validate()) {
                                        //           return await userDetailsApiCall().whenComplete(() async {
                                        //             if (userDetailsValueNotifier.value.item1 == 1) {
                                        //               return await createPostApiCall(
                                        //                   uid: userDetailsValueNotifier.value.item2.result.userId,
                                        //                   name: userDetailsValueNotifier.value.item2.result.username,
                                        //                   profilePic: userDetailsValueNotifier.value.item2.result.profileUrl,
                                        //                   description: descriptionTextEditingController.text)
                                        //                   .whenComplete(() async {
                                        //                 if (createPostValueNotifier.value.item1 == 1) {
                                        //                   Navigator.pop(context, true);
                                        //                 } else if (createPostValueNotifier.value.item1 == 2 || createPostValueNotifier.value.item1 == 3) {
                                        //                   if (!mounted) return;
                                        //                   setState(() {
                                        //                     isLoading = false;
                                        //                   });
                                        //                   final snackBar = snackbar(content:createPostValueNotifier.value.item3.toString());
                                        //                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        //                 }
                                        //               });
                                        //             } else if (userDetailsValueNotifier.value.item1 == 2 || userDetailsValueNotifier.value.item1 == 3) {
                                        //               if (!mounted) return;
                                        //               setState(() {
                                        //                 isLoading = false;
                                        //               });
                                        //               final snackBar = snackbar(content: userDetailsValueNotifier.value.item3.toString());
                                        //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        //             }
                                        //           });
                                        //         } else {
                                        //           if (!mounted) return;
                                        //           setState(() {
                                        //             isLoading = false;
                                        //           });
                                        //           final snackBar = snackbar(content: "Please fill out all the required fields before uploading!");
                                        //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        //         }
                                        //       }
                                        //           : () async {
                                        //         if (!mounted) return;
                                        //         setState(() {
                                        //           isLoading = true;
                                        //         });
                                        //         if (_formKey.currentState!.validate()) {
                                        //           return await updatePostApiCall().whenComplete(() async {
                                        //             if (updatePostValueNotifier.value.item1 == 1) {
                                        //               Navigator.pop(context, true);
                                        //             } else if (updatePostValueNotifier.value.item1 == 2 || updatePostValueNotifier.value.item1 == 3) {
                                        //               if (!mounted) return;
                                        //               setState(() {
                                        //                 isLoading = false;
                                        //               });
                                        //               final snackBar = snackbar(content: updatePostValueNotifier.value.item3.toString());
                                        //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        //             }
                                        //           });
                                        //         } else {
                                        //           if (!mounted) return;
                                        //           setState(() {
                                        //             isLoading = false;
                                        //           });
                                        //           final snackBar = snackbar(content: "Please fill out all the required fields before uploading!");
                                        //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        //         }
                                        //       };
                                        //     },
                                        //     child: Text(
                                        //       'Post',
                                        //       style: GoogleFonts.inter(
                                        //           textStyle: TextStyle(
                                        //               color: Color.fromRGBO(0, 0, 0, 1),
                                        //               fontSize: 24.sp,
                                        //               fontWeight: FontWeight.w700)),
                                        //     )),
                                        MaterialButton(
                                          elevation: 0,
                                          shape: CircleBorder(),
                                          color: Color(accent),
                                          padding: EdgeInsets.all(20),
                                          onPressed: (isLoading)
                                              ? null
                                              : (widget.state == 0)
                                              ? () async {
                                            print('lotus:${fileList.length}');
                                            if (!mounted) return;
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (_formKey.currentState!.validate()) {

                                              return await userDetailsApiCall().whenComplete(() async {
                                                if (userDetailsValueNotifier.value.item1 == 1) {
                                                  return await createPostApiCall(
                                                      uid: userDetailsValueNotifier.value.item2.result.userId,
                                                      name: userDetailsValueNotifier.value.item2.result.username,
                                                      profilePic: userDetailsValueNotifier.value.item2.result.profileUrl,
                                                      description: descriptionTextEditingController.text)
                                                      .whenComplete(() async {
                                                    if (createPostValueNotifier.value.item1 == 1) {
                                                      Navigator.pop(context, true);
                                                    } else if (createPostValueNotifier.value.item1 == 2 ||
                                                        createPostValueNotifier.value.item1 == 3) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      final snackBar = snackbar(content: createPostValueNotifier.value.item3.toString());
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }
                                                  });
                                                } else if (userDetailsValueNotifier.value.item1 == 2 || userDetailsValueNotifier.value.item1 == 3) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  final snackBar = snackbar(content: userDetailsValueNotifier.value.item3.toString());
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              });
                                            } else {
                                              if (!mounted) return;
                                              setState(() {
                                                isLoading = false;
                                              });
                                              final snackBar = snackbar(content: "Please fill out all the required fields before uploading!");
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }
                                              : () async {
                                            if (!mounted) return;
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (_formKey.currentState!.validate()) {
                                              return await updatePostApiCall().whenComplete(() async {
                                                if (updatePostValueNotifier.value.item1 == 1) {
                                                  Navigator.pop(context, true);
                                                } else if (updatePostValueNotifier.value.item1 == 2 || updatePostValueNotifier.value.item1 == 3) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  final snackBar = snackbar(content: updatePostValueNotifier.value.item3.toString());
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              });
                                            } else {
                                              if (!mounted) return;
                                              setState(() {
                                                isLoading = false;
                                              });
                                              final snackBar = snackbar(content: "Please fill out all the required fields before uploading!");
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          },
                                          child: (isLoading)
                                              ? CircularProgressIndicator()
                                              : Icon(
                                            Icons.send_outlined,
                                            color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ));
                }
              );
            } else {
              return exceptionScaffold(
                context: context,
                lottieString: loadingLottie,
                subtitle: "Downloading posts...",
              );
            }
          }),
    );
  }
}
