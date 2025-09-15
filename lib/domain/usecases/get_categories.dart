import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;
  GetCategories(this.repository);

  Future<List<dynamic>> call() => repository.fetchList();
}
