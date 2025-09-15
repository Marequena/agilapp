import 'package:hive/hive.dart';

class LocalStorage {
  static const customersBox = 'customers_box';
  static const productsBox = 'products_box';
  static const categoriesBox = 'categories_box';
  static const pendingBox = 'pending_writes_box';

  static Future<void> init(String path) async {
    Hive.init(path);
    // boxes are opened lazily by repositories
  }

  static Future<Box> openBox(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box(name);
    return await Hive.openBox(name);
  }
}
