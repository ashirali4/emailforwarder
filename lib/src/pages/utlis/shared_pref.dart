import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
   readObject(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("Read Data");
      if (prefs != null) {
        print("Read Data");
        return json.decode(prefs.getString(key).toString());
      } else {
        return Future(() => null);
      }
    } catch (e) {
      print(e.toString());
      return Future(() => null);
    }
  }

  saveObject(String key, value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, json.encode(value));
      print('Value Saved');
      return Future(() => true);
    } catch (Exception) {
      return Future(() => false);
    }
  }

  remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
      return Future(() => true);
    } catch (Exception) {
      return Future(() => false);
    }
  }
}
