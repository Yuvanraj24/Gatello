
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/Authentication.dart';

class StorageManager {
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

Future setVisitedFlag(bool value) async {
  StorageManager.saveData("alreadyVisited", value);
}

Future getVisitedFlag() async {
  return await StorageManager.readData("alreadyVisited") ?? false;
}

Future setUIDFlag() async {
  StorageManager.saveData("uid", getUID());
}

Future setRootID(String rootID) async {
  StorageManager.saveData("rootID", rootID);
}

Future getRootID() async {
  return await StorageManager.readData("rootID");
}

Future setRecentEmoji(String recentEmoji) async {
  List<String> emojiList =
  List<String>.from(await StorageManager.readData("recentEmojiList") ?? []);
  if (emojiList.contains(recentEmoji) == false) {
    // emojiList.add(recentEmoji);
    emojiList.insert(0, recentEmoji);
  }
  StorageManager.saveData("recentEmojiList", emojiList);
}

Future getRecentEmoji() async {
  return await StorageManager.readData("recentEmojiList") ?? [];
}
