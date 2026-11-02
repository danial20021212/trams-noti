import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class BridgeTypePage extends StatefulWidget {
  const BridgeTypePage({super.key});

  @override
  State<BridgeTypePage> createState() => _BridgeTypePageState();
}

class _BridgeTypePageState extends State<BridgeTypePage> {
  final controller = Get.find<FormBController>();

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
          padding: const EdgeInsets.all(10),
          children: [
            _buildTitle(title: "Bridge Type"),
            Obx(() {
              return Column(
                children: controller.superstructuresList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtSuperstructureID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtSuperstructureID = 0;
                        } else {
                          controller.setBtSuperstructureID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Parapet type'),
            Obx(() {
              return Column(
                children: controller.parapetList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtParapetID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtParapetID = 0;
                        } else {
                          controller.setBtParapetID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Bearing type'),
            Obx(() {
              return Column(
                children: controller.bearingList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtBearingID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtBearingID = 0;
                        } else {
                          controller.setBtBearingID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Expansion type'),
            Obx(() {
              return Column(
                children: controller.expansionList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtExpansionID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtExpansionID = 0;
                        } else {
                          controller.setBtExpansionID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Deck type'),
            Obx(() {
              return Column(
                children: controller.deckList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtDeckID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtDeckID = 0;
                        } else {
                          controller.setBtDeckID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Abutment type'),
            Obx(() {
              return Column(
                children: controller.abutmentList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtAbutmentID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtAbutmentID = 0;
                        } else {
                          controller.setBtAbutmentID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Pier type'),
            Obx(() {
              return Column(
                children: controller.pierList.map((structure) {
                  return CustomRadioListTile(
                    isReadOnly: controller.isReadOnly.value,
                    title: structure.name,
                    value: structure.recID,
                    groupValue: controller.getBtPierID,
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          controller.setBtPierID = 0;
                        } else {
                          controller.setBtPierID = value as int;
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            _buildSubTitle('Number of expansion'),
            Row(
              children: [
                Expanded(
                    child: textField(
                        readOnly: controller.isReadOnly.value,
                        isNumberInput: true,
                        labelText: "",
                        getter: controller.getBtNoOfExpansionFirstPart,
                        setter: (e) =>
                            controller.setBtNoOfExpansionFirstPart(e))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '@',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
                Expanded(
                    child: textField(
                        readOnly: controller.isReadOnly.value,
                        isNumberInput: true,
                        labelText: "",
                        getter: controller.getBtNoOfExpansionSecondPart,
                        setter: (e) =>
                            controller.setBtNoOfExpansionSecondPart(e))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'meters',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Text(
              'per expansion joint',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            )
          ],
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
