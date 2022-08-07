import 'dart:convert';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
// import 'package:flutter_switch/flutter_switch.dart';

class New_Post extends StatefulWidget {
  const New_Post({Key? key}) : super(key: key);

  @override
  State<New_Post> createState() => _New_PostState();
}

class _New_PostState extends State<New_Post> {


  String? desc ;
  String uid = "s8b6XInslPffQEgz8sVTINsPhcx2";

  String username = "akashtest";

  String profile_url = "";


  TextEditingController _descController = TextEditingController();
  List<PlatformFile> fileList = [];
  Future<FilePickerResult?> files() async => await FilePicker.platform.pickFiles(
    withData: true,
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mpeg4'],
  );
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;


  String? params;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'New post',
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(12, 16, 29, 1))),
          ),
          leading: Icon(Icons.arrow_back, color: Color.fromRGBO(12, 16, 29, 1)),
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
                                          fontSize: 13.sp,
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
                                      fontSize: 14,
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
                        dropdownMaxHeight: 80,
                        dropdownWidth: 74,
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
                TextField(
                  controller: _descController,
                  onChanged: (val) {
                   desc = _descController.text.toString();
                  },
                  maxLines: 10,

                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.w,
                              color: Color.fromRGBO(181, 181, 181, 1)),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Type here...',
                      hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(165, 165, 165, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp)),
                      prefix: Container(
                          height: 32.h,
                          width: 34.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)),
                          child: Image.network(
                            'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg',
                            fit: BoxFit.fill,
                          )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.w,
                              color: Color.fromRGBO(181, 181, 181, 1)),
                          borderRadius: BorderRadius.circular(10))),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 28, left: 18),
                      child: Row(
                        children: [

                           SvgPicture.asset(
                                'assets/pops_asset/new_post_gallery.svg'),


                          SizedBox(
                            width: 18.w,
                          ),
                          InkWell(
                            onTap: ()async{
                              Fluttertoast.showToast(
                                  msg: "${desc}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1);

                              return await files().then((value) {
                                if (value != null && value.files.isNotEmpty) {
                                  fileList.clear();
                                  if (value.files.length < 10) {
                                    for (int i = 0; i < value.files.length; i++) {
                                      if (value.files[i].size < 52428800) {
                                        fileList.add(value.files[i]);
                                      } else {
                                        // final snackBar = snackbar(content: "${value.files[i].name} file exceeds 50mb.");
                                        Fluttertoast.showToast(
                                            msg: "${value.files[i].name} file exceeds 50mb.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1);
                                      }
                                    }

                                    Fluttertoast.showToast(
                                        msg: "${fileList.length}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1);
                                  } else {
                                    // final snackBar = snackbar(content: "Only 10 files can be uploaded per post.");
                                    Fluttertoast.showToast(
                                        msg: "Only 10 files can be uploaded per post.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1);
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
                          SvgPicture.asset('assets/pops_asset/Tag_people.svg'),
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
                          SvgPicture.asset(
                              'assets/pops_asset/Location_image.svg'),
                          SizedBox(
                            width: 18.w,
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
                          SizedBox(
                            width: 257.w,
                          ),
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          primary: Color.fromRGBO(248, 206, 97, 1),
                          fixedSize: Size(194.w, 43.h),
                        ),
                        onPressed: () {

                          params =
                          "?user_id=${uid}&username=${username}&profile_url=${profile_url}&description=${desc}";
                          print(params);
                          print("Description : $desc");
                          var body = jsonEncode(<String, dynamic>{});
                          createPost(body);
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
      ),
    );
  }
  Future<void> createPost(var body) async {
    List<Tuple4<String, Uint8List, String, String>> formData = [];
    print("File List lenght ${fileList.length}");
    for (int i = 0; i < fileList.length; i++) {
      if (fileList[i].extension!.contains('mp4') ||
          fileList[i].extension!.contains('mpeg4')) {
        formData.add(Tuple4("posts", fileList[i].bytes!, 'Video', "Mp4"));
      } else {
        formData.add(Tuple4("posts", fileList[i].bytes!, 'Image', 'Jpeg'));
        print("Form Data Added!");
      }
    }

    print(body.toString());
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("http://3.108.219.188:5000/create/post" + params!));

      // var url = Uri.parse("http://3.108.219.188:5000/create/post" + params!);
      // print(url);
      // request.fields.addAll(body);

      // var response = await http.post(url, body: body);
      for (var file in fileList) {
        print("MP Adding");
        request.files
            .add(await http.MultipartFile.fromPath("posts", file.path!));
        print("File Path${file.path!}");
      }
      var sendRequest = await request.send();
      var response = await http.Response.fromStream(sendRequest);
      print(response.body);
      print("Posted--");
      if (response.statusCode == 200) {
        print("Posted");
        print(response.body.toString());
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        String status = map['status'];

        print("STATUS:" + status);
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
