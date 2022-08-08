import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/tabbar/pops/comments.dart';
import 'package:gatello/views/tabbar/pops/newpost.dart';
import 'package:gatello/views/tabbar/pops/poplikes.dart';
import 'package:gatello/views/tabbar/pops/report.dart';
import 'package:gatello/views/tabbar/pops/share.dart';
import 'package:google_fonts/google_fonts.dart';

class Pops_Page extends StatefulWidget {
  const Pops_Page({Key? key}) : super(key: key);

  @override
  State<Pops_Page> createState() => _Pops_PageState();
}

class _Pops_PageState extends State<Pops_Page> {
  TextEditingController _controllerpop =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:
        Container(
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
                      child: TextField(
                        controller: _controllerpop,
                        decoration: InputDecoration(
                          hintMaxLines: 2,
                          hintText: 'Pop your photos, videos &\nmessages here...',hintStyle: TextStyle(
                            fontSize: 18,fontWeight: FontWeight.w400),
                          enabledBorder:OutlineInputBorder(borderSide: BorderSide(color:Colors.transparent,width: 1),),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:  Colors.transparent,width: 1),),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => New_Post()));
                      },
                        child: SvgPicture.asset(
                          'assets/pops_asset/pops_gallery.svg',
                          width: 38.w,
                          height: 40.h,
                        ),
                      ),
                    )
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Jonny',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        Text(
                                          '23 minutes ago',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
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
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w400,
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
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
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
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
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
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w400,
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
                              GestureDetector(
                                onDoubleTap: () {
                                  liked_Button();
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 16),
                                        child: Text(
                                          'I love nature... more',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
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
                                      crossAxisAlignment:CrossAxisAlignment.start,
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
                                          child: Text( '3.6k', style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color:
                                                Color.fromRGBO(51, 51, 51, 1),
                                              )),),
                                        ),
                                        SizedBox(
                                          width: 13.w,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 6),
                                          child: GestureDetector(onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Command_page()));
                                          },
                                            child: SvgPicture.asset(
                                                'assets/pops_asset/pops_commentbutton.svg',height: 15.h,width: 15.w),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 7),
                                          child: Text(
                                            '3.6k',
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
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
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(
                                                          20),
                                                      topRight:
                                                      Radius.circular(
                                                          20))),
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    child: Share_Page());
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
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 28.w,
                                        ),
                                        Text(
                                          'Liked by',
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1))),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => pop_Likes()));
                                          },
                                          child: Container(
                                            width: 45.w,
                                            child: Stack(
                                              children: [
                                                likedmembers(),
                                                Positioned(
                                                    left: 10,
                                                    child: likedmembers()),
                                                Positioned(
                                                    left: 20,
                                                    child: likedmembers())
                                              ],
                                            ),
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
                                          width: 20.w,
                                        ),
                                        SizedBox(height: 25.h,
                                          child: TextButton(child:Text( 'view all comments...',
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                    Color.fromRGBO(98, 98, 98, 1),
                                                  ))
                                          ), onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Command_page()));
                                          },

                                          ),
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 300, bottom: 20),
              //   child: FloatingActionButton(
              //       backgroundColor: Color.fromRGBO(248, 206, 97, 1),
              //       focusColor: Color.fromRGBO(248, 206, 97, 1),
              //       child: Icon(
              //         Icons.keyboard_arrow_up,
              //         color: Color.fromRGBO(12, 16, 29, 1),
              //         size: 40,
              //       ),
              //       onPressed: () {}),
              // )

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 12,
            backgroundColor: Color.fromRGBO(248, 206, 97, 1),
            focusColor: Color.fromRGBO(248, 206, 97, 1),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Color.fromRGBO(12, 16, 29, 1),
              size: 40,
            ),
            onPressed: () {

            }),
      ),
    );
  }

  Widget liked_Button() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
          height: 82.h,
          width: 82.w,
          child: Icon(
            Icons.thumb_up_alt,
            size: 40,
          ),
          // SvgPicture.asset('assets/pops_asset/liked.svg',height: 20.h,width: 20.w,),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(255, 255, 255, 1))),
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
