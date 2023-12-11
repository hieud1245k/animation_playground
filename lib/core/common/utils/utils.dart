import 'package:flutter/cupertino.dart';

class Utils {
  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static String convertNameToPath(String name) {
    return name.toLowerCase().replaceAll(RegExp("\\s+"), "-");
  }
}
