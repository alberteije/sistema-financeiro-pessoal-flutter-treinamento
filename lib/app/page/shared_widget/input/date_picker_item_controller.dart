import 'package:flutter/foundation.dart';

class DatePickerItemController extends ValueNotifier<DateTime?> {
  DatePickerItemController(DateTime? value) : super(value);

  DateTime? get date => value;
  set date(DateTime? newValue) => value = newValue;
}
