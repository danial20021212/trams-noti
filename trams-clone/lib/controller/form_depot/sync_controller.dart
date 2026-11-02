// import 'dart:convert';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../model/form/form_depot/common/remarks_model.dart';
// import '../../model/form/form_depot/form_draft/form_draft_model.dart';
// import '../../model/shared/draft_status_model.dart';
// import '../../repository/bridge_type_repository.dart';
// import '../../repository/form_repository.dart';
// import '../../repository/pavement_repository.dart';
// import '../auth/auth_controller.dart';
// import 'form_draft_controller.dart';
// import 'main_listing/main_listing_filter_controller.dart';
//
// class SyncController extends GetxController {
//   final Connectivity _connectivity = Connectivity();
//
//   bool _isGlobalSyncing = false;
//   bool isSyncingDraft = false;
//   bool isSyncingBridgeType = false;
//   bool isSyncingDistress = false;
//   bool isSyncingRouting = false;
//
//   final AuthController auth = Get.find<AuthController>();
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // 1. Listen for network changes automatically
//     _connectivity.onConnectivityChanged
//         .listen((List<ConnectivityResult> results) {
//       if (results.contains(ConnectivityResult.mobile) ||
//           results.contains(ConnectivityResult.wifi)) {
//         _performGlobalSync();
//       }
//     });
//   }
//
//   Future<void> _performGlobalSync() async {
//     final token = auth.accessToken();
//     // Don't show snackbars or attempt sync if the user isn't logged in
//     if (token == null || token.toString().trim().isEmpty || token == "null") {
//       return;
//     }
//
//     if (_isGlobalSyncing) return;
//     _isGlobalSyncing = true;
//
//     // --- 1. SHOW START SNACKBAR ---
//     Get.snackbar(
//       "Sync Started 🔄",
//       "Backing up drafts and fetching latest reference data...",
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(10),
//       borderRadius: 8,
//       duration: const Duration(seconds: 3), // Dismisses after 3 seconds
//       isDismissible: true,
//     );
//
//     try {
//       // --- 2. RUN BOTH SYNCS CONCURRENTLY ---
//       // Using Future.wait runs both tasks at the same time and waits for both to finish
//       await Future.wait([
//         _syncPendingDrafts(),
//         _syncReferenceData(),
//       ]);
//
//       // --- 3. SHOW SUCCESS SNACK BAR ---
//       Get.snackbar(
//         "Sync Complete ✅",
//         "All offline data is up to date.",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green.withValues(alpha: 0.9),
//         colorText: Colors.white,
//         margin: const EdgeInsets.all(10),
//         borderRadius: 8,
//         duration: const Duration(seconds: 4),
//       );
//     } catch (e) {
//       // --- 4. SHOW ERROR SNACK BAR (Optional) ---
//       Get.snackbar(
//         "Sync Interrupted ⚠️",
//         "Some data could not be synced. We will retry later.",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
//         colorText: Colors.white,
//         margin: const EdgeInsets.all(10),
//         duration: const Duration(seconds: 4),
//       );
//       Get.log("Global sync failed: $e");
//     } finally {
//       _isGlobalSyncing = false;
//     }
//   }
//
//   Future<void> _syncPendingDrafts() async {
//     final token = auth.accessToken();
//     if(token == null) return; // Prevent syncing if not logged in
//     if (isSyncingDraft) return; // Prevent overlapping syncs
//     isSyncingDraft = true;
//
//     try {
//       final formDraftController = Get.find<FormDraftController>();
//
//       // Fetch all drafts where status is 'PendingSync'
//       List<FormDraft> pendingDrafts =
//           await formDraftController.getDraftsByStatus(DraftStatus.pendingSync);
//
//       if (pendingDrafts.isEmpty) {
//         isSyncingDraft = false;
//         return;
//       }
//
//       for (var draft in pendingDrafts) {
//         await _uploadSingleDraft(draft, formDraftController);
//       }
//     } catch (e) {
//       Get.log("Sync process error: $e");
//     } finally {
//       isSyncingDraft = false;
//     }
//   }
//
//   // --- SYNC OFFLINE REFERENCE DATA ---
//   Future<void> _syncReferenceData() async {
//     final token = auth.accessToken();
//     if (token == null) return;
//
//     await _syncBridgeType();
//     await _syncDistressData();
//     await _syncRoutingData();
//
//   }
//
//   Future<void> _syncBridgeType() async {
//     if (isSyncingBridgeType) return;
//     isSyncingBridgeType = true;
//
//     final btRepository = BridgeTypeRepository();
//
//     try {
//       Get.log("Fetching latest reference data (Bridge Types)...");
//
//       // 1. Create a list of keys in the EXACT same order as the Future.wait calls
//       final List<String> cacheKeys = [
//         'cache_superstructure',
//         'cache_parapet',
//         'cache_bearing',
//         'cache_expansion',
//         'cache_deck',
//         'cache_abutment',
//         'cache_pier',
//       ];
//
//       // 2. Fetch the data
//       final results = await Future.wait([
//         btRepository.showFilterBtSuperstructure(),
//         btRepository.showFilterBtParapet(),
//         btRepository.showFilterBtBearing(),
//         btRepository.showFilterBtExpansion(),
//         btRepository.showFilterBtDeck(),
//         btRepository.showFilterBtAbutment(),
//         btRepository.showFilterBtPier(),
//       ]).timeout(const Duration(seconds: 15));
//
//       // 3. The Magic Loop: dynamically save all 7 lists!
//       for (int i = 0; i < results.length; i++) {
//         // results[i] represents the FilterBridgeTypeModel for this specific loop
//         if (results[i].data.isNotEmpty) {
//           box.write(
//               cacheKeys[i],
//               results[i].data.map((e) => e.toJson()).toList()
//           );
//         }
//       }
//
//       Get.log("Successfully cached all reference data (FilterBridgeTypeModel)");
//
//     } catch (e) {
//       Get.log("Failed to sync reference data: $e");
//     } finally {
//       isSyncingBridgeType = false;
//     }
//   }
//
//   Future<void> _syncDistressData() async {
//     final token = auth.accessToken();
//     if (token == null) return;
//
//     if (isSyncingDistress) return;
//     isSyncingDistress = true;
//
//     // TODO: Replace with the exact repository class you use for showDistress
//     // if it is not FormRepository.
//     final repository = FormRepository(formType: '');
//
//     try {
//       Get.log("Fetching latest reference data (Distress)...");
//
//       // 1. Create a list of groups to iterate through
//       final List<String> groups = [
//         'P1', 'P2', 'P3', 'P4', 'P5',
//         'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7'
//       ];
//
//       // 2. Generate cache keys dynamically based on the groups
//       final List<String> cacheKeys = groups.map((g) => 'cache_distress_$g').toList();
//
//       // 3. Fetch all distress data concurrently
//       final results = await Future.wait(
//           groups.map((group) => repository.showDistress(distressGroup: group))
//       ).timeout(const Duration(seconds: 20));
//
//       // 4. Save to GetStorage dynamically
//       for (int i = 0; i < results.length; i++) {
//         if (results[i].data.isNotEmpty) {
//           box.write(
//               cacheKeys[i],
//               results[i].data.map((e) => e.toJson()).toList()
//           );
//         }
//       }
//
//       Get.log("Successfully cached all Distress reference data");
//
//     } catch (e) {
//       Get.log("Failed to sync Distress data: $e");
//     } finally {
//       isSyncingDistress = false;
//     }
//   }
//
//   // --- SYNC OFFLINE ROUTING DATA (Packages, Districts, Routes) ---
//   Future<void> _syncRoutingData() async {
//     final token = auth.accessToken();
//     if (token == null) return;
//
//     if (isSyncingRouting) return;
//     isSyncingRouting = true;
//
//     final pavementRepository = PavementRepository();
//
//     try {
//       Get.log("Fetching latest reference data (Routing: Packages, Districts, Routes)...");
//
//       // 1. Fetch Packages
//       final packageRes = await pavementRepository.showFilterPackage()
//           .timeout(const Duration(seconds: 15));
//
//       if (packageRes.tblPackage.isNotEmpty) {
//         // Cache all packages
//         box.write('cache_packages', packageRes.tblPackage.map((e) => e.toJson()).toList());
//
//         // 2. Loop through each Package to fetch its Districts
//         for (var pkg in packageRes.tblPackage) {
//           final String pkgId = pkg.packageId;
//
//           try {
//             final districtRes = await pavementRepository.showFilterDistrict(pkgId)
//                 .timeout(const Duration(seconds: 15));
//
//             if (districtRes.tblDistrict.isNotEmpty) {
//               // Cache districts dynamically using the Package ID
//               box.write('cache_districts_$pkgId', districtRes.tblDistrict.map((e) => e.toJson()).toList());
//
//               // 3. Loop through each District to fetch its Routes
//               for (var dist in districtRes.tblDistrict) {
//                 final String distId = dist.districtId;
//
//                 try {
//                   final routeRes = await pavementRepository.showFilterRoute(pkgId, distId)
//                       .timeout(const Duration(seconds: 15));
//
//                   if (routeRes.tblRoute.isNotEmpty) {
//                     // Cache routes dynamically using both Package ID and District ID
//                     box.write('cache_routes_${pkgId}_$distId', routeRes.tblRoute.map((e) => e.toJson()).toList());
//                   }
//                 } catch (e) {
//                   Get.log("Failed to fetch Routes for Pkg: $pkgId, Dist: $distId - $e");
//                   // Continue the loop even if one specific route fetch fails
//                 }
//               }
//             }
//           } catch (e) {
//             Get.log("Failed to fetch Districts for Pkg: $pkgId - $e");
//           }
//         }
//       }
//
//       Get.log("Successfully cached all Routing reference data!");
//
//       // If the user is currently on the Filter screen, silently update their dropdowns with the new cache!
//       if (Get.isRegistered<MainListingFilterController>()) {
//         Get.find<MainListingFilterController>().initialLoad(initial: true);
//       }
//
//     } catch (e) {
//       Get.log("Failed to sync Routing data: $e");
//     } finally {
//       isSyncingRouting = false;
//     }
//   }
//
//   // Handle the actual API upload
//   Future<void> _uploadSingleDraft(
//       FormDraft draft, FormDraftController db) async
//   {
//     try {
//       // Decode the saved JSON data from SQLite
//       Map<String, dynamic> formData = jsonDecode(draft.formData);
//       String formLetter = draft.formType
//           .replaceAll(RegExp(r'Form\s+', caseSensitive: false), '')
//           .trim();
//
//       // Check if we already have a recID from a previous partial sync
//       String? latestRecId = formData['recID']?.toString();
//
//       // --- STEP A: Submit Main Form (ONLY IF NOT SUBMITTED YET) ---
//       if (latestRecId == null || latestRecId.isEmpty) {
//         Get.log("Syncing Main Form $formLetter (Draft ID: ${draft.id})...");
//
//         // --- Duplicate Check: Does this date already exist? ---
//         bool isDuplicate = await _isInspectionDateExists(formData, formLetter);
//
//         if (isDuplicate) {
//           // Mark as conflict and halt this specific draft's upload
//           draft.status = DraftStatus.conflict;
//           draft.errorLog = "An inspection already exists for this date and route.";
//           await db.updateDraft(draft);
//           return; // EXIT the function, move to the next draft in the loop
//         }
//
//         final repo = FormRepository(formType: formLetter);
//         final res = await repo
//             .submitNewInspectionForm(mapForm: formData)
//             .timeout(const Duration(seconds: 15));
//
//         if (res.data == null || res.data["recID"] == null) {
//           throw Exception("Invalid API response: Missing recID");
//         }
//
//         latestRecId = res.data["recID"].toString();
//
//         // CRITICAL FIX: Save the recID to SQLite IMMEDIATELY.
//         // If the media upload fails right after this, the app will remember
//         // that the main form is already on the server.
//         formData['recID'] = latestRecId;
//         draft.formData = jsonEncode(formData);
//         await db.updateDraft(draft);
//
//         await Future.delayed(const Duration(milliseconds: 500));
//       } else {
//         Get.log("Form already submitted (RecID: $latestRecId). Resuming media upload...");
//       }
//
//       // --- STEP B: Submit Photos & Remarks ---
//       await _uploadDraftMedia(latestRecId, draft, formData, formLetter);
//
//       // --- SUCCESS ---
//       draft.status = DraftStatus.synced;
//       await db.updateDraft(draft);
//
//       Get.log("Successfully synced draft ID: ${draft.id} (RecID: $latestRecId)");
//     } catch (e) {
//       _handleSyncFailure(draft, db, e.toString());
//     }
//   }
//
//
//   // Handles the delivery of heavy media payloads with granular queue reduction
//   Future<void> _uploadDraftMedia(String recId, FormDraft draft,
//       Map<String, dynamic> formData, String formLetter) async
//   {
//
//     final repo = FormRepository(formType: formLetter);
//
//     try {
//       // Populate your Remarks model using the saved SQLite formData
//       // We inject the NEW recId we just got from Step A
//       final remarks = Remarks(
//         recID: recId,
//         spRemarksPartB: formData['sp_remarks_partB'] ?? "",
//         consRemarksPartB: formData['cons_remarks_partB'] ?? "",
//         spRemarksPartC: formData['sp_remarks_partC'] ?? "",
//         consRemarksPartC: formData['cons_remarks_partC'] ?? "",
//         spRemarksPartD: formData['sp_remarks_partD'] ?? "",
//         consRemarksPartD: formData['cons_remarks_partD'] ?? "",
//       );
//
//       // Use your existing repository method
//       await repo.submitFormRemark(mapForm: remarks.toJson());
//       Get.log("Remarks synced successfully for recID: $recId");
//     } catch (e) {
//       throw Exception("Failed to sync remarks: $e");
//     }
//
//     if (draft.mediaPaths != null && draft.mediaPaths!.isNotEmpty) {
//       List<dynamic> paths = jsonDecode(draft.mediaPaths!);
//
//       // Create a mutable queue to track pending uploads
//       List<dynamic> remainingPaths = List.from(paths);
//
//       for (int i = 0; i < paths.length; i++) {
//         String localPath = paths[i];
//
//         try {
//           File imageFile = File(localPath);
//           if (!await imageFile.exists()) {
//             remainingPaths.remove(localPath);
//             continue; // Skip missing files to prevent execution blocks
//           }
//
//           List<int> imageBytes = await imageFile.readAsBytes();
//           String base64Photo = base64Encode(imageBytes);
//           String currentPhotoNo = (i + 1).toString();
//
//           await repo.uploadFormPhoto(
//             recID: recId,
//             photo: base64Photo,
//             photoNo: currentPhotoNo,
//           );
//
//           // QUEUE REDUCTION: Remove successfully uploaded photo and update local DB
//           remainingPaths.remove(localPath);
//           draft.mediaPaths = jsonEncode(remainingPaths);
//
//           final db = Get.find<FormDraftController>();
//           await db.updateDraft(draft);
//
//         } catch (e) {
//           // Bubble up the exception to halt the sync, preserving the remaining queue
//           throw Exception("Failed to sync photo ${i + 1}: $e");
//         }
//       }
//     }
//   }
//
//
//   // --- Duplicate Prevention Check ---
//   Future<bool> _isInspectionDateExists(
//       Map<String, dynamic> formData, String formLetter) async
//   {
//     try {
//       // 1. Extract necessary IDs from the draft's JSON data
//       final packageID = formData['packageId']?.toString();
//       final districtID = formData['districtId']?.toString();
//       final routeID = formData['roadId']?.toString();
//       final draftDate = formData['inspection_date']?.toString();
//       final draftRefNo = formData['reference_no']?.toString();
//
//       // If missing critical routing data, we can't reliably check.
//       if (packageID == null || districtID == null || routeID == null || draftDate == null || draftRefNo == null) {
//         Get.log("Missing routing, date, or reference data in draft. Skipping duplicate check.");
//         return false;
//       }
//
//       // 2. Fetch the existing listings from the server
//       final repo = FormRepository(formType: formLetter);
//       final responseData = await repo.showFormMainListing(
//         packageID: packageID,
//         districtID: districtID,
//         routeID: routeID,
//       );
//
//       // 3. Compare dates AND reference numbers
//       List<dynamic> existingRecords = responseData.data;
//       for (var record in existingRecords) {
//
//         // Check if both the date AND the reference number match
//         // Note: Ensure 'record.referenceNo' matches the exact property name in your response model
//         final bool isSameDate = parseDMY(record.inspectionDate) == parseDMY(draftDate);
//         final bool isSameRef = record.referenceNo?.toString() == draftRefNo;
//
//         if (isSameDate && isSameRef) {
//           Get.log("Duplicate found! Form $formLetter for Route $routeID already has an inspection on $draftDate with reference $draftRefNo.");
//           return true; // The duplicate exists!
//         }
//       }
//       return false; // No duplicate found
//     } catch (e) {
//       Get.log("Error checking existing records: $e");
//       throw Exception("Validation failed: Could not verify existing records.");
//     }
//   }
//
//
//   // Handle failures and max retries
//   Future<void> _handleSyncFailure(
//       FormDraft draft, FormDraftController db, String error) async {
//     Get.log("Failed to sync draft ID: ${draft.id}. Error: $error");
//
//     draft.syncRetryCount += 1;
//     draft.errorLog = error;
//
//     // Circuit Breaker: Halt automated retries after 3 failed attempts
//     if (draft.syncRetryCount >= 3) {
//       draft.status = DraftStatus.conflict;
//     }
//
//     await db.updateDraft(draft);
//   }
//
//
//   DateTime parseDMY(String? date) {
//     if (date == null || date.isEmpty) {
//       return DateTime(1900); // fallback for null
//     }
//
//     final parts = date.split('-');
//     if (parts.length != 3) {
//       return DateTime(1900); // fallback for invalid format
//     }
//
//     final day = int.tryParse(parts[0]);
//     final month = int.tryParse(parts[1]);
//     final year = int.tryParse(parts[2]);
//
//     if (day == null || month == null || year == null) {
//       return DateTime(1900); // fallback if parsing fails
//     }
//
//     return DateTime(year, month, day);
//   }
// }
