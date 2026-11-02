import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/main_listing/inspection_details_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/inspection_review_components.dart';

class FormB1ReviewScreen extends StatefulWidget {
  const FormB1ReviewScreen({super.key});

  @override
  State<FormB1ReviewScreen> createState() => _FormB1ReviewScreenState();
}

class _FormB1ReviewScreenState extends State<FormB1ReviewScreen> {
  final controller = Get.find<InspectionDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xfff3f8fe),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 72,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: InspectionReviewBackButton(
              baseColor: const Color(0xFFE3E8EF),
              icon: Icons.arrow_back,
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          "Review Form ${controller.formType}1",
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
                return _buildFormB1();
              case LoaderState.failure:
                return _buildRetryButton();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormB1() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 40.0), // Extra padding at bottom for scroll clearance
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

          // --- 2. Collapsible Group List (Primary, Secondary, etc.) ---
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

  // --- Helper: Builds the "Dropdown" Header (e.g., PRIMARY MEMBERS) ---
  Widget _buildCollapsibleGroup(dynamic group) {
    return InspectionReviewGroup(
      headerTitle: group.headerTitle,
      initiallyExpanded: false,
      children: group.items.map<Widget>(_buildDetailCard).toList(),
    );
  }

  // --- Helper: Builds the individual White Cards (e.g., P1, P2) ---
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

            // 2. Material (e.g. RC)
            Text(
              item.materials.isNotEmpty ? item.materials.join(", ") : "-",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            // 3. Data Rows (Distress & Severity)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Distress
                Expanded(
                  flex: 6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Distress:",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Severity:",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.severity.isNotEmpty ? item.severity : "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
