import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/main_listing/inspection_details_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/inspection_review_components.dart';

class FormC1ReviewScreen extends StatefulWidget {
  const FormC1ReviewScreen({super.key});

  @override
  State<FormC1ReviewScreen> createState() => _FormC1ReviewScreenState();
}

class _FormC1ReviewScreenState extends State<FormC1ReviewScreen> {
  final controller = Get.find<InspectionDetailsController>();

  // Set the requested base color
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
        toolbarHeight: 70,
        leadingWidth: 72,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: InspectionReviewBackButton(
              icon: Icons.arrow_back,
              baseColor: baseColor,
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: const Text(
          "Review Form C1",
          style: TextStyle(
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
                return _buildFormC1();
              case LoaderState.failure:
                return _buildRetryButton();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormC1() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 40.0), // Extra bottom padding for scroll clearance
      child: Column(
        children: [
          // --- 1. Inspection Date Header ---
          InspectionDateBanner(
            date: controller.formTitleMap.value
                .firstWhere(
                  (element) => element.keys.first == "Inspection Date",
                  orElse: () => {"Inspection Date": "N/A"},
                )
                .values
                .first,
          ),

          // --- 2. Collapsible Group List ---
          Obx(() {
            if (controller.groupedInspectionData.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text("No details available")),
              );
            }

            return Column(
              children: controller.groupedInspectionData.map((group) {
                return _buildCollapsibleGroup(group);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCollapsibleGroup(dynamic group) {
    return InspectionReviewGroup(
      headerTitle: group.headerTitle,
      initiallyExpanded: false,
      baseColor: baseColor,
      children: group.items.map<Widget>(_buildDetailCard).toList(),
    );
  }

  Widget _buildDetailCard(dynamic item) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.12),
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
            // 1. Title (e.g. Abutment Walls...)
            Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),

            // Material section was commented out in original form C1, preserving spacing
            const SizedBox(height: 12),

            // 3. Data Rows (Distress & Severity)
            Row(
              children: [
                // Left Side: Distress
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Distress:",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          item.distress.isNotEmpty ? item.distress : "ND",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Side: Severity
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Severity:",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Text(
                        item.severity.isNotEmpty ? item.severity : "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return InspectionReviewRetryPanel(
      onRetry: controller.loadMainListingDetails,
    );
  }

  // Helper for the small bottom text (Distress/Severity)
  Widget _buildLabelValue(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
