import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart'; // Penyimpanan token
import '../config/api_config.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  final _storage = GetStorage(); // Storage untuk token

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("🔹 [API On Request] ${options.method} ${options.path}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("✅ [API On Response] ${response.statusCode}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("❌ [API On Error] ${e.message}");
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    print("🔹 [API Request] GET $endpoint dengan params: $params");

    String? token = _storage.read('access_token');

    if (token == null || token.isEmpty) {
      print("⚠️ [API Warning] Token tidak ditemukan!");
      throw Exception("Token is missing");
    }

    // Pisahkan headers
    final headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"  // Trim untuk memastikan tidak ada spasi ekstra
    };

    // print("📤 [Headers Sent] $headers");
    print("📤 [Token storage] $token");

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: headers), // Masukkan headers ke options
      );

      return response;
    } catch (e) {
      print("❌ [API Error] $e");
      rethrow;
    }
  }

  Future<Response> post(String endpoint, dynamic data, {bool useToken = true, Map<String, dynamic>? headers}) async {
    return await _dio.post(endpoint, data: data, options: _getOptions(useToken, headers));
  }

  Future<Response> put(String endpoint, dynamic data, {bool useToken = true, Map<String, dynamic>? headers}) async {
    return await _dio.put(endpoint, data: data, options: _getOptions(useToken, headers));
  }

  Future<Response> delete(String endpoint, {dynamic data, bool useToken = true, Map<String, dynamic>? headers}) async {
    return await _dio.delete(endpoint, data: data, options: _getOptions(useToken, headers));
  }

  Future<Response> patch(String path, {dynamic data, bool useToken = true, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _getOptions(useToken, queryParameters)
    );
  }

  Options _getOptions(bool useToken, Map<String, dynamic>? customHeaders) {
    final defaultHeaders = <String, dynamic>{
      "Accept": "application/json",
    };

    if (useToken) {
      String? token = _storage.read('access_token');
      if (token != null) {
        defaultHeaders["Authorization"] = "Bearer $token";
      } else {
        print("⚠️ [API Warning] Token tidak ditemukan!");
      }
    }

    if (customHeaders != null) {
      defaultHeaders.addAll(customHeaders);
    }

    return Options(headers: defaultHeaders);
  }

}
