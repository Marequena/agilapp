import 'package:flutter/foundation.dart';
import '../../domain/entities/sample_item.dart';
import '../../domain/usecases/get_items.dart';

class SampleController extends ChangeNotifier {
  final GetItems getItems;
  SampleController(this.getItems);

  List<SampleItem> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    items = await getItems.call(null);
    loading = false;
    notifyListeners();
  }
}
