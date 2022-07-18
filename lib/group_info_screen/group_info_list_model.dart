import 'package:flutter/material.dart';
class GroupInfoListModel {
  String dp;
  String name;
  String account;
  bool isSelected;
  GroupInfoListModel(
      {required this.dp,
      required this.isSelected,
      required this.name,
      required this.account});
}

groupInfoListData() {
  List<GroupInfoListModel> grouplistDetails = [];

  GroupInfoListModel tileData =
      GroupInfoListModel(name: '', account: '', dp: '', isSelected: false);

  tileData = GroupInfoListModel(
      dp: 'assets/group_info/add participants.png', isSelected: false, name: 'Add participants', account: '');
  grouplistDetails.add(tileData);

//1
  tileData = GroupInfoListModel(
      dp: 'assets/group_info/invite link.png', isSelected: false, name: 'Invite via link', account: '');
  grouplistDetails.add(tileData);
//2
  tileData = GroupInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png', isSelected: false, name: 'Angelena', account: 'Business account');
  grouplistDetails.add(tileData);
//3
  tileData = GroupInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png', isSelected: false, name: 'Elumalai', account: 'Business account');
  grouplistDetails.add(tileData);

  //4
   tileData = GroupInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png', isSelected: false, name: 'Ragu', account: 'Business account');
  grouplistDetails.add(tileData);
  //5
   tileData = GroupInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png', isSelected: false, name: 'Yuvan', account: 'Business account');
  grouplistDetails.add(tileData);
  return grouplistDetails;
}

