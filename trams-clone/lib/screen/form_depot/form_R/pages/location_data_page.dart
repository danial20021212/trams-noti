import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

import '../../../../components/Neumorphic/dropdown.dart';

class LocationDataPage extends StatefulWidget {
  const LocationDataPage({super.key});

  @override
  State<LocationDataPage> createState() => _LocationDataPageState();
}

class _LocationDataPageState extends State<LocationDataPage> {
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
            const Text("Location Data",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 20),
            //Package Dropdown
            Obx(
              () => NeumorphicDropdown(
                wtitle: _buildLabel("Package:"),
                selected: controller.baseFormController.packageDropdown.any(
                        (e) =>
                            e.value ==
                            controller.baseFormController.getPackageID)
                    ? controller.baseFormController.getPackageID
                    : null,
                onChanged: (v) {
                  controller.baseFormController.selectPackage(v);
                },
                items:
                    controller.baseFormController.packageDropdown.toList(),
              ),
            ),
            const SizedBox(height: 16),
            //District Dropdown
            Obx(() => NeumorphicDropdown(
                  wtitle: _buildLabel("District:"),
                  selected:
                      controller.baseFormController.districtDropdown.isEmpty
                          ? null
                          : controller.baseFormController.getDistrictID,
                  onChanged: (v) {
                    controller.baseFormController.selectDistrict(v);
                  },
                  items: controller.baseFormController.districtDropdown
                      .toList(),
                )),
            const SizedBox(height: 16),
            //Road Code Dropdown
            Obx(() => NeumorphicDropdown(
                  wtitle: _buildLabel("Road Code:"),
                  selected:
                      controller.baseFormController.roadDropdown.isEmpty
                          ? null
                          : controller.baseFormController.getRoadID,
                  onChanged: (v) {
                    controller.baseFormController.selectRoute(v);
                  },
                  items:
                      controller.baseFormController.roadDropdown.toList(),
                )),
            const SizedBox(height: 18),

            //Road Name
            Obx(() => textField(
                  readOnly: true,
                  maxLines: 3,
                  labelText: 'Road Name',
                  getter: controller.baseFormController.getRoadName ?? "",
                  setter: (v) =>
                      controller.baseFormController.setRoadName = v,
                )),
            Obx(
              () => textField(
                labelText: 'Reference No.',
                getter: controller.getReferenceNo,
                setter: (value) => controller.setReferenceNo = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Chainage / Kilometre',
                getter: controller.getChainageKilometre,
                setter: (value) => controller.setChainageKilometre = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Structure Code',
                getter: controller.getStructureCode,
                setter: (value) => controller.setStructureCode = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'GPS Easting',
                getter: controller.getGpsEasting,
                setter: (value) => controller.setGpsEasting = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'GPS Northing',
                getter: controller.getGpsNorting,
                setter: (value) => controller.setGpsNorting = value,
              ),
            ),
            //Use current location checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Use Current Location',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Obx(() {
                    return Checkbox(
                      value: controller.useCurrentLocation.value,
                      onChanged: (v) {
                        if (v != null) {
                          controller.fetchCurrentLocation(v);
                        }
                      },
                      activeColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    );
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }
}
