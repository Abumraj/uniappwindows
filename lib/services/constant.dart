import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../main.dart';

class Constants {
  static String sharedPreferenceUserLoggedInKey = "false";
  static String sharedPreferenceUserTypeKey = "USERTYPEKEY";
  static String sharedPreferenceUserTokenKey = "USERTOKEN";
  static String sharedPreferenceUserMailKey = "USERMAIL";
  static String sharedPreferenceUserProgramKey = "USERPROGRAM";
  static String sharedPreferenceUserSchoolKey = "USERSCHOOL";
  static String sharedPreferenceUserRoleKey = "USERROLE";
  static String sharedPreferenceFirebaesTokenChannelKey = "FIREBASETOKEN";
  static String sharedPreferenceFirebaesTopicByProgramChannelKey =
      "FIREBASETOPICBYPROGRAM";
  //  save auth token
  static Future<String> saveUserTokenKeyInSharedPreference(String token) async {
    saveLocal.write(key: sharedPreferenceUserTokenKey, value: token);
    return token;
  }

  // retrieve auth token
  static Future<String?> getUserTokenSharedPreference() async {
    return saveLocal.read(key: sharedPreferenceUserTokenKey);
  }

  //  save school url
  static Future<String> saveUserSchoolSharedPreference(String schoolUrl) async {
    saveLocal.write(key: sharedPreferenceUserSchoolKey, value: schoolUrl);
    return schoolUrl;
  }

  // retrieve school url
  static Future<String?> getUserSchoolSharedPreference() async {
    return saveLocal.read(key: sharedPreferenceUserSchoolKey);
  }

  //  save usertype
  static Future<String> savegUserTypeSharedPreference(String userType) async {
    saveLocal.write(key: sharedPreferenceUserTypeKey, value: userType);
    return userType;
  }

  // retrieve usertype
  static Future<String?> getUserTypeSharedPreference() async {
    return saveLocal.read(key: sharedPreferenceUserTypeKey);
  }

  //  save user loggin status
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    saveLocal.write(
        key: sharedPreferenceUserLoggedInKey, value: isUserLoggedIn.toString());
    return isUserLoggedIn;
  }

  //  retrieve user loggin status
  static Future<bool?> getUerLoggedInSharedPreference() async {
    bool isLoggedIn = true;
    var isUserLoggedIn =
        saveLocal.read(key: sharedPreferenceUserLoggedInKey).toString();
    if (isUserLoggedIn == "true") {
      return isLoggedIn;
    } else {
      return false;
    }
  }

  // save user role

  static Future<String> savegetUserRoleSharedPreference(String userRole) async {
    saveLocal.write(key: sharedPreferenceUserRoleKey, value: userRole);
    return userRole;
  }

  // retrieve user role
  static Future<String?> getUserRoleSharedPreference() async {
    return saveLocal.read(key: sharedPreferenceUserRoleKey);
  }
}
