import 'package:flutter/material.dart';

class PingsChatListModel {
  String name;
  String lasttext;
  String dp;
  int unreadMsg;

  PingsChatListModel({
    required this.name,
    required this.lasttext,
    required this.dp,
    required this.unreadMsg,
  });
}

pingsChatListData() {
  List<PingsChatListModel> pingsListDetails = [];

  PingsChatListModel tileData =
      PingsChatListModel(name: "", lasttext: "", 
      dp: "", unreadMsg: 0);

  //1
  tileData = PingsChatListModel(
      name: "Yuvan",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 10);
  pingsListDetails.add(tileData);
  //2
  tileData = PingsChatListModel(
      name: "Naveen",
      lasttext: "have a good day",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 6);
  pingsListDetails.add(tileData);
  //3
  tileData = PingsChatListModel(
      name: "Akash",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 1);
  pingsListDetails.add(tileData);
  //4
  tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15);
  pingsListDetails.add(tileData);

  return pingsListDetails;
  
}
