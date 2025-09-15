import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../../core/storage/secure_storage.dart';
import 'dart:developer' as developer;

class ApiClient {
  final Dio _dio;

  ApiClient._internal(this._dio);

  factory ApiClient.create() {
    final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl, connectTimeout: const Duration(seconds: 10)));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // Add interceptor to inject Authorization header
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await SecureStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }, onError: (e, handler) async {
      final response = e.response;
      if (response != null && response.statusCode == 401) {
        developer.log('Unauthorized response, clearing token');
        await SecureStorage.deleteToken();
      }
      return handler.next(e);
    }));

    return ApiClient._internal(dio);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {data, Map<String, dynamic>? queryParameters}) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path, {data, Map<String, dynamic>? queryParameters}) async {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.delete(path, queryParameters: queryParameters);
  }
}
