import 'package:tram/provider/interceptor/unauthrized_interceptor.dart';
import '../controller/auth/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

class ApiProvider extends GetxController {
  final Dio _dio = Dio();
  final AuthController auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = auth.accessToken();
          final userName = auth.accessName();

          if (token != null) {
            // --- 1. HANDLE FORM DATA ---
            if (options.data is FormData) {
              options.data.fields.add(MapEntry('access_token', token));
              options.data.fields.add(MapEntry('userName', userName ?? ''));
            }
            // --- 2. HANDLE JSON MAPS (POST/PUT) ---
            else if (options.data is Map) {
              // Create a mutable copy to avoid "Cannot modify unmodifiable map" errors
              final mutableData = Map<String, dynamic>.from(options.data);
              mutableData['access_token'] = token;
              mutableData['userName'] = userName;
              options.data = mutableData;
            }
            // --- 3. HANDLE GET/DELETE REQUESTS ---
            else {
              // Create a mutable copy of queryParameters
              final mutableQuery = Map<String, dynamic>.from(options.queryParameters);
              mutableQuery['access_token'] = token;
              mutableQuery['userName'] = userName;
              options.queryParameters = mutableQuery;
            }
          }

          Get.log("API Request: ${options.method} ${options.path}");
          Get.log("Access Token: $token");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          //Get.log("API Response [${response.requestOptions.path}]: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          Get.log("API Error: ${e.response?.statusCode} - ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(UnauthorizedInterceptor());
  }

  Future<Response> store(String url, {Map<String, dynamic> data = const {}}) {
    return _dio.post(url, data: FormData.fromMap(data));
  }

  Future<Response> index(String url, {Map<String, dynamic> query = const {}}) {
    return _dio.get(url, queryParameters: query);
  }

  Future<Response> show(String url, {Map<String, dynamic> query = const {}}) {
    return _dio.get(url, queryParameters: query);
  }

  Future<Response> put(String url, dynamic data) {
    return _dio.put(url, data: data);
  }

  Future<Response> destroy(String url) {
    return _dio.delete(url);
  }
}
