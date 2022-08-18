// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gatello/views/profile/see_more.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tuple/tuple.dart';
//
// import '../../Others/exception_string.dart';
// import '../../core/models/exception/pops_exception.dart';
// import 'editprofile.dart';
//
// class Unfollow_page extends StatefulWidget {
//   const Unfollow_page({Key? key}) : super(key: key);
//
//   @override
//   State<Unfollow_page> createState() => _Unfollow_pageState();
// }
//
// class _Unfollow_pageState extends State<Unfollow_page> {
//   ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
//       exceptionFromJson(loading), "Loading", null));
//       int i=0;
//   @override
//   Widget build(BuildContext context) {
//     return  DefaultTabController(length:3,initialIndex:1,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(onTap:(){Navigator.pop(context);},
//             child: Column(mainAxisAlignment:MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset('assets/profile_assets/back_button.svg',
//                     height: 30.h, width:30.w),
//               ],
//             ),
//           ),
//           title: Row(
//             children: [
//               Text(
//                 'Suresh Offical',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Color.fromRGBO(0, 0, 0, 1))),
//               ),
//               SizedBox(width: 7.w),
//               Container(
//                 height: 14.h,
//                 width: 14.w,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color.fromRGBO(0, 163, 255, 1)),
//                 child: Icon(Icons.check_rounded,
//                     size: 12, color: Color.fromRGBO(255, 255, 255, 1)),
//               ),Spacer(),
//               SvgPicture.asset('assets/profile_assets/commentnotifi.svg',height:25.h,
//               width:25.w)
//             ],
//           ),
//           actions: [
//             PopupMenuButton(icon:Icon(Icons.more_vert,color:Colors.black,),iconSize:30,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Remove follower',
//                         style: GoogleFonts.inter(
//                             textStyle: TextStyle(fontWeight: FontWeight.w400,
//                                 color: Color.fromRGBO(
//                                     0, 0, 0, 1))),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Share this profile',
//                         style: GoogleFonts.inter(
//                             textStyle: TextStyle(fontWeight: FontWeight.w400,
//                                 color: Color.fromRGBO(
//                                     0, 0, 0, 1))),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Report',
//                         style: GoogleFonts.inter(fontWeight: FontWeight.w400,
//                             textStyle: TextStyle(
//                                 color: Color.fromRGBO(
//                                     0, 0, 0, 1))),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Block',
//                         style: GoogleFonts.inter(
//                             textStyle: TextStyle(fontWeight: FontWeight.w400,
//                                 color: Color.fromRGBO(
//                                     255, 40, 40, 1))),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(height:176.h,width:double.infinity,
//                 child:Stack(
//                   children: [ Container(
//                     height: 119.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: NetworkImage(
//                                 'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
//                             fit: BoxFit.fill)),
//                   ),
//                     Positioned(
//                       top: 92,
//                       left: 21,
//                       child: Container(
//                         height: 94.h,
//                         width: 93.w,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                     'https://ukcompaniesco.com/wp-content/uploads/2020/05/company-formation-in-the-united-kingdom.jpg'),
//                                 fit: BoxFit.fill),
//                             border: Border.all(
//                                 color: Color.fromRGBO(255, 255, 255, 1), width: 2),
//                             shape: BoxShape.circle),
//                       ),
//                     ),
//                     Positioned(top:146,left:170,
//                       child: Container(child:Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 '789',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                               SizedBox(width: 39.w),
//                               Text(
//                                 '789',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                               SizedBox(width: 42.w),
//                               Text(
//                                 '1,028',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               )
//                             ],
//                           ),
//                           SizedBox(height:5.h),
//                           Row(
//                             children: [
//                               Text(
//                                 'Pops',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                               SizedBox(width: 32.w),
//                               Text(
//                                 'Following',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                               SizedBox(width: 25.w),
//                               Text(
//                                 'Followers',
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               )
//                             ],
//                           ),
//                         ],),),
//                     ),
//                   ],
//                 ),),
//
//               Padding(
//                 padding: const EdgeInsets.only(left:27,top:8),
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Suresh',
//                           style: GoogleFonts.inter(
//                               textStyle: TextStyle(
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color.fromRGBO(0, 0, 0, 1))),
//                         ),
//                         Spacer(),
//                         Padding(
//                           padding:EdgeInsets.only(right:35),
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(elevation: 0,
//                                 side: BorderSide(
//                                   width:1,color: Color.fromRGBO(0, 163, 255, 1)
//                               ),
//                                 shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                 primary:Colors.white,fixedSize: Size(180.w,29.h),
//                               ),
//                               onPressed: (){}, child: Text('Unfollow',style: GoogleFonts.inter(
//                               textStyle: TextStyle(
//                                   color: Color.fromRGBO(0, 163, 255, 1),fontSize:15,fontWeight: FontWeight.w700
//                               )
//                           ),)),
//                         ),
//
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           height: 25.h,
//                           width: 25.w,
//                           decoration: BoxDecoration(
//                               color: Color.fromRGBO(165, 165, 165, 0.9),
//                               shape: BoxShape.circle),
//                           child: Icon(Icons.location_on_sharp,
//                               color: Colors.white),
//                         ),
//                         SizedBox(width: 11.w),
//                         RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
//                             children:[
//                               TextSpan(text: 'Lives in ',style: GoogleFonts.inter(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
//                               TextDecoration.none
//                               ))),
//                               TextSpan(text:'Chennai',style: GoogleFonts.inter(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,0.5),decoration:
//                               TextDecoration.none
//                               )))
//                             ])),
//                       ],
//                     ),
//                     SizedBox(height: 9.h),
//                     Row(
//                       children: [
//                         Container(
//                             height: 25.h,
//                             width: 25.w,
//                             decoration: BoxDecoration(
//                                 color: Color.fromRGBO(165, 165, 165, 0.9),
//                                 shape: BoxShape.circle),
//                             child:
//                             Column(crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset('assets/profile_assets/proffesion.svg'
//                                     ,height:12.h,width:12.w),
//                               ],
//                             )
//                         ),
//                         SizedBox(width: 11.w),
//                         Text(
//                           'Designer',
//                           style: GoogleFonts.inter(
//                               textStyle: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w400,
//                                   color: Color.fromRGBO(0, 0, 0, 1))),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 9.h),
//                     Row(
//                       children: [
//                         Container(
//                             height: 25.h,
//                             width: 25.w,
//                             decoration: BoxDecoration(
//                                 color: Color.fromRGBO(165, 165, 165, 0.9),
//                                 shape: BoxShape.circle),
//                             child:
//                             Column(crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset('assets/profile_assets/proffesion.svg'
//                                     ,height:12.h,width:12.w),
//                               ],
//                             )
//                         ),
//                         SizedBox(width: 11.w),
//                         RichText(text: TextSpan(style:DefaultTextStyle.of(context).style,
//                             children:[
//                               TextSpan(text: 'Working at ',style: GoogleFonts.inter(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w700,fontSize:14,color: Color.fromRGBO(0, 0, 0,1),decoration:
//                               TextDecoration.none
//                               ))),
//                               TextSpan(text:'Deejos arvhitects Pvt Ltd',style: GoogleFonts.inter(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w400,fontSize:14,color: Color.fromRGBO(0, 0, 0,0.5),decoration:
//                               TextDecoration.none
//                               )))
//                             ])),
//                       ],
//                     ),
//                     SizedBox(height:14.h),
//                     Row(
//                       children: [
//                         Text(
//                           'Biog',
//                           style: GoogleFonts.inter(
//                               textStyle: TextStyle(
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color.fromRGBO(0, 0, 0, 1))),
//                         ),
//                         SizedBox(width:10.w),
//                       ],
//                     ),
//                     i==1?Text(''):
//                     Column(
//                       children: [
//                         SizedBox(height:7.h),
//                         Text('Your professional bio is an important piece of ...',style: GoogleFonts.inter(
//                             textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp,
//                                 color: Color.fromRGBO(0,0,0,0.5)
//                             )
//                         ),),
//                         Divider(thickness:1.w,color: Color.fromRGBO(228, 228, 228, 1),
//                             indent:22,endIndent:18),
//                         GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               i=1;
//                             });
//                           },
//                           child: Padding(
//                             padding:EdgeInsets.only(left:285,bottom:10,top:5),
//                             child: Text('See More...',style:GoogleFonts.inter(
//                                 textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 12.sp,
//                                     color: Color.fromRGBO(0, 163, 255, 1)
//                                 )
//                             ),),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],),
//               ),
//               i==1?SeeMoreText(onPressed: (){
//                 setState(() {
//                   i=0;
//                 });
//               },
//                   email: profileDetailsValueNotifier.value.item2.result.profileDetails.email,
//                   phone: profileDetailsValueNotifier.value.item2.result.profileDetails.phone
//               ):
//               Column(
//                 children: [
//                   TabBar(
//                       indicator: BoxDecoration(
//                           color: Colors.transparent,border:Border(bottom:BorderSide(
//                           color: Colors.transparent
//                       ))
//                       ),
//                       unselectedLabelStyle: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w400,
//                               color: Color.fromRGBO(0, 0, 0, 1))),
//                       unselectedLabelColor: Color.fromRGBO(151, 145, 145, 1),
//                       labelColor: Color.fromRGBO(0, 0, 0, 1),
//                       labelStyle: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Color.fromRGBO(0, 0, 0, 1))),
//                       tabs: [
//                         Text('All Pops'),
//                         Text('Photo Pops'),
//                         Text('Video Pops'),
//                       ]),
//                   Container(child:  TabBarView(children: <Widget>[
//                     Container(
//                       child: Center(
//                         child: Container(
//                           child: Stack(children: [
//                             Container(
//                               color: Colors.white,
//                             ),
//                             Positioned(
//                               left: 12,
//                               top: 15,
//                               child: Stack(children: [
//                                 Container(
//                                   height: 104.h,
//                                   width: 106.w,
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               'https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
//                                           fit: BoxFit.fill)),
//                                 ),
//                                 Positioned(
//                                     left: 35,
//                                     right: 35,
//                                     top: 35,
//                                     bottom: 35,
//                                     child: Container(height:18.h,width:18.w,
//                                       child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                             height:18.h,width:18.w,),
//                                         ],
//                                       ),
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color:Color.fromRGBO(255, 255, 255, 1)),)
//                                 )
//                               ]),
//                             ),
//                             Positioned(
//                               left: 147,
//                               top: 15,
//                               child: Container(
//                                 height: 87.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               right: 12,
//                               top: 15,
//                               child: Container(
//                                 height: 104.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               left: 12,
//                               top: 140,
//                               child: Container(
//                                 height: 104.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               left: 146,
//                               top: 122,
//                               child: Container(
//                                 height: 101.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               right: 12,
//                               top: 142,
//                               child: Stack(children: [
//                                 Container(
//                                   height: 102.h,
//                                   width: 106.w,
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                           fit: BoxFit.fill)),
//                                 ),
//                                 Positioned(
//                                     left: 35,
//                                     right: 35,
//                                     top: 35,
//                                     bottom: 35,
//                                     child: Container(height:18.h,width:18.w,
//                                       child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                             height:18.h,width:18.w,),
//                                         ],
//                                       ),
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color:Color.fromRGBO(255, 255, 255, 1)),)
//                                 )
//                               ]),
//                             ),
//                             Positioned(
//                               left: 12,
//                               top: 265,
//                               child: Container(
//                                 height: 102.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               left: 146,
//                               top: 245,
//                               child: Container(
//                                 height: 120.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                             Positioned(
//                               right: 12,
//                               top: 265,
//                               child: Container(
//                                 height: 102.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: Container(
//                         child: Stack(children: [
//                           Container(
//                             color: Colors.white,
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 15,
//                             child: Container(
//                               height: 104.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             left: 147,
//                             top: 15,
//                             child: Container(
//                               height: 87.h,
//                               width: 112.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 15,
//                             child: Container(
//                               height: 104.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 140,
//                             child: Container(
//                               height: 104.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             left: 146,
//                             top: 122,
//                             child: Container(
//                               height: 101.h,
//                               width: 112.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(

//                             right: 12,
//                             top: 142,
//                             child: Container(
//                               height: 102.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 265,
//                             child: Container(
//                               height: 102.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             left: 146,
//                             top: 245,
//                             child: Container(
//                               height: 120.h,
//                               width: 112.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 265,
//                             child: Container(
//                               height: 102.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                       fit: BoxFit.fill)),
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       child: Container(
//                         child: Stack(children: [
//                           Container(
//                             color: Colors.white,
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 15,
//                             child: Stack(children: [
//                               Container(
//                                 height: 104.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             left: 147,
//                             top: 15,
//                             child: Stack(children: [
//                               Container(
//                                 height: 87.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 25,
//                                   right: 25,
//                                   top: 25,
//                                   bottom: 25,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 15,
//                             child: Stack(children: [
//                               Container(
//                                 height: 104.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 140,
//                             child: Stack(children: [
//                               Container(
//                                 height: 104.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             left: 146,
//                             top: 122,
//                             child: Stack(children: [
//                               Container(
//                                 height: 101.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 32,
//                                   right: 32,
//                                   top: 32,
//                                   bottom: 32,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 142,
//                             child: Stack(children: [
//                               Container(
//                                 height: 102.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             left: 12,
//                             top: 265,
//                             child: Stack(children: [
//                               Container(
//                                 height: 102.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             left: 146,
//                             top: 245,
//                             child: Stack(children: [
//                               Container(
//                                 height: 120.h,
//                                 width: 112.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 40,
//                                   right: 40,
//                                   top: 40,
//                                   bottom: 40,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                           Positioned(
//                             right: 12,
//                             top: 265,
//                             child: Stack(children: [
//                               Container(
//                                 height: 102.h,
//                                 width: 106.w,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Positioned(
//                                   left: 35,
//                                   right: 35,
//                                   top: 35,
//                                   bottom: 35,
//                                   child: Container(height:18.h,width:18.w,
//                                     child:Column(mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset('assets/profile_assets/videoplay.svg',
//                                           height:18.h,width:18.w,),
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color:Color.fromRGBO(255, 255, 255, 1)),)
//                               )
//                             ]),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ]),
//                     height: 400, //height of TabBarView
//                     decoration: BoxDecoration(
//                         border: Border(
//                             top: BorderSide(
//                                 color: Colors.grey, width: 0.5))),)
//                 ],
//               )
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
