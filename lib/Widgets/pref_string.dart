import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceIml {
  SharedPreferenceIml._sharedInstance();

  static final SharedPreferenceIml shared = SharedPreferenceIml._sharedInstance();

  factory SharedPreferenceIml() => shared;

   SharedPreferences instance;
  final String token = "token";
  final String userId = "userId";
}
