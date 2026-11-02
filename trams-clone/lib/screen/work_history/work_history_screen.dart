import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tram/controller/work_history/work_history_controller.dart';


class WorkHistoryScreen extends StatefulWidget {
  const WorkHistoryScreen({super.key});

  @override
  State<WorkHistoryScreen> createState() => _WorkHistoryState();
}

class _WorkHistoryState extends State<WorkHistoryScreen> {
  final controller = Get.find<WorkHistoryController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 5,
        right: 5,
      ),
      color: const Color(0xffe9f3fd),
      width: Get.width,
      child: Obx(
        () {
          switch (controller.state.value) {
            case WorkHistoryState.empty:
              return _emptyWidget();
            case WorkHistoryState.loading:
            case WorkHistoryState.loaded:
            case WorkHistoryState.failure:
              return IndexedStack(
                index: controller.index.value,
                children: [
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  controller.pagedView,
                ],
              );
          }
        },
      ),
    );
  }
}

Widget _emptyWidget() {
  return const Center(
    child: Text(
      "Please apply Filter to view the result.",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
