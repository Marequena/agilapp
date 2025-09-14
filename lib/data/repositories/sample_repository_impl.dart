import '../../domain/entities/sample_item.dart';
import '../../domain/repositories/sample_repository.dart';

class SampleRepositoryImpl implements SampleRepository {
  @override
  Future<List<SampleItem>> fetchItems() async {
    // Simular un retardo y devolver items de ejemplo
    await Future.delayed(const Duration(milliseconds: 200));
    return List.generate(6, (i) => SampleItem(id: '$i', title: 'Item $i'));
  }
}
