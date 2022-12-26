import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/profile/profile_details.dart';
import 'package:gatello/views/profile/workdetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '/core/models/default.dart' as defaultModel;

class Work_Experience extends StatefulWidget {
  final String uid;
  Work_Experience({Key? key, required this.uid}) : super(key: key);

  @override
  State<Work_Experience> createState() => Work_ExperienceState();
}

class Work_ExperienceState extends State<Work_Experience> {
  List<TextEditingController> workExController = [];
  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier =
  ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  int _count=0;
  List<Widget> widgetList=<Widget>[];
  bool isSwitched = false;
  final _fromController=TextEditingController();
  final _toController=TextEditingController();
  List<TextEditingController> _positionController=[];
  //final _positionController=TextEditingController();
  final _companyController=TextEditingController();
  final _locationController=TextEditingController();
  Future profileDetailUpdateApiCall() async {

    print('editApi called');
    var jList=[];
    for(int j=0; j<_positionController.length; j++){
      jList.add(_positionController[j].text);
    }
    // ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultModel.defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile",
        requestMethod: 1,
        body: {
          "user_id": widget.uid,
          "work_experience":[
            {
               "companyName":'ff',
               "startDate":'gg',
               "endDate":'kk',
              "position":jList,
               "location":'ll'

            }
          ]

        });
  }
  showDialogFun(){
    Future.delayed(Duration(seconds: 0),
            () =>     showDialog(
          context: context,
          builder: (BuildContext context) {
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
                    Spacer(),
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
                      // Row(
                      //   children: [
                      //     Text('From',style: GoogleFonts.inter(textStyle: TextStyle(
                      //         fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                      //     )),),SizedBox(width:9.w),
                      //     Container(height:26.h,width:101.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      //         child: Container(
                      //           height:25.h,width:100.w,
                      //           child: TextField(
                      //             autofocus: true,
                      //             controller:_fromController,
                      //             onChanged: (val){
                      //
                      //             },
                      //             cursorColor:Colors.black,
                      //             decoration: InputDecoration(
                      //               enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //               focusedBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                       width: 1.w,
                      //                       color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //             ),),
                      //         )
                      //     ),
                      //     Spacer(),
                      //     Text('To',style: GoogleFonts.inter(textStyle: TextStyle(
                      //         fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                      //     )),),SizedBox(width:9.w),
                      //     Container(height:26.h,width:101.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      //       child:  Container(
                      //         height:25.h,width:100.w,
                      //         child: TextField(
                      //           autofocus: true,
                      //           controller:_toController,
                      //           cursorColor:Colors.black,
                      //           decoration: InputDecoration(
                      //
                      //             enabledBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(color: Colors.transparent),
                      //                 borderRadius: BorderRadius.circular(10)),
                      //             focusedBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     width: 1.w,
                      //                     color: Colors.transparent),
                      //                 borderRadius: BorderRadius.circular(10)),
                      //           ),),
                      //       ),)
                      //   ],
                      // ),
                      // SizedBox(height:17.h),
                      Row(
                        children: [
                          Text('Position',style: GoogleFonts.inter(textStyle: TextStyle(
                              fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                          )),),SizedBox(width:11.w),
                          Container(height:26.h,width:240.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                              child: Container(
                                height:25.h,width:100.w,
                                child: TextField(
                                  autofocus: true,
                                  controller:_positionController[_positionController.length-1],
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
                                  ),),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height:17.h),
                      // Row(
                      //   children: [
                      //     Text('Company',style: GoogleFonts.inter(textStyle: TextStyle(
                      //         fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                      //     )),),SizedBox(width:11.w),
                      //     Container(height:45.h,width:228.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      //         child: Container(
                      //           height:25.h,width:100.w,
                      //           child: TextField(
                      //             autofocus: true,
                      //             controller:_companyController,
                      //             cursorColor:Colors.black,
                      //             decoration: InputDecoration(
                      //               enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //               focusedBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                       width: 1.w,
                      //                       color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //             ),),
                      //         )
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height:17.h),
                      // Row(
                      //   children: [
                      //     Text('Location',style: GoogleFonts.inter(textStyle: TextStyle(
                      //         fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                      //     )),),SizedBox(width:11.w),
                      //     Container(height:26.h,width:234.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      //         child: Container(
                      //           height:25.h,width:100.w,
                      //           child: TextField(
                      //             autofocus: true,
                      //             controller:_locationController,
                      //             cursorColor:Colors.black,
                      //             decoration: InputDecoration(
                      //               enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //               focusedBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                       width: 1.w,
                      //                       color: Colors.transparent),
                      //                   borderRadius: BorderRadius.circular(10)),
                      //             ),),
                      //         )
                      //     ),
                      //   ],
                      // ),
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
                        // setState(() {
                        //   _count++;
                        //   listAdd();
                        // });



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
          },
        )

    );
  }
listAdd(){
    print('fun called');
    for(int i=0;i<=_count;i++){
      _positionController.add(TextEditingController());
      widgetList.add(

          showDialogFun()

      );
      break;
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/profile_assets/back_button.svg',
                  height: 30.h, width: 30.w),
            ],
          ),
        ),
        title: Text(
          'Work Experience',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1))),
        ),
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              iconSize: 30,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Center(
                    child: Text(
                      'Settings',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                  ),
                )
              ])
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 31, top: 18, right: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Work Experience',
                      style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 27.w),
                    IconButton(
                      onPressed: () {
_count++;
listAdd();


                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.only(top: 7, left: 9, bottom: 6),
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
                              child: Text(item,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                      ))),
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
                          padding: EdgeInsets.only(right: 10),
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
                        itemHeight: 30,
                        // itemPadding: EdgeInsets.only(left: 14, right: 14),
                        dropdownMaxHeight: 130,
                        dropdownWidth: 90,
                        buttonElevation: 0,
                        dropdownElevation: 0,
                        dropdownDecoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        scrollbarAlwaysShow: false,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 33.h),
                Column(

                    children:  widgetList
                ),
                // SizedBox(height: 30.h),
                // Row(
                //   children: [
                //     Container(
                //       height: 12.h,
                //       width: 12.w,
                //       decoration: BoxDecoration(
                //           color: Color.fromRGBO(165, 165, 165, 0.9),
                //           shape: BoxShape.circle),
                //     ),
                //     SizedBox(width: 11.w),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Marketing Executive',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color.fromRGBO(0, 0, 0, 1))),
                //         ),
                //         SizedBox(height: 7.h),
                //         Text(
                //           'May 2021 - june 2021',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w400,
                //                   color: Color.fromRGBO(185, 185, 185, 1))),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: 33.h),
                // Row(
                //   children: [
                //     Container(
                //       height: 12.h,
                //       width: 12.w,
                //       decoration: BoxDecoration(
                //           color: Color.fromRGBO(165, 165, 165, 0.9),
                //           shape: BoxShape.circle),
                //     ),
                //     SizedBox(width: 11.w),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'UI UX designer - Tech 4 Lyf',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color.fromRGBO(0, 0, 0, 1))),
                //         ),
                //         SizedBox(height: 7.h),
                //         Text(
                //           'May 2022 - Present',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w400,
                //                   color: Color.fromRGBO(185, 185, 185, 1))),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: 30.h),
                // Row(
                //   children: [
                //     Container(
                //       height: 12.h,
                //       width: 12.w,
                //       decoration: BoxDecoration(
                //           color: Color.fromRGBO(165, 165, 165, 0.9),
                //           shape: BoxShape.circle),
                //     ),
                //     SizedBox(width: 11.w),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Marketing Executive',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color.fromRGBO(0, 0, 0, 1))),
                //         ),
                //         SizedBox(height: 7.h),
                //         Text(
                //           'May 2021 - june 2021',
                //           style: GoogleFonts.inter(
                //               textStyle: TextStyle(
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w400,
                //                   color: Color.fromRGBO(185, 185, 185, 1))),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                primary: Color.fromRGBO(248, 206, 97, 1),
                fixedSize: Size(336.w, 47.h),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
              )),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(bottom: 13),
            child: Divider(
              thickness: 2.w,
              indent: 140,
              endIndent: 137,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          )
        ],
      ),
    );
  }
}

