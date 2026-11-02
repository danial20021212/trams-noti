import 'dart:convert'; // Added for JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tram/model/shared/draft_status_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../../../controller/auth/auth_controller.dart';
import '../../../../controller/form_depot/form_draft_controller.dart';
import '../../../../controller/form_depot/main_listing/main_listing_details_controller.dart';
import '../../../../widget/form_depot/form_depot_text_scope.dart';
import '../inspection_review_components.dart';

class MainListingDetailsScreen extends StatefulWidget {
  const MainListingDetailsScreen({super.key});

  @override
  State<MainListingDetailsScreen> createState() =>
      _MainListingDetailsScreenState();
}

class _MainListingDetailsScreenState extends State<MainListingDetailsScreen> {
  final controller = Get.find<MainListingDetailsController>();
  final auth = Get.find<AuthController>();
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
              shadowOpacity: 0.2,
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Form ${controller.formType}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              controller.formTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: baseColor,
        child: RefreshIndicator(
          onRefresh: controller.load,
          child: SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(
                () {
                  switch (controller.state.value) {
                    case LoaderState.initial:
                    case LoaderState.loading:
                      return const SizedBox(
                        height: 270,
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
                    case LoaderState.loaded:
                      return _buildRecordData();
                    case LoaderState.failure:
                      return _buildRetryButton();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- DOWNLOAD PDF BUTTON --
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomNeumorphicTextButton(
                text: "Download PDF",
                icon: Icons.picture_as_pdf,
                baseColor: Colors.green,
                textColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                onPressed: () => controller.downloadPDF(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // --- HEADER CARD ---
          RepaintBoundary(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withValues(alpha: 0.25),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.formTitleMap.value.map<Widget>((item) {
                  final title = item.keys.first;
                  final value = item.values.first;
                  return _buildText(title, value);
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- LOCAL DRAFTS SECTION ---
          Obx(() {
            if (controller.localDrafts.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Local Drafts (${controller.localDrafts.length})",
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.localDrafts.length,
                  itemBuilder: (context, index) {
                    final draft = controller.localDrafts[index];

                    // 1. Format the Saved Draft Timestamp
                    String formattedDate = draft.updatedAt;
                    try {
                      formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                          .format(DateTime.parse(draft.updatedAt).toLocal());
                    } catch (e) {
                      Get.log("Date format error");
                    }

                    // 2. Decode formData to extract the Inspection Date
                    String inspectionDate = "Not Set";
                    try {
                      final Map<String, dynamic> draftData =
                          jsonDecode(draft.formData);
                      if (draftData['inspection_date'] != null &&
                          draftData['inspection_date'].toString().isNotEmpty) {
                        DateTime dt = DateTime.parse(
                            draftData['inspection_date'].toString());
                        inspectionDate = DateFormat("yyyy-MM-dd").format(dt);
                      }
                    } catch (e) {
                      Get.log(
                          "Error extracting inspection date from draft: $e");
                    }

                    return RepaintBoundary(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                              width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(4, 4),
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 8,
                              offset: Offset(-4, -4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            draft.status == DraftStatus.pendingSync
                                ? "Submission Pending Sync"
                                : "Unsubmitted Draft",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16),
                          ),
                          // 3. Display the Extracted Inspection Date alongside the Saved timestamp
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                "Inspection Date: $inspectionDate",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Saved: $formattedDate",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InspectionReviewBackButton(
                                icon: Icons.delete_outline,
                                iconSize: 20,
                                iconColor: Colors.redAccent,
                                baseColor: baseColor,
                                shadowOpacity: 0.2,
                                padding: const EdgeInsets.all(10),
                                onPressed: () {
                                  _showDeleteConfirmDialog(draft.id!);
                                },
                              ),
                              const SizedBox(width: 10),
                              InspectionReviewBackButton(
                                icon: Icons.edit,
                                iconSize: 20,
                                iconColor: Colors.orange,
                                baseColor: baseColor,
                                shadowOpacity: 0.2,
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  final result = await Get.toNamed(
                                    '/base_form',
                                    arguments: {
                                      'formType': controller.formType,
                                      'formPage': 'inspection',
                                      'isResumeDraft': true,
                                      'draftId': draft.id,
                                      'previousRecID': controller.previousRecID
                                    },
                                  );
                                  if (mounted) {
                                    await controller
                                        .refreshAfterEditorResult(result);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),

          _buildInspectionPaging(),

          const SizedBox(height: 10),

          if (controller.currentDisplayList.isEmpty)
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "No records found",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            )),

          const SizedBox(height: 10),

          _buildInspectionRecords(),

          // --- BOTTOM FIXED BUTTON ---
          if (auth.getUserType() == "Service Provider")
            CustomNeumorphicTextButton(
              text: 'Add New Inspection',
              icon: Icons.add,
              baseColor: const Color(0xFFE0C158),
              textColor: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              borderRadius: 30.0,
              onPressed: () {
                _showDatePickerDialog();
              },
            ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _buildInspectionRecords() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.currentDisplayList.length,
      itemBuilder: (context, index) {
        final item = controller.currentDisplayList[index];

        return RepaintBoundary(
          child: Container(
            margin: const EdgeInsets.only(bottom: 11),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withValues(alpha: 0.25),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
                title: item.inspectionDate == ""
                    ? const Text("null")
                    : Text(item.inspectionDate),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // --- EXTRACT FULL PRE-LOADED DATA ---
                        dynamic passedDataObj;
                        if (controller.formType.toLowerCase() == 'c' &&
                            controller.formDetails.value != null) {
                          try {
                            passedDataObj = controller.formDetails.value.data
                                .firstWhere((e) => e.insRecID == item.insRecID);
                          } catch (_) {}
                        }

                        Get.toNamed(
                          '/inspection_details',
                          arguments: {
                            'recID': item.recID, // Passes Parent ID
                            'insRecID': item.insRecID, // Passes Child ID
                            'formType': controller.formType,
                            'status': item.status,
                            'passedData':
                                passedDataObj, // <-- PASS FULL DATA WITHOUT API CALL
                          },
                        );
                      },
                      child: const Text(
                        "View",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _buildInspectionPaging() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Inspection Records",
          style: TextStyle(fontSize: 18, color: Colors.grey[800]),
        ),
        Visibility(
          visible: controller.currentDisplayList.isNotEmpty,
          child: Obx(
            () => GestureDetector(
              onTap: () => _showPaginationModal(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Page ${controller.currentPage.value}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(int draftId) {
    Get.dialog(
      FormDepotTextScope(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: Get.width * 0.8,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 40, color: Colors.redAccent),
                const SizedBox(height: 12),
                const Text(
                  "Delete Draft?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This action cannot be undone. Are you sure you want to permanently delete this draft?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomNeumorphicTextButton(
                      text: "Cancel",
                      baseColor: Colors.grey[300]!,
                      textColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      onPressed: () => Get.back(),
                    ),
                    CustomNeumorphicTextButton(
                      text: "Delete",
                      baseColor: Colors.redAccent,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      onPressed: () async {
                        Get.back();

                        if (!Get.isRegistered<FormDraftController>()) {
                          Get.lazyPut(() => FormDraftController());
                        }

                        await Get.find<FormDraftController>()
                            .deleteDraft(draftId);
                        controller.load();
                        SmartDialog.showToast("Draft deleted.");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaginationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FormDepotTextScope(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEF6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Page",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close,
                          size: 28, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.totalPages,
                    separatorBuilder: (c, i) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final int pageNum = index + 1;
                      final bool isSelected =
                          pageNum == controller.currentPage.value;

                      return GestureDetector(
                        onTap: () {
                          controller.jumpToPage(pageNum);
                          Get.back();
                        },
                        child: Container(
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            "$pageNum",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDatePickerDialog() {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return FormDepotTextScope(
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xffe0e6ef),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return SizedBox(
                    width: Get.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Select Inspection Date",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Inset Date Display
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 18),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xffd4dbe5), // Darker inset look
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white60, width: 1.5),
                              ),
                              child: Text(
                                DateFormat("yyyy-MM-dd").format(selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Choose Date Button
                            CustomNeumorphicTextButton(
                              text: "Choose Date",
                              baseColor: baseColor,
                              textColor: Colors.black,
                              borderRadius: 30.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );

                                if (date != null) {
                                  setStateDialog(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomNeumorphicTextButton(
                              text: "Cancel",
                              baseColor: baseColor,
                              textColor: Colors.black,
                              borderRadius: 20.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              onPressed: () => Get.back(),
                            ),
                            const SizedBox(width: 12),
                            CustomNeumorphicTextButton(
                              text: "OK",
                              baseColor: Colors.lightBlueAccent,
                              textColor: Colors.white,
                              borderRadius: 20.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 10),
                              onPressed: () async {
                                Get.back();
                                final result = await Get.toNamed(
                                  '/base_form',
                                  arguments: {
                                    'formType': controller.formType,
                                    'formPage': 'inspection',
                                    'recID': controller.recID,
                                    'inspectionDate': selectedDate,
                                    'previousRecID': controller.previousRecID,
                                    'previousInspectionDate':
                                        controller.currentDisplayList.isNotEmpty
                                            ? controller.currentDisplayList
                                                .first.inspectionDate
                                            : null,
                                    'parentID': controller.parentID,
                                    'referenceNo': controller.referenceNo
                                  },
                                );
                                if (mounted) {
                                  await controller
                                      .refreshAfterEditorResult(result);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      height: 270,
      child: Center(
        child: Column(
          children: [
            const Text("Failed to load data"),
            TextButton(
                onPressed: () => controller.load(),
                child: const Text(
                  'Retry ?',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class CustomNeumorphicTextButton extends StatefulWidget {
  final String text;
  final Color baseColor;
  final Color textColor;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? width;
  final double iconSize;

  const CustomNeumorphicTextButton({
    super.key,
    required this.text,
    required this.baseColor,
    required this.textColor,
    this.icon,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 12.0,
    this.width,
    this.iconSize = 16,
    required this.onPressed,
  });

  @override
  State<CustomNeumorphicTextButton> createState() =>
      _CustomNeumorphicTextButtonState();
}

class _CustomNeumorphicTextButtonState
    extends State<CustomNeumorphicTextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.baseColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withValues(alpha: 0.3),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.textColor, size: widget.iconSize),
              const SizedBox(width: 6),
            ],
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
