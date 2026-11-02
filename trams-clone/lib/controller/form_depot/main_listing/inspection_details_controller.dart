import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';

import '../../../model/form/form_depot/form_B/form_B_model.dart';
import '../../../model/form/form_depot/form_C/form_C_main_listing_details_model.dart';
import '../../../model/form/form_depot/form_C/form_C_model.dart';
import '../../../model/form/form_depot/form_R/form_R_model.dart';
import '../../../model/form/form_depot/main_listing/form_main_listing_details_model.dart';
import '../../../model/form/form_depot/main_listing/inspection_detail_model.dart';

class InspectionDetailsController extends GetxController {
  String recID = '';
  String insRecID = '';
  String formType = '';

  Rx<LoaderState> state = LoaderState.initial.obs;
  FormRepository repository = FormRepository(formType: '');
  Rx<dynamic> mainListingDetails = Rxn(); // Holds data for any form
  Rx<dynamic> formTitleMap = Rxn();

  Rx<dynamic> inspectionDetails = Rxn();
  //The structured list specifically for the UI
  RxList<dynamic> groupedInspectionData = <dynamic>[].obs;

  RxString status = "".obs;

  @override
  void onInit() async {
    super.onInit();

    recID = Get.arguments['recID'] ?? "";
    formType = Get.arguments['formType'] ?? "";

    // GRAB THE INSPECTION ID (Fallback to recID for Form C)
    insRecID = Get.arguments['insRecID'] ?? recID;
    status.value = Get.arguments['status']?.toString() ?? '';

    repository = FormRepository(formType: formType);
    await loadMainListingDetails();
    await loadInspectionDetails();
  }

  Future<void> loadMainListingDetails() async {
    try {
      state.value = LoaderState.loading;

      // --- 1. INTERCEPT PASSED DATA (BYPASS API FOR FORM C HEADER) ---
      if (formType.toLowerCase() == "c" &&
          Get.arguments['passedData'] != null) {
        mainListingDetails.value = Form_C_MainListingDetailsModel(
          httpStatus: "200",
          data: [Get.arguments['passedData']],
        );
        await loadTitle();
        state.value = LoaderState.loaded;
        return; // EXIT EARLY
      }

      final detailsResponse =
          await repository.showFormMainListingDetails(recID: recID);

      mainListingDetails.value = detailsResponse;
      mainListingDetails.refresh();

      await loadTitle();

      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log(err.toString());
      state.value = LoaderState.failure;
    }
  }

  Future<void> loadTitle() async {
    final details = mainListingDetails.value;
    if (details == null || details.data.isEmpty) {
      formTitleMap.value = [];
      state.value = LoaderState.failure;
      return;
    }
    final firstItem = details.data.first;
    if (firstItem is FormMainListingDetails) {
      formTitleMap.value = firstItem.getKeyValuePairs();
    } else {
      formTitleMap.value = [
        {"title": "Unknown Form", "value": "N/A"}
      ];
    }
  }

  Future<void> loadInspectionDetails() async {
    try {
      state.value = LoaderState.loading;

      var response;

      // --- FIX: WE MUST CALL THE API HERE TO GET THE DISTRESS/SEVERITY DATA ---
      if (formType.toLowerCase() == "c") {
        response =
            await repository.showInspectionDetailsFormC(insRecID: insRecID);
      } else {
        response = await repository.showInspectionDetails(recID: recID);
      }

      if (response.data.isEmpty) {
        groupedInspectionData.clear();
        state.value = LoaderState.loaded;
        return;
      }

      InspectionDetailModel? detailedModel;

      if (response is Form_B_InspectionDetailsModel) {
        detailedModel = response.data.first;
      } else if (response is Form_C_InspectionDetailsModel) {
        detailedModel = response.data.first;
      } else if (response is Form_G_InspectionDetailsModel) {
        detailedModel = response.data.first;
      } else if (response is Form_R_InspectionDetailsModel) {
        detailedModel = response.data.first;
        // -- Inject Form R specific fields into the Header
        if (response.data.isNotEmpty) {
          final rData = response.data.first;
          // Create a modifiable copy of the current header list
          List<dynamic> currentHeader = List.from(formTitleMap.value ?? []);

          // --- HELPER: Map Code to "Code: Description" ---
          String mapCode(String? code, Map<String, String> dataMap) {
            if (code == null || code.isEmpty) return "";
            final desc = dataMap[code] ?? "";
            return desc.isNotEmpty ? "$code: $desc" : code;
          }

          // ---------------------------------------------------------
          // 1. WALL FUNCTION
          // ---------------------------------------------------------
          String wallFunctionVal = "-";
          if (rData.wallFunction != null && rData.wallFunction!.isNotEmpty) {
            wallFunctionVal = rData.wallFunction!
                .map((c) => mapCode(c, FormRModel.wallFunctionData))
                .join("\n");
          }
          currentHeader.add({"Wall Function": wallFunctionVal});

          if (rData.wallFunctionOther?.isNotEmpty == true) {
            currentHeader
                .add({"Wall Function Other": rData.wallFunctionOther!});
          }

          // ---------------------------------------------------------
          // 2. WALL MEMBERS
          // ---------------------------------------------------------
          List<String> members = [];

          if (rData.wallMember1?.isNotEmpty == true) {
            members.add(mapCode(rData.wallMember1, FormRModel.wallMemberData));
          }
          if (rData.wallMember2?.isNotEmpty == true) {
            members.add(mapCode(rData.wallMember2, FormRModel.wallMemberData));
          }
          if (rData.wallMember3?.isNotEmpty == true) {
            members.add(mapCode(rData.wallMember3, FormRModel.wallMemberData));
          }

          String wallMembersVal = members.isNotEmpty ? members.join("\n") : "-";
          currentHeader.add({"Wall Members": wallMembersVal});

          if (rData.wallMemberOther?.isNotEmpty == true) {
            currentHeader.add({"Wall Member Other": rData.wallMemberOther!});
          }

          // ---------------------------------------------------------
          // 3. FACING TYPES
          // ---------------------------------------------------------
          List<String> facings = [];

          if (rData.facingType1?.isNotEmpty == true) {
            facings.add(mapCode(rData.facingType1, FormRModel.facingTypeData));
          }
          if (rData.facingType2?.isNotEmpty == true) {
            facings.add(mapCode(rData.facingType2, FormRModel.facingTypeData));
          }
          if (rData.facingType3?.isNotEmpty == true) {
            facings.add(mapCode(rData.facingType3, FormRModel.facingTypeData));
          }

          String facingTypesVal = facings.isNotEmpty ? facings.join("\n") : "-";
          currentHeader.add({"Facing Types": facingTypesVal});

          if (rData.facingTypeOther?.isNotEmpty == true) {
            currentHeader.add({"Facing Type Other": rData.facingTypeOther!});
          }

          // Update the UI
          formTitleMap.value = currentHeader;
        }
      } else {
        Get.log("Unknown form model type: ${response.runtimeType}");
      }

      //Generate the groups if we found a valid model
      if (detailedModel != null) {
        groupedInspectionData.value = detailedModel.getInspectionGroups();
      } else {
        groupedInspectionData.clear();
      }

      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log(err.toString());
      state.value = LoaderState.failure;
    }
  }

  DateTime parseDMY(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime(1900); // fallback for null
    }

    final parts = date.split('-');
    if (parts.length != 3) {
      return DateTime(1900); // fallback for invalid format
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return DateTime(1900); // fallback if parsing fails
    }

    return DateTime(year, month, day);
  }
}
