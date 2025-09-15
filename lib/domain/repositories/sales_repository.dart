import '../entities/sale.dart';

abstract class SalesRepository {
  /// Create a sale on the server. Returns the created Sale on success or null on failure.
  Future<Sale?> createSale(Map<String, dynamic> payload);
}
