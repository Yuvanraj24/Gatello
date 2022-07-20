import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/dummy.dart';
import 'package:gatello/firebase_auth.dart';
import 'package:gatello/group_info_screen/group_info.dart';
import 'package:gatello/reset_password.dart';
import 'package:gatello/select_contact.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:gatello/views/birthday_on_gatello.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/invite_friends.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:gatello/views/select_birthday.dart';
import 'package:gatello/views/set_password.dart';
import 'package:gatello/views/signup_check.dart';
import 'package:gatello/views/signup_screen.dart';
import 'package:gatello/views/splash_screen3.dart';
import 'package:gatello/views/splash_screen4.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:gatello/views/splash_screen1.dart';
import 'package:gatello/views/splash_screen2.dart';
import 'package:gatello/views/tabbar/chats/link_device_screen.dart';
import 'package:gatello/views/tabbar/chats/pesrsonal_chat.dart';
void main(){

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return ScreenUtilInit(
        
     // designSize:  Size(360, 800),
    minTextAdapt: true,
       splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          
          debugShowCheckedModeBanner: false,
        
            theme: ThemeData(
       
            appBarTheme: AppBarTheme(
toolbarHeight:  45.h,

                shadowColor: Colors.transparent,
                backgroundColor: Color.fromRGBO(248, 206, 97, 1))
          ),
          home: child,
        );
      },
     child: Splash4()
    );
  }
}
