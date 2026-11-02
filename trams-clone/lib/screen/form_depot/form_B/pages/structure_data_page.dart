import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class StructureDataPage extends StatefulWidget {
  const StructureDataPage({super.key});

  @override
  State<StructureDataPage> createState() => _StructureDataPageState();
}

class _StructureDataPageState extends State<StructureDataPage> {
  final controller = Get.find<FormBController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 5,
            left: 5,
            right: 5,
          ),
          height: Get.height -
              Scaffold.of(context).appBarMaxHeight!.toDouble() -
              (Get.size.shortestSide >= 600 ? 80 : 60) -
              50,
          width: Get.width,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _buildTitle(title: "Structure Data"),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Lane Width',
                    getter: controller.getStLaneWidth,
                    setter: (v) => controller.setStLaneWidth = v,
                    suffixText: 'meters',
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Span Length',
                    getter: controller.getStSpanLength,
                    setter: (v) => controller.setStSpanLength = v,
                    suffixText: 'meters',
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Bridge Length',
                    getter: controller.getStBridgeLength,
                    setter: (v) => controller.setStBridgeLength = v,
                    suffixText: 'meters',
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Bridge Width',
                    getter: controller.getStBridgeWidth,
                    setter: (v) => controller.setStBridgeWidth = v,
                    suffixText: 'meters',
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'No. of Lane',
                    getter: controller.getStNoOfLane,
                    setter: (v) => controller.setStNoOfLane = v,
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'No. of Span',
                    getter: controller.getStNoOfSpan,
                    setter: (v) => controller.setStNoOfSpan = v,
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Median',
                    getter: controller.getStMedian,
                    setter: (v) => controller.setStMedian = v,
                    suffixText: 'meters',
                  )),
              Obx(() => textField(
                    readOnly: controller.isReadOnly.value,
                    isNumberInput: true,
                    labelText: 'Walkway',
                    getter: controller.getStWalkway,
                    setter: (v) => controller.setStWalkway = v,
                    suffixText: 'meters',
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }
}
