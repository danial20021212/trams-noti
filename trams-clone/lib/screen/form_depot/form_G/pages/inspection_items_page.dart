import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_G_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class InspectionItemsPage extends StatefulWidget {
  const InspectionItemsPage({super.key});

  @override
  State<InspectionItemsPage> createState() => _InspectionItemsPageState();
}

class _InspectionItemsPageState extends State<InspectionItemsPage> {
  final controller = Get.find<FormGController>();

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
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          shrinkWrap: true,
          children: [
            _buildTitle(title: "Inspection Items"),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "*Note: If distress as per above descriptions observed, tick YES. If structure condition at Critical state, tick Critical . If Previous Critical Condition resolved, tick Closed .",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Obx(
              () => _inspectionItem(
                  sectionCode: "1",
                  sectionTitle: "Barries",
                  description:
                      "Protection to gantry columns: are they accident damage? Connections/Alignment/material defects observed?",
                  getDistress: controller.getBarrierDistress,
                  setDistress: (e) => controller.setBarrierDistress = e ?? "",
                  getCritical: controller.getBarrierCritical,
                  setCritical: (e) => controller.setBarrierCritical = e,
                  getClosed: controller.getBarrierClosed,
                  setClosed: (e) => controller.setBarrierClosed = e),
            ),
            Obx(
              () => _inspectionItem(
                  sectionCode: "2",
                  sectionTitle: "Gantry Beams",
                  description:
                      "Connections to the columns: material defects? impact damage? large deflections? Corrosion? flexible sealant? coatings/paint deterioration observed?",
                  getDistress: controller.getGantryBeamDistress,
                  setDistress: (e) =>
                      controller.setGantryBeamDistress = e ?? "",
                  getCritical: controller.getGantryBeamCritical,
                  setCritical: (e) => controller.setGantryBeamCritical = e,
                  getClosed: controller.getGantryBeamClosed,
                  setClosed: (e) => controller.setGantryBeamClosed = e),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "3",
                sectionTitle: "Gantry Columns",
                description:
                    "Columns supporting the beam Base Plates/Gussets: material defects? impact damage? Buckling? Corrosion? cracked welds? coatings/paint deterioration observed?",
                getDistress: controller.getGantryColumnDistress,
                setDistress: (e) =>
                    controller.setGantryColumnDistress = e ?? "",
                getCritical: controller.getGantryColumnCritical,
                setCritical: (e) => controller.setGantryColumnCritical = e,
                getClosed: controller.getGantryColumnClosed,
                setClosed: (e) => controller.setGantryColumnClosed = e,
              ),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "4",
                sectionTitle: "Footings",
                description:
                    "Gantry column foundations below ground? Concrete: material defects, cracking, spalling, movement or settlement?",
                getDistress: controller.getFootingsDistress,
                setDistress: (e) => controller.setFootingsDistress = e ?? "",
                getCritical: controller.getFootingsCritical,
                setCritical: (e) => controller.setFootingsCritical = e,
                getClosed: controller.getFootingsClosed,
                setClosed: (e) => controller.setFootingsClosed = e,
              ),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "5",
                sectionTitle: "Anchor Bolts and Mortar Grout Pads",
                description:
                    "Gantry column anchor bolts below ground? Bolts, Nuts, Washers: material defects, missing, corrosion, projection of thread Grout Fill: material defects, cracking or spalling observed?",
                getDistress: controller.getAnchorMortarDistress,
                setDistress: (e) =>
                    controller.setAnchorMortarDistress = e ?? "",
                getCritical: controller.getAnchorMortarCritical,
                setCritical: (e) => controller.setAnchorMortarCritical = e,
                getClosed: controller.getAnchorMortarClosed,
                setClosed: (e) => controller.setAnchorMortarClosed = e,
              ),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "6",
                sectionTitle: "Maintenance Access",
                description:
                    "walkway balustrades: material defects, corrosion, missing seals, coatings/paint, locks deteoration observed?",
                getDistress: controller.getMaintenanceAccessDistress,
                setDistress: (e) =>
                    controller.setMaintenanceAccessDistress = e ?? "",
                getCritical: controller.getMaintenanceAccessCritical,
                setCritical: (e) => controller.setMaintenanceAccessCritical = e,
                getClosed: controller.getMaintenanceAccessClosed,
                setClosed: (e) => controller.setMaintenanceAccessClosed = e,
              ),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "7",
                sectionTitle: "Static Signs",
                description:
                    "Static signs, sign lights: material defects, corrosion, mounting brackets (welded, bolted, clipped, etc.), support angles, reflective paint, graffiti, generally not readable?",
                getDistress: controller.getStaticSignsDistress,
                setDistress: (e) => controller.setStaticSignsDistress = e ?? "",
                getCritical: controller.getStaticSignsCritical,
                setCritical: (e) => controller.setStaticSignsCritical = e,
                getClosed: controller.getStaticSignsClosed,
                setClosed: (e) => controller.setStaticSignsClosed = e,
              ),
            ),
            Obx(
              () => _inspectionItem(
                sectionCode: "8",
                sectionTitle: "Variable Message Signs (VMS)",
                description:
                    "Variable Message Signs: material defects, corrosion, mounting brackets (welded, bolted, clipped, etc.), support angles, exposed wires, graffiti, generally not readable?",
                getDistress: controller.getVmsDistress,
                setDistress: (e) => controller.setVmsDistress = e ?? "",
                getCritical: controller.getVmsCritical,
                setCritical: (e) => controller.setVmsCritical = e,
                getClosed: controller.getVmsClosed,
                setClosed: (e) => controller.setVmsClosed = e,
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
    required String description,
    required String getDistress,
    required Function(String?) setDistress,
    required String getCritical,
    required Function(String) setCritical,
    required String getClosed,
    required Function(String) setClosed,
  }) {
    // Get the expansion state from the map, default to true if not set
    bool isExpanded = _expandedStates[sectionCode] ?? true;
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
          if (isExpanded && controller.isInspectionItemChecked(sectionCode))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                    child: Text.rich(
                      TextSpan(
                        text: description,
                        children: const [
                          TextSpan(
                            text: " *",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                          fontSize:
                              16), // Match this to your app's standard text size
                    ),
                  ),
                  Column(
                    children: controller.optionsYesOrNo.map((value) {
                      return CustomRadioListTile(
                        title: value.value,
                        value: value.id,
                        groupValue: getDistress,
                        onChanged: (value) => setState(() {
                          setDistress(value);
                        }),
                      );
                    }).toList(),
                  ),
                  _buildContent(content: "Structure conditions"),
                  CustomCheckboxListTile(
                      id: "",
                      title: "Critical",
                      isSelected: getCritical == "1" ? true : false,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            setCritical("1");
                          } else {
                            setCritical("0");
                          }
                        });
                      }),
                  CustomCheckboxListTile(
                      id: "",
                      title: "Closed",
                      isSelected: getClosed == "1" ? true : false,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            setClosed("1");
                          } else {
                            setClosed("0");
                          }
                        });
                      }),
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
                        value: controller.isInspectionItemChecked(sectionCode),
                        onChanged: (_) =>
                            controller.toggleInspectionItem(sectionCode),
                        activeColor: Colors.blue[900],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      )),
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

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  Widget _buildSubTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _buildContent({required String content}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text.rich(
        TextSpan(
          text: content,
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
