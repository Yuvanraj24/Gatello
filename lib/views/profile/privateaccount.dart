import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Private_Account extends StatefulWidget {
  const Private_Account({Key? key}) : super(key: key);

  @override
  State<Private_Account> createState() => _Private_AccountState();
}

class _Private_AccountState extends State<Private_Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/profile_assets/back_button.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
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
            SizedBox(width: 7.w),
            Container(
              height: 14.h,
              width: 14.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(0, 163, 255, 1)),
              child: Icon(Icons.check_rounded,
                  size: 12, color: Color.fromRGBO(255, 255, 255, 1)),
            ),Spacer(),
            SvgPicture.asset('assets/profile_assets/commentnotifi.svg',height:25.h,
                width:25.w)
          ],
        ),
        actions: [
          PopupMenuButton(iconSize:30,icon: Icon(Icons.more_vert,color:Colors.black),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Center(
                  child: Text(
                    'Settings',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Color.fromRGBO(
                                0, 0, 0, 1))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(children: [
        Container(height:176.h,width:double.infinity,
          child:Stack(
            children: [ Container(
              height: 119.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                      fit: BoxFit.fill)),
            ),

              Positioned(
                top: 92,
                left: 21,
                child: Container(
                  height: 94.h,
                  width: 93.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://ukcompaniesco.com/wp-content/uploads/2020/05/company-formation-in-the-united-kingdom.jpg'),
                          fit: BoxFit.fill),
                      border: Border.all(
                          color: Color.fromRGBO(255, 255, 255, 1), width: 2),
                      shape: BoxShape.circle),
                ),
              ),
              Positioned(
                left: 161,
                top: 143,
                child: Row(
                  children: [
                    Text(
                      '789',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                    SizedBox(width: 39.w),
                    Text(
                      '789',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                    SizedBox(width: 39.w),
                    Text(
                      '1,028',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 160,
                top: 176,
                child: Row(
                  children: [
                    Text(
                      'Pops',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                    SizedBox(width: 32.w),
                    Text(
                      'Following',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    ),
                    SizedBox(width: 25.w),
                    Text(
                      'Followers',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                    )
                  ],
                ),
              ),],
          ),),

        Padding(
          padding: const EdgeInsets.only(left:27,top:8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Suresh',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right:35),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(180.w,29.h),
                        ),
                        onPressed: (){}, child: Text('Follow',style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),fontSize:15,fontWeight: FontWeight.w700
                        )
                    ),)),
                  ),
                ],
              ),
      ],),
        ),
        Divider(indent:12,endIndent:12,thickness:1,color:Color.fromRGBO(231, 231, 231, 1)),
        Padding(
          padding: const EdgeInsets.only(left:16),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(height:50.h,width:50.w,
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:12),
                      child: Container(
                        child: SvgPicture.asset('assets/profile_assets/privateaccount.svg',height:30,
                        width:30),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(shape: BoxShape.circle,
                border: Border.all(width:1.w,color: Colors.black)
              ),),
              SizedBox(width:15.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('This account is private',style:GoogleFonts.inter(textStyle: TextStyle(
                  fontWeight:FontWeight.w700,fontSize:13.sp,color:Color.fromRGBO(0,0,0,1)
                )),),
                SizedBox(height:5.h),
                Text('Follow this account to see their photos and',
                  style:GoogleFonts.inter(textStyle: TextStyle(
                    fontWeight:FontWeight.w400,fontSize:13.sp,color:Color.fromRGBO(98, 98, 98, 1)
                )),),
                  SizedBox(height:5.h),
                Text('Videos',
                  style:GoogleFonts.inter(textStyle: TextStyle(
                      fontWeight:FontWeight.w400,fontSize:13.sp,color:Color.fromRGBO(98, 98, 98, 1)
                  )),),
              ],)
            ],
          ),
        )
        ]
    )
    );
  }
}
