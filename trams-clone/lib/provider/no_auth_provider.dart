import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class NoAuthProvider extends getx.GetxController {
  final _dio = Dio();

  @override 
  void onInit() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print(e.response?.data);
        return handler.next(e);
      },
    ));
    // _dio.interceptors.add(UnauthorizedInterceptor());
    super.onInit();
  }

  Future<Response> store(String url, Map<String, dynamic> data) {
    return _dio.post(
      url,
      data: FormData.fromMap(data),
    );
  }

  Future<Response> index(String url) {
    return _dio.get(
      url,
    );
  }

  Future<Response> show(String url) {
    return _dio.get(
      url,
    );
  }

  Future<Response> put(
    String url,
    String data,
  ) {
    return _dio.put(
      url,
      data: data,
    );
  }

  Future<Response> destroy(String url) {
    return _dio.delete(
      url,
    );
  }
}
