import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

import '../../../../components/Neumorphic/dropdown.dart';
import '../../../../controller/form_depot/common/base_form_controller.dart';
import '../../../../controller/form_depot/form_C_controller.dart';

class InspectionDataPage extends StatefulWidget {
  const InspectionDataPage({super.key});

  @override
  State<InspectionDataPage> createState() => _InspectionDataPageState();
}

class _InspectionDataPageState extends State<InspectionDataPage> {
  final controller = Get.find<FormCController>();

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
            _buildTitle(title: "Inspection Data"),
            _buildSubTitle(title: "Basic Information"),
            //Package Dropdown
            Obx(
              () => NeumorphicDropdown(
                wtitle: _buildLabel("Package:"),
                selected:
                    controller.baseFormController.packageDropdown.any((e) => e.value == controller.baseFormController.getPackageID)
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
                labelText: 'Location Chainage',
                getter: controller.getChainage,
                setter: (value) => controller.setChainage = value,
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
                labelText: 'Finished Road Level',
                suffixText: "m",
                isNumberInput: true,
                getter: controller.getFinishedRoadLevel,
                setter: (value) => controller.setFinishedRoadLevel = value,
              ),
            ),
            _buildSubTitle(title: "Additional Information"),
            Obx(
              () => textField(
                labelText: 'Catchment Area',
                suffixText: "km²",
                isNumberInput: true,
                getter: controller.getCatchmentArea,
                setter: (value) => controller.setCatchmentArea = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Design Flow',
                suffixText: "cms",
                isNumberInput: true,
                getter: controller.getDesignFlow,
                setter: (value) => controller.setDesignFlow = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Precast / In-situ',
                getter: controller.getPrecastInSitu,
                setter: (value) => controller.setPrecastInSitu = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Barrel Number Size',
                isNumberInput: true,
                getter: controller.getBarrelNumberSize,
                setter: (value) => controller.setBarrelNumberSize = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Inlet Level',
                suffixText: "m",
                isNumberInput: true,
                getter: controller.getInletLevel,
                setter: (value) => controller.setInletLevel = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Outlet Level',
                suffixText: "m",
                isNumberInput: true,
                getter: controller.getOutletLevel,
                setter: (value) => controller.setOutletLevel = value,
              ),
            ),
            _buildSubTitle(title: "Culvert Details"),
            Obx(
              () => textField(
                labelText: 'Culvert Skew',
                suffixText: "degrees",
                isNumberInput: true,
                getter: controller.getCulvertSkew,
                setter: (value) => controller.setCulvertSkew = value,
              ),
            ),
            Obx(
              () => textField(
                labelText: 'Culvert Length',
                isNumberInput: true,
                getter: controller.getCulvertLength,
                setter: (value) => controller.setCulvertLength = value,
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
                getter: controller.getGpsNorthing,
                setter: (value) => controller.setGpsNorthing = value,
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
            _buildSubTitle(title: "Culvert Type"),
            Obx(
              () => Column(
                children: controller.culvertTypeOptions.map((e) {
                  return CustomCheckboxListTile(
                    id: "",
                    title: e,
                    isSelected: controller.getCulvertType.contains(e),
                    onChanged: (value) {
                      _handleSelection(
                          selectedList: controller.selectedCulvertTypes,
                          selectedId: e);
                      controller.setCulvertType =
                          controller.selectedCulvertTypes;
                    },
                  );
                }).toList(),
              ),
            ),
            _buildSubTitle(title: "Culvert Material"),
            Obx(
              () => Column(
                children: controller.culvertMaterialOptions.map((e) {
                  return CustomCheckboxListTile(
                    id: "",
                    title: e,
                    isSelected: controller.getCulvertMaterial.contains(e),
                    onChanged: (value) {
                      _handleSelection(
                          selectedList: controller.selectedCulvertMaterials,
                          selectedId: e);
                      controller.setCulvertMaterial =
                          controller.selectedCulvertMaterials;
                    },
                  );
                }).toList(),
              ),
            ),
            _buildSubTitle(title: "Inlet Structure"),
            Obx(
              () => Column(
                children: controller.inletStructureOptions.map((e) {
                  return CustomCheckboxListTile(
                    id: "",
                    title: e,
                    isSelected: controller.getInletStructure.contains(e),
                    onChanged: (value) {
                      _handleSelection(
                          selectedList: controller.selectedInletStructures,
                          selectedId: e);
                      controller.setInletStructure =
                          controller.selectedInletStructures;
                    },
                  );
                }).toList(),
              ),
            ),
            _buildSubTitle(title: "Outlet Structure"),
            Obx(
              () => Column(
                children: controller.outletStructureOptions.map((e) {
                  return CustomCheckboxListTile(
                    id: "",
                    title: e,
                    isSelected: controller.getOutletStructure.contains(e),
                    onChanged: (value) {
                      _handleSelection(
                          selectedList: controller.selectedOutletStructures,
                          selectedId: e);
                      controller.setOutletStructure =
                          controller.selectedOutletStructures;
                    },
                  );
                }).toList(),
              ),
            )
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

  void _handleSelection(
      {required RxList<String> selectedList, required String selectedId}) {
    setState(() {
      if (selectedList.contains(selectedId)) {
        selectedList.remove(selectedId);
      } else {
        selectedList.add(selectedId);
      }
    });
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
