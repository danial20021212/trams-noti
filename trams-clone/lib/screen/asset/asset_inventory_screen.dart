import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'package:tram/components/Neumorphic/card_3.dart';
import 'package:tram/controller/asset/asset_inventory_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class AssetInventoryScreen extends StatefulWidget {
  const AssetInventoryScreen({super.key});

  @override
  State<AssetInventoryScreen> createState() => _AssetInventoryState();
}

class _AssetInventoryState extends State<AssetInventoryScreen> {
  final controller = Get.find<AssetInventoryController>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: "Asset Inventory",
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
                Obx(() { 
                  switch (controller.state1.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 270,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildStateCard();
                    case LoaderState.failure:
                      return const SizedBox(
                        height: 270,
                        child: Center(
                          child: Text("Failed to load data"),
                        ),
                      );
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  switch (controller.state1.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildSlider();
                    case LoaderState.failure:
                      return const SizedBox(
                        height: 300,
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
    final data = controller.inventory.value!.statewide;
    return NeumorphicCard3(
      "StateWide",
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textValue("Paved", "${data!.pavedRoad.toStringAsFixed(2)}%"),
            textValue("Road", "${data.roadQuantity.toString()} nos"),
            textValue("Culverts", "${data.culvertQuantity.toString()} nos"),
            textValue("Bridges", "${data.bridgeQuantity.toString()} nos"),
            textValue("Signages", "${data.signageQuantity.toString()} nos"),
            textValue(
              "Traffic Light",
              "${data.trafficLightQuantity.toString()} nos",
            ),
            textValue(
              "Street Lighting",
              "${data.streetLightingQuantity.toString()} nos",
            ),
            textValue(
              "Solar Street Lighting",
              "${data.solarStreetLightingQuantity.toString()} nos",
            ),
            textValue("Guardrail", "${data.guardrailQuantity.toString()} m"),
          ],
        ),
      ],
    );
  }

  Widget textValue(
    String t1,
    String t2,
  ) {
    return Text(
      "$t1 : $t2",
      textAlign: TextAlign.left,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSlider() {
    return CarouselSlider.builder(
      itemCount: controller.sliders.length,
      options: CarouselOptions(
        height: 400,
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
