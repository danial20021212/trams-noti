import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tram/controller/gis/maintenance_work_filter_controller.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';
import 'package:tram/controller/gis/pavement_map_filter_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/dropdown.dart';
import '../../components/Neumorphic/input.dart';
import '../../components/simple_datepicker.dart';

class MaintenanceWorkFilter extends StatefulWidget {
  const MaintenanceWorkFilter({super.key});

  @override
  State<MaintenanceWorkFilter> createState() => _MaintenanceWorkFilterState();
}

class _MaintenanceWorkFilterState extends State<MaintenanceWorkFilter> {
  final controller = Get.find<MaintenanceWorkFilterController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: Get.size.shortestSide >= 600 ? 404.0 : 304.0,
        backgroundColor: NeumorphicTheme.baseColor(context),
        child: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                          ),
                          child: Text(
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
                        NeumorphicDropdown(
                          wtitle: _title(context, "District"),
                          selected: controller.district.value,
                          onChanged: (v) {
                            controller.selectDistrict(v);
                          },
                          items: controller.districtDropdown.toList(),
                        ),
                        NeumorphicDropdown(
                          wtitle: _title(context, "Route No"),
                          items: controller.routeDropdown,
                          selected: controller.route.value,
                          onChanged: (v) {
                            controller.selectRoute(v);
                          },
                        ),
                        NeumorphicInput(
                          placeholder: "Survey Year",
                          enabled: true,
                          controller: controller.dateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: _selecteDate,
                        ),
                        NeumorphicDropdown(
                          wtitle: _title(context,
                              "Annual Periodic Maintenance Work Program By"),
                          items: controller.programDropdown.toList(),
                          selected: controller.program.value,
                          onChanged: (v) {
                            controller.selectProgram(v);
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
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
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

  void _selecteDate() {
    SmartDialog.show(
      clickMaskDismiss: false,
      builder: (context) {
        return Container(
          width: Get.width * 0.8,
          height: Get.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(10),
          child: SimpleDatePicker(
            view: DateRangePickerView.decade,
            onSubmit: (v) {
              controller.selectDate(v.year.toString());
              SmartDialog.dismiss();
            },
            onCancel: () {
              SmartDialog.dismiss();
            },
          ),
        );
      },
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
