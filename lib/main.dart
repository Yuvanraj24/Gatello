import 'package:flutter/material.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:gatello/views/birthday_on_gatello.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/invite_friends.dart';
import 'package:gatello/views/otp_screen.dart';
import 'package:gatello/views/select_birthday.dart';
import 'package:gatello/views/set_password.dart';
import 'package:gatello/views/signup_screen.dart';
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
    return MaterialApp(
      theme: ThemeData(
    
        appBarTheme: AppBarTheme(
    toolbarHeight: 32,
          shadowColor: Colors.transparent,
          backgroundColor: Color.fromRGBO(248, 206, 97, 1)
        )
      ),
      debugShowCheckedModeBanner: false,

      home:  SignUpScreen()

    );
  }
}
