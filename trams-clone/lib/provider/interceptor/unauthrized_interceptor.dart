
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' as getx;
import 'package:tram/controller/auth/auth_controller.dart';

class UnauthorizedInterceptor extends QueuedInterceptor {
  final authenticationManager = getx.Get.find<AuthController>();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dynamic message = response.data;
    if (message != null &&
        message.runtimeType.toString() == "_Map<String, dynamic>" &&
        message.containsKey("http_status")) {
      if (message["http_status"] == "Token expired.") {
        SmartDialog.showToast(message["http_status"]);
        authenticationManager.logout();
        return;
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
