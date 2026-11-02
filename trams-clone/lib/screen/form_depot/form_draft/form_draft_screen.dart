import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/form_depot/form_draft_controller.dart';
import 'package:tram/model/shared/draft_status_model.dart';

import '../../../model/form/form_depot/form_draft/form_draft_model.dart';
import '../../../widget/form_depot/form_depot_text_scope.dart';

class FormDraftScreen extends StatefulWidget {
  const FormDraftScreen({super.key});

  @override
  State<FormDraftScreen> createState() => _FormDraftScreenState();
}

class _FormDraftScreenState extends State<FormDraftScreen> {
  final FormDraftController controller = Get.put(FormDraftController());

  final RxString selectedCategory = 'All'.obs;
  final List<String> categories = [
    'All',
    'Form B',
    'Form C',
    'Form G',
    'Form R'
  ];

  @override
  void initState() {
    super.initState();
    controller.fetchAllDrafts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Local Drafts",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Pending & Saved Inspections",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        color: const Color(0xfff3f8fe),
        leading: NeumorphicButton(
          padding: EdgeInsets.zero,
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          child: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategoryFilters(),
            Expanded(
              child: Obx(() {
                final filteredDrafts = controller.drafts.where((draft) {
                  if (selectedCategory.value == 'All') return true;
                  return draft.formType.trim() == selectedCategory.value;
                }).toList();

                if (filteredDrafts.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDrafts.length,
                  itemBuilder: (context, index) {
                    return _buildDraftCard(filteredDrafts[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // UI WIDGET BUILDERS
  // ==========================================

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Obx(() {
            final isSelected = selectedCategory.value == category;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: NeumorphicButton(
                onPressed: () => selectedCategory.value = category,
                style: NeumorphicStyle(
                  depth: isSelected ? -3 : 2,
                  intensity: 0.8,
                  color: isSelected
                      ? Colors.blue.withValues(alpha: 0.1)
                      : const Color(0xfff3f8fe),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            selectedCategory.value == 'All'
                ? "No drafts found."
                : "No drafts found for ${selectedCategory.value}.",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftCard(FormDraft draft) {
    Map<String, dynamic> formDataMap = {};
    try {
      formDataMap = jsonDecode(draft.formData);
    } catch (e) {
      debugPrint("Failed to parse draft JSON: $e");
    }

    return Neumorphic(
      margin: const EdgeInsets.only(bottom: 16),
      style: NeumorphicStyle(
        color: const Color(0xfff3f8fe),
        depth: 2,
        intensity: 0.8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side data
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.formType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // DYNAMIC CONTENT INJECTED HERE
                  _buildDraftDetails(draft, formDataMap),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(draft.status)
                              .withValues(alpha: 0.1),
                          border: Border.all(
                              color: _getStatusColor(draft.status), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(draft.status),
                          style: TextStyle(
                            color: _getStatusColor(draft.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Saved: ${_formatDate(draft.updatedAt)}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicButton(
                  onPressed: () => _showDeleteConfirmDialog(draft.id!),
                  style: const NeumorphicStyle(
                    depth: 2,
                    color: Color(0xfff3f8fe),
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 24),
                ),
                const SizedBox(width: 12),
                NeumorphicButton(
                  onPressed: () {
                    String parsedFormType =
                        draft.formType.replaceAll("Form ", "").trim();
                    Get.toNamed(
                      '/base_form',
                      arguments: {
                        'formType': parsedFormType,
                        'formPage': 'inspection',
                        'isResumeDraft': true,
                        'draftId': draft.id,
                      },
                    );
                  },
                  style: const NeumorphicStyle(
                    depth: 2,
                    color: Colors.blue,
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.edit_document,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Extracts dynamic data specific to Form B, Form C, or Generic Form types
  Widget _buildDraftDetails(FormDraft draft, Map<String, dynamic> formDataMap) {
    String firstNonEmpty(List<String> keys) {
      for (final key in keys) {
        final value = formDataMap[key]?.toString().trim() ?? '';
        if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
      }
      return '-';
    }

    final String refCode =
        formDataMap['referenceNo']?.toString().isNotEmpty == true
            ? formDataMap['referenceNo'].toString()
            : '-';

    if ({'Form B', 'Form C', 'Form G', 'Form R'}.contains(draft.formType)) {
      String iDateStr = formDataMap['inspection_date']?.toString() ?? '';
      String formattedInspDate = '-';

      if (iDateStr.isNotEmpty) {
        try {
          formattedInspDate =
              DateFormat('dd MMM yyyy').format(DateTime.parse(iDateStr));
        } catch (_) {
          formattedInspDate = iDateStr.split('T')[0];
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Ref. Code: $refCode",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Render Bridge Name ONLY for Form B
          if (draft.formType == 'Form B')
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                formDataMap['bridgeName']?.toString() ?? 'Unknown Bridge',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Package",
                  firstNonEmpty(const [
                    'packageId',
                    'packageID',
                    'packageName',
                    'ProjectName',
                  ]),
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "District",
                  firstNonEmpty(const [
                    'districtId',
                    'districtID',
                    'districtName',
                    'district',
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Road ID",
                  firstNonEmpty(const [
                    'roadId',
                    'roadID',
                    'roadName',
                    'RoadName',
                  ]),
                ),
              ),
              Expanded(child: _buildInfoItem("Insp. Date", formattedInspDate)),
            ],
          ),
        ],
      );
    }

    return Text(
      'Ref. Code: $refCode',
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ==========================================
  // HELPERS AND DIALOGS
  // ==========================================

  Color _getStatusColor(DraftStatus status) {
    switch (status) {
      case DraftStatus.draft:
        return Colors.orange;
      case DraftStatus.pendingSync:
        return Colors.blue;
      case DraftStatus.synced:
        return Colors.green;
      case DraftStatus.conflict:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(DraftStatus status) {
    switch (status) {
      case DraftStatus.draft:
        return 'Draft';
      case DraftStatus.pendingSync:
        return 'Pending Sync';
      case DraftStatus.synced:
        return 'Synced';
      case DraftStatus.conflict:
        return 'Conflict';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(String isoString) {
    try {
      final DateTime date = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return isoString;
    }
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
              color: const Color(0xfff3f8fe),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, spreadRadius: 2)
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
                      color: Colors.black87),
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
                    NeumorphicButton(
                      onPressed: () => Get.back(),
                      style: NeumorphicStyle(
                        depth: 2,
                        color: Colors.grey[300],
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: const Text("Cancel",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                    NeumorphicButton(
                      onPressed: () async {
                        await controller.deleteDraft(draftId);
                        Get.back();
                        SmartDialog.showToast("Draft deleted.");
                      },
                      style: NeumorphicStyle(
                        depth: 2,
                        color: Colors.redAccent,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: const Text("Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
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
}
