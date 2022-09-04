import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/profile/tabbarprofile.dart';
import 'package:gatello/views/status/showpage.dart';
import 'package:gatello/views/storage/storage_S1.dart';
import 'package:gatello/views/tabbar/calls/call.dart';
import 'package:gatello/views/tabbar/calls/incomingcall.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/contact_card.dart';
import 'package:gatello/views/tabbar/pops/No%20request.dart';
import 'package:gatello/views/tabbar/pops/Requests.dart';
import 'package:gatello/views/tabbar/pops/birthday.dart';
import 'package:gatello/views/tabbar/pops/circle_indicator.dart';
import 'package:gatello/views/tabbar/pops/comments.dart';
import 'package:gatello/views/tabbar/pops/doubletap.dart';
import 'package:gatello/views/tabbar/pops/interactions.dart';
import 'package:gatello/views/tabbar/pops/newpost.dart';
import 'package:gatello/views/tabbar/pops/poplikes.dart';
import 'package:gatello/views/tabbar/pops/pops.dart';
import 'package:gatello/views/tabbar/pops/report.dart';
import 'package:gatello/views/tabbar/pops/secondreport.dart';
import 'package:gatello/views/tabbar/pops/share.dart';
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
import 'package:gatello/views/tabbar/chats/group_personal_screen/group_personal_chat.dart';
import 'package:gatello/views/tabbar/pings_chat/group_info_screen/group_info.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:gatello/views/tabbar/pops/thirdreport.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:gatello/views/splash_screen1.dart';
import 'package:gatello/views/splash_screen2.dart';
import 'package:gatello/views/tabbar/chats/link_device_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:gatello/views/tabbar/test_code/home.dart';
import 'package:gatello/views/tabbar/test_code/sing_in_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'Database/StorageManager.dart';

import 'Others/components/LottieComposition.dart';
import 'Others/lottie_strings.dart';
import 'Style/Colors.dart';
import 'Style/Text.dart';
import 'firebase_options.dart';
import 'views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
const String ip = 'http://3.108.219.188:5000';
const String signUpip = '$ip/signup';
const String loginip = '$ip/login';


late ValueNotifier<AdaptiveThemeMode> themedata;
class MyApp extends StatefulWidget {

  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: AdaptiveTheme(
        light: ThemeData(
            primaryColor: Color(white),
            brightness: Brightness.light,
            backgroundColor: const Color(white),
            canvasColor: Color(white),
            scaffoldBackgroundColor: Color(white),
            dividerColor: Color(dividerGrey),
            primarySwatch: Palette.dark,
            buttonColor: Color(materialBlack),
            accentColor: Color(accent),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(white)),
            bottomAppBarColor: Color(white),
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Color(black)), backgroundColor: Color(white), titleTextStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(black))))),
        dark: ThemeData(
            primaryColor: Color(materialBlack),
            brightness: Brightness.dark,
            backgroundColor: const Color(materialBlack),
            dividerColor: Color(dividerGrey),
            canvasColor: Color(materialBlack),
            primarySwatch: Palette.light,
            accentColor: Color(accent),
            scaffoldBackgroundColor: Color(materialBlack),
            buttonColor: Color(white),
            bottomAppBarColor: Color(materialBlack),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(materialBlack)),
            appBarTheme:AppBarTheme(
                iconTheme: IconThemeData(color: Color(white)),
                backgroundColor: Color(materialBlack),
                titleTextStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(white))))),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return ScreenUtilInit(
            designSize: Size(360,800),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                        shadowColor: Colors.transparent,
                        backgroundColor: Color.fromRGBO(248, 206, 97, 1))),
                home: FutureBuilder(
                    future: getVisitedFlag(),
                    builder: (context, snapshot) {
                      themedata = AdaptiveTheme.of(context).modeChangeNotifier;
                      return ValueListenableBuilder(
                          valueListenable: themedata,
                          builder: (context, value, _) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return (snapshot.data == true) ? Tabbar():Tabbar();

                            } else {
                              return lottieAnimation(loadingLottie);
                            }
                          });
                    }),
              );
            },
          );
        },
      ),
    );
  }
  var _loginStatus = 0;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("value")!;
    });
  }
}

