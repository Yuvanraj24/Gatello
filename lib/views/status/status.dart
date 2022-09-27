import 'dart:async';
import 'dart:io';
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

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> with TickerProviderStateMixin{
  int selectValue=0;
  late Timer _timer;
 TextEditingController story=TextEditingController();

  late AnimationController controller;
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
  final check="https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg";

  List statusprofile=["https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg",
    "https://dl.memuplay.com/new_market/img/com.vicman.newprofilepic.icon.2022-06-07-21-33-07.png",
    "https://www.seekpng.com/png/detail/506-5061704_cool-profile-avatar-picture-cool-picture-for-profile.png"];

  List name=["Deena","Krishna","Ragu"];

  List time=["6.45","7.12","5.23"];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Container(
            padding:EdgeInsets.fromLTRB(12.w,15.h,12.w,0.h),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,
              children:[

                Container(height:250.h,width:250.w,
                    child: Image.network(check)),
                ElevatedButton(onPressed:()
                async{

                  final uri = Uri.parse(check);
                  final res = await http.get(uri);
                  final bytes = res.bodyBytes;
                  final temp = await getTemporaryDirectory();
                  final path = "${temp.path}/image.svg";
                  File(path).writeAsBytesSync(bytes);


                }, child:Icon(Icons.share)),

                Padding(padding:EdgeInsets.fromLTRB(21.w,0.h,21.w,0.h),
                  child: Row(children:[
                    GestureDetector(
                      onTap:() {
                       setState(() {
                      selectValue=0;
                       });
                    },
                      child: Container(height:27.h,width:143.w,decoration:BoxDecoration(
                        border:Border.all(color:selectValue==1?Color.fromRGBO(203, 203, 203, 1):Colors.transparent),
                          color:selectValue==0?Color.fromRGBO(248, 206, 97, 1):Colors.transparent,
                          borderRadius:BorderRadius.circular(5)),
                        child:Center(
                          child: Text("Ping Status",style:GoogleFonts.inter(textStyle:TextStyle(
                              fontWeight:FontWeight.w400,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                          )),),
                        ),),
                    ),
                    SizedBox(width:8.w),
                    GestureDetector(
                      onTap:() {
                        setState(() {
                          selectValue=1;
                          print(selectValue);
                        });
                      },
                      child: Container(height:27.h,width:143.w,decoration:BoxDecoration(
                        border:Border.all(color:selectValue==1?Colors.transparent:
                        Color.fromRGBO(203, 203, 203, 1)),
                          color:selectValue==1?Color.fromRGBO(248, 206, 97, 1):Colors.transparent,
                          borderRadius:BorderRadius.circular(5)),
                        child:Center(
                          child: Text("Pop Status",style:GoogleFonts.inter(textStyle:TextStyle(
                              fontWeight:FontWeight.w400,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                          )),),
                        ),
                      ),
                    )],),
                ),
                SizedBox(height:15.h),
                Divider(color:Color.fromRGBO(242, 242, 242, 1),thickness:1.5.w),
                SizedBox(height:12.h),
               selectValue==0?
               Column(crossAxisAlignment:CrossAxisAlignment.start,
                   children: [
                 Row(mainAxisAlignment:MainAxisAlignment.center,
                   children: [GestureDetector(onTap:(){Navigator.push(context,MaterialPageRoute(builder:
                       (context) => MoreStories()
                           // statusViewed(controller)
                   ));},
                     child: Column(children: [
                       Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                           image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                               fit:BoxFit.fill),
                           border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                       SizedBox(height:4.h),
                       Text("My status",style:GoogleFonts.inter(textStyle:TextStyle(
                           fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                       ))),
                       SizedBox(height:4.h),
                       Text("Today at 6:00am",style:GoogleFonts.inter(textStyle:TextStyle(
                           fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                       ))),
                     ]),
                   ),
                   ],
                 ), SizedBox(height:10.h),
                 Text("Recent updates",style:GoogleFonts.inter(textStyle:TextStyle(
                     fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                 ))),
                 ListView.builder(shrinkWrap:true,
                   physics:BouncingScrollPhysics(),
                   itemCount:statusprofile.length,
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
                       child: Container(height:98.h,width:double.infinity.w,
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
                                 children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                                     fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                                   Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                                       fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                                   )))])
                           ],),
                       ),
                     );
                   },),
                 Text("Viewed",style:GoogleFonts.inter(textStyle:TextStyle(
                     fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
                 ))),
                 ListView.builder(shrinkWrap:true,
                   physics:BouncingScrollPhysics(),
                   itemCount:statusprofile.length,
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
                       child: Container(height:98.h,width:double.infinity.w,
                         color:Colors.transparent,
                         // padding:EdgeInsets.fromLTRB(0.w,8.h,0.w,18.h),
                         child:Row(
                           children: [
                             Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                                 image:DecorationImage(image: NetworkImage
                                   (statusprofile[index]),
                                     fit:BoxFit.fill),
                                 border:Border.all(width:2.w,color:Color.fromRGBO(139, 139, 139, 1))),),
                             SizedBox(width:15.w),
                             Column(crossAxisAlignment:CrossAxisAlignment.start,
                                 mainAxisAlignment:MainAxisAlignment.center,
                                 children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                                     fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                                   Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                                       fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                                   )))])
                           ],),

                       ),
                     );
                   },),
               ]):popStatus()
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
                return storyText();
               },));
                },
                backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                child:SvgPicture.asset('assets/status_assets/status_text.svg')
            ),
            SpeedDialChild(
              onTap:() {pickimage();},
                backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                child:SvgPicture.asset('assets/status_assets/camera_icon.svg')
            ),
          ],
        )
      ),
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
                      Text('My status',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
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
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final temporaryImage = File(image.path);
      setState(() {
        this.image = temporaryImage;
      });
    } on PlatformException catch (e) {
      print('unable to pick image $e');
    }
  }
  Widget storyText(){
    return SafeArea(
      child: Scaffold(
        body:Stack(
          children:[ Container(height:double.infinity.h,width:double.infinity.w,decoration:BoxDecoration(
            color:Color.fromRGBO(255, 121, 46, 1)
          ),),
            Positioned(left:27.w,top:40.h,right:17.w,
              child: Row(children: [
                GestureDetector(onTap:() {
                  Navigator.pop(context);
                },
                    child: SvgPicture.asset('assets/status_assets/back_icon.svg',height:32.h,width:32.w)),
             Spacer(),
                Container(height:45.h,width:45.w,decoration:BoxDecoration(
                  shape:BoxShape.circle,color:Colors.red,border:Border.all(color:Colors.white)
                ))
              ]),
            ),
            Positioned(top:283.h,left:83.w,
              child: Container(
                height:60.h,width:200.w,
                child: TextField(controller:story,
                  cursorColor:Colors.black,
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
                          color: Colors.white)
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

          },
        ),
      ),
    );
  }
  Widget popStatus(){
    return Column(crossAxisAlignment:CrossAxisAlignment.start,
        children: [
      Row(mainAxisAlignment:MainAxisAlignment.center,
        children: [GestureDetector(onTap:(){Navigator.push(context,MaterialPageRoute(builder:
            (context) =>MoreStories()
                // statusViewed(controller)
        ));},
          child: Column(children: [
            Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                    fit:BoxFit.fill),
                border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
            SizedBox(height:4.h),
            Text("My story",style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
            ))),
            SizedBox(height:4.h),
            Text("Today at 6:00am",style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
            ))),
          ]),
        ),
        ],
      ), SizedBox(height:10.h),
      Text("Recent updates",style:GoogleFonts.inter(textStyle:TextStyle(
          fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
      ))),
      ListView.builder(shrinkWrap:true,
        physics:BouncingScrollPhysics(),
        itemCount:statusprofile.length,
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
            child: Container(height:98.h,width:double.infinity.w,
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
                      children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                          fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                        Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                        )))])
                ],),
            ),
          );
        },),
      Text("Viewed",style:GoogleFonts.inter(textStyle:TextStyle(
          fontWeight:FontWeight.w700,fontSize:14.sp,color:Color.fromRGBO(0,0,0,1)
      ))),
      ListView.builder(shrinkWrap:true,
        physics:BouncingScrollPhysics(),
        itemCount:statusprofile.length,
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
            child: Container(height:98.h,width:double.infinity.w,
              color:Colors.transparent,
              // padding:EdgeInsets.fromLTRB(0.w,8.h,0.w,18.h),
              child:Row(
                children: [
                  Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                      image:DecorationImage(image: NetworkImage
                        (statusprofile[index]),
                          fit:BoxFit.fill),
                      border:Border.all(width:2.w,color:Color.fromRGBO(139, 139, 139, 1))),),
                  SizedBox(width:15.w),
                  Column(crossAxisAlignment:CrossAxisAlignment.start,
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [Text(name[index],style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                          fontSize:14.sp,color:Color.fromRGBO(0,0,0,1))),
                        Text("Today at ${time[index]}",style:GoogleFonts.inter(textStyle:TextStyle(
                            fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(121, 117, 117, 1)
                        )))])
                ],),

            ),
          );
        },),
    ]);
  }
}


class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
            duration: Duration(minutes: 1)
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            duration:Duration(milliseconds:30),
            url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTxYUbW9vYBWtS-U1UdHRiZJp_g3aIdqODlcA&usqp=CAU",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://i.gifer.com/LeKR.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://i.pinimg.com/originals/ca/92/98/ca9298defb01dbe4c9bbee2400b1f4e0.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://i.pinimg.com/originals/81/5d/89/815d895b4721c14cbe7c86c63806d6c8.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: true,
        controller: storyController,
      ),
    );
  }
}