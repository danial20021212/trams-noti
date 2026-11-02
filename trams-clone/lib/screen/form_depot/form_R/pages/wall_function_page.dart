import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

class WallFunctionPage extends StatefulWidget {
  const WallFunctionPage({super.key});

  @override
  State<WallFunctionPage> createState() => _WallFunctionPageState();
}

class _WallFunctionPageState extends State<WallFunctionPage> {
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
            const Text("Wall Function",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 20),
            Obx(() => Column(
                  children: controller.wallFunction.map((e) {
                    return CustomCheckboxListTile(
                      id: e.id,
                      title: e.value,
                      isSelected: controller.getWallFunction.contains(e.id),
                      onChanged: (bool? value) {
                        _handleSelection(
                            selectedList: controller.selectedWallFunctions,
                            selectedId: e.id);
                        controller.setWallFunction =
                            controller.selectedWallFunctions;
                      },
                    );
                  }).toList(),
                )),
            if (controller.getWallFunction.contains("F8"))
              Obx(() => textField(
                  labelText: "Other...",
                  getter: controller.getWallFunctionOther,
                  setter: (e) => controller.setWallFunctionOther = e))
          ],
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
}
