import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/home/home_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

class MapDialog extends GetView<HomeController> {
  const MapDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20,
        ),
        height: Get.height * 0.58,
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  final state = controller.state.value;
                  switch (state) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case LoaderState.loaded:
                      final detail = controller.selected.value;
                      if (detail == null) {
                        return const Center(
                          child: Text("Please try Again Later"),
                        );
                      }
                      return Column(
                        children: [
                          Image.network(
                            detail.logo,
                            fit: BoxFit.scaleDown,
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            detail.companyName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          _spacer5(),
                          Text(
                            detail.package,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          _spacer5(),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(
                                "/package_detail",
                                arguments: {
                                  "company": detail.companyName,
                                  "pkg": detail.package
                                      .split("Package ")[1]
                                      .trim(),
                                },
                              );
                            },
                            child: Text(
                              "Total Length : ${detail.totalLength} KM",
                              style: const TextStyle(
                                shadows: [
                                  Shadow(
                                    color: Colors.blue,
                                    offset: Offset(0, -5),
                                  ),
                                ],
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationThickness: 3,
                                color: Colors.transparent,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                          Text(
                            "Paved : ${detail.pavedLength.toStringAsFixed(2)} KM",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          _spacer5(),
                          Text(
                            "Unpaved : ${detail.unpavedLength.toStringAsFixed(2)} KM",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "SP's Representative:",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          _spacer5(),
                          Text(
                            detail.spCompanyName,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${detail.spContactPerson} - ${detail.spContactNo}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          _spacer5(),
                          const Text(
                            "Eng. Consultant:",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          _spacer5(),
                          Text(
                            detail.constCompanyName,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${detail.constContactPerson} - ${detail.constContactNo}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    case LoaderState.failure:
                      return const Center(
                        child: Text("Failed to load detail"),
                      );
                  }
                }),
              ),
            ),
            NeumorphicButton(
              onPressed: () {
                SmartDialog.dismiss();
              },
              child: Container(
                alignment: Alignment.center,
                width: Get.width * 0.65,
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget _spacer5() {
  return const SizedBox(
    height: 4,
  );
}
