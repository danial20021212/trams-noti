import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/gis/all_gis_map_controller.dart';
import 'package:tram/controller/gis/pavement_map_filter_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/controller/work_history/work_history_filter_controller.dart';
import 'package:tram/model/basic/gis/pavement_detail_model.dart';
import 'package:tram/widget/dialog/video_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class PavementMapController extends GetxController {
  Rx<String?> video = Rxn();
  final rootHomeController = Get.find<RootHomeController>();
  final allMapController = Get.find<AllGisMapController>();
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
    video.listen((v) {
      if (v == null) {
        floatingButton = null;
      } else {
        floatingButton = NeumorphicButton(
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
            lightSource: LightSource.topLeft,
            depth: 3,
          ),
          minDistance: -3,
          child: const Icon(
            Icons.play_arrow,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            openVideo();
          },
        );
      }
      allMapController.floatingButton.value = floatingButton;
      rootHomeController.setFLoatingButton(floatingButton);
    });
    super.onInit();
  }

  Future<NavigationActionPolicy> navigationRequest(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    var uri = navigationAction.request.url!.toString();

    if (uri.startsWith("https://www.google.com/maps")) {
      final success = await _launchUrl(uri.toString());

      if (success) {
        return NavigationActionPolicy.CANCEL;
      } else {
        return NavigationActionPolicy.ALLOW;
      }
    } else if (uri.contains("prims.ipaves.my/site/api_workHistory")) {
      openWorkHistry(uri);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  openWorkHistry(String url) {
    final workController = Get.find<WorkHistoryFilterController>();
    rootHomeController.to(4);
    try {
      final queries = Uri.parse(url).queryParameters;
      final params = {
        "pkg": queries["package"],
        "district": queries["district"],
        "route": queries["route_id"],
        "year": queries["survey_year"],
      };
      if (params["year"]!.isEmpty) {
        final filter = Get.find<PavementMapFilterController>();
        params["year"] = filter.year.value;
      }
      workController.manualArguments(params);
    } catch (err) {
      print(err);
      SmartDialog.showToast("Failed to Open Work History");
    }
  }

  to([PavementDetailModel? model]) async {
    late String url;
    print(model);
    if (model == null || model.fileName.isEmpty) {
      url = UrlStorage.pavementMap;
      video.value = null;
    } else {
      url = "${UrlStorage.pavementMap}/?src=${model.fileName}";
      if (model.videoFilePath.isNotEmpty) {
        video.value = model.videoFilePath;
      } else {
        video.value = null;
      }
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

  openVideo() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return Center(
          child: Container(
            width: Get.width * 0.75,
            height: Get.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: VideoDialog(
              url: video.value!,
            ),
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
