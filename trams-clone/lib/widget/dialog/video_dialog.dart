import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tram/controller/gis/pavement_video_controller.dart';

class VideoDialog extends StatefulWidget {
  final String url;
  const VideoDialog({super.key, required this.url});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoController controller;

  @override
  void initState() {
    Get.put(VideoController(widget.url));
    controller = Get.find<VideoController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInitialized.value) {
        return Chewie(controller: controller.chewieController);
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  @override
  void dispose() {
    Get.delete<VideoController>();
    super.dispose();
  }
}
