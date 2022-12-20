import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/test_chat/test_chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

import '../Firebase/Writes.dart';
import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../components/AssetPageView.dart';
import '../components/SnackBar.dart';
import '../core/Models/Default.dart';
import '../core/models/exception/pops_exception.dart';
import '../handler/Network.dart';
import '../profile_avator.dart';
import 'contact_list.dart';
import 'invitefriends.dart';

class AddProfilePic extends StatefulWidget {
  var uid;
  var mobileNo;
  var password;
  var username;
  var name;
  var birthDay;
  var email;
  String? userPicture;
  var avatarData;

  AddProfilePic({
    required this.uid,
    required this.mobileNo,
    required this.username,
    required this.password,
    required this.birthDay,
    required this.name,
     this.userPicture,
    required this.email,
    this.avatarData


  });
  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {

  var profileByte;

  FirebaseFirestore instance = FirebaseFirestore.instance;


  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  Uint8List? userPicture;


  File? image;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  Future<FilePickerResult?> gallery() async =>
      await FilePicker.platform.pickFiles(

          withData: true,
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg',]

        // withData: true,
        // allowedExtensions: ['jpg'],
      );

  Future<FilePickerResult?> camera() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );

  Future profileDetailUpdateApiCallBody() async {

    Stream<QuerySnapshot>  userRef = instance.collection("user-detail").where("uid",isEqualTo: widget.uid).snapshots();

    userRef.forEach((field) {
      field.docs.asMap().forEach((index, data) {
        print("Proff:${field.docs[index]["pic"]}");
        userPicture=field.docs[index]["pic"];
      });
    });
    ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultFromJson,
        url: editprofileUrl + "?profile_url=${userPicture ?? ""}",
        requestMethod: 1,
        formData: (userPicture == null) ? [Tuple4("profile_file", profileByte, "Image", "Jpeg")] : null,
        formBody: {
          "user_id": widget.uid,
          "username": widget.username,
          "name": widget.name,
          // "phone": countryCode + " " + phoneTextEditingController.text,
          "phone": "+91${widget.mobileNo}",
          "dob": widget.birthDay,
          "email": widget.email,
          "designation": "",
          "city": "",
          "member": "",
          "company": "",
          "job": "",
          "college": "",
          "high_school": "",
          "interest": "",
          // "relationship_status": relationshipStatusTextEditingController.text,
          "relationship_status": "",
          "about": "",

        });
  }


  Future pickimage() async {
    try {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return;
      final temporaryImage = File(image1.path);
      setState(() {
        this.image = temporaryImage;
        print("this is a img : ${image1}");

      });
    } on PlatformException catch (e) {
      print('unable to pick image $e');
    }
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions:[
          TextButton(
            child: Text(
              'No',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#646363')),

            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              'Yes',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#646363')),

            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Center(
                child: TextButton(
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: HexColor('#646363')),

                  ),
                  onPressed: (){
                    Navigator.push(context, PageTransition(
                        duration: Duration(milliseconds: 120),
                        type: PageTransitionType.rightToLeft, child: InviteFriends(state: 0,mobileNo: widget.mobileNo,password: widget.password ,username: widget.username, Getstarted: 'Sign up' ,)
                        ));


                  },
                ),
              )
            ],
          ),
          body: Container(
            padding:
            EdgeInsets.only(left: 12.w,
                right: 12.w,
                top: 150.h,
                bottom: 51.h
            ),
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: (){
                    },
                    child: Text(
                      "Add profile photo",
                      style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add a profile photo so that your friends know its you.',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#646363'))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  // (image != null)?
                  // Image.file(image!):
                  Image.asset(
                    "assets/profile_page/profile_pic_logo.png",
                    width: 165.w,
                  ),

                  Spacer(),
                  ElevatedButton(
                    onPressed: () async{

                      showModalBottomSheet(context: context, builder: (context) {
                        return Container(height:200.h,padding:EdgeInsets.only(top:25.h,left: 20.w),
                          child:Column(crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text("Profile Photo",  style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),),
                              SizedBox(height: 30.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      return await gallery().then((value) async {
                                        if (value != null && value.files.first.size<52428800) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AssetPageView(
                                                    fileList: value.files,
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
                                                          file: value.files.first.bytes!,
                                                          fileName: timestamp,
                                                          contentType: "image/" + value.files.first.extension!, guid: '');
                                                      String url = await taskSnapshot.ref.getDownloadURL();
                                                      profileByte = value.files.first.bytes!;
                                                      instance.collection("user-detail").doc(widget.uid).update({
                                                        "uid": widget.uid,
                                                        "pic": url,

                                                      });

                                                      profileDetailUpdateApiCallBody();

                                                    },
                                                  ))).whenComplete(() =>
                                              Navigator.push(context,

                                                  MaterialPageRoute(
                                                      builder: (context) => InviteFriends(state: 0,mobileNo: widget.mobileNo,password: widget.password ,username: widget.username, Getstarted: 'Sign up' ,)
                                                  )));
                                        } else {
                                          final snackBar = snackbar(content: "File size is greater than 50MB");
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });

                                    },
                                    child: Column(children: [
                                      SvgPicture.asset("assets/icons_assets/signup_gallery.svg",height:50.h,width:50.w,),
                                      SizedBox(height:10.h,),
                                      Text("Gallery",  style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),)
                                    ],),
                                  ),

                                  SizedBox(width:40.w,),

                                  GestureDetector(
                                    onTap: ()async{
                                      return await pickimage().then((value) async {
                                        if (value != null && value.files.first.size<52428800) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AssetPageView(
                                                    fileList: value.files,
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
                                                          file: value.files.first.bytes!,
                                                          fileName: timestamp,
                                                          contentType: "image/" + value.files.first.extension!, guid: '');
                                                      String url = await taskSnapshot.ref.getDownloadURL();
                                                      profileByte = value.files.first.bytes!;
                                                      instance.collection("user-detail").doc(widget.uid).update({
                                                        "uid": widget.uid,
                                                        "pic": url,

                                                      });

                                                      profileDetailUpdateApiCallBody();

                                                    },
                                                  ))).whenComplete(() =>
                                              Navigator.push(context,

                                                  MaterialPageRoute(
                                                      builder: (context) => InviteFriends(state: 0,mobileNo: widget.mobileNo,password: widget.password ,username: widget.username, Getstarted: 'Sign up' ,)
                                                  )));
                                        } else {
                                          final snackBar = snackbar(content: "File size is greater than 50MB");
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    },
                                    child: Column(children: [
                                      SvgPicture.asset("assets/icons_assets/signup_camera.svg",height:50.h,width:50.w,),
                                      SizedBox(height:10.h,),
                                      Text("Camera",  style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),)
                                    ],),
                                  ),
                                  SizedBox(width:40.w,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Avator(uid: widget.uid, mobileNo: widget.mobileNo, password: widget.password, username: widget.username, name: widget.name, birthDay: widget.birthDay, email: widget.email,)
                                          ));
                                    },
                                    child: Column(children: [
                                      SvgPicture.asset('assets/invite_friends/profilepicture.svg',height:50.h,width:50.w,),
                                      SizedBox(height:10.h,),
                                      Text("Avatar",  style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),)
                                    ],),
                                  )
                                ],),
                            ],
                          ),
                        );
                      },);





                    },
                    child: Text(
                      'Add a photo',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        onPrimary: Colors.black,
                        //  padding: EdgeInsets.all(10),
                        minimumSize: Size(234.w, 48.h),
                        primary: Color.fromRGBO(248, 206, 97, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  InkWell(
                    child: Text(
                      'Next',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: HexColor('#646363')),

                    ),
                    onTap: (){

                      svgToPng(context, widget.avatarData).then((value)async{
                        Directory tempDir = await getTemporaryDirectory();
                        String tempPath = tempDir.path;
                        print("TMP : ${tempPath}");
                        File file=File(tempPath+"/avatar.png");
                        print("UID: ${widget.uid}");
                        print("mobile ${widget.uid}");

                        TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
                            file: value.buffer.asUint8List(),
                            fileName: timestamp,
                            contentType: "image/png", guid: '');
                        String url = await taskSnapshot.ref.getDownloadURL();
                        profileByte = value.buffer.asByteData();
                        instance.collection("user-detail").doc("${widget.uid}").update({
                          "uid": "${widget.uid}",
                          "pic": url,

                        });

                        profileDetailUpdateApiCallBody();

                        // writeToFile(value.buffer.asByteData(), tempPath+"/avatar.png").then((value) async {
                        //
                        //
                        // });
                      }).then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InviteFriends(state: 0,mobileNo: widget.mobileNo,password: widget.password ,username: widget.username, Getstarted: 'Sign up' ,)
                          )));


                    },
                  )
                ]),
          ),
        ),
      ),
    );
  }

  createAvatar(ByteData bytes)async {
    TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
        file: bytes.buffer.asUint8List(),
        fileName: timestamp,
        contentType: "image/" + "png", guid: '');
    String url = await taskSnapshot.ref.getDownloadURL();
    profileByte = bytes;
    print("profile data ${profileByte}");
    instance.collection("user-detail").doc(widget.uid).update({
      "uid": widget.uid,
      "pic": url,

    });

    profileDetailUpdateApiCallBody();
    return bytes;
  }

  Future<Uint8List> svgToPng(BuildContext context, String svgString,
      ) async {
    var svgHeight = 264;
    var svgWidth = 280;
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");

    // to have a nice rendering it is important to have the exact original height and width,
    // the easier way to retrieve it is directly from the svg string
    // but be careful, this is an ugly fix for a flutter_svg problem that works
    // with my images
    String temp = svgString.substring(svgString.indexOf('height="') + 8);
    int originalHeight =
        svgHeight ?? int.parse(temp.substring(0, temp.indexOf('p')));
    temp = svgString.substring(svgString.indexOf('width="') + 7);
    int originalWidth =
        svgWidth ?? int.parse(temp.substring(0, temp.indexOf('p')));

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    double width = originalHeight *
        devicePixelRatio; // where 32 is your SVG's original width
    double height = originalWidth * devicePixelRatio; // same thing

    // Convert to ui.Picture
    final picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the screen DPI
    final image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }




}