import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Followers_Page extends StatefulWidget {
  const Followers_Page({Key? key}) : super(key: key);
  
  @override
  State<Followers_Page> createState() => _Followers_PageState();
}

class _Followers_PageState extends State<Followers_Page> {
  int i=2;
  TextEditingController _followercontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,initialIndex:0,
      child: Scaffold(
        appBar: AppBar(
          leading: SvgPicture.asset('assets/profile_assets/back_button.svg',
              height: 24.h, width: 24.w),
          title: Row(
            children: [
              Text(
                'Suresh Offical',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              SizedBox(width: 11.w),
              Container(
                height: 14.h,
                width: 14.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 163, 255, 1)),
                child: Icon(Icons.check_rounded,
                    size: 12, color: Color.fromRGBO(255, 255, 255, 1)),
              ),
            ],
          ),
          actions: [
           Icon(Icons.more_vert,color:Color.fromRGBO(0,0,0,1),size:30)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left:12,right:12,top:14),
          child: Column(children: [
            Container(height:31.h,width:335.w,
              child: TextField(
                controller: _followercontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded,size: 35,color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:  Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(3)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:  Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(3)
                  ),
                  disabledBorder: InputBorder.none,
                  filled: true,
                  fillColor: Color.fromRGBO(217, 217, 217, 1),
                  hintText:'Peter Parker',hintStyle: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(118, 118, 118, 1)
                    )
                ),
                ),
              ),
            ),
          Container(height:54.h,
          child:Row(children: [
            Padding(
              padding: const EdgeInsets.only(left:40),
              child: Container(width:100.w,
                child: Text('86 Followers',style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1)
                    )
                ),),
              ),
            ),
            SizedBox(width:75.w),
            Container(width:100.w,
              child: Text('86 Following',style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 16.sp,fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1)
                  )
              ),),
            ),
          ],),),
          //   TabBar(  unselectedLabelStyle: GoogleFonts.inter(
          //       textStyle: TextStyle(
          //           fontSize: 15.sp,
          //           fontWeight: FontWeight.w400,
          //           color: Color.fromRGBO(0, 0, 0, 1))),
          //       unselectedLabelColor: Color.fromRGBO(151, 145, 145, 1),
          //       labelColor: Color.fromRGBO(0, 0, 0, 1),
          //       labelStyle: GoogleFonts.inter(
          //           textStyle: TextStyle(
          //               fontSize: 15.sp,
          //               fontWeight: FontWeight.w700,
          //               color: Color.fromRGBO(0, 0, 0, 1))),
          //       tabs: [
          //         Text('86 Followers',style:GoogleFonts.inter(textStyle: TextStyle(
          //             fontSize: 14.sp,fontWeight: FontWeight.w500,
          //             color: Color.fromRGBO(0,0,0,1)
          //         ))),
          //         Text('86 Followers',style:GoogleFonts.inter(textStyle: TextStyle(
          //             fontSize: 14.sp,fontWeight: FontWeight.w500,
          //             color: Color.fromRGBO(0,0,0,1)
          //         )))
          //   ]),
          //   TabBarView(children: [
          //     Container(height:400,color: Colors.black,),
          //     Container(height:400,color: Colors.black,)
          // ],),
            Container(child:Padding(
              padding: const EdgeInsets.only(left:9,right:16),
              child: Row(children: [
                Container(
                  height: 57.h,width: 57.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                          fit: BoxFit.fill)
                  ),
                ),
                 SizedBox(width:13),
                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Peter Parker',style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1)
                        )
                    ),),
                    Text('Peter',style: GoogleFonts.inter(
                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                        )
                    ),),
                    Text('In contact',style: GoogleFonts.inter(
                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                        )
                    ),),
                  ],
                ),
               Spacer(),
                ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: Color.fromRGBO(255, 255, 255, 1),fixedSize: Size(76.w, 32.h),
                ),
                    onPressed: (){}, child: Text('Take out',style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(255, 0, 0, 1),fontSize: 12,fontWeight: FontWeight.w700
                        )
                    ),)),

              ],),
            ),

              height:75.h,width:double.infinity,decoration: BoxDecoration(
              color:Color.fromRGBO(248, 206, 97, 1),borderRadius:BorderRadius.circular(7)
            ),
            ),
            Expanded(
              child: ListView.builder(itemCount:10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top:22),
                      child: Container(height:75.h,width:double.infinity,decoration: BoxDecoration(
                          color:Color.fromRGBO(248, 206, 97, 0.28),borderRadius:BorderRadius.circular(7)
                      ),
                        child:Padding(
                          padding: const EdgeInsets.only(left:9,right:16),
                          child: Row(children: [
                            Container(
                              height: 57.h,width: 57.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                                      fit: BoxFit.fill)
                              ),
                            ),
                            SizedBox(width:13),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Mary Jane',style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(0, 0, 0, 1)
                                    )
                                ),),
                                Text('MJ',style: GoogleFonts.inter(
                                    textStyle: TextStyle(fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                                    )
                                ),),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              primary: Color.fromRGBO(255, 255, 255, 1),fixedSize: Size(76.w, 32.h),
                            ),
                                onPressed: (){}, child: Text('Take out',style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: Color.fromRGBO(255, 0, 0, 1),fontSize: 12,fontWeight: FontWeight.w700
                                    )
                                ),)),

                          ],),
                        ),
                      ),
                    );
                  }
              ),
            )
          ]
      ),
        ),
      )
    );
  }
}

