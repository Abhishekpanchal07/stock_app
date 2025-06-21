import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> registerAdapters() async {
  Hive.registerAdapter(SearchResultModelAdapter());
  Hive.registerAdapter(FiftyTwoWeekAdapter());
}
