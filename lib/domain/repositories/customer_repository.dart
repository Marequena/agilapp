import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> fetchFullDetails();
  Future<dynamic> fetchFullDetailsRaw();
  Future<Customer?> createCustomer(Map<String, dynamic> payload);
  Future<Customer?> updateCustomer(String id, Map<String, dynamic> payload);
}
