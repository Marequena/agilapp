abstract class ProductRepository {
  Future<List<Map<String, dynamic>>> fetchFullDetailsRaw();
  Future<List<dynamic>> fetchFullDetails();
}
