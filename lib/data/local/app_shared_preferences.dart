// import 'package:pionixbox/data/local/db_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppSharedPreferences {
//   late SharedPreferences _prefs;
//
//   Future<AppSharedPreferences> getInstance() async {
//     _prefs = await SharedPreferences.getInstance();
//     return AppSharedPreferences();
//   }
//
// Future<void> updateWifiConnection(String ssid) async {
//   _prefs = await SharedPreferences.getInstance();
// await _prefs.setString(DbHelper.colConnectedSsid, ssid);
// }
//
// Future<String> getConnectedSSID() async {
//   _prefs = await SharedPreferences.getInstance();
//   return _prefs.getString(DbHelper.colConnectedSsid) ?? '';
// }
// }
