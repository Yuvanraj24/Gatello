import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future getContactName(String phone)
async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? encodedMap = prefs.getString('conMap');
  Map<String,dynamic> conMap = json.decode(encodedMap!);
  print(conMap);

  String? encodedMap1 = prefs.getString('conNames');
  List conNames = json.decode(encodedMap1!);
  print(conNames);

  String? encodedMap2 = prefs.getString('conNums');
  List conNums = json.decode(encodedMap2!);
  print(conNums);

  print(conNums.indexOf(phone));
  // print("This name is  :   ${conNames[conNums.indexOf(phone)]}");

  return conNames[conNums.indexOf(phone)];

}