
//ijhedijorkgrhtk,
//test

import 'package:firebase_core/firebase_core.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/dummy.dart';

// import 'package:gatello/reset_password.dart';
// import 'package:gatello/select_contact.dart';
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
import 'package:gatello/views/signup_screen.dart';
import 'package:gatello/views/splash_screen3.dart';
import 'package:gatello/views/splash_screen4.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:gatello/views/splash_screen1.dart';
import 'package:gatello/views/splash_screen2.dart';
import 'package:gatello/views/tabbar/chats/link_device_screen.dart';
import 'package:gatello/views/tabbar/chats/pesrsonal_chat.dart';
import 'package:gatello/views/tabbar/test_code/home.dart';
import 'package:gatello/views/tabbar/test_code/sing_in_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  runApp(MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

const String ip = 'http://3.108.219.188:5000';
const String signUpip = '$ip/signup';
const String loginip = '$ip/login';

// const String ROOT = "http://tutionteacher.rrtutors.com";
// const String REGISTRATION = "$ROOT/api/registration.php";
// const String LOGIN = "$ROOT/api/login.php";

class MyApp extends StatefulWidget {
  static const IconData phone =
      IconData(0xf4b8, fontFamily: "", fontPackage: "");
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                    shadowColor: Colors.transparent,
                    backgroundColor: Color.fromRGBO(248, 206, 97, 1))),
            home: child,
            routes: {
              // '/signin': (BuildContext context) => SignIn(),
              // '/signup': (BuildContext context) => SignUp(),
              // '/home': (BuildContext context) => Home(),
            },
          );
        },
        child: Splash4()
        // child: Stack(
        //   children: [
        //     Container(
        //       width: double.infinity,
        //       height: double.infinity,
        //       child: Image.network(
        //         "https://c4.wallpaperflare.com/wallpaper/384/818/513/himalayas-mountains-landscape-nature-wallpaper-preview.jpg",
        //         fit: BoxFit.fill,
        //       ),
        //     ),
        //     (_loginStatus == 1) ? Home() : SignIn()
        //   ],
        // ),
        );
  }

  //Test Comment

  var _loginStatus = 0;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("value")!;
    });
  }
}
