import 'dart:developer';


import 'package:flutter/material.dart';

class AppRoute {
  static const callingPage = '/CallPage';

  static Route<Object>? generateRoute(RouteSettings settings) {
    var args = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case callingPage:
        return null;
    // MaterialPageRoute(
    //     builder: (_) => CallPage(
    //           startTimestamp: args["extra"]["startTimestamp"],
    //           title: args["extra"]["title"],
    //           video: (args["extra"]["video"] == 'false' || args["extra"]["video"] == 0.0) ? false : true,
    //           channelName: args["extra"]["channelName"],
    //           chatType: (args["extra"]["chatType"] == 0.0) ? args["extra"]["chatType"].ceil() : int.parse(args["extra"]["chatType"]),
    //         ),
    //     settings: settings);
      default:
        return null;
    }
  }
}
