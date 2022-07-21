import 'package:flutter/material.dart';

class PingsChatListModel {
  String name;
  String lasttext;
  String dp;
  int unreadMsg;
  bool isSelected;
  PingsChatListModel(
      {required this.name,
      required this.lasttext,
      required this.dp,
      required this.unreadMsg,
      required this.isSelected});
}
pingsChatListData() {
  List<PingsChatListModel> pingsListDetails = [];

  PingsChatListModel tileData = PingsChatListModel(
      name: "", lasttext: "", dp: "", unreadMsg: 0, isSelected: false);

  tileData = PingsChatListModel(
      name: "Yuvan",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 10,
      isSelected: false);
  pingsListDetails.add(tileData);

  //2
  tileData = PingsChatListModel(
      name: "Naveen",
      lasttext: "have a good day",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 6,
      isSelected: false);
  pingsListDetails.add(tileData);
  //3
  tileData = PingsChatListModel(
      name: "Akash",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 1,
      isSelected: false);
  pingsListDetails.add(tileData);
  //4
  tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15,
      isSelected: false);
  pingsListDetails.add(tileData);
  //5
  tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15,
      isSelected: false);
  pingsListDetails.add(tileData);
  //6
  tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15,
      isSelected: false);
  pingsListDetails.add(tileData);
  //7
  tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15,
      isSelected: false);
  pingsListDetails.add(tileData);
  //8
tileData = PingsChatListModel(
      name: "Aishu",
      lasttext: "Good Morning",
      dp: "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      unreadMsg: 15,
      isSelected: false);
  pingsListDetails.add(tileData);
  return pingsListDetails;
}
