import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/components/Neumorphic/dropdown.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/widget/form_depot/basic/severity_slider.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';
import 'package:tram/widget/form_depot/bottom_sheet/material_abbreviation_bottom_sheet.dart';

import '../../../../model/form/form_depot/form_B/form_B_model.dart';
import '../../../../widget/form_depot/bottom_sheet/severity_details_bottom_sheet.dart';

class SecondaryMemberPage extends StatefulWidget {
  const SecondaryMemberPage({super.key});

  @override
  State<SecondaryMemberPage> createState() => _SecondaryMemberPageState();
}

class _SecondaryMemberPageState extends State<SecondaryMemberPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<FormBController>();
  final Map<String, bool> _expandedStates = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
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
            _buildTitle(title: "Secondary Member"),
            Column(
              children: [
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S1",
                    sectionTitle: "Signboard, Utilities",
                    selectedMaterials: controller.getS1Materials,
                    materialList: const ["S", "O"],
                    onMaterialsChanged: (e) => controller.setS1Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS1MaterialOther = e,
                    materialOther: controller.getS1MaterialOther,
                    dropDownDistress: controller.dropDownDistressS1,
                    getDistress: controller.getS1Distress,
                    setDistress: (e) => controller.setS1Distress = e,
                    getDistressOther: controller.getS1DistressOther,
                    setDistressOther: (e) => controller.setS1DistressOther = e,
                    getSeverity: controller.getS1Severity,
                    setSeverity: (e) => controller.setS1Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S2",
                    sectionTitle: "Waterway",
                    selectedMaterials: controller.getS2Materials,
                    materialList: const ["N", "RC", "B", "O"],
                    onMaterialsChanged: (e) => controller.setS2Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS2MaterialOther = e,
                    materialOther: controller.getS2MaterialOther,
                    dropDownDistress: controller.dropDownDistressS2,
                    getDistress: controller.getS2Distress,
                    setDistress: (e) => controller.setS2Distress = e,
                    getDistressOther: controller.getS2DistressOther,
                    setDistressOther: (e) => controller.setS2DistressOther = e,
                    getSeverity: controller.getS2Severity,
                    setSeverity: (e) => controller.setS2Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S3",
                    sectionTitle: "Drain Water Down Pipe, Drainage",
                    selectedMaterials: controller.getS3Materials,
                    materialList: const ["S", "P", "H", "RC", "O"],
                    onMaterialsChanged: (e) => controller.setS3Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS3MaterialOther = e,
                    materialOther: controller.getS3MaterialOther,
                    dropDownDistress: controller.dropDownDistressS3,
                    getDistress: controller.getS3Distress,
                    setDistress: (e) => controller.setS3Distress = e,
                    getDistressOther: controller.getS3DistressOther,
                    setDistressOther: (e) => controller.setS3DistressOther = e,
                    getSeverity: controller.getS3Severity,
                    setSeverity: (e) => controller.setS3Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S4",
                    sectionTitle: "Parapet, Railing",
                    selectedMaterials: controller.getS4Materials,
                    materialList: const ["S", "RC", "T", "M", "O"],
                    onMaterialsChanged: (e) => controller.setS4Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS4MaterialOther = e,
                    materialOther: controller.getS4MaterialOther,
                    dropDownDistress: controller.dropDownDistressS4,
                    getDistress: controller.getS4Distress,
                    setDistress: (e) => controller.setS4Distress = e,
                    getDistressOther: controller.getS4DistressOther,
                    setDistressOther: (e) => controller.setS4DistressOther = e,
                    getSeverity: controller.getS4Severity,
                    setSeverity: (e) => controller.setS4Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S5",
                    sectionTitle: "Kerb, Sidewalks, Approaches, Approach Slabs",
                    selectedMaterials: controller.getS5Materials,
                    materialList: const ["S", "RC", "A", "O"],
                    onMaterialsChanged: (e) => controller.setS5Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS5MaterialOther = e,
                    materialOther: controller.getS5MaterialOther,
                    dropDownDistress: controller.dropDownDistressS5,
                    getDistress: controller.getS5Distress,
                    setDistress: (e) => controller.setS5Distress = e,
                    getDistressOther: controller.getS5DistressOther,
                    setDistressOther: (e) => controller.setS5DistressOther = e,
                    getSeverity: controller.getS5Severity,
                    setSeverity: (e) => controller.setS5Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S6",
                    sectionTitle: "Expansion Joint",
                    selectedMaterials: controller.getS6Materials,
                    materialList: const ["AP", "E", "R", "O"],
                    onMaterialsChanged: (e) => controller.setS6Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS6MaterialOther = e,
                    materialOther: controller.getS6MaterialOther,
                    dropDownDistress: controller.dropDownDistressS6,
                    getDistress: controller.getS6Distress,
                    setDistress: (e) => controller.setS6Distress = e,
                    getDistressOther: controller.getS6DistressOther,
                    setDistressOther: (e) => controller.setS6DistressOther = e,
                    getSeverity: controller.getS6Severity,
                    setSeverity: (e) => controller.setS6Severity = e,
                  ),
                ),
                Obx(
                  () => _buildSecondaryMember(
                    isReadOnly: controller.isReadOnly.value,
                    sectionCode: "S7",
                    sectionTitle: "Slope Protections, Retaining Walls",
                    selectedMaterials: controller.getS7Materials,
                    materialList: const ["R", "G", "N", "O"],
                    onMaterialsChanged: (e) => controller.setS7Materials = e,
                    onMaterialOtherChanged: (e) =>
                        controller.setS7MaterialOther = e,
                    materialOther: controller.getS7MaterialOther,
                    dropDownDistress: controller.dropDownDistressS7,
                    getDistress: controller.getS7Distress,
                    setDistress: (e) => controller.setS7Distress = e,
                    getDistressOther: controller.getS7DistressOther,
                    setDistressOther: (e) => controller.setS7DistressOther = e,
                    getSeverity: controller.getS7Severity,
                    setSeverity: (e) => controller.setS7Severity = e,
                  ),
                ),
              ],
            )
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

  Widget _buildSecondaryMember({
    required bool isReadOnly,
    required String sectionCode,
    required String sectionTitle,
    required List<String> materialList,
    required List<String> selectedMaterials,
    required String materialOther,
    required ValueChanged<List<String>> onMaterialsChanged,
    required ValueChanged<String> onMaterialOtherChanged,
    required List<DropdownModel> dropDownDistress,
    required String getDistress,
    required Function(String) setDistress,
    required String getDistressOther,
    required Function(String) setDistressOther,
    required String getSeverity,
    required Function(String) setSeverity,
  }) {
    // Get the expansion state from the map, default to true if not set
    bool isExpanded = _expandedStates[sectionCode] ?? true;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(0xfff3f8fe),
        borderRadius: BorderRadius.circular(12),
        // Add a subtle Neumorphic card effect behind the whole section
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCollapsibleHeader(
              isReadOnly: isReadOnly,
              sectionCode: sectionCode,
              sectionTitle: sectionTitle,
              isExpanded: isExpanded,
              onTap: () {
                setState(() {
                  _expandedStates[sectionCode] = !isExpanded;
                });
              }),
          if (isExpanded && controller.isMemberChecked(sectionCode))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          text: 'Material ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          materialAbbreviationBottomSheet(
                              context, materialList);
                        },
                        child: Text(
                          'Show abbreviation',
                          style: TextStyle(
                            color: Colors.blue[900],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: materialList.map<Widget>((material) {
                      return _buildMaterialButton(
                        label: material,
                        isSelected: selectedMaterials.contains(material),
                        onTap: () {
                          if (!isReadOnly) {
                            setState(() {
                              // Check if the item is already selected before clearing
                              final bool isAlreadySelected =
                                  selectedMaterials.contains(material);

                              // Store if "O" was selected before clearing
                              final bool wasOtherSelected =
                                  selectedMaterials.contains("O");

                              // 1. Clear the list completely to enforce single selection
                              selectedMaterials.clear();

                              // 2. If the item wasn't already selected, add it.
                              //    (This allows tapping an active button to deselect it)
                              if (!isAlreadySelected) {
                                selectedMaterials.add(material);
                              }

                              // 3. Clear the "Other" field if "O" was just deselected
                              //    (i.e., it was selected, but now the list no longer contains it)
                              if (wasOtherSelected &&
                                  !selectedMaterials.contains("O")) {
                                materialOther = "";
                                onMaterialOtherChanged("");
                              }

                              // 4. Notify the parent.
                              //    'selectedMaterials' will now contain 0 or 1 item.
                              onMaterialsChanged(selectedMaterials);
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  if (selectedMaterials.contains("O"))
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: textField(
                        readOnly: isReadOnly,
                        labelText: "Others",
                        getter: materialOther,
                        setter: (value) {
                          if (!isReadOnly) {
                            setState(() {
                              materialOther = value;
                              onMaterialOtherChanged(value);
                            });
                          }
                        },
                      ),
                    ),
                  //Distress drop down
                  NeumorphicDropdown(
                    enabled: !isReadOnly,
                    wtitle: _secondTitle(context, 'Distress'),
                    selected: getDistress.isNotEmpty &&
                            dropDownDistress
                                .any((element) => element.id == getDistress)
                        ? getDistress
                        : "ND",
                    onChanged: isReadOnly
                        ? null
                        : (v) {
                            setState(() {
                              setDistress(v);
                              //if distress is "No distress" set severity to 1
                              if (v == "ND") {
                                setSeverity("1");
                              }
                            });
                          },
                    items: dropDownDistress,
                  ),
                  if (getDistress == "OTH")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: textField(
                        readOnly: isReadOnly,
                        labelText: "Specify...",
                        getter: getDistressOther,
                        setter: (value) {
                          if (!isReadOnly) {
                            setState(() {
                              setDistressOther(value);
                            });
                          }
                        },
                      ),
                    ),
                  SeveritySlider(
                    defaultValue: getSeverity.isNotEmpty &&
                            double.parse(getSeverity) >= 0 &&
                            double.parse(getSeverity) < 6
                        ? getSeverity
                        : "1",
                    onChanged: (e) {
                      if (!isReadOnly) {
                        //only set severity if distress is not "No distress"
                        if (getDistress != "No distress") {
                          setState(() {
                            setSeverity(e);
                          });
                        }
                      }
                    },
                    t1: "No deficiencies",
                    t2: "Critical failure",
                    max: "5",
                    detailsButton: TextButton(
                      onPressed: () {
                        severityDetailsBottomSheet(context,
                            severityModel: FormBModel.severityModel);
                      },
                      child: Text(
                        'Show details',
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _secondTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Text.rich(
        TextSpan(
          text: title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: NeumorphicTheme.defaultTextColor(context),
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleHeader(
      {required bool isReadOnly,
      required String sectionCode,
      required String sectionTitle,
      required bool isExpanded,
      required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          border:
              Border(bottom: BorderSide(color: Colors.blue[900]!, width: 2)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: controller.isMemberChecked(sectionCode),
                    onChanged: isReadOnly
                        ? null
                        : (_) => controller.toggleMember(sectionCode),
                    activeColor: Colors.blue[900],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Colors.blue[900],
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(
                      sectionCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      sectionTitle,
                      style: TextStyle(color: Colors.blue[900], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[100] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue[900]! : Colors.grey,
                width: 1,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.blue[900] : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
