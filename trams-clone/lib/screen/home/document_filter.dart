import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:tram/controller/home/document_filter_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/dropdown.dart';
import '../../components/Neumorphic/input.dart';

class DocumentFilter extends StatefulWidget {
  const DocumentFilter({super.key});

  @override
  State<DocumentFilter> createState() => _DocumentFilterState();
}

class _DocumentFilterState extends State<DocumentFilter> {
  final controller = Get.find<DocumentFilterController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: Get.size.shortestSide >= 600 ? 404.4 : 304.4,
        backgroundColor: NeumorphicTheme.baseColor(context),
        child: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 20,
                          ),
                          child: const Text(
                            'Search Filter',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        NeumorphicDropdown(
                          wtitle: _title(context, "Package"),
                          selected: controller.packageDropdown.isEmpty
                              ? null
                              : controller.package.value,
                          onChanged: (v) {
                            controller.selectPackage(v);
                          },
                          items: controller.packageDropdown.toList(),
                        ),
                        NeumorphicInput(
                          placeholder: "Document Name",
                          enabled: true,
                          controller: controller.docNameController,
                          onChanged: (v) {
                            controller.fillName(v.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                  _controlPanel(),
                ],
              ),
              if (controller.state.value == LoaderState.loading)
                const Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if (controller.state.value == LoaderState.loading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      //loading animation
                      const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),

                      //msg
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("Loading...",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _controlPanel() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _button("Reset", () => controller.resetFilter()),
          _button("Apply", () => controller.applyFilter()),
        ],
      ),
    );
  }
}

Widget _title(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      15,
      20,
      10,
    ),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: NeumorphicTheme.defaultTextColor(context),
      ),
    ),
  );
}

Widget _button(String title, Function() onPressed) {
  return NeumorphicButton(
    padding: EdgeInsets.only(
      left: 35,
      right: 35,
      top: 15,
      bottom: 15,
    ),
    style: const NeumorphicStyle(
      depth: 5,
      boxShape: NeumorphicBoxShape.stadium(),
    ),
    onPressed: onPressed,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
