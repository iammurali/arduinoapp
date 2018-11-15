import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _ipKey = "ip";

 
  /// ----------------------------------------------------------
  /// Method that saves the ip address
  /// ----------------------------------------------------------
  Future<bool> setIpAddress(String value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("im ***********from***************** service"+ value);
    return prefs.setString(_ipKey, value);
  }

   /// ----------------------------------------------------------
  /// Method that gets the ip address
  /// ----------------------------------------------------------
   Future<String> getIpAdress() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.getString(_ipKey) ?? "null";
  }
}