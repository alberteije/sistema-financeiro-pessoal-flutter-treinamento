import 'dart:math';

abstract class ModelBase {
  String tempId;

  ModelBase() : tempId = 'temp_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}';
}