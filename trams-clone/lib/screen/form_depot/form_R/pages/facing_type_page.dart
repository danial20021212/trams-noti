import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class FacingTypePage extends StatefulWidget {
  const FacingTypePage({super.key});

  @override
  State<FacingTypePage> createState() => _FacingTypePageState();
}

class _FacingTypePageState extends State<FacingTypePage> {
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
            const Text("Facing Type",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 10),
            Obx(() {
              return Column(
                children: controller.facingType.map((e) {
                  return CustomCheckboxListTile(
                    id: e.id,
                    title: e.value,
                    isSelected:
                        controller.selectedFacingType.contains(e.id),
                    onChanged: (bool? value) {
                      _handleSelection(
                          selectedList: controller.selectedFacingType,
                          selectedId: e.id);
                      setState(() {
                        controller.saveFacingType();
                      });
                    },
                  );
                }).toList(),
              );
            }),
            if (controller.selectedFacingType.contains("T15"))
              Obx(() => textField(
                  labelText: "Other...",
                  getter: controller.getFacingTypeOther,
                  setter: (e) => controller.setFacingTypeOther = e))
          ],
        ),
      ),
    );
  }

  void _handleSelection({
    required RxList<String> selectedList,
    required String selectedId,
  }) {
    // If already selected → unselect
    if (selectedList.contains(selectedId)) {
      selectedList.remove(selectedId);
      return;
    }

    // If selecting new item and already 3 selected → block
    if (selectedList.length >= 3) {
      Get.snackbar(
        "Limit Reached",
        "You can only select up to 3 facing types.",
      );
      return;
    }

    // Otherwise add
    selectedList.add(selectedId);
  }
}
