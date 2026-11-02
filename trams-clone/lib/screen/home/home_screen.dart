import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tram/controller/home/home_controller.dart';
import 'package:tram/screen/home/macos_home_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.rect(),
        color: Color(0xffe9f3fd),
      ),
      child: Obx(
        () {
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
            final pins = controller.visiblePins.toList(growable: false);
            return MacOSHomeMap(
              key: ValueKey(pins.map((pin) => pin.id).join('|')),
              initialCameraPosition: controller.initialPlex,
              pins: pins,
              onMarkerTapped: controller.showDialog,
            );
          }

          return GoogleMap(
            onMapCreated: controller.onMapCreated,
            initialCameraPosition: controller.initialPlex,
            markers: controller.makers.toSet(),
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
          );
        },
      ),
    );
  }
}
