import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tram/constant/path.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';
import 'package:tram/controller/gis/road_asset_controller.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../../components/rect_painter.dart';

class RoadAssetScreen extends StatefulWidget {
  const RoadAssetScreen({super.key});

  @override
  State<RoadAssetScreen> createState() => _RoadAssetState();
}

class _RoadAssetState extends State<RoadAssetScreen>
    with AutomaticKeepAliveClientMixin<RoadAssetScreen> {
  final controller = Get.find<RoadAssetController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      Widget? legend;
      switch (controller.legend.value) {
        case RoadAssetType.bridge:
          legend = _bridgeLegend();
          break;
        case RoadAssetType.culvert:
          legend = _culvertLegend();
          break;
        case RoadAssetType.kilometer:
          legend = _kilometerLegend();
          break;
        case RoadAssetType.signboard:
          legend = _signboardLegend();
          break;
        case RoadAssetType.none:
          legend = null;
          break;
      }
      return Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: controller.webViewKey,
              initialUrlRequest:
                  URLRequest(url: WebUri(UrlStorage.pavementMap)),
              initialSettings: controller.settings,
              onWebViewCreated: (c) {
                controller.webViewController = c;
              },
              onLoadStart: (controller, url) {
                // setState(() {
                //   this.url = url.toString();
                //   urlController.text = this.url;
                // });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              shouldOverrideUrlLoading: controller.navigationRequest,
              // onLoadStop: (controller, url) async {
              //   pullToRefreshController?.endRefreshing();
              //   setState(() {
              //     this.url = url.toString();
              //     urlController.text = this.url;
              //   });
              // },
              onReceivedError: (controller, request, error) {
                // pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                // if (progress == 100) {
                //   pullToRefreshController?.endRefreshing();
                // }
                // setState(() {
                //   this.progress = progress / 100;
                //   urlController.text = url;
                // });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                // setState(() {
                //   this.url = url.toString();
                //   urlController.text = this.url;
                // });
              },
              onConsoleMessage: (controller, consoleMessage) {
                // if (kDebugMode) {
                //   print(consoleMessage);
                // }
              },
            ),
          ),
          if (legend != null) legend
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _kilometerLegend() {
  return _legendBox([
    _legend(
      AssetStorage.legendKmPost,
      "Kilometer Post",
      const Color.fromARGB(255, 222, 226, 235),
    ),
  ]);
}

Widget _bridgeLegend() {
  return _legendBox([
    _legend(
      AssetStorage.legendBridge,
      "Bridge",
      const Color.fromARGB(255, 222, 226, 235),
    ),
  ]);
}

Widget _culvertLegend() {
  return _legendBox([
    _legend(
      AssetStorage.legendCulvert,
      "Culvert(Reinforced Concrete Pipe)",
      const Color.fromARGB(255, 222, 226, 235),
    ),
    _spacer(),
    _legend(
      AssetStorage.legendCulvert2,
      "Culvert(Box Culvert)",
      const Color.fromARGB(255, 222, 226, 235),
    ),
    _spacer(),
    _legend(
      AssetStorage.legendMetalPipe,
      "Culvert(Corrugated Metal Pipe)",
      const Color.fromARGB(255, 222, 226, 235),
    ),
  ]);
}

Widget _signboardLegend() {
  return _legendBox([
    _legend(
      AssetStorage.legendSignboard,
      "Directional & Distance Signs",
      const Color.fromARGB(255, 222, 226, 235),
    ),
    _spacer(),
    _legend(
      AssetStorage.legendSignboard2,
      "Warning Signs",
      const Color.fromARGB(255, 222, 226, 235),
    ),
    _spacer(),
    _legend(
      AssetStorage.legendSignboard3,
      "Regulatory Signs",
      const Color.fromARGB(255, 222, 226, 235),
    ),
  ]);
}

Widget _legendBox(List<Widget> children) {
  return Container(
    height: Get.height * 0.055,
    padding: const EdgeInsets.all(10),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}

Widget _legend(String image, String text, Color color) {
  return Row(
    children: [
      Container(
        width: Get.height * 0.035,
        height: Get.height * 0.035,
        decoration: BoxDecoration(
          color: color,
        ),
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ),
      ),
      Text(
        " = $text",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

Widget _spacer() {
  return const SizedBox(
    width: 10,
  );
}
