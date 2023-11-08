import 'package:flutter/cupertino.dart';

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}
