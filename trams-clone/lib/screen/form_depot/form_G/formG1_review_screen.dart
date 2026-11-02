import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/main_listing/inspection_details_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/inspection_review_components.dart';

class FormG1ReviewScreen extends StatefulWidget {
  const FormG1ReviewScreen({super.key});

  @override
  State<FormG1ReviewScreen> createState() => _FormG1ReviewScreenState();
}

class _FormG1ReviewScreenState extends State<FormG1ReviewScreen> {
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
          "Review Form G1",
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
                return _buildFormG1();
              case LoaderState.failure:
                return _buildRetryButton();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormG1() {
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Helper: Builds the Collapsible Header (e.g. SITE CONDITION, P1, P2...) ---
  Widget _buildCollapsibleGroup(dynamic group) {
    return InspectionReviewGroup(
      headerTitle: group.headerTitle,
      initiallyExpanded: true,
      baseColor: baseColor,
      children: group.items.map<Widget>((item) {
        return _buildDetailCard(group.headerTitle, item);
      }).toList(),
    );
  }

  // --- Helper: Builds the individual White Cards ---
  Widget _buildDetailCard(String groupTitle, dynamic item) {
    bool isSiteCondition = groupTitle == "Site Condition";

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
            // --- CARD TYPE A: SITE CONDITION ---
            if (isSiteCondition) ...[
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildLabelValue("Parking Position:", item.value1),
                  const SizedBox(height: 4),
                  _buildLabelValue(
                      "Access Condition:", item.value2 == "✓" ? "YES" : "NO"),
                  const SizedBox(height: 4),
                  _buildLabelValue(
                      "Potential Hazards:", item.value3 == "✓" ? "YES" : "NO"),
                ],
              ),
            ]
            // --- CARD TYPE B: STANDARD INSPECTION ITEM ---
            else ...[
              // 1. Title
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // 2. Distress Title & Yes/No Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(width: 8),
                  Text(
                    item.value1, // Usually "YES" or "NO"
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 3. Critical & Closed Status
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
  }

  // --- Helper: Label/Value Row ---
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

  Widget _buildRetryButton() {
    return InspectionReviewRetryPanel(
      onRetry: controller.loadMainListingDetails,
    );
  }
}
