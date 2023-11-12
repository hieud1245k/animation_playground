import 'package:animation_playground/core/common/utils/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Environment {
  LOCAL,
  DEV,
  STG,
  PRD;

  String get url {
    switch (this) {
      case LOCAL:
        return "https://localhost:8080/";
      default:
        return "";
    }
  }
}

class BuildConfig {
  late Environment environment;

  static BuildConfig instance = BuildConfig._();

  BuildConfig._();

  static Future ensureInitialized(Environment environment) async {
    instance.environment = environment;
    AppPreferences.instance = await SharedPreferences.getInstance();
  }
}
