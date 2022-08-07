
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHandler {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  void writeUserInfo(String user_id, String email, String root_folder_id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("userid", user_id);
    prefs.setString("email", email);
    prefs.setString("root_folder_id", root_folder_id);
    print("Writing to Shared Preferences");
  }

  Future<String> getUserId()
  async{
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("userid").toString());
    return prefs.getString("userid").toString();

  }

  Future<String> getEmail()
  async{
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("email").toString();
  }

  Future<String> getRootFolderId()
  async{
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("root_folder_id").toString();
  }

}