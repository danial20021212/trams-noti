import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/controller/gis/maintenance_work_controller.dart';

import '../../components/rect_painter.dart';

class MaintenanceWorkScreen extends StatefulWidget {
  const MaintenanceWorkScreen({super.key});

  @override
  State<MaintenanceWorkScreen> createState() => _MaintenanceWorkState();
}

class _MaintenanceWorkState extends State<MaintenanceWorkScreen>
    with AutomaticKeepAliveClientMixin<MaintenanceWorkScreen> {
  final controller = Get.find<MaintenanceWorkController>();

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
        Container(
          height: Get.height * 0.045,
          padding: const EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._conditionTile("Selected Location", Colors.green),
              const SizedBox(
                width: 20,
              ),
              ..._conditionTile(
                  "Periodlc Maintenance Work Program", Colors.orange),
              const SizedBox(
                width: 20,
              ),
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
