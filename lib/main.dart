import 'package:flutter/material.dart';
import 'package:gatello/views/add_email.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:gatello/views/birthday_on_gatello.dart';
import 'package:gatello/views/create_username.dart';
import 'package:gatello/views/invite_friends.dart';
import 'package:gatello/views/select_birthday.dart';
import 'package:gatello/views/set_password.dart';

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
          shadowColor: Colors.transparent,
          backgroundColor: Color.fromRGBO(248, 206, 97, 1)
        )
      ),
      debugShowCheckedModeBanner: false,
      home: InviteFriends(),
    );
  }
}
