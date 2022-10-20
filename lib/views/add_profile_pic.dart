import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import '../Firebase/Writes.dart';
import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../components/AssetPageView.dart';
import '../components/SnackBar.dart';
import '../core/Models/Default.dart';
import '../core/models/exception/pops_exception.dart';
import '../handler/Network.dart';
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

  AddProfilePic({
    required this.uid,
    required this.mobileNo,
    required this.username,
    required this.password,
    required this.birthDay,
    required this.name,
     this.userPicture,
    required this.email


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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              )),
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

                Text(
                  "Add profile photo",
                  style: GoogleFonts.fredoka(
                      textStyle: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
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
                            Padding(
                              padding: EdgeInsets.only(left:65.w,top:30.h),
                              child: Row(
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

                                  SizedBox(width:80.w,),

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
                                  )
                                ],),
                            ),
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
                    'Skip',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: HexColor('#646363')),

                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InviteFriends(state: 0,mobileNo: widget.mobileNo,password: widget.password ,username: widget.username, Getstarted: 'Sign up' ,)
                        ));


                  },
                )
              ]),
        ),
      ),
    );
  }




}