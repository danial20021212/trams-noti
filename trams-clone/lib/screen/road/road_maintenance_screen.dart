import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tram/controller/road/road_maintenance_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class RoadMaintenanceScreen extends StatefulWidget {
  const RoadMaintenanceScreen({super.key});

  @override
  State<RoadMaintenanceScreen> createState() => _RoadMaintenanceState();
}

class _RoadMaintenanceState extends State<RoadMaintenanceScreen> {
  final controller = Get.find<RoadMaintenanceController>();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: "Road Maintenance Indicators",
        showDrawer: false,
        color: Color(0xfff3f8fe),
      ),
      body: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xfff3f8fe),
        ),
        child: SizedBox(
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Neumorphic(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Sarawak State Road Maintenance Indicator (RMI)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Get.size.shortestSide >= 600 ? 21 : 12,
                        ),
                      ),
                      Obx(
                        () {
                          switch (controller.state1.value) {
                            case LoaderState.initial:
                            case LoaderState.loading:
                              return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            case LoaderState.loaded:
                              return _buildStateCard();
                            case LoaderState.failure:
                              return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text("Failed to load data"),
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  switch (controller.state2.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildSlider();
                    case LoaderState.failure:
                      return const SizedBox(
                        height: 400,
                        child: Center(
                          child: Text("Failed to load data"),
                        ),
                      );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateCard() {
    return SizedBox(
      height: Get.size.shortestSide >= 600 ? 150 : 100,
      width: Get.width,
      child: FittedBox(
        child: Row(children: [
          const RotationTransition(
            turns: AlwaysStoppedAnimation(-90 / 360),
            child: Text(
              "Survey Year",
              style: TextStyle(fontSize: 12),
            ),
          ),
          Text(controller.roadState.value!.dataSurveyYr.isEmpty
              ? "----"
              : controller.roadState.value!.dataSurveyYr),
          const SizedBox(
            width: 10,
          ),
          SfLinearGauge(
            showTicks: false,
            markerPointers: [
              LinearWidgetPointer(
                animationType: LinearAnimationType.linear,
                value: controller.roadState.value!.dataAvgRmi.toDouble(),
                position: LinearElementPosition.outside,
                child: SizedBox(
                  width: 55,
                  height: 45,
                  child: Center(
                    child: Text(
                      controller.roadState.value!.dataAvgRmi.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ranges: <LinearGaugeRange>[
              LinearGaugeRange(
                startValue: 0,
                endValue: controller.roadState.value!.dataAvgRmi.toDouble(),
                color: Colors.green,
              ),
            ],
          ),
        ]),
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
