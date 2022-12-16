import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/status/skeleton.dart';
import 'package:gatello/views/status/status.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:tuple/tuple.dart';
import '../../Others/Routers.dart';
import '../../Others/components/ExceptionScaffold.dart';
import '../../Others/exception_string.dart';
import '../../Others/lottie_strings.dart';
import '../../Style/Colors.dart';
import '../../Style/Text.dart';
import '../../components/flatButton.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '../tabbar/pops/circle_indicator.dart';
import '/core/models/StoriesModel.dart'as storiesModel;

import 'constants.dart';
class MyStatus extends StatefulWidget {
  final String uid;
  final String statusProfile;
  const MyStatus({Key? key, required this.uid,required this.statusProfile}) : super(key: key);
  @override
  State<MyStatus> createState() => _MyStatusState();
}

class _MyStatusState extends State<MyStatus> with TickerProviderStateMixin{
  late AnimationController controller;
  Future? _future;
  // DateTime getCurrentTimestamp = DateTime.now();
  ValueNotifier<Tuple4> statusShowValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  ValueNotifier<Tuple4> userViewValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(alert), "Null", null));
  Future viewStatus({required String uid}) async{

    print("api called.....");
    return await ApiHandler().apiHandler(
        valueNotifier: statusShowValueNotifier,
        jsonModel: storiesModel.storiesFromJson,
        //    jsonModel: myStoriesModel.welcomeFromJson,
        // url: 'http://192.168.29.93:4000/status/status',
        url:viewStatusUrl,
        requestMethod: 1,
        body: {"user_id": widget.uid}

    );

  }
  Future userViewStatus({required String uid,required String statusId}) async{

    print("userview api called");
    return await ApiHandler().apiHandler(
        valueNotifier: userViewValueNotifier,
        jsonModel: storiesModel.storiesFromJson,
        //  url: userviewStatusUrl+"?user_id=${uid}",
        url: 'http://192.168.29.93:4000/view/profile',
        requestMethod: 1,
        body: {"user_id": uid,"status_id":statusId}

    );

  }
  String formatISOTime(DateTime date) {
    //converts date into the following format:
// or 2019-06-04T12:08:56.235-0700
    var duration = date.timeZoneOffset;
    if (duration.isNegative)
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    else
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }
  // String agreementSigned = formatISOTime(getCurrentTimestamp);
  Future<dynamic> sendData()async{

    final data1= viewStatus(uid: widget.uid);
    //final data2=userViewStatus(uid:'JhRKwvnKe4Wxu1nYaucwZVurRlt1', statusId: '63946f760bb3099c428b6fd8' );
    return [data1];
  }
  @override
  void initState() {
    _future=sendData();
    // storiesApiCall(uid: "JhRKwvnKe4Wxu1nYaucwZVurRlt1");

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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:   _future,
        builder: (context,snapshot) {

          return AnimatedBuilder(
            animation: Listenable.merge([statusShowValueNotifier]),
            builder: (context, _) {

              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (statusShowValueNotifier.value.item1 == 1 ) {
                    print('worked1');

                    return Scaffold(
// body: ListView.builder(
//     itemCount:userViewValueNotifier.value.item2.result.length,
//     itemBuilder: (context,index){
//   return Text(userViewValueNotifier.value.item2.result[index].userId);
//
//
// }),



                      body: StoryPageView(
                        indicatorDuration: Duration(seconds: 20),
                        initialPage: 0,
                        // initialStoryIndex: 1,
                        onPageLimitReached: (){

                        },

                        gestureItemBuilder: (context, pageIndex, storyIndex){
                          return GestureDetector(

                          );
                        },
                        itemBuilder: (context, pageIndex, storyIndex){

                          return Stack(
                            children: [
                              Positioned.fill(
                                child: Container(color: Colors.black),
                              ),
                              // ListView.separated(
                              //   itemCount: 5,
                              //   itemBuilder: (context, index) => const NewsCardSkelton(),
                              //   separatorBuilder: (context, index) =>
                              //   const SizedBox(height: defaultPadding),
                              // ),
                              Positioned.fill(
                                child: Image.network(

                                  "http://3.110.105.86:2022/${statusShowValueNotifier.value.item2.result[storyIndex].statusPost}",
                                  // fit: BoxFit.fit,
                                ),
                              ),
                              Positioned(
                                top: 50.h,
                                left: 20.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    InkWell(
                                      onTap: () {

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Status(
                                          uid: '', profilePic: '',

                                        )));
                                      },
                                      child: SvgPicture.asset(
                                          'assets/status_assets/status_back_arrow.svg',
                                          height: 30.h,
                                          width: 30.w),
                                    ),
                                    SizedBox(width: 11.w,),
                                    Container(
                                      height: 40.h,
                                      width: 32.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:NetworkImage(widget.statusProfile),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('My status',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        Text(

                                          statusShowValueNotifier.value.item2.result[storyIndex].createdAt.toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),


                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              // Positioned(
                              //   bottom: 10.h,
                              //   right: 150.w,
                              //
                              //   child: FloatingActionButton(
                              //
                              //
                              //    // backgroundColor: Colors.transparent,
                              //
                              //     onPressed: (){
                              //
                              //       print('action worked');
                              //
                              //       showModalBottomSheet(
                              //
                              //         shape:
                              //
                              //         RoundedRectangleBorder(
                              //
                              //             borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                              //
                              //         context:
                              //
                              //         context,
                              //
                              //         builder:
                              //
                              //             (context) {
                              //
                              //           return Container(child: ViewedBy( ));
                              //
                              //         },
                              //
                              //       );
                              //
                              //     },
                              //
                              //     child: Column(children: [
                              //
                              //       SvgPicture.asset('assets/status_assets/seen_icon.svg'),
                              //
                              //       SizedBox(height: 5.h,),
                              //
                              //       Text(
                              //         '5',
                              //         // userViewValueNotifier.value.item2.result.length.toString(),
                              //
                              //         style: GoogleFonts.inter(
                              //
                              //             textStyle: TextStyle(
                              //
                              //                 fontWeight: FontWeight.w700,
                              //
                              //                 fontSize: 12.sp,
                              //
                              //                 color: Color.fromRGBO(255, 255, 255, 1))),
                              //
                              //       ),
                              //
                              //
                              //
                              //     ],),
                              //
                              //   ),
                              // ),
                            ],
                          );
                        },
                        storyLength: (int pageIndex) {
                          // int num=5;
                          // return num;
                          return statusShowValueNotifier.value.item2.result.length;
                        },
                        pageLength: 1,

                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: FloatingActionButton(


                        backgroundColor: Colors.transparent,

                        onPressed: (){

                          print('action worked');

                          showModalBottomSheet(

                            shape:

                            RoundedRectangleBorder(

                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),

                            context:

                            context,

                            builder:

                                (context) {

                              return Container(child: ViewedBy( ));

                            },

                          );

                        },

                        child: Column(children: [

                          SvgPicture.asset('assets/status_assets/seen_icon.svg'),

                          SizedBox(height: 5.h,),

                          Text(
                            '5',
                            // userViewValueNotifier.value.item2.result.length.toString(),

                            style: GoogleFonts.inter(

                                textStyle: TextStyle(

                                    fontWeight: FontWeight.w700,

                                    fontSize: 12.sp,

                                    color: Color.fromRGBO(255, 255, 255, 1))),

                          ),



                        ],),

                      ),


                    );
                  }else if(statusShowValueNotifier.value.item1 == 2){
                    return Scaffold(body:     Center(
                      child: flatButton(
                        onPressed: ()  {},
                        backgroundColor: Color(accent),
                        textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                        child: Text("No Status Available"),
                      ),
                    ),);
                  }
                  else if(statusShowValueNotifier.value.item1 == 3){
                 return Scaffold(body:     Center(
                   child: flatButton(
                     onPressed: ()  {

                     },
                     backgroundColor: Color(accent),
                     textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                     child: Text("No Status Available"),
                   ),
                 ),);
                  }
                  else {
                    return CircleIndicator();
                  }
                },
              );
            },
          );
        }
    );
  }
}
class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 120, width: 120),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(width: 80),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: const [
                  Expanded(
                    child: Skeleton(),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    child: Skeleton(),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}


class ViewedBy extends StatefulWidget {





  @override
  State<ViewedBy> createState() => _ViewedByState();
}

class _ViewedByState extends State<ViewedBy>with TickerProviderStateMixin {
  ValueNotifier<Tuple4> userViewValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(alert), "Null", null));
  late AnimationController controller;
  Future userViewStatus({required String uid,required String statusId}) async{

    print("userview api called");
    return await ApiHandler().apiHandler(
        valueNotifier: userViewValueNotifier,
        jsonModel: storiesModel.storiesFromJson,
        url: userviewStatusUrl+"?user_id=${uid}",
        requestMethod: 1,
        body: {"user_id": uid,"status_id":statusId}

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
    userViewStatus(uid:'JhRKwvnKe4Wxu1nYaucwZVurRlt1', statusId: '63958a290bb3099c428b714d' );
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    //  print('Arraylen${userViewValueNotifier.value.item2.result[0].length}');
    return  DraggableScrollableSheet(

      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.75,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          Container(
            color:Color.fromRGBO(248, 206, 97, 1) ,
            padding:EdgeInsets.only(left:12.w ,right: 34,top: 15.h,bottom: 15.h) ,
            height: 50.h,
            width: double.infinity,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Viewed by 32',
                  style:
                  GoogleFonts.inter(textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700, color: Color.fromRGBO(0,0,0, 1))),
                ),

                SvgPicture.asset('assets/status_assets/delete_icon.svg'),
              ],)
            ,
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: 5,
              //  itemCount: userViewValueNotifier.value.item2.result[0].viewDetails.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading:    Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        shape: BoxShape
                            .circle,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/noProfile.jpg")
                        )
                    ),
                  ),

                  title: Text('Peter Parker',style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp,fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1)
                      )
                  ),),
                  subtitle:Text('',style: GoogleFonts.inter(
                      textStyle: TextStyle(fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(121, 117, 117, 1),fontSize: 11.sp
                      )
                  ),) ,
                );
              },
            ),
          ),
        ],
      ),
    );

  }
}