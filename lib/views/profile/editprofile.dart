import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import '../../Firebase/Writes.dart';
import '../../Others/exception_string.dart';
import '../../components/AssetPageView.dart';
import '../../core/Models/Default.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '/core/models/default.dart' as defaultModel;
class Edit_Profile extends StatefulWidget {

  final String uid;
  final String coverPic;
  final String city;
  final String job;
  final String company;
  final String profilePic;
final String name;
  const Edit_Profile({Key? key,required this.uid,required this.company,
    required this.coverPic,required this.job, required this.city,
    required this.profilePic,required this.name}) : super(key: key);

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  TextEditingController cityController=TextEditingController();
  TextEditingController jobController=TextEditingController();
  TextEditingController companyController=TextEditingController();
  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier =
  ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null",null));
  Uint8List? userPicture;
  String? userPictureFileName;
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue1;
    Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );
  Future profileDetailUpdateApiCall() async {
    print('editApi1 called');
    // ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultModel.defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile",
        requestMethod: 1,
        body: {
          "user_id": widget.uid,
          "city": cityController.text,
          "job":jobController.text,
          "company":companyController.text
        });
  }
 updateFirestore(){
    FirebaseFirestore instance =FirebaseFirestore.instance;
    instance.collection('user-detail').doc(widget.uid).update({
      "city":cityController.text,
      "job":jobController.text,
      "company":companyController.text,

    });
}
  Future profilePictureUpdateAPi()async{
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultFromJson,
        // url: editprofileUrl + "?profile_url=${userPicture ?? ""}",
        url:"http://3.110.105.86:4000/update/profilePic",
        requestMethod: 1,
        formData: [
          Tuple4("profile_url", userPicture!, "Image", "Jpeg")
        ],
        formBody:{
          "user_id":widget.uid.toString()
        }
    );
  }
  Future coverPictureUpdateAPi()async{
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultFromJson,
        // url: editprofileUrl + "?profile_url=${userPicture ?? ""}",
        url:"http://3.110.105.86:4000/update/coverPic",
        requestMethod: 1,
        formData: [
          Tuple4("cover_url", userPicture!, "Image", "Jpeg")
        ],
        formBody:{
          "user_id":widget.uid.toString()
        }
    );
  }
  Future updateFirestorePic() async{
    FirebaseFirestore instance = FirebaseFirestore.instance;
    String? url;
    if (userPicture != null) {
      var taskSnapshot = await Write(uid:widget.uid).userProfile(uid: widget.uid.toString(), file: userPicture!, fileName: userPictureFileName!, contentType: "Image/jpeg");
      url = await taskSnapshot.ref.getDownloadURL();
    }
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    instance.collection("user-detail").doc(widget.uid).update({

      "pic": url,
      "updatedAt": timestamp,
    });
  }
  @override
  Widget build(BuildContext context) {
    print('userid${widget.uid}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading:  GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {


                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                    'assets/profile_assets/back_button.svg',
                    height: 30.h,
                    width: 30.w),
              ),
            ],
          ),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1))),
        ),
        actions: [
          PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
              itemBuilder: (context) => [
                PopupMenuItem(child: Center(
                  child: Text('Settings',style: GoogleFonts.inter(
                      textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize:14,
                          color: Color.fromRGBO(0,0,0,1))
                  ),),
                ),)
              ])
        ],
      ),
      body:Padding(
        padding:  EdgeInsets.only(right:12,left:12,top:15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cover photo',style: GoogleFonts.inter(
                textStyle: TextStyle(fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(70, 70, 70, 1),fontSize: 20
                ))),
            SizedBox(height:15.h),
            Stack(
                children:[   (widget.coverPic.isNotEmpty)
                    ? CachedNetworkImage(

                  fadeInDuration:
                  const Duration(
                      milliseconds:
                      400),
                  imageBuilder:
                      (context,
                      imageProvider) =>
                      Container(
                        height: 119.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                imageProvider,
                                fit: BoxFit.fill)
                        ),
                      ),
                  progressIndicatorBuilder:
                      (context, url,
                      downloadProgress) =>
                      Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress
                                .progress),
                      ),
                  imageUrl: widget.coverPic,
                  errorWidget:
                      (context, url,
                      error) =>
                      Container(
                        height: 119.h,
                        width: double.infinity,
                        decoration: BoxDecoration(

                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/noProfile.jpg"),
                              fit: BoxFit
                                  .cover

                          ),
                        ),
                      ),
                )
                    : Container(
                  height: 119.h,
                  width: double.infinity,
                  decoration: BoxDecoration(

                      image: DecorationImage(
                          image: AssetImage(
                              "assets/noProfile.jpg"),
                          fit: BoxFit
                              .cover)),
                  //   child: Image.asset("assets/noProfile.jpg")
                ),
                  Positioned(right:10,bottom: 10,
                    child: Container(height:23.h,width:23.w,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              return await gallery().then((value) async {
                                if (value != null && value.files.first.size < 52428800) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AssetPageView(
                                            fileList: value.files,
                                            onPressed: () {

                                              Navigator.pop(context);
                                              if (!mounted) return;
                                              setState(() {
                                                userPicture = value.files.first.bytes;
                                                userPictureFileName = value.files.first.name;
                                              });
                                              coverPictureUpdateAPi();
                                            //  updateFirestore();
                                            },
                                          )));
                                }
                              });
                            },
                            child: SvgPicture.asset('assets/profile_assets/edittoolblack.svg',
                                height:15,width:15),
                          ),
                        ],
                      ),
                      decoration:BoxDecoration(
                          color:Color.fromRGBO(248, 206, 97, 1),shape: BoxShape.circle
                      ),),
                  )
                ]
            ),
            SizedBox(height:20.h),
            Text('Profile picture',style: GoogleFonts.inter(
                textStyle: TextStyle(fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(70, 70, 70, 1),fontSize: 20
                ))),
            SizedBox(height:10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    children:[  (  widget.profilePic!= null)
                        ? CachedNetworkImage(
                      imageBuilder:
                          (context,
                          imageProvider) =>
                          Container(
                            width: 154.w,
                            height: 154.h,
                            decoration:
                            BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                image: DecorationImage(
                                    image:
                                    imageProvider,
                                    fit: BoxFit
                                        .cover),
                                border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))
                            ),
                          ),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      imageUrl:  widget.profilePic,
                      errorWidget: (context, url, error) =>     Container(
                        width: 154.w,
                        height: 154.h,
                        decoration: BoxDecoration(
                            shape: BoxShape
                                .circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/noProfile.jpg")
                            ),
                            border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))
                        ),
                      ),
                    )
                        : Container(
                      width: 154.w,
                      height: 154.h,
                      decoration: BoxDecoration(
                          shape: BoxShape
                              .circle,
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/noProfile.jpg"),
                              fit: BoxFit
                                  .cover),
                          border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))

                      ),
                      //   child: Image.asset("assets/noProfile.jpg")
                    ),
                      Positioned(right:0,bottom:9,
                        child: Container(height:43.h,width:43.w,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: ()async{
                                  return await gallery().then((value) async {
                                    if (value != null && value.files.first.size < 52428800) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AssetPageView(
                                                fileList: value.files,
                                                onPressed: () {

                                                  //Navigator.pop(context);
                                                  if (!mounted) return;
                                                  setState(() {
                                                    userPicture = value.files.first.bytes;
                                                    userPictureFileName = value.files.first.name;
                                                  });
                                                  profilePictureUpdateAPi();
                                                  updateFirestorePic();
                                                },
                                              )));
                                    }
                                  });
                                },
                                child: SvgPicture.asset('assets/profile_assets/edittoolblack.svg',
                                    height:26,width:26),
                              ),
                            ],
                          ),
                          decoration:BoxDecoration(
                              color:Color.fromRGBO(248, 206, 97, 1),shape: BoxShape.circle
                          ),),
                      ),]
                ),
              ],
            ),
            SizedBox(height:16.h),
            Center(
              child: Text(widget.name,style: GoogleFonts.inter(
                  textStyle: TextStyle(fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.6),fontSize: 20
                  ))),
            ),
            Padding(
              padding: EdgeInsets.only(left:27,top:8),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(165, 165, 165, 0.9),
                          shape: BoxShape.circle),
                      child: Icon(Icons.location_on_sharp,
                          color: Colors.white),
                    ),
                    SizedBox(width: 11.w),
                    RichText(
                        text: TextSpan(style:DefaultTextStyle.of(context).style,
                            children:[
                              TextSpan(text: 'Lives in ',style: GoogleFonts.inter(textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                              TextDecoration.none
                              ))),
                              TextSpan(text:widget.city,style: GoogleFonts.inter(textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
                              TextDecoration.none
                              )))
                            ])),
                    Spacer(),
                    TextButton(
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  insetPadding: EdgeInsets.only(left: 12, right: 12),
                                  titlePadding: EdgeInsets.all(0),
                                  title: Container(

                                    width:336.w,height:323.h,decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)
                                  ),child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.only(left:16,top:17,right:17),
                                      child: Row(children: [
                                        Text('Biog',  style: GoogleFonts.inter(
                                            textStyle: TextStyle(fontSize:20.sp,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                Color.fromRGBO(0, 0, 0, 1))

                                        ),),
                                        Spacer(),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            isExpanded: true,
                                            hint: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(
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
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                      item,
                                                      style: GoogleFonts.inter(
                                                          textStyle: TextStyle(
                                                            fontSize: 10.sp,
                                                            fontWeight: FontWeight.w400,
                                                            color: Color.fromRGBO(0, 0, 0, 1),
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ))
                                                .toList(),
                                            value: selectedValue1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue1 = value as String;
                                              });
                                            },
                                            icon: Padding(
                                              padding:  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                size: 20,
                                                color: Color.fromRGBO(12, 16, 29, 1),
                                              ),
                                            ),
                                            iconSize: 14,
                                            buttonHeight: 30,
                                            buttonWidth: 90,
                                            buttonDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(2),
                                                color: Color.fromRGBO(248, 206, 97, 1)),
                                            itemHeight:30,
                                            dropdownMaxHeight: 130,
                                            dropdownWidth: 90,
                                            buttonElevation: 0,
                                            dropdownElevation: 0,
                                            dropdownDecoration: BoxDecoration(
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                            scrollbarAlwaysShow: false,
                                          ),
                                        ),
                                        SizedBox(width: 10.w,),
                                        GestureDetector(onTap: (){
                                          Navigator.pop(context);
                                        },
                                          child: Text('Cancel',style: GoogleFonts.inter(textStyle: TextStyle(
                                              fontSize:14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 163, 255, 1)
                                          )),),
                                        )
                                      ],),
                                    ),
                                    Container(padding:EdgeInsets.only(left:18,top:40,right:18),
                                      child: Column(
                                        children: [

                                          TextField(
                                            cursorColor: Color.fromRGBO(102, 102, 102, 1),
                                            controller: cityController,
                                            decoration: const InputDecoration(hintText: "Enter city",
                                              border: InputBorder.none,),
                                          ),
                                          TextField(
                                            cursorColor: Color.fromRGBO(102, 102, 102, 1),
                                            controller: jobController,
                                            decoration: const InputDecoration(hintText: "Enter job",
                                              border: InputBorder.none,),
                                          ),
                                          TextField(
                                            cursorColor: Color.fromRGBO(102, 102, 102, 1),
                                            controller: companyController,
                                            decoration: const InputDecoration(hintText: "Enter company",
                                              border: InputBorder.none,),
                                          ),





                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(bottom:17),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(elevation: 0,
                                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(302.w,36.h),
                                          ),
                                          onPressed: (){
                                            profileDetailUpdateApiCall();
                                            updateFirestore();
                                            Navigator.pop(context);
                                          }, child: Text('Save',style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),fontSize:20,fontWeight: FontWeight.w700
                                          )
                                      ),)),
                                    ),
                                  ],),
                                  ),
                                );

                              });
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text('TODO'),
                      //         content: Container(
                      //           height: 150,
                      //           child: Column(
                      //             children: [
                      //               TextField(
                      //                 controller: cityController,
                      //                 decoration: const InputDecoration(hintText: "Enter city"),
                      //               ),
                      //               TextField(
                      //                 controller: jobController,
                      //                 decoration: const InputDecoration(hintText: "Enter job"),
                      //               ),
                      //               TextField(
                      //                 controller: companyController,
                      //                 decoration: const InputDecoration(hintText: "Enter company"),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         actions: <Widget>[
                      //           ElevatedButton(
                      //             child: const Text("cancel"),
                      //             onPressed: () =>
                      //
                      //                 Navigator.pop(context),
                      //           ),
                      //           ElevatedButton(
                      //               child: const Text('OK'),
                      //               onPressed: () {
                      //
                      //                 profileDetailUpdateApiCall();
                      //                 updateFirestore();
                      //                 Navigator.pop(context);
                      //
                      //               }
                      //           ),
                      //         ],
                      //       );
                      //     });


                    }, child:Text('EDIT',style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 163, 255, 1)
                    ),))
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                        height: 25.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(165, 165, 165, 0.9),
                            shape: BoxShape.circle),
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/profile_assets/proffesion.svg'
                                ,height:12.h,width:12.w),
                          ],
                        )
                    ),
                    SizedBox(width: 11.w),
                    Text(
                      widget.job,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ],
                ),
                SizedBox(height: 9.h),
                Row(
                  children: [
                    Container(
                        height: 25.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(165, 165, 165, 0.9),
                            shape: BoxShape.circle),
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/profile_assets/proffesion.svg'
                                ,height:12.h,width:12.w),
                          ],
                        )
                    ),
                    SizedBox(width: 11.w),
                    RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
                        children:[
                          TextSpan(text: 'Working at ',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0, 0.5),decoration:
                          TextDecoration.none
                          ))),
                          TextSpan(text:widget.company,style: GoogleFonts.inter(textStyle: TextStyle(
                              fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
                          TextDecoration.none
                          )))
                        ])),
                  ],
                ),
              ],),
            ),
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(336.w,47.h),
                ),
                onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Save',style: GoogleFonts.inter(
                textStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),fontSize:20,fontWeight: FontWeight.w700
                )
            ),)),
            Padding(
              padding: EdgeInsets.only(top:10,bottom:12),
              child: Divider(thickness:2.w,indent:140,endIndent:137,color: Color.fromRGBO(0,0,0,1),),
            )
          ],
        ),
      ),
    );
  }
}
