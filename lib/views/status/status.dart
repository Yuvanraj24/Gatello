import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/status/others_status.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import '../../Firebase/Writes.dart';
import '../../Others/exception_string.dart';
import '../../components/AssetPageView.dart';
import '../../components/SnackBar.dart';
import '../../core/Models/Default.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import 'myMoreStatus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '/core/models/own_status_model.dart' as OwnStatusDetailsModel;

class Status extends StatefulWidget {
  String uid;
  Status({
    required this.uid

  });

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> with TickerProviderStateMixin{
  int selectValue=0;
  late Timer _timer;
  TextEditingController story=TextEditingController();
  late AnimationController controller;

  var profileByte;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();



  ValueNotifier<Tuple4> statusCreateValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> statusShowValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
List statusList=[];
 // var tempPort = "http://3.110.105.86:2000";

  Future<FilePickerResult?> gallery() async =>
      await FilePicker.platform.pickFiles(

          withData: true,
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg',]

        // withData: true,
        // allowedExtensions: ['jpg'],
      );


  statusCreate()async{
    print("this is an success api...!");

    return await ApiHandler().apiHandler(
        valueNotifier: statusCreateValueNotifier,
        jsonModel: defaultFromJson,
        url: "http://3.110.105.86:2000/create/status?user_id=${widget.uid}",
        requestMethod: 1,
        formData: [Tuple4("status_post", profileByte, "Image", "jpg")],
        formBody: {
          "user_id" : widget.uid,
        });
  }


  showOwnStatus() async{

    print("this is an showStatus success api...!");
    return await ApiHandler().apiHandler(
        valueNotifier: statusShowValueNotifier,
        jsonModel: OwnStatusDetailsModel.statusDataFromJson,
        url : "http://3.110.105.86:2000/allstatus/status",
        requestMethod: 1,
        body: {"user_id": widget.uid,}

    );

  }




  @override
  void initState() {

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds:60),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  List statusprofile=["https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg",
    "https://dl.memuplay.com/new_market/img/com.vicman.newprofilepic.icon.2022-06-07-21-33-07.png",
    "https://www.seekpng.com/png/detail/506-5061704_cool-profile-avatar-picture-cool-picture-for-profile.png"];

  List name=["Deena","Krishna","Ragu"];

  List time=["6.45","7.12","5.23"];

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: showOwnStatus(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
                body:SingleChildScrollView(
                  child: Container(
                    padding:EdgeInsets.fromLTRB(12.w,15.h,12.w,0.h),
                    child:Column(crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        Column(crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              GestureDetector(onTap:() {
                                // showOwnStatus();
                                // print("value Notifier : ${statusShowValueNotifier.value}");
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => MoreStories(uid: widget.uid,
                                // )));

                              },
                                child: Row(mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                                        image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                                            fit:BoxFit.fill),
                                        border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),SizedBox(width:15.w),
                                    Column(crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height:4.h),
                                          Text("My Status",style:GoogleFonts.inter(textStyle:TextStyle(
                                              fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                                          ))),
                                          SizedBox(height:4.h),
                                          Text("Today at 6:00am",style:GoogleFonts.inter(textStyle:TextStyle(
                                              fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                                          ))),
                                        ]),
                                  ],
                                ),
                              ), SizedBox(height:10.h),
                              Text("Recent updates",style:GoogleFonts.inter(textStyle:TextStyle(
                                  fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                              ))),SizedBox(height:10.h),
                              ListView.builder(
                                shrinkWrap:true,
                                physics:BouncingScrollPhysics(),
                                itemCount: 5,
                                // itemCount:statusprofile.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder:(context) {
                                        return Otherstatus();
                                      },));
                                    },
                                    onLongPress:() {
                                      showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          shape:RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(20)),
                                          title:Text('Mute status',style:TextStyle(fontWeight:FontWeight.w700,
                                              fontSize:20.sp,color:Color.fromRGBO(0,0,0,1))),
                                          content:Text(''),
                                          actions: [
                                            TextButton(
                                              onPressed: () {Navigator.pop(context);},
                                              child: Text('Cancel',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                                                  color:Color.fromRGBO(0, 163, 255, 1))),
                                            ),
                                            TextButton(onPressed: () {  },
                                              child: Text('OK',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                                                  color:Color.fromRGBO(0, 0, 0, 1))),
                                            )
                                          ],
                                        );
                                      });
                                    },
                                    child: Container(height:80.h,width:double.infinity.w,
                                      color:Colors.transparent,
                                      // padding:EdgeInsets.fromLTRB(0.w,8.h,0.w,18.h),
                                      child:Row(
                                        children: [
                                          Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                                              image:DecorationImage(image: NetworkImage
                                                (statusprofile[index]),
                                                  fit:BoxFit.fill),
                                              border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                                          SizedBox(width:15.w),
                                          Column(crossAxisAlignment:CrossAxisAlignment.start,
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [

                                                Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                                                  fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                                                Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                                                    fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                                                )))])
                                        ],),
                                    ),
                                  );
                                },),
                              SizedBox(height:10.h),
                              // Text("Viewed",style:GoogleFonts.inter(textStyle:TextStyle(
                              //     fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                              // ))),SizedBox(height:10.h),
                              // ListView.builder(
                              //   shrinkWrap:true,
                              //   physics:BouncingScrollPhysics(),
                              //   itemCount:statusprofile.length,
                              //   itemBuilder: (context, index) {
                              //     return GestureDetector(
                              //       onTap: () {
                              //         Navigator.push(context, MaterialPageRoute(builder:(context) {
                              //           return Otherstatus();
                              //         },));
                              //       },
                              //       onLongPress:() {
                              //         showDialog(context: context, builder: (context){
                              //           return AlertDialog(
                              //             shape:RoundedRectangleBorder(
                              //                 borderRadius:BorderRadius.circular(20)),
                              //             title:Text('Mute status',style:TextStyle(fontWeight:FontWeight.w700,
                              //                 fontSize:20.sp,color:Color.fromRGBO(0,0,0,1))),
                              //             content:Text(''),
                              //             actions: [
                              //               TextButton(
                              //                 onPressed: () {Navigator.pop(context);},
                              //                 child: Text('Cancel',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                              //                     color:Color.fromRGBO(0, 163, 255, 1))),
                              //               ),
                              //               TextButton(onPressed: () {  },
                              //                 child: Text('OK',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                              //                     color:Color.fromRGBO(0, 0, 0, 1))),
                              //               )
                              //             ],
                              //           );
                              //         });
                              //       },
                              //       child: Container(height:80.h,width:double.infinity.w,
                              //         color:Colors.transparent,
                              //         // padding:EdgeInsets.fromLTRB(0.w,8.h,0.w,18.h),
                              //         child:Row(
                              //           children: [
                              //             Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                              //                 image:DecorationImage(image: NetworkImage
                              //                   (statusprofile[index]),
                              //                     fit:BoxFit.fill),
                              //                 border:Border.all(width:2.w,color:Color.fromRGBO(139, 139, 139, 1))),),
                              //             SizedBox(width:15.w),
                              //             Column(crossAxisAlignment:CrossAxisAlignment.start,
                              //                 mainAxisAlignment:MainAxisAlignment.center,
                              //                 children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                              //                     fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                              //                   Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                              //                       fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                              //                   )))])
                              //           ],),
                              //
                              //       ),
                              //     );
                              //   },),
                            ])
                      ],),),
                ),
                floatingActionButton:SpeedDial(
                  overlayOpacity:0, spacing:17,
                  spaceBetweenChildren: 17, activeIcon:Icons.keyboard_arrow_down_rounded,
                  icon: Icons.keyboard_arrow_up_rounded, backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                  foregroundColor:Colors.black,
                  children: [SpeedDialChild(
                      onTap:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ColorTest(uid: widget.uid);
                        },));
                      },
                      backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                      child:SvgPicture.asset('assets/status_assets/status_text.svg')
                  ),
                    SpeedDialChild(
                        onTap:() async{
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
                                          profileByte = value.files.first.bytes!;
                                          statusCreate();
                                        },
                                      )));

                            } else {
                              final snackBar = snackbar(content: "File size is greater than 50MB");
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                        },
                        backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                        child:SvgPicture.asset('assets/status_assets/camera_icon.svg')
                    ),
                  ],
                )
            ),
          );
        }
    );
  }
  Widget statusViewed(controller){
    return SafeArea(
      child: Scaffold(
        body:Stack(
            children:[
              Container(height:double.infinity.h,width:double.infinity.w,decoration:BoxDecoration(
                  color:Colors.black,
                  image:DecorationImage(image:NetworkImage('https://images.unsplash.com/photo-1589419621083-1ead66c96fa7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWlja2V5JTIwbW91c2V8ZW58MHx8MHx8&w=1000&q=80'),
                  )
              ),),
              Positioned(top:28.h,left:10.w,
                child: Row(children: [
                  GestureDetector(onTap:() {
                    Navigator.pop(context);
                  },
                      child: SvgPicture.asset('assets/status_assets/back_icon.svg',height:32.h,width:32.w)),
                  SizedBox(width:10.w),
                  Container(height:60.h,width:60.w,decoration:BoxDecoration(shape:BoxShape.circle,
                      image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                          fit:BoxFit.fill),
                      border:Border.all(width:1.5.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                  SizedBox(width:10.w),
                  Column(crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text('My ',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                          fontSize:14.sp,color:Color.fromRGBO(255, 255, 255, 1))),
                      SizedBox(height:5.h),
                      Text('Today at 6:00am',style:GoogleFonts.inter(textStyle:TextStyle(
                          fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(255, 255, 255, 1)
                      )))
                    ],)
                ]),
              ),
              Positioned(bottom:23.h,left:170.w,right:170.w,
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          barrierColor:Colors.transparent,
                          context: context, builder:(context) {
                          return viwersList();
                        },);
                      },
                      child: Column(
                        children: [SvgPicture.asset('assets/status_assets/statusview_icon.svg'),
                          SizedBox(height:5.h),
                          Text('10',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w700,
                              fontSize:18.sp)),

                        ],
                      ))),

              LinearProgressIndicator(
                value:controller.value,
                backgroundColor:Colors.white,
              ),

            ]),
      ),
    );
  }
  Widget viwersList(){
    return Column(
      children: [
        Container(
          height:44.h,width:double.infinity.w,decoration:BoxDecoration(
            color:Color.fromRGBO(248, 206, 97, 1)),
          child:Padding(
            padding:EdgeInsets.fromLTRB(12.w,0.h,34.w,0.h),
            child: Row(children: [
              Text('Viewed by  10',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                  fontSize:12.sp,color:Color.fromRGBO(0,0,0,1))),
              Spacer(),
              SvgPicture.asset('assets/status_assets/delete_icon.svg')
            ]),
          ),
        ),
        Expanded(
          child: ListView.builder(itemCount:10,
            itemBuilder: (context, index) {
              return Container(
                // padding:EdgeInsets.symmetric(vertical:25.h),
                child:ListTile(
                  leading:Container(height:42.h,width:41.w,decoration:BoxDecoration(
                      shape:BoxShape.circle,image:DecorationImage(image:NetworkImage(
                      'https://i0.wp.com/i.pinimg.com/474x/df/c6/ee/dfc6ee8d269617c0812194b3f5422e22.jpg'),fit:
                  BoxFit.fill)
                  ),),
                  title:Text("Deena",style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                  )),),
                  subtitle:Text("Today at 6:00am",style:GoogleFonts.inter(textStyle:TextStyle(
                      fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                  )),),
                ),
              );
            },),
        )
      ],
    );
  }
  File? image;
  Future pickimage() async {
    try {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return;
      final temporaryImage = File(image1.path);
      setState(() {
        this.image = temporaryImage;
        print("this is an image : ${image}");
      });
    } on PlatformException catch (e) {
      print('unable to pick image $e');
    }
  }


}

class ColorTest extends StatefulWidget {
  String uid;
  ColorTest({
    required this.uid

  });



  @override
  State<ColorTest> createState() => _ColorTestState();
}

class _ColorTestState extends State<ColorTest> {
  ValueNotifier<Tuple4> statusCreateValueNotifier = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  ValueNotifier<Tuple4> statusShowValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  // create some values
  TextEditingController storyController=TextEditingController();
  Color pickerColor = HexColor('#F8CE61');
  Color currentColor = HexColor('#F8CE61');
  Color pickerColor1 =Colors.black;
  Color currentColor1 = Colors.black;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeColor1(Color color) {
    setState(() => pickerColor1 = color);
  }


  statusCreate1()async{
    print("this is an success api...!");

    return await ApiHandler().apiHandler(
        valueNotifier: statusCreateValueNotifier,
        jsonModel: defaultFromJson,
        url: "http://3.110.105.86:2000/create/status",
        requestMethod: 1,

        formBody: {
          "user_id" : widget.uid,
          "status_text":storyController.text,
          "background_color":currentColor.toString().substring(6,16),
          "font_style":'8'
        });
  }

  void showColorPicker() {
    showDialog(
        context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),

        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              print('selected color${pickerColor} ');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void showColorPicker1() {
    showDialog(
        context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor1,
            onColorChanged: changeColor1,
          ),

        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor1 = pickerColor1);
              print('selected color${pickerColor1} ');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Stack(
          children:[
            Container(height:double.infinity.h,width:double.infinity.w,decoration:BoxDecoration(
              color:currentColor
          ),),
            Positioned(left:27.w,top:40.h,right:17.w,
              child: Row(children: [
                GestureDetector(onTap:() {
                  Navigator.pop(context);
                },
                    child: SvgPicture.asset('assets/status_assets/back_icon.svg',height:32.h,width:32.w)),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    showColorPicker1();
                  },
                  child: Container(child: Center(child: Text('T',style: TextStyle(color: Colors.black,fontSize: 25),)),height:45.h,width:45.w,decoration:BoxDecoration(
                      shape:BoxShape.circle,color:currentColor1,border:Border.all(color:Colors.white)
                  )),
                ),
                GestureDetector(
                  onTap: (){
                    showColorPicker();
                  },
                  child: Container(height:45.h,width:45.w,decoration:BoxDecoration(
                      shape:BoxShape.circle,color:currentColor,border:Border.all(color:Colors.white)
                  )),
                )
              ]),
            ),
            Positioned(top:283.h,left:83.w,
              child: Container(
                height:60.h,width:200.w,
                child: TextField(
                  controller:storyController,
                  cursorColor:Colors.black,
                  style: TextStyle(fontWeight:FontWeight.w700,fontSize: 32.sp,
                      color: currentColor1),
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.w,
                              color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      hintText:'Tap to type',hintStyle:GoogleFonts.inter(
                      textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize: 32.sp,
                          color: currentColor1)
                  )
                  ),),
              ),
            )
          ]),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(
        backgroundColor:Colors.white,
        child:Icon(Icons.check_rounded,color:Colors.black),
        onPressed: () {

          statusCreate1();
        },
      ),
    );
  }


}



