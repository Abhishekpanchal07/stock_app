import 'package:beyond_stock_app/services/hive/register_hiveadapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static final HiveManager _instance = HiveManager._internal();
  factory HiveManager() => _instance;

  HiveManager._internal();

  final Map<String, Box> _openBoxes = {};

  Future<void> initializeHive() async {
    await Hive.initFlutter(); 
   await registerAdapters();
  }

 

  Future<Box<T>> getBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName] as Box<T>;
    }

    if (!Hive.isBoxOpen(boxName)) {
      final box = await Hive.openBox<T>(boxName);
      _openBoxes[boxName] = box;
      return box;
    }

    final box = Hive.box<T>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  Future<void> closeAllBoxes() async {
    for (final box in _openBoxes.values) {
      await box.close();
    }
    _openBoxes.clear();
  }
}
