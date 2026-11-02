import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/main_listing/inspection_details_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/inspection_review_components.dart';

class FormR1ReviewScreen extends StatefulWidget {
  const FormR1ReviewScreen({super.key});

  @override
  State<FormR1ReviewScreen> createState() => _FormR1ReviewScreenState();
}

class _FormR1ReviewScreenState extends State<FormR1ReviewScreen> {
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
          "Review Form R1",
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
                return _buildFormR1();
              case LoaderState.failure:
                return _buildRetryButton();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormR1() {
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

  // --- Helper: Builds the Collapsible Header ---
  Widget _buildCollapsibleGroup(dynamic group) {
    return InspectionReviewGroup(
      headerTitle: group.headerTitle,
      initiallyExpanded: true,
      baseColor: baseColor,
      children: group.items.map<Widget>(_buildDetailCard).toList(),
    );
  }

  // --- Helper: Builds the individual White Cards (Form R Style) ---
  Widget _buildDetailCard(dynamic item) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Label (Flex 3)
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

            // Right Side: Value (Flex 5)
            Expanded(
              flex: 5,
              child: Text(
                item.value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors
                      .black54, // Slightly softer color for reading values
                  height: 1.3, // Better line height for long text
                ),
                textAlign: TextAlign.left,
              ),
            ),
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
}
