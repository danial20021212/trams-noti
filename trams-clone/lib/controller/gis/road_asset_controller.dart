import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/basic/gis/road_asset_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum RoadAssetType { none, bridge, culvert, kilometer, signboard }

class RoadAssetController extends GetxController {
  // Rx<String?> video = Rxn();
  final rootHomeController = Get.find<RootHomeController>();
  Rx<RoadAssetType> legend = RoadAssetType.none.obs;

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

  to([RoadAssetModel? model, RoadAssetType? type]) async {
    late String url;
    if (model == null || model.fileName.isEmpty) {
      url = UrlStorage.pavementMap;
      legend.value = RoadAssetType.none;
    } else {
      url = "${UrlStorage.pavementMap}/?src=${model.fileName}";
      if (type != null) legend.value = type;
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
