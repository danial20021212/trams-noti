import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/basic/gis/maintenance_work_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MaintenanceWorkController extends GetxController {
  Rx<String?> video = Rxn();
  final rootHomeController = Get.find<RootHomeController>();
  Widget? floatingButton;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: false,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
  );

  @override
  void onInit() {
    super.onInit();
  }

  Future<NavigationActionPolicy> navigationRequest(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    var url = navigationAction.request.url!.toString();

    if (url.startsWith("https://www.google.com/maps")) {
      final success = await _launchUrl(url);

      if (success) {
        return NavigationActionPolicy.CANCEL;
      } else {
        return NavigationActionPolicy.ALLOW;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }

  to([MaintenanceWorkModel? model]) async {
    late String url;
    if (model == null || model.fileName.isEmpty) {
      url = UrlStorage.pavementMap;
      video.value = null;
    } else {
      url = "${UrlStorage.pavementMap}/?src=${model.fileName}";
    }
    webViewController?.loadUrl(
        urlRequest: URLRequest(
      url: WebUri(url),
    ));
  }

  Future<bool> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      return true;
    } else {
      return false;
    }
  }
}
