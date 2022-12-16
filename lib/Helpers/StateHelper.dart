import 'package:get_storage/get_storage.dart';
 setData(String key, dynamic value) => GetStorage().write(key, value);
String getData(dynamic key){
  return GetStorage().read(key).toString();
}