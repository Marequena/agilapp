import '../../domain/entities/sample_item.dart';
import '../../domain/repositories/sample_repository.dart';
import '../datasources/api_client.dart';
import 'dart:developer' as developer;

class SampleRepositoryImpl implements SampleRepository {
  final ApiClient _apiClient;

  SampleRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<List<SampleItem>> fetchItems() async {
    try {
      final res = await _apiClient.get('/api/items');
      if (res.statusCode == 200 && res.data is List) {
        final List data = res.data as List;
        return data.map((e) => SampleItem(id: e['id'].toString(), title: e['title'].toString())).toList();
      }
    } catch (e, st) {
      developer.log('API fetchItems failed, falling back to local', error: e, stackTrace: st);
    }

    // Fallback local
    await Future.delayed(const Duration(milliseconds: 200));
    return List.generate(6, (i) => SampleItem(id: '$i', title: 'Item $i'));
  }
}

