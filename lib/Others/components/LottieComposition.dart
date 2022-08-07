import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

Future<LottieComposition> lottieComposition(String asset) async {
  var assetData = await rootBundle.load(asset);
  return await LottieComposition.fromByteData(assetData);
}

Widget lottieAnimation(String asset,{bool repeat = false}) {
  return FutureBuilder(
    future: lottieComposition(asset),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return (snapshot.hasData && snapshot.connectionState == ConnectionState.done)
          ? Center(
        child: Lottie(
          width: MediaQuery.of(context).size.width / 2,
          composition: snapshot.data,
          repeat: repeat,
        ),
      )
          : Container();
      // : Center(child: CircularProgressIndicator(color:Color(white)));
    },
  );
}
