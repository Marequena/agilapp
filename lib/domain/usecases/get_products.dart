import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;
  GetProducts(this.repository);

  Future<List<dynamic>> call() async {
    return repository.fetchFullDetails();
  }
}
