import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';
import '../../../../components/Neumorphic/dropdown.dart';
import '../../../../controller/form_depot/common/base_form_controller.dart';
import '../../../../model/shared/dropdown_model.dart';

class LocationDataPage extends StatefulWidget {
  const LocationDataPage({super.key});

  @override
  State<LocationDataPage> createState() => _LocationDataPageState();
}

class _LocationDataPageState extends State<LocationDataPage> {
  final controller = Get.find<FormBController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: Get.width,
        height: Get.height -
            Scaffold.of(context).appBarMaxHeight!.toDouble() -
            (Get.size.shortestSide >= 600 ? 80 : 60) -
            50,
        child: Obx(() {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              _buildTitle(title: "Location Data"),
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
              textField(
                readOnly: true,
                maxLines: 3,
                labelText: 'Road Name',
                getter: controller.baseFormController.getRoadName ?? "",
                setter: (v) => controller.baseFormController.setRoadName = v,
              ),

              //Ref No
              Obx(() => textField(
                isMandatory: true,
                    readOnly: controller.isReadOnly.value,
                    labelText: 'Reference No.',
                    getter: controller.getReferenceNo,
                    setter: (v) => controller.setReferenceNo = v,
                  )),

              //Chainage
              Obx(() => textField(
                isMandatory: true,
                    readOnly: controller.isReadOnly.value,
                    labelText: 'Chainage / Kilometre',
                    getter: controller.getChainageKilometre,
                    setter: (v) => controller.setChainageKilometre = v,
                  )),

              //River Name
              Obx(() => textField(
                isMandatory: true,
                    readOnly: controller.isReadOnly.value,
                    labelText: 'River Name',
                    getter: controller.getRiverName,
                    setter: (v) => controller.setRiverName = v,
                  )),

              //GPS Easting
              Obx(() => textField(
                isMandatory: true,
                    readOnly: controller.isReadOnly.value,
                    labelText: 'GPS Easting',
                    getter: controller.getGpsEasting,
                    setter: (v) => controller.setGpsEasting = v,
                  )),

              //GPS Northing
              Obx(() => textField(
                isMandatory: true,
                    readOnly: controller.isReadOnly.value,
                    labelText: 'GPS Northing',
                    getter: controller.getGpsNorting,
                    setter: (v) => controller.setGpsNorting = v,
                  )),

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
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
