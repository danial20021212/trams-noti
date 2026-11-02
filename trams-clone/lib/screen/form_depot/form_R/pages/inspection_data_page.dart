import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/model/form/form_depot/form_R/form_R_model.dart';
import 'package:tram/widget/form_depot/basic/severity_slider.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';
import 'package:tram/widget/form_depot/bottom_sheet/severity_details_bottom_sheet.dart';

class InspectionDataPage extends StatefulWidget {
  const InspectionDataPage({super.key});

  @override
  State<InspectionDataPage> createState() => _InspectionDataPageState();
}

class _InspectionDataPageState extends State<InspectionDataPage> {
  final controller = Get.find<FormRController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
          left: 5,
          right: 5,
        ),
        width: Get.width,
        height: Get.height -
            Scaffold.of(context).appBarMaxHeight!.toDouble() -
            (Get.size.shortestSide >= 600 ? 80 : 60) -
            50,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 50),
            const Text.rich(
              TextSpan(
                text: "Inspection Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                children: [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSubTitle("Distress(es) observed"),
            Obx(() => Column(
                  children: FormRModel.distressModel.map((e) {
                    return CustomCheckboxListTile(
                      id: e.distressCode,
                      title: e.distressName,
                      isSelected:
                          controller.getDistress.contains(e.distressCode),
                      onChanged: (_) =>
                          controller.toggleDistress(e.distressCode),
                    );
                  }).toList(),
                )),
            Obx(
              () {
                final severity = double.tryParse(controller.getSeverity);
                final validSeverity =
                    severity != null && severity >= 1 && severity <= 5;
                return IgnorePointer(
                  ignoring: controller.isNoDistressSelected,
                  child: SeveritySlider(
                    defaultValue: controller.isNoDistressSelected
                        ? "1"
                        : validSeverity
                            ? controller.getSeverity
                            : "1",
                    onChanged: (e) {
                      setState(() {
                        controller.setSeverity = e;
                      });
                    },
                    t1: 'Low',
                    t2: 'High',
                    max: "5",
                    detailsButton: TextButton(
                      onPressed: () {
                        severityDetailsBottomSheet(context,
                            severityModel: FormRModel.severityModel);
                      },
                      child: Text(
                        'Show details',
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
