// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../../model/form/form_depot/basic/form_draft_model.dart';
//
// class FormDraftController extends GetxController {
//   static FormDraftController get to => Get.find();
//
//   final RxList<FormDraftModel> allDrafts = <FormDraftModel>[].obs;
//   final RxMap<FormType, String> lastSavedDraftIds = <FormType, String>{}.obs;
//   final RxBool isLoading = false.obs;
//
//   final GetStorage _box = GetStorage('form_drafts_storage');
//   // Storage keys
//   static const String _draftsKey = 'form_drafts_key';
//   static const String _lastSavedKeyPrefix = 'last_saved_draft_';
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadAllDrafts();
//     loadLastSavedDrafts();
//   }
//
//   // Load all drafts from storage
//   void loadAllDrafts() {
//     try {
//       isLoading.value = true;
//       final List<dynamic>? draftsData = _box.read<List<dynamic>>(_draftsKey);
//
//       if (draftsData != null) {
//         allDrafts.assignAll(
//             draftsData.map((draft) => FormDraftModel.fromMap(Map<String, dynamic>.from(draft))).toList()
//         );
//         // Sort by saved date (newest first)
//         allDrafts.sort((a, b) => b.savedAt.compareTo(a.savedAt));
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading drafts: $e');
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Load last saved draft IDs for all form types
//   void loadLastSavedDrafts() {
//     for (final formType in FormType.values) {
//       final lastSavedId = _box.read<String>('$_lastSavedKeyPrefix${formType.key}') ?? '';
//       if (lastSavedId.isNotEmpty) {
//         lastSavedDraftIds[formType] = lastSavedId;
//       }
//     }
//   }
//
//   // Save draft form (generic method)
//   Future<void> saveDraft({
//     required FormType formType,
//     required Map<String, dynamic> formData,
//     String? customTitle,
//     String? existingDraftId,
//   }) async
//   {
//     try {
//       isLoading.value = true;
//
//       final String draftId = existingDraftId ?? 'draft_${formType.key}_${DateTime.now().millisecondsSinceEpoch}';
//       final String title = customTitle ?? '${formType.displayName} - ${DateTime.now().toString().substring(0, 16)}';
//
//       final FormDraftModel draft = FormDraftModel(
//         id: draftId,
//         formType: formType,
//         data: formData,
//         savedAt: DateTime.now(),
//         title: title,
//       );
//
//       // Remove existing draft with same ID if updating
//       if (existingDraftId != null) {
//         allDrafts.removeWhere((d) => d.id == draftId);
//       }
//
//       // Add to current list (insert at beginning)
//       allDrafts.insert(0, draft);
//
//       // Save to storage
//       await _saveDraftsToStorage();
//
//       // Update last saved for this form type
//       lastSavedDraftIds[formType] = draftId;
//       await _box.write('$_lastSavedKeyPrefix${formType.key}', draftId);
//
//       Get.snackbar(
//         'Success',
//         '${formType.displayName} saved as draft',
//         snackPosition: SnackPosition.TOP,
//         duration: Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to save draft: $e',
//         snackPosition: SnackPosition.TOP,
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   // Get drafts by form type
//   List<FormDraftModel> getDraftsByType(FormType formType) {
//     return allDrafts.where((draft) => draft.formType == formType).toList();
//   }
//
//   // Get all draft types available
//   List<FormType> get availableFormTypes {
//     return allDrafts.map((draft) => draft.formType).toSet().toList();
//   }
//
//   // Load draft data by ID
//   Map<String, dynamic>? loadDraftData(String draftId) {
//     try {
//       final FormDraftModel? draft = allDrafts.firstWhereOrNull((d) => d.id == draftId);
//       return draft?.data;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading draft data: $e');
//       }
//       return null;
//     }
//   }
//
//   // Get draft by ID
//   FormDraftModel? getDraftById(String draftId) {
//     return allDrafts.firstWhereOrNull((draft) => draft.id == draftId);
//   }
//
//   // Get last saved draft for a specific form type
//   FormDraftModel? getLastSavedDraft(FormType formType) {
//     final lastSavedId = lastSavedDraftIds[formType];
//     if (lastSavedId != null) {
//       return getDraftById(lastSavedId);
//     }
//     return null;
//   }
//
//   // Delete a draft
//   Future<void> deleteDraft(String draftId) async {
//     try {
//       final draft = getDraftById(draftId);
//       allDrafts.removeWhere((draft) => draft.id == draftId);
//       await _saveDraftsToStorage();
//
//       // If deleted draft was the last saved for its type, clear that reference
//       if (draft != null) {
//         final lastSavedId = lastSavedDraftIds[draft.formType];
//         if (lastSavedId == draftId) {
//           lastSavedDraftIds.remove(draft.formType);
//           await _box.remove('$_lastSavedKeyPrefix${draft.formType.key}');
//         }
//       }
//
//       Get.snackbar(
//         'Success',
//         'Draft deleted',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to delete draft: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Delete all drafts for a specific form type
//   Future<void> deleteDraftsByType(FormType formType) async {
//     try {
//       allDrafts.removeWhere((draft) => draft.formType == formType);
//       await _saveDraftsToStorage();
//
//       // Clear last saved reference for this type
//       lastSavedDraftIds.remove(formType);
//       await _box.remove('$_lastSavedKeyPrefix${formType.key}');
//
//       Get.snackbar(
//         'Success',
//         'All ${formType.displayName} drafts deleted',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to delete drafts: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Delete all drafts
//   Future<void> deleteAllDrafts() async {
//     try {
//       allDrafts.clear();
//       lastSavedDraftIds.clear();
//       await _box.remove(_draftsKey);
//
//       // Remove all last saved keys
//       for (final formType in FormType.values) {
//         await _box.remove('$_lastSavedKeyPrefix${formType.key}');
//       }
//
//       Get.snackbar(
//         'Success',
//         'All drafts deleted',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to delete drafts: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Check if there are any saved drafts for a specific type
//   bool hasDraftsForType(FormType formType) {
//     return allDrafts.any((draft) => draft.formType == formType);
//   }
//
//   // Check if there are any saved drafts
//   bool get hasDrafts => allDrafts.isNotEmpty;
//
//   // Get draft count by type
//   int getDraftCountByType(FormType formType) {
//     return allDrafts.where((draft) => draft.formType == formType).length;
//   }
//
//   // Update draft title
//   Future<void> updateDraftTitle(String draftId, String newTitle) async {
//     try {
//       final int index = allDrafts.indexWhere((draft) => draft.id == draftId);
//       if (index != -1) {
//         final FormDraftModel updatedDraft = FormDraftModel(
//           id: draftId,
//           formType: allDrafts[index].formType,
//           data: allDrafts[index].data,
//           savedAt: allDrafts[index].savedAt,
//           title: newTitle,
//         );
//         allDrafts[index] = updatedDraft;
//         await _saveDraftsToStorage();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error updating draft title: $e');
//       }
//     }
//   }
//
//   // Private method to save drafts to storage
//   Future<void> _saveDraftsToStorage() async {
//     final List<Map<String, dynamic>> draftsData =
//     allDrafts.map((draft) => draft.toMap()).toList();
//     await _box.write(_draftsKey, draftsData);
//   }
// }