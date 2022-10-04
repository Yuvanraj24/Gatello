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
import '../../../Others/exception_string.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/SnackBar.dart';
import '../../../components/VideoPlayerContainer.dart';
import '../../../core/Models/Default.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
import '../../../main.dart';
import '../../../validator/validator.dart';
import '/core/Models/UserDetail.dart' as userDetailsModel;
// import 'package:flutter_switch/flutter_switch.dart';

class New_Post extends StatefulWidget {

  int state=0;
  final List<String>? stringList;
  final String? description;
  final String? postId;
   New_Post({Key? key,required this.state, this.postId, this.description,
     this.stringList}) : super(key: key);

  @override
  State<New_Post> createState() => _New_PostState();
}

class _New_PostState extends State<New_Post> {

  int currentPageIndex = 0;
  Future? _future;
  List<String> fileUrlList = [];
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
 String? uid;
  bool initLoading = true;
  // String? description;
  //
  // String uid = "s8b6XInslPffQEgz8sVTINsPhcx2";
  //
  // String username = "akashtest";
  //
  // String profile_url = "";

  // TextEditingController _descController = TextEditingController();

  PageController pageController = PageController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  List<PlatformFile> fileList = [];
  ValueNotifier<Tuple4> userDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> createPostValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> updatePostValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  Future<FilePickerResult?> files() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mpeg4'],
      );
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;

  String? params;
  Future userDetailsApiCall() async {
    print('111111111111');
    return await ApiHandler().apiHandler(
      valueNotifier: userDetailsValueNotifier,
      jsonModel: userDetailsModel.userDetailsFromJson,
      url: userDetailsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
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
    print('22222222222');
    return await ApiHandler().apiHandler(
      valueNotifier: createPostValueNotifier,
      jsonModel: defaultFromJson,
      url: createPostsUrl + url,
      requestMethod: 1,
      formData: formData,
    );
  }
  Future updatePostApiCall() async {
    print('3333333333');
    return await ApiHandler().apiHandler(
      valueNotifier: updatePostValueNotifier,
      jsonModel: defaultFromJson,
      url: editPostsUrl,
      requestMethod: 1,
      body: {"user_id": uid, "post_id": widget.postId!,
        "description": descriptionTextEditingController.text},
    );
  }


  Future<void> _getUID() async {
    print('444444444444');
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid");
    print("ShardPref ${uid}");
  }
  Future<dynamic> sendData() async {
 //_getUID();
final data1=await _getUID();

    final data2 = await userDetailsApiCall();
    final data3=await updatePostApiCall();
    return [data1, data2, data3];
  }
  @override
  void initState() {
_future=sendData();
if (widget.state == 0 && fileList != null) {
  fileList = fileList!;
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
    super.initState();
  }

  @override
  void dispose() {
    createPostValueNotifier.dispose();
    updatePostValueNotifier.dispose();
    userDetailsValueNotifier.dispose();
    descriptionTextEditingController.dispose();

    fileList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _future
          ,
        builder: (context,_) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: InkWell(
                onTap: (){
                  print('lotus${userDetailsValueNotifier.value.item2.result.userId}');
                },
                child: Text(
                  'New post',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(12, 16, 29, 1))),
                ),
              ),
              leading: InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back, color: Color.fromRGBO(12, 16, 29, 1))),
            ),
            body: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12, top: 13),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 7, left: 9, bottom: 6),
                                    child: Text(
                                      'Public',
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.sp,
                                              color: Color.fromRGBO(0, 0, 0, 1))),
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value as String;
                              });
                            },
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Color.fromRGBO(12, 16, 29, 1),
                              ),
                            ),
                            iconSize: 14,
                            buttonHeight: 30,
                            buttonWidth: 86,
                            buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Color.fromRGBO(248, 206, 97, 1)),
                            itemHeight: 40,
                            // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 90,
                            dropdownWidth: 90,
                            buttonElevation: 0,
                            dropdownElevation: 0,
                            dropdownDecoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            scrollbarAlwaysShow: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Container(
                      height: 115.h,
                      width: 351.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(214, 214, 214, 1)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding:  EdgeInsets.only(left:13,top:13),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(height: 100.h,width: 280.w,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: descriptionTextEditingController,
                                validator: (value) => defaultValidator(value: value,
                                    type: "Description"),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:  Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)
                                  ),
                                  hintText: 'Write a caption...',
                                  hintStyle: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(152, 152, 152, 1))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (widget.state == 0)
                        ? Flexible(
                      child: Stack(
                        children: [
                          PageView.builder(
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
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 28, left: 18),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/pops_asset/photosge.svg'),
                              SizedBox(
                                width: 18.w,
                              ),
                              InkWell(
                                onTap: () async {
                                  return await files().then((value) {
                                    print('1111111111111');
                                    if (value != null && value.files.isNotEmpty) {
                                      print('222222222222');
                                      fileList.clear();
                                      if (value.files.length < 10) {
                                        print('33333333333333333');
                                        for (int i = 0; i < value.files.length; i++) {

                                          if (value.files[i].size < 52428800) {
                                            print('444444444');
                                            fileList.add(value.files[i]);
                                            print('444444444');
                                          } else {
                                            print('55555555555');
                                            final snackBar = snackbar(content: "${value.files[i].name} file exceeds 50mb.");
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          }
                                        }
                                        // return Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        //     Post(state: 0, fileList: fileList))).then((value) async {
                                        //   if (value != null) {
                                        //     return await feedsApiCall(uid: getUID());
                                        //   }
                                        // }
                                        // );
                                      } else {
                                        final snackBar = snackbar(content: "Only 10 files can be uploaded per post.");
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    }
                                  });
                                },
                                child: Text(
                                  'Add photo and videos',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/pops_asset/tagge.svg'),
                              SizedBox(
                                width: 11.w,
                              ),
                              Text(
                                'Tag your friends',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 18),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 30),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Location',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6, top: 6),
                          child: Row(
                            children: [
                              Text('Status',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      color: Color.fromRGBO(0, 0, 0, 1))),
                              Spacer(),
                              FlutterSwitch(
                                switchBorder: Border.all(
                                    color: Color.fromRGBO(0, 163, 255, 1),
                                    width: 1.w),
                                toggleColor: Color.fromRGBO(0, 163, 255, 1),
                                inactiveToggleColor: Color.fromRGBO(0, 0, 0, 1),
                                activeColor: Color.fromRGBO(255, 255, 255, 1),
                                width: 35.w,
                                height: 18.h,
                                activeToggleColor: Color.fromRGBO(0, 163, 255, 1),
                                valueFontSize: 25.0,
                                toggleSize: 10,
                                value: isSwitched,
                                borderRadius: 9.5,
                                onToggle: (value) {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 77.h,
                         ),
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
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              primary: Color.fromRGBO(248, 206, 97, 1),
                              fixedSize: Size(194.w, 43.h),
                            ),
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
                            child: Text(
                              'Post',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700)),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  // Future<void> createPost(var body) async {
  //   List<Tuple4<String, Uint8List, String, String>> formData = [];
  //   print("File List lenght ${fileList.length}");
  //   for (int i = 0; i < fileList.length; i++) {
  //     if (fileList[i].extension!.contains('mp4') ||
  //         fileList[i].extension!.contains('mpeg4')) {
  //       formData.add(Tuple4("posts", fileList[i].bytes!, 'Video', "Mp4"));
  //     } else {
  //       formData.add(Tuple4("posts", fileList[i].bytes!, 'Image', 'Jpeg'));
  //       print("Form Data Added!");
  //     }
  //   }
  //
  //   print(body.toString());
  //   try {
  //     var request = http.MultipartRequest(
  //         "POST", Uri.parse("http://3.108.219.188:5000/create/post" + params!));
  //
  //     // var url = Uri.parse("http://3.108.219.188:5000/create/post" + params!);
  //     // print(url);
  //     // request.fields.addAll(body);
  //
  //     // var response = await http.post(url, body: body);
  //     for (var file in fileList) {
  //       print("MP Adding");
  //       request.files
  //           .add(await http.MultipartFile.fromPath("posts", file.path!));
  //       print("File Path${file.path!}");
  //     }
  //     var sendRequest = await request.send();
  //     var response = await http.Response.fromStream(sendRequest);
  //     print(response.body);
  //     print("Posted--");
  //     if (response.statusCode == 200) {
  //       print("Posted");
  //       print(response.body.toString());
  //       Map<String, dynamic> map = jsonDecode(response.body.toString());
  //       String status = map['status'];
  //
  //       print("STATUS:" + status);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
