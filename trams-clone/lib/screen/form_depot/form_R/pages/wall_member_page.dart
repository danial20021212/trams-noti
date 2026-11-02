import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class WallMemberPage extends StatefulWidget {
  const WallMemberPage({super.key});

  @override
  State<WallMemberPage> createState() => _WallMemberPageState();
}

class _WallMemberPageState extends State<WallMemberPage> {
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
            const Text("Wall Member",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 10),
            Obx(() {
              return Column(
                children: controller.wallMember.map((e) {
                  return CustomCheckboxListTile(
                    id: e.id,
                    title: e.value,
                    isSelected:
                        controller.selectedWallMember.contains(e.id),
                    onChanged: (bool? value) {
                      _handleSelection(
                          selectedList: controller.selectedWallMember,
                          selectedId: e.id);
                      setState(() {
                        controller.saveWallMember();
                      });
                    },
                  );
                }).toList(),
              );
            }),
            if (controller.selectedWallMember.contains("M24"))
              Obx(() => textField(
                  labelText: "Other...",
                  getter: controller.getWallMemberOther,
                  setter: (e) => controller.setWallMemberOther = e))
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
        "You can only select up to 3 wall members.",
      );
      return;
    }

    // Otherwise add
    selectedList.add(selectedId);
  }
}
