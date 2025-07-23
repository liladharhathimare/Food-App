import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Keys
  static const String _userIdKey = "USERKEY";
  static const String _userNameKey = "USERNAMEKEY";
  static const String _userEmailKey = "USEREMAILKEY";
  static const String _userImageKey = "USERIMAGEKEY";
  static const String _userAddressKey = "USERADDRESSKEY";

  /// -------------------- Save Methods --------------------

  /// Save User ID
  Future<bool> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userIdKey, userId);
  }

  /// Save User Name
  Future<bool> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userNameKey, userName);
  }

  /// Save User Email
  Future<bool> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userEmailKey, email);
  }

  /// Save User Image (Asset path or URL)
  Future<bool> saveUserImage(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userImageKey, imageUrl);
  }

  /// Save User Address
  Future<bool> saveUserAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userAddressKey, address);
  }

  /// -------------------- Get Methods --------------------

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userImageKey);
  }

  Future<String?> getUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userAddressKey);
  }

  /// -------------------- Clear All User Data --------------------

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userImageKey);
    await prefs.remove(_userAddressKey);
  }
}
