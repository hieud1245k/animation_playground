enum Environment {
  LOCAL,
  DEV,
  STG,
  PRD;

  String get url {
    switch (this) {
      case LOCAL:
        return "http://127.0.0.1:8090";
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
  }
}
