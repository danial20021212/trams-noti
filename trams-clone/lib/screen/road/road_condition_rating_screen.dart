import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/controller/road/road_condition_rating_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class RoadConditionRatingScreen extends StatefulWidget {
  const RoadConditionRatingScreen({super.key});

  @override
  State<RoadConditionRatingScreen> createState() => _RoaConditionState();
}

class _RoaConditionState extends State<RoadConditionRatingScreen> {
  final controller = Get.find<RoadConditionRatingController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: "Road Condition Rating",
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
              Expanded(
                child: Obx(() {
                  switch (controller.state1.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 350,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildSlider1();
                    case LoaderState.failure:
                      return const SizedBox(
                        height: 350,
                        child: Center(
                          child: Text("Failed to load data"),
                        ),
                      );
                  }
                }),
              ),
              Expanded(
                child: Obx(() {
                  switch (controller.state1.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 350,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildSlider2();
                    case LoaderState.failure:
                      return const SizedBox(
                        height: 350,
                        child: Center(
                          child: Text("Failed to load data"),
                        ),
                      );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider1() {
    return CarouselSlider.builder(
      itemCount: controller.paved.length,
      options: CarouselOptions(
        height: 350,
        enlargeCenterPage: true,
        pageSnapping: true,
        enableInfiniteScroll: controller.paved.length < 2 ? false : true,
        onPageChanged: (index, reason) => setState(
          (() => controller.activeIndex1 = index),
        ),
      ),
      itemBuilder: ((context, index, realIndex) {
        return controller.paved[index];
      }),
    );
  }

  Widget _buildSlider2() {
    return CarouselSlider.builder(
      itemCount: controller.unpaved.length,
      options: CarouselOptions(
        height: 350,
        enlargeCenterPage: true,
        pageSnapping: true,
        enableInfiniteScroll: controller.unpaved.length < 2 ? false : true,
        onPageChanged: (index, reason) => setState(
          (() => controller.activeIndex2 = index),
        ),
      ),
      itemBuilder: ((context, index, realIndex) {
        return controller.unpaved[index];
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
