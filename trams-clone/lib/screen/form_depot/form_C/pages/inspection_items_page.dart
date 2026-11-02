import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_model.dart';
import 'package:tram/widget/form_depot/basic/severity_slider.dart';
import 'package:tram/widget/form_depot/bottom_sheet/distress_details_bottom_sheet.dart';
import 'package:tram/widget/form_depot/bottom_sheet/severity_details_bottom_sheet.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

import '../../../../controller/form_depot/form_C_controller.dart';

class InspectionItemsPage extends StatefulWidget {
  const InspectionItemsPage({super.key});

  @override
  State<InspectionItemsPage> createState() => _InspectionItemsPageState();
}

class _InspectionItemsPageState extends State<InspectionItemsPage> {
  final controller = Get.find<FormCController>();

  // A map to track expansion state of each inspection items
  final Map<String, bool> _expandedStates = {};

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
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          children: [
            _buildTitle(title: "Inspection Items"),
            _buildSubTitle(title: "1) Culvert Marker"),
            Obx(
                  () => _inspectionItem(
                  sectionCode: "1A",
                  sectionTitle: "Culvert Marker",
                  distressList: ["C01", "C02", "C03", "C04"],
                  getDistress: controller.getCulvertMarkerDistress,
                  setDistress: (e) =>
                  controller.setCulvertMarkerDistress = e,
                  getSeverity: controller.getCulvertMarkerSeverity,
                  setSeverity: (e) =>
                  controller.setCulvertMarkerSeverity = e),
            ),

            _buildSubTitle(title: "2) Waterways"),
            Obx(
                  () => _inspectionItem(
                sectionCode: "2A",
                sectionTitle: "Waterway",
                distressList: [
                  "C05",
                  "C06",
                  "C07",
                  "C08",
                  "C09",
                  "C10",
                  "C11",
                  "C12"
                ],
                getDistress: controller.getWaterwayDistress,
                setDistress: (e) => controller.setWaterwayDistress = e,
                getSeverity: controller.getWaterwaySeverity,
                setSeverity: (e) => controller.setWaterwaySeverity = e,
                getDistressOther: controller.getWaterwayDistressOther,
                setDistressOther: (e) => controller.setWaterwayDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "2B",
                sectionTitle: "Embankment (Revetment)",
                distressList: [
                  "C05",
                  "C06",
                  "C07",
                  "C08",
                  "C09",
                  "C10",
                  "C11",
                  "C12"
                ],
                getDistress: controller.getEmbankmentDistress,
                setDistress: (e) => controller.setEmbankmentDistress = e,
                getSeverity: controller.getEmbankmentSeverity,
                setSeverity: (e) => controller.setEmbankmentSeverity = e,
                getDistressOther: controller.getEmbankmentDistressOther,
                setDistressOther: (e) => controller.setEmbankmentDistressOther = e,
              ),
            ),
            _buildSubTitle(title: "3) Walls and Aprons"),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3A",
                sectionTitle: "Headwall (Inlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getHeadwallInletDistress,
                setDistress: (e) => controller.setHeadwallInletDistress = e,
                getSeverity: controller.getHeadwallInletSeverity,
                setSeverity: (e) => controller.setHeadwallInletSeverity = e,
                getDistressOther: controller.getHeadwallInletDistressOther,
                setDistressOther: (e) => controller.setHeadwallInletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3B",
                sectionTitle: "Wingwall (Inlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getWingwallInletDistress,
                setDistress: (e) => controller.setWingwallInletDistress = e,
                getSeverity: controller.getWingwallInletSeverity,
                setSeverity: (e) => controller.setWingwallInletSeverity = e,
                getDistressOther: controller.getWingwallInletDistressOther,
                setDistressOther: (e) => controller.setWingwallInletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3C",
                sectionTitle: "Apron (Inlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getApronInletDistress,
                setDistress: (e) => controller.setApronInletDistress = e,
                getSeverity: controller.getApronInletSeverity,
                setSeverity: (e) => controller.setApronInletSeverity = e,
                getDistressOther: controller.getApronInletDistressOther,
                setDistressOther: (e) => controller.setApronInletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3D",
                sectionTitle: "Riprap (Inlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getRiprapInletDistress,
                setDistress: (e) => controller.setRiprapInletDistress = e,
                getSeverity: controller.getRiprapInletSeverity,
                setSeverity: (e) => controller.setRiprapInletSeverity = e,
                getDistressOther: controller.getRiprapInletDistressOther,
                setDistressOther: (e) => controller.setRiprapInletDistressOther = e,
              ),
            ),

            Obx(
                  () => _inspectionItem(
                sectionCode: "3E",
                sectionTitle: "Headwall (Outlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getHeadwallOutletDistress,
                setDistress: (e) =>
                controller.setHeadwallOutletDistress = e,
                getSeverity: controller.getHeadwallOutletSeverity,
                setSeverity: (e) =>
                controller.setHeadwallOutletSeverity = e,
                getDistressOther: controller.getHeadwallOutletDistressOther,
                setDistressOther: (e) => controller.setHeadwallOutletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3F",
                sectionTitle: "Wingwall (Outlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getWingwallOutletDistress,
                setDistress: (e) =>
                controller.setWingwallOutletDistress = e,
                getSeverity: controller.getWingwallOutletSeverity,
                setSeverity: (e) =>
                controller.setWingwallOutletSeverity = e,
                getDistressOther: controller.getWingwallOutletDistressOther,
                setDistressOther: (e) => controller.setWingwallOutletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3G",
                sectionTitle: "Apron (Outlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getApronOutletDistress,
                setDistress: (e) => controller.setApronOutletDistress = e,
                getSeverity: controller.getApronOutletSeverity,
                setSeverity: (e) => controller.setApronOutletSeverity = e,
                getDistressOther: controller.getApronOutletDistressOther,
                setDistressOther: (e) => controller.setApronOutletDistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "3H",
                sectionTitle: "Riprap (Outlet)",
                distressList: [
                  "C13",
                  "C14",
                  "C15",
                  "C16",
                  "C17",
                  "C18",
                  "C19",
                  "C20"
                ],
                getDistress: controller.getRiprapOutletDistress,
                setDistress: (e) => controller.setRiprapOutletDistress = e,
                getSeverity: controller.getRiprapOutletSeverity,
                setSeverity: (e) => controller.setRiprapOutletSeverity = e,
                getDistressOther: controller.getRiprapOutletDistressOther,
                setDistressOther: (e) => controller.setRiprapOutletDistressOther = e,
              ),
            ),
            _buildSubTitle(title: "4) Culvert Units"),
            Obx(
                  () => _inspectionItem(
                sectionCode: "4A",
                sectionTitle: "Barrel #1",
                distressList: [
                  "C21",
                  "C22",
                  "C23",
                  "C24",
                  "C25",
                  "C26",
                  "C27",
                  "C28",
                  "C30",
                  "C31",
                  "C32",
                ],
                getDistress: controller.getBarrel1Distress,
                setDistress: (e) => controller.setBarrel1Distress = e,
                getSeverity: controller.getBarrel1Severity,
                setSeverity: (e) => controller.setBarrel1Severity = e,
                getDistressOther: controller.getBarrel1DistressOther,
                setDistressOther: (e) => controller.setBarrel1DistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "4B",
                sectionTitle: "Barrel #2",
                distressList: [
                  "C21",
                  "C22",
                  "C23",
                  "C24",
                  "C25",
                  "C26",
                  "C27",
                  "C28",
                  "C30",
                  "C31",
                  "C32",
                ],
                getDistress: controller.getBarrel2Distress,
                setDistress: (e) => controller.setBarrel2Distress = e,
                getSeverity: controller.getBarrel2Severity,
                setSeverity: (e) => controller.setBarrel2Severity = e,
                getDistressOther: controller.getBarrel2DistressOther,
                setDistressOther: (e) => controller.setBarrel2DistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "4C",
                sectionTitle: "Barrel #3",
                distressList: [
                  "C21",
                  "C22",
                  "C23",
                  "C24",
                  "C25",
                  "C26",
                  "C27",
                  "C28",
                  "C30",
                  "C31",
                  "C32",
                ],
                getDistress: controller.getBarrel3Distress,
                setDistress: (e) => controller.setBarrel3Distress = e,
                getSeverity: controller.getBarrel3Severity,
                setSeverity: (e) => controller.setBarrel3Severity = e,
                getDistressOther: controller.getBarrel3DistressOther,
                setDistressOther: (e) => controller.setBarrel3DistressOther = e,
              ),
            ),
            Obx(
                  () => _inspectionItem(
                sectionCode: "4D",
                sectionTitle: "Barrel #4",
                distressList: [
                  "C21",
                  "C22",
                  "C23",
                  "C24",
                  "C25",
                  "C26",
                  "C27",
                  "C28",
                  "C30",
                  "C31",
                  "C32",
                ],
                getDistress: controller.getBarrel4Distress,
                setDistress: (e) => controller.setBarrel4Distress = e,
                getSeverity: controller.getBarrel4Severity,
                setSeverity: (e) => controller.setBarrel4Severity = e,
                getDistressOther: controller.getBarrel4DistressOther,
                setDistressOther: (e) => controller.setBarrel4DistressOther = e,
              ),
            ),
            _buildSubTitle(title: "5) Culvert Approach Condition"),
            Obx(
                  () => _inspectionItem(
                sectionCode: "5A",
                sectionTitle: "Culvert Approach Condition",
                distressList: ["C33", "C34", "C35", "C36"],
                getDistress: controller.getCulvertApproachConditionDistress,
                setDistress: (e) =>
                controller.setCulvertApproachConditionDistress = e,
                getSeverity: controller.getCulvertApproachConditionSeverity,
                setSeverity: (e) =>
                controller.setCulvertApproachConditionSeverity = e,
                getDistressOther: controller.getCulvertApproachConditionDistressOther,
                setDistressOther: (e) => controller.setCulvertApproachConditionDistressOther = e,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inspectionItem({
    required String sectionCode,
    required String sectionTitle,
    required List<String> distressList,
    required String getDistress,
    required Function(String) setDistress,
    required String getSeverity,
    required Function(String) setSeverity,
    String? getDistressOther,
    Function(String)? setDistressOther,
  }) {
    // Get the expansion state from the map, default to true if not set
    bool isExpanded = _expandedStates[sectionCode] ?? true;
    final bool isND = getDistress == "ND";
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(0xfff3f8fe),
        borderRadius: BorderRadius.circular(12),
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
        children: [
          _buildCollapsibleHeader(
              sectionCode: sectionCode,
              sectionTitle: sectionTitle,
              isExpanded: isExpanded,
              onTap: () {
                setState(() {
                  _expandedStates[sectionCode] = !isExpanded;
                });
              }),
          if (isExpanded && (controller.sectionCheckboxes[sectionCode] ?? true))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDistressButtonList(
                      distressList: distressList,
                      selectedDistress: getDistress,
                      setDistress: setDistress,
                      setSeverity: setSeverity),

                  // Render "Other" TextField if last item is selected (not ND)
                  if (!isND && getDistress == distressList.last && setDistressOther != null)
                    textField(
                      labelText: "Please specify...",
                      getter: getDistressOther ?? "",
                      setter: (value) {
                        setState(() {
                          setDistressOther(value);
                        });
                      },
                    ),

                  SeveritySlider(
                    defaultValue: isND
                        ? "1"
                        : getSeverity.isNotEmpty &&
                            (double.tryParse(getSeverity) ?? -1) >= 0 &&
                            (double.tryParse(getSeverity) ?? -1) < 6
                            ? getSeverity
                            : "1",
                    onChanged: isND
                        ? (_) {}
                        : (e) {
                      setState(() {
                        setSeverity(e);
                      });
                    },
                    t1: "Low",
                    t2: "High",
                    max: "5",
                    detailsButton: TextButton(
                      onPressed: () => severityDetailsBottomSheet(context, severityModel: FormCModel.severityModel),
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

  Widget _buildCollapsibleHeader(
      {required String sectionCode,
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
                  Obx(() => Checkbox(
                    value: controller.sectionCheckboxes[sectionCode] ?? true,
                    onChanged: (v) => controller.toggleSection(sectionCode),
                    activeColor: Colors.blue[900],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8)),
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

  Widget _buildDistressButtonList(
      {required List<String> distressList,
        required String selectedDistress,
        required Function(String) setDistress,
        required Function(String) setSeverity}) {
    final allOptions = [...distressList, "ND"];
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text.rich(
                  TextSpan(
                    text: 'Distress ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => distressDetailsBottomSheet(context,
                    distressList: distressList),
                child: Text(
                  'Show details',
                  style: TextStyle(
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 10, // horizontal spacing
            runSpacing: 10, // vertical spacing
            alignment: WrapAlignment.start,
            children: allOptions.map<Widget>((distress) {
              final isND = distress == "ND";
              return _buildDistressButton(
                label: distress,
                isSelected: selectedDistress == distress,
                isND: isND,
                onTap: () {
                  setState(() {
                    if (selectedDistress == distress) {
                      setDistress("");
                    } else {
                      setDistress(distress);
                      if (isND) {
                        setSeverity("1");
                      }
                    }
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildDistressButton({
    required String label,
    required bool isSelected,
    required bool isND,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = isND ? Colors.green[900]! : Colors.blue[900]!;
    final Color selectedBg = isND ? Colors.green[100]! : Colors.blue[100]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? selectedColor : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  Widget _buildSubTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}