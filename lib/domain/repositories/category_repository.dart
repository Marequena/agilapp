abstract class CategoryRepository {
  Future<List<Map<String, dynamic>>> fetchListRaw();
  Future<List<dynamic>> fetchList();
}
