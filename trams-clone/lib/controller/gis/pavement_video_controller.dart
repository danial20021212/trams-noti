import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final String url;

  VideoController(this.url);

  late VideoPlayerController videoController;
  late ChewieController chewieController;

  Rx<Widget> video = const Center(
    child: CircularProgressIndicator(),
  ).obs;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    videoController = VideoPlayerController.network(url);
    videoController.addListener(() {
      isInitialized.value = videoController.value.isInitialized;
      if (videoController.value.hasError) {
        isInitialized.value = true;
      }
    });
    chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: false,
      autoInitialize: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );
    video = Chewie(
      controller: chewieController,
    ).obs;
    super.onInit();
  }

  @override
  void onClose() {
    videoController.dispose();
    chewieController.dispose();
    super.onClose();
  }
}
