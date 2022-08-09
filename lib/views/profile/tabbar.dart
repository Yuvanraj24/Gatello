import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Tabb extends StatefulWidget {
  const Tabb({Key? key}) : super(key: key);

  @override
  State<Tabb> createState() => _TabbState();
}

class _TabbState extends State<Tabb> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(length: 3,initialIndex: 0,
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                TabBar(
                  unselectedLabelStyle:GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                  unselectedLabelColor: Color.fromRGBO(151, 145, 145, 1),
                  labelColor:Color.fromRGBO(0,0,0, 1),
                    labelStyle:GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                    tabs: [ Text('All Pops'),
                  Text('Photo Pops'),
                  Text('Video Pops'),
              ]),
                Container(
                    height: 400, //height of TabBarView
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                    ),
                    child: TabBarView(children: <Widget>[
                      Container(
                        child: Center(
                          child: Container(
                            child: Stack(
                                children: [Container(color: Colors.white,
                                ),
                                  Positioned(left:12,top: 15,
                                    child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(left:147,top: 15,
                                    child: Container(height:87.h,width: 112.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(right:12,top: 15,
                                    child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(left:12,top:140,
                                    child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(left:146,top:122,
                                    child: Container(height:101.h,width: 112.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(right:12,top:142,
                                    child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(left:12,top:265,
                                    child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(left:146,top:245,
                                    child: Container(height:120.h,width: 112.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                  Positioned(right:12,top:265,
                                    child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                            fit: BoxFit.fill)
                                    ),),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          child: Stack(
                              children: [Container(color: Colors.white,
                              ),
                                Positioned(left:12,top: 15,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:147,top: 15,
                                  child: Container(height:87.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top: 15,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:12,top:140,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:146,top:122,
                                  child: Container(height:101.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top:142,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:12,top:265,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:146,top:245,
                                  child: Container(height:120.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top:265,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                              ]
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          child: Stack(
                              children: [Container(color: Colors.white,
                              ),
                                Positioned(left:12,top: 15,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:147,top: 15,
                                  child: Container(height:87.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top: 15,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:12,top:140,
                                  child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:146,top:122,
                                  child: Container(height:101.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top:142,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:12,top:265,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(left:146,top:245,
                                  child: Container(height:120.h,width: 112.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                                Positioned(right:12,top:265,
                                  child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                          fit: BoxFit.fill)
                                  ),),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ])
                )
              ])
          ),

            ),
    );

  }
}
