import '../../core/usecase.dart';
import '../entities/sample_item.dart';
import '../repositories/sample_repository.dart';

class GetItems implements UseCase<List<SampleItem>, void> {
  final SampleRepository repository;
  GetItems(this.repository);

  @override
  Future<List<SampleItem>> call(void params) async {
    return repository.fetchItems();
  }
}
