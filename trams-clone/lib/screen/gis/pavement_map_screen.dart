import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';

import '../../components/rect_painter.dart';

class PavementMapScreen extends StatefulWidget {
  const PavementMapScreen({super.key});

  @override
  State<PavementMapScreen> createState() => _PavementMapState();
}

class _PavementMapState extends State<PavementMapScreen>
    with AutomaticKeepAliveClientMixin<PavementMapScreen> {
  final controller = Get.find<PavementMapController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: InAppWebView(
            key: controller.webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(UrlStorage.pavementMap)),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ..._conditionTile("Good", Colors.green),
              const SizedBox(
                width: 20,
              ),
              ..._conditionTile("Fair", Colors.orange),
              SizedBox(
                width: 20,
              ),
              ..._conditionTile("Poor", Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<Widget> _conditionTile(String text, Color color) {
  return [
    CustomPaint(
      painter: RectPainter(
        width: 12,
        height: 12,
        color: color,
      ),
      child: SizedBox(
        height: 12,
        width: 14,
      ),
    ),
    Text(
      " = $text",
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    ),
  ];
}
