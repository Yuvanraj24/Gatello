

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


import 'LottieComposition.dart';

Widget exceptionScaffold(
    {required BuildContext context, required String lottieString, required String subtitle, Function()? onPressed, String buttonTitle = "Try Again", bool goBack = true}) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: (onPressed != null)
        ? AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: (goBack)
          ? IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
          ))
          : null,
    )
        : null,
    body: FutureBuilder(
      future: lottieComposition(lottieString),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (snapshot.hasData && snapshot.connectionState == ConnectionState.done)
            ? Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.center,
                    child:
                       Container(
                        width: 50,
                        child: Lottie(composition: snapshot.data, repeat: false),

                       )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.poppins(textStyle: TextStyle()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                (onPressed != null)
                    ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                      child: ElevatedButton(
                        onPressed: onPressed,

                       // style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 20)),
                        child: Text(buttonTitle),
                      )),
                )
                    : Container(),
              ],
            ),
          ),
        )
            : Container();
      },
    ),
  );
}
