import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:tram/controller/detail/achievement_kppi_controller.dart';

import '../../components/Neumorphic/navbar.dart';
import '../../model/shared/loader_state_model.dart';

class AchievementKPPIScreen extends StatefulWidget {
  const AchievementKPPIScreen({super.key});

  @override
  State<AchievementKPPIScreen> createState() => _AchievementState();
}

class _AchievementState extends State<AchievementKPPIScreen> {
  final controller = Get.find<AchievementKPPIController>();
  @override
  Widget build(BuildContext context) {
    late String title;
    if (controller.type == "district") {
      title = "Achievement of KPPI for ${controller.place}";
    } else if (controller.type == "division") {
      title = "Achievement of KPPI for Division ${controller.place}";
    } else {
      title = "Achievement of KPPI for Package ${controller.place}";
    }

    return Scaffold(
      appBar: NeumorphicNavBar(
        title: "Condition",
        showDrawer: false,
        color: Color(0xfff3f8fe),
      ),
      body: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xfff3f8fe),
        ),
        child: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color.fromARGB(255, 38, 41, 64),
                ),
              ),
              Obx(() {
                switch (controller.state.value) {
                  case LoaderState.initial:
                  case LoaderState.loading:
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case LoaderState.loaded:
                    return _buildSlider();
                  case LoaderState.failure:
                    return Expanded(
                      child: Center(
                        child: Text(
                          controller.packge?.error != ""
                              ? controller.packge?.error ??
                                  "Failed to load data"
                              : "Failed to load data",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return CarouselSlider.builder(
      itemCount: controller.sliders.length,
      options: CarouselOptions(
        height: 450,
        enlargeCenterPage: true,
        pageSnapping: true,
        onPageChanged: (index, reason) => setState(
          (() => controller.activeIndex = index),
        ),
      ),
      itemBuilder: ((context, index, realIndex) {
        return controller.sliders[index];
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
