import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_G_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class SideConditionPage extends StatefulWidget {
  const SideConditionPage({super.key});

  @override
  State<SideConditionPage> createState() => _SideConditionPageState();
}

class _SideConditionPageState extends State<SideConditionPage> {
  final controller = Get.find<FormGController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: Get.width,
        height: Get.height -
            Scaffold.of(context).appBarMaxHeight!.toDouble() -
            (Get.size.shortestSide >= 600 ? 80 : 60) -
            50,
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildTitle(title: "Side Condition"),

            _buildSubTitle(title: "Parking Position"),
            Column(
              children: controller.optionsYesOrNo.map((e) {
                return CustomRadioListTile(
                  title: e.value,
                  value: e.id,
                  groupValue: controller.getParkingPosition,
                  onChanged: (value) {
                    setState(() => controller.setParkingPosition = value ?? "");
                  },
                );
              }).toList(),
            ),

            _buildSubTitle(title: "Accessibility"),
            Column(
              children: controller.optionsYesOrNo.map((e) {
                return CustomRadioListTile(
                  title: e.value,
                  value: e.id,
                  groupValue: controller.getAccessCondition,
                  onChanged: (value) {
                    setState(() => controller.setAccessCondition = value ?? "");
                  },
                );
              }).toList(),
            ),

            _buildSubTitle(title: "Potential Hazards"),
            Column(
              children: controller.optionsYesOrNo.map((e) {
                return CustomRadioListTile(
                  title: e.value,
                  value: e.id,
                  groupValue: controller.getPotentialHazard,
                  onChanged: (value) {
                    setState(() => controller.setPotentialHazard = value ?? "");
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  Widget _buildSubTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
