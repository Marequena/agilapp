import '../entities/sample_item.dart';

abstract class SampleRepository {
  Future<List<SampleItem>> fetchItems();
}
