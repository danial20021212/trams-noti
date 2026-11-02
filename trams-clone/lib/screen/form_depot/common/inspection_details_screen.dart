import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/main_listing/inspection_details_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import 'inspection_review_components.dart';

class InspectionDetailsScreen extends StatefulWidget {
  const InspectionDetailsScreen({super.key});

  @override
  State<InspectionDetailsScreen> createState() =>
      _InspectionDetailsScreenState();
}

class _InspectionDetailsScreenState extends State<InspectionDetailsScreen> {
  final controller = Get.find<InspectionDetailsController>();
  bool isClickedEditButton = false;

  final Color baseColor = const Color(0xFFE3E8EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: baseColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leadingWidth: 60,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: InspectionReviewBackButton(
              icon: Icons.arrow_back,
              iconSize: 20,
              padding: const EdgeInsets.all(9),
              baseColor: baseColor,
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          "Form ${controller.formType}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(
          () {
            switch (controller.state.value) {
              case LoaderState.initial:
              case LoaderState.loading:
                return SizedBox(
                  height: Get.height * 0.8,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case LoaderState.loaded:
                final String type = controller.formType.toLowerCase();

                // --- CLEAN UI ROUTING ---
                // Form B and Form C share the identical clean Header + Buttons UI!
                if (type == 'b' || type == 'c' || type == 'g' || type == 'r') {
                  return _buildGeneralInspectionDetails();
                } else {
                  return _buildGeneralInspectionDetails();
                }

              case LoaderState.failure:
                return _buildRetryButton();
            }
          },
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return InspectionReviewRetryPanel(
      onRetry: controller.loadMainListingDetails,
    );
  }

  Widget _buildGeneralInspectionDetails() {
    return Column(
      children: [
        // The General Info Card
        RepaintBoundary(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "INSPECTION DETAILS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const Divider(height: 16, thickness: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.formTitleMap.value.map<Widget>((item) {
                    final title = item.keys.first;
                    final value = item.values.first;
                    return _buildText(title, value);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            // Form X1 button
            GestureDetector(
              onTap: () => Get.toNamed(
                '/base_form',
                arguments: {
                  'formType': controller.formType,
                  'formPage': 'review_${controller.formType}1',
                  'recID': controller.recID
                },
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 6,
                      offset: Offset(-3, -3),
                    ),
                  ],
                ),
                child: Text(
                  "Form ${controller.formType}1",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Form X2 button
            GestureDetector(
              onTap: () {
                debugPrint('=== Navigate to review ===');
                debugPrint('formType: ${controller.formType}');
                debugPrint('insRecID: ${controller.insRecID}');
                debugPrint('recID: ${controller.recID}');
                final reviewRecID = controller.formType.toLowerCase() == "c"
                    ? controller.insRecID
                    : controller.recID;
                debugPrint('reviewRecID: $reviewRecID');
                Get.toNamed(
                  '/base_form',
                  arguments: {
                    'formType': controller.formType,
                    'formPage': 'review_${controller.formType}2',
                    'recID': reviewRecID,
                    'status': controller.status.value,
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 6,
                      offset: Offset(-3, -3),
                    ),
                  ],
                ),
                child: Text(
                  "Form ${controller.formType}2",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildInspectionDetailsFormG() {
    return Column(
      children: [
        // The General Info Card
        RepaintBoundary(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("INSPECTION DETAILS",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 20, thickness: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.formTitleMap.value.map<Widget>((item) {
                    final title = item.keys.first;
                    final value = item.values.first;
                    return _buildText(title, value);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        // Inspection Date Box
        RepaintBoundary(
          child: Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 6,
                  offset: Offset(-3, -3),
                ),
              ],
            ),
            child: Text(
              "Inspection Date: ${controller.formTitleMap.value.firstWhere((element) => element.keys.first == "Inspection Date", orElse: () => {
                    "Inspection Date": "N/A"
                  }).values.first}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // The Inspection Groups
        Obx(() {
          if (controller.groupedInspectionData.isEmpty) {
            return const Center(child: Text("No details available"));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controller.groupedInspectionData.map((group) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RepaintBoundary(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(3, 3),
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 6,
                              offset: Offset(-3, -3),
                            ),
                          ],
                        ),
                        child: Text(
                          group.headerTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ...group.items.map((item) {
                      bool isSiteCondition =
                          group.headerTitle == "Site Condition";

                      return RepaintBoundary(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(3, 3),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 6,
                                offset: Offset(-3, -3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (isSiteCondition) ...[
                                Column(
                                  children: [
                                    _buildLabelValue(
                                        "Parking Position:", item.value1),
                                    const SizedBox(height: 4),
                                    _buildLabelValue("Access Condition:",
                                        item.value2 == "✓" ? "YES" : "NO"),
                                    const SizedBox(height: 4),
                                    _buildLabelValue("Potential Hazards:",
                                        item.value3 == "✓" ? "YES" : "NO"),
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.titleDistress,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.value1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: [
                                    _buildLabelValue("Critical:", item.value2),
                                    const SizedBox(height: 4),
                                    _buildLabelValue("Closed:", item.value3),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInspectionDetailsFormR() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // General Info Card
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: Offset(-5, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("INSPECTION DETAILS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(height: 20, thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.formTitleMap.value.map<Widget>((item) {
                      final title = item.keys.first;
                      final value = item.values.first;
                      return _buildText(title, value);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Inspection Date Box
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 6,
                    offset: Offset(-3, -3),
                  ),
                ],
              ),
              child: Text(
                "Inspection Date: ${controller.formTitleMap.value.firstWhere(
                      (element) => element.keys.first == "Inspection Date",
                      orElse: () => {"Inspection Date": "N/A"},
                    ).values.first}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Inspection Groups
          Obx(() {
            if (controller.groupedInspectionData.isEmpty) {
              return const Center(
                child: Text("No details available"),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: controller.groupedInspectionData.map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RepaintBoundary(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(3, 3),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 6,
                                offset: Offset(-3, -3),
                              ),
                            ],
                          ),
                          child: Text(
                            group.headerTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ...group.items.map((item) {
                        return RepaintBoundary(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(3, 3),
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 6,
                                  offset: Offset(-3, -3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    item.value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
