import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/settings/privacy.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child:  Column(
              mainAxisAlignment: MainAxisAlignment
                  .center,
              crossAxisAlignment: CrossAxisAlignment
                  .center,
              children: [
                SvgPicture.asset(
                  'assets/pops_asset/back_button.svg',
                  height: 30.h,
                  width: 30.w,),
              ],
            ),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(12, 16, 29, 1)
              )),
        ),
      ),
          body:SingleChildScrollView(
            child: Container(
child: Column(children: [
  Row(children: [
    Container(
      padding: EdgeInsets.only(left: 12.w,right: 12.w,top: 20.h),
            width: 75.w,
            height: 75.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,),

     child: SvgPicture.asset(
         "assets/invite_friends/profilepicture.svg",


        height:50.h,
        width: 50.w,
      ),
    ),
    Padding(
      padding: EdgeInsets.only(left: 5.w,top: 13.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
            'Kishore',
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 0, 0, 1)
                )),
        ),
        Text(
            'Kishore 0605',
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(156, 156, 156, 1)
                )),
        ),


      ],),
    ),
    Padding(
      padding:  EdgeInsets.only(left: 19.w,right: 37.w,top: 12.h),
      child: SvgPicture.asset(
        "assets/settngs/QR.svg", fit: BoxFit.cover,
        height:22.h,
        width: 22.w,
      ),
    ),
    Padding(
      padding:  EdgeInsets.only(top: 12.h),
      child: ElevatedButton(onPressed: (){},  style: ElevatedButton.styleFrom(
          elevation: 0,
          onPrimary: Colors.black,
          minimumSize: Size(92.w, 28.h),
          primary: Color.fromRGBO(248, 206, 97, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
          )),

      child:    Text(
        'Edit profile',
        style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1)
              )),
      ),),
    )
  ],),
  Divider(indent: 5,endIndent: 5,height: 1.h,),
  SizedBox(height: 20.h,),
  GestureDetector(
    onTap: (){

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>ChatSettings()

          ),
        );

    },
    child: ListTile(leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/settngs/account_icon.svg"
          //, fit: BoxFit.cover,
          // height:35.h,
          // width: 35.w,
        ),
      ],
    ),
    title:Text(
      'Account',
      style: GoogleFonts.inter(
          textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
          )),
    ),
    subtitle:Text(
      'Privacy, change number, delete account',
      style: GoogleFonts.inter(
          textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(135, 135, 135, 1)
          )),
    ),
    ),
  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(
            "assets/tabbar_icons/pings_icon.svg",
        //, fit: BoxFit.cover,
        height:25.h,
        width: 25.w,
      ),
    ],
  ),
    title:Text(
      'Pings & Pops',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),
    subtitle:Text(
      'Wallpaper, language, Pings backup',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(135, 135, 135, 1)
            )),
    ),
  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.notifications_none_outlined,color: Color.fromRGBO(0, 0, 0, 1))
      // SvgPicture.asset(
      //       "assets/settngs/account_icon.svg"
      //   //, fit: BoxFit.cover,
      //   // height:35.h,
      //   // width: 35.w,
      // ),
    ],
  ),
    title:Text(
      'Notifications',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),
    subtitle:Text(
      'Message, group & tones',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(135, 135, 135, 1)
            )),
    ),
  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // SvgPicture.asset(
      //       "assets/settngs/help.svg"
      //   //, fit: BoxFit.cover,
      //   // height:35.h,
      //   // width: 35.w,
      // ),
      Icon(Icons.help_center_outlined,color: Color.fromRGBO(0, 0, 0, 1))
    ],
  ),
    title:Text(
      'Help',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),
    subtitle:Text(
      'Help center, contact us, privacy policy',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(135, 135, 135, 1)
            )),
    ),
  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.save_alt_outlined,color: Color.fromRGBO(0, 0, 0, 1))
      // SvgPicture.asset(
      //       "assets/settngs/saved.svg"
      //   //, fit: BoxFit.cover,
      //   // height:35.h,
      //   // width: 35.w,
      // ),
    ],
  ),
    title:Text(
      'Saved',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),

  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // SvgPicture.asset(
      //       "assets/settngs/sun.svg"
      //   //, fit: BoxFit.cover,
      //   // height:35.h,
      //   // width: 35.w,
      // ),
      Icon(Icons.dark_mode_outlined,color: Color.fromRGBO(0, 0, 0, 1))
    ],
  ),
    title:Text(
      'Dark mode',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),

  ),
  ListTile(leading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // SvgPicture.asset(
      //       "assets/settngs/logout_icon.svg"
      //   //, fit: BoxFit.cover,
      //   // height:35.h,
      //   // width: 35.w,
      // ),
      Icon(Icons.logout_outlined,color: Color.fromRGBO(0, 0, 0, 1))
    ],
  ),
    title:Text(
      'Log out',
      style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1)
            )),
    ),

  ),

],),
            ),
          ) ,
    );
  }
}
// class BasicTile{
//   final String title;
//   final String subtitle;
//   final String pic;
//   final List<BasicTile> tiles;
//   BasicTile({
//
//     required this.title,
//     required this.subtitle,
//     required this.pic,
//     this.tiles=const[]
//   });
// }
// final basicTiles=<BasicTile>[
//    BasicTile(title: title, subtitle: subtitle, pic: pic)
// ];