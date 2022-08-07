import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:gatello/views/tabbar/pops/report.dart';
import 'package:gatello/views/tabbar/pops/share.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:gatello/views/tabbar/pops/report.dart';
// import 'package:gatello/views/tabbar/pops/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';

import '../../../../Authentication/Authentication.dart';
import '../../../../components/snackbar.dart';

import '../../../../core/models/exception/pops_exception.dart';

import '../../../../handler/Network.dart';

import '../../../Others/exception_string.dart';

import '../../../Others/route.dart';
import '../../../core/models/Feeds.dart';
import 'newpost.dart';

class Pops_Page extends StatefulWidget {
  const Pops_Page({Key? key}) : super(key: key);

  @override
  State<Pops_Page> createState() => _Pops_PageState();
}

class _Pops_PageState extends State<Pops_Page> {
  List<Tuple4<String, Uint8List, String, String>> formData = [];
   String? params;
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>
    (Tuple4(0, exceptionFromJson(loading), "Loading", null));
  List<PlatformFile> fileList = [];
  Future<FilePickerResult?> files() async => await FilePicker.platform.pickFiles(
    withData: true,
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mpeg4'],
  );
  Future feedsApiCall({required String uid}) async {
    return await ApiHandler().apiHandler(
      valueNotifier: feedsValueNotifier,
      jsonModel: feedsFromJson,
      url: feedsUrl,
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }
  Future<void> createPost(var body) async {
    print(body.toString());
    try {
      var url = Uri.parse("http://3.108.219.188:5000/create/post?"+params!);
      print(url);

      var response = await http.post(url, body: body);

      for (int i = 0; i < fileList.length; i++) {
        if (fileList[i].extension!.contains('mp4') || fileList[i].extension!.contains('mpeg4')) {
          formData.add(Tuple4("posts", fileList[i].bytes!, 'Video', "Mp4"));
        } else {
          formData.add(Tuple4("posts", fileList[i].bytes!, 'Image', 'Jpeg'));
        }
      }
      if (response.statusCode == 200) {
        print(response.body.toString());
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        String status = map['status'];
        print("STATUS:" + status);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: Column(
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
                          color: Colors.yellow,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              'Pop your photos,videos &',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(152, 152, 152, 1),
                                      fontSize: 14.sp)),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text('messages here...',
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(152, 152, 152, 1),
                                        fontSize: 14.sp))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    IconButton(onPressed: ()
                    {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>New_Post()),
                     );



                    },
                        icon: Icon(Icons.add)),
                    // Padding(
                    //   padding:  EdgeInsets.only(bottom: 15),
                    //   child: SvgPicture.asset(
                    //     'assets/pops_asset/pops_gallery.svg',
                    //     width: 38.w,
                    //     height: 40.h,
                    //   ),
                    // ),
                        //
                        Padding(
                          padding:  EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap:(){


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
                    itemCount: 10,
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
                                  SizedBox(
                                    width: 24.9.w,
                                  ),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.whatsappimages.in/wp-content/uploads/2021/12/Creative-Whatsapp-Dp-Pics-Download.jpg'),
                                    radius: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.45),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Jonny',
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
                            Stack(children: [
                              GestureDetector(onDoubleTap: (){
                                print('Double tapped');
                                 // liked_Button();
                              },
                                child: Container(
                                  height: 259.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1509070016581-915335454d19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              Positioned(
                                  top: 61.h,
                                  left: 139.w,
                                  right: 139.w,
                                  child: liked_Button()),
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
                                          'I love nature... more',
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
                              height: 108.h,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 28.w,
                                        ),
                                        SvgPicture.asset(
                                          'assets/pops_asset/pops_likebutton.svg',
                                        ),
                                        SizedBox(
                                          width: 7.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 7),
                                          child: Text(
                                            '3.6k',
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
                                          padding: const EdgeInsets.only(top: 6),
                                          child: SvgPicture.asset(
                                              'assets/pops_asset/pops_commentbutton.svg'),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 7),
                                          child: Text(
                                            '3.6k',
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(fontWeight: FontWeight.w400,
                                              color:
                                                  Color.fromRGBO(51, 51, 51, 1),
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
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
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: SvgPicture.asset(
                                              'assets/pops_asset/pops_sharefinal.svg',
                                              height: 15.h,
                                              width: 15.w,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 160.w,
                                        ),
                                        SvgPicture.asset(
                                            'assets/pops_asset/pops_savebutton.svg')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 28.w,
                                        ),
                                        Text(
                                          'Liked by',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1))),
                                        ),
                                        SizedBox(
                                          width: 5.w,
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 28.w,
                                        ),
                                        Text(
                                          'view all comments...',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(fontWeight: FontWeight.w400,
                                            color: Color.fromRGBO(98, 98, 98, 1),
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    indent: 25,
                                    endIndent: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 300,bottom: 20),
                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(248, 206, 97, 1),
                  focusColor: Color.fromRGBO(248, 206, 97, 1),focusElevation: 10,elevation: 10,
                    child: Icon(Icons.keyboard_arrow_up,color: Color.fromRGBO(12, 16, 29, 1),size: 40,),
                    onPressed: (){}),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget liked_Button(){
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
          height: 82.h,
          width: 82.w,
        child: Icon(Icons.thumb_up_alt,size: 40,),
        // SvgPicture.asset('assets/pops_asset/liked.svg',height: 20.h,width: 20.w,),
        decoration:BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(255, 255, 255, 1)
        )
      ),
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
}