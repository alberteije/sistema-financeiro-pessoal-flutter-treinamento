import 'package:flutter/foundation.dart';

class CustomDropdownButtonController extends ValueNotifier<String> {
  CustomDropdownButtonController(String value) : super(value);

  String get selected => value;
  set selected(String newValue) => value = newValue;
}
