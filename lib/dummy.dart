import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'Models/Feeds.dart';
import 'Others/exception_string.dart';
import 'core/models/exception/pops_exception.dart';
import 'handler/Network.dart';

class FeesTest extends StatefulWidget {
  const FeesTest({Key? key}) : super(key: key);

  @override
  State<FeesTest> createState() => _FeesTestState();
}

class _FeesTestState extends State<FeesTest> {
  ValueNotifier<Tuple4> feedsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));

  Future feedsApiCall({required String uid}) async {
    return await ApiHandler().apiHandler(
      valueNotifier: feedsValueNotifier,
      jsonModel: feedsFromJson,
      url: "http://3.108.219.188:5000/list/home_feeds",
      requestMethod: 1,
      body: {"user_id": uid},
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            feedsApiCall(uid: "s8b6XInslPffQEgz8sVTINsPhcx2");
          },
          child: Text("Hello"),
        ),
      ),
    );
  }
}
