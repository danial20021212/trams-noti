// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/model/form/form_depot/common/distress_model.dart';
import 'package:tram/model/form/form_depot/common/remarks_model.dart';
import 'package:tram/model/form/form_depot/common/signature_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_main_listing_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_search_model.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_model.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_model.dart';
import 'package:tram/model/form/form_depot/form_R/form_R_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_model.dart';
import 'package:tram/model/form/form_depot/common/form_photo_listing_model.dart';
import 'package:tram/model/form/form_depot/form_R/form_R_model.dart';
import 'package:tram/provider/api_provider.dart';

import '../model/form/form_depot/form_C/form_C_main_listing_model.dart';
import '../model/form/form_depot/form_C/form_C_search_model.dart';

class FormRepository {
  final String formType;
  final ApiProvider provider = Get.find<ApiProvider>();

  FormRepository({required this.formType});

  Future<FormMainListingDataModel> searchForm({
    required String packageID,
    required String searchBox, //for search Bridge Name
  }) async {
    var res;
    Map<String, String> mapForm = {
      "packageId": packageID,
      "searchBox": searchBox,
    };

    res = await provider.store(
      UrlStorage().formSearch(formType: formType),
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return FormMainListingDataModel.fromJson(res.data);
  }

  Future<FormBSearchDataModel> searchFormB({
    required String packageID,
    String? division,
    String? roadID,
    required String searchBox, //for search Bridge Name
  }) async {
    var res;
    final Map<String, String> mapForm = {
      "packageId": packageID,
      "division": division ?? "",
      "roadId": roadID ?? "",
      "searchBox": searchBox,
    };

    res = await provider.store(
      UrlStorage.formBSearch,
      data: mapForm,
    );

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return FormBSearchDataModel.fromJson(res.data);
  }

  Future<FormCSearchDataModel> searchFormC({
    required String packageID,
    required String searchBox, //for search Bridge Name
  }) async {
    var res;
    Map<String, String> mapForm = {
      "packageId": packageID,
      "searchBox": searchBox,
    };

    res = await provider.store(
      UrlStorage().formSearch(formType: formType),
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return FormCSearchDataModel.fromJson(res.data);
  }

  // Future<FormMainListingDataModel> showFormMainListing({
  //   required String packageID,
  //   required String districtID,
  //   required String routeID,
  // }) async {
  //   var res;
  //   Map<String, String> mapForm = {
  //     "packageId": packageID,
  //     "districtId": districtID,
  //     "routeId": routeID,
  //   };

  //   res = await provider.store(
  //     UrlStorage().formMainListing(formType: formType),
  //     data: mapForm,
  //   );

  //   if (res.statusCode != 200) throw res;
  //   if (res.data["http_status"] != "Success.") throw res;

  //   return FormMainListingDataModel.fromJson(res.data);
  // }
  Future<FormMainListingDataModel> showFormMainListing({
    required String packageID,
    required String districtID,
    required String routeID,
  }) async {
    var res;
    Map<String, String> mapForm = {
      "packageId": packageID,
      "districtId": districtID,
      "routeId": routeID,
    };

    final url = UrlStorage().formMainListing(formType: formType);
    // This method is shared with other forms, so only print for Form G.
    final bool debugG = formType.toUpperCase() == 'G';

    if (debugG) {
      debugPrint('\n========== FORM G MAIN LISTING API DEBUG ==========');
      debugPrint('URL: $url');
      debugPrint('formType: $formType');
      debugPrint('Body keys: ${mapForm.keys.toList()} '
          '(+ access_token, userName added by interceptor)');
      debugPrint('Request body: ${jsonEncode(mapForm)}');
    }

    try {
      res = await provider.store(url, data: mapForm);

      if (debugG) {
        debugPrint('Status code: ${res.statusCode}');
        debugPrint(
            'Response keys: ${res.data is Map ? res.data.keys.toList() : "not a map"}');
        if (res.data is Map) {
          debugPrint('http_status: ${res.data["http_status"]}');
          final rawData = res.data["data"];
          debugPrint('data type: ${rawData.runtimeType}');
          if (rawData is List) {
            debugPrint('data length: ${rawData.length}');
            if (rawData.isNotEmpty && rawData.first is Map) {
              debugPrint(
                  'First item keys: ${(rawData.first as Map).keys.toList()}');
            }
          }
        }
        _printLong('Full response: ${jsonEncode(res.data)}');
        debugPrint('===================================================\n');
      }

      if (res.statusCode != 200) throw res;
      if (res.data["http_status"] != "Success.") throw res;

      return FormMainListingDataModel.fromJson(res.data);
    } catch (e, stackTrace) {
      if (debugG) {
        debugPrint('\n========== FORM G MAIN LISTING API ERROR ==========');
        debugPrint('URL: $url');
        debugPrint('Request body: ${jsonEncode(mapForm)}');
        debugPrint('Error: $e');
        debugPrint('StackTrace: $stackTrace');
        debugPrint('===================================================\n');
      }
      rethrow;
    }
  }

  Future<FormBMainListingDataModel> showFormBMainListing2({
    required String parentID,
  }) async {
    var res;
    Map<String, String> mapForm = {"parentID": parentID};

    res = await provider.store(
      UrlStorage.formBMainListing,
      data: mapForm,
    );

    debugPrint('\n========== FORM B LISTING API DEBUG ==========');
    debugPrint('URL: ${UrlStorage.formBMainListing}');
    debugPrint('Payload: $mapForm');
    debugPrint('Status code: ${res.statusCode}');
    debugPrint(
        'Response keys: ${res.data is Map ? res.data.keys.toList() : "not a map"}');
    if (res.data is Map && res.data["data"] is List) {
      final list = res.data["data"] as List;
      debugPrint('data length: ${list.length}');
      if (list.isNotEmpty && list.first is Map) {
        debugPrint('First item keys: ${(list.first as Map).keys.toList()}');
        debugPrint('First item: ${jsonEncode(list.first)}');
      }
    }
    _printLong('Full response: ${jsonEncode(res.data)}');
    debugPrint('===============================================\n');

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return FormBMainListingDataModel.fromJson(res.data);
  }

  Future<FormCMainListingDataModel> showFormCMainListing({
    required String packageID,
    required String districtID,
    required String routeID,
  }) async {
    var res;
    Map<String, String> mapForm = {
      "packageId": packageID,
      "districtId": districtID,
      "roadId": routeID,
    };

    debugPrint('=== showFormCMainListing Request ===');
    debugPrint('URL: ${UrlStorage.formCMainListing}');
    debugPrint('Payload: $mapForm');

    res = await provider.store(
      UrlStorage.formCMainListing,
      data: mapForm,
    );

    debugPrint('=== showFormCMainListing Response ===');
    debugPrint(
        'Raw response keys: ${res.data is Map ? res.data.keys.toList() : "not a map"}');
    if (res.data is Map &&
        res.data["data"] is List &&
        (res.data["data"] as List).isNotEmpty) {
      debugPrint(
          'First item raw: ${jsonEncode((res.data["data"] as List).first)}');
      debugPrint(
          'First item keys: ${(res.data["data"] as List).first is Map ? (res.data["data"] as List).first.keys.toList() : "not a map"}');
    }
    debugPrint('===================================');

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return FormCMainListingDataModel.fromJson(res.data);
  }

  Future<dynamic> showFormMainListingDetails({required String recID}) async {
    Map<String, String> mapForm = {"recID": recID};
    dynamic details;

    final url = UrlStorage().formMainListingDetails(formType: formType);

    debugPrint('\n========== MAIN LISTING DETAILS API DEBUG ==========');
    debugPrint('URL: $url');
    debugPrint('formType: $formType');
    debugPrint('Request body: ${jsonEncode(mapForm)}');

    var res = await provider.store(url, data: mapForm);

    debugPrint(
        'Raw response keys: ${res.data is Map ? res.data.keys.toList() : "not a map"}');
    debugPrint('Raw response: ${jsonEncode(res.data)}');
    debugPrint('====================================================\n');

    debugPrint('\n========== MAIN LISTING DETAILS RESPONSE ==========');
    debugPrint('Status code: ${res.statusCode}');
    if (res.data is Map) {
      debugPrint('Response keys: ${res.data.keys.toList()}');
      final rawData = res.data["data"];
      debugPrint('data type: ${rawData.runtimeType}');
      if (rawData is List) {
        debugPrint('data length: ${rawData.length}');
        if (rawData.isNotEmpty && rawData.first is Map) {
          debugPrint(
              'First item keys: ${(rawData.first as Map).keys.toList()}');
        }
      }
    }
    _printLong('Full response: ${jsonEncode(res.data)}');
    debugPrint('====================================================\n');

    switch (formType) {
      case 'B':
        details = Form_B_MainListingDetailsModel.fromJson(res.data);
        break;

      case 'C':
        details = Form_C_MainListingDetailsModel.fromJson(res.data);
        break;

      case 'G':
        details = Form_G_MainListingDetailsModel.fromJson(res.data);
        break;

      case 'R':
        details = Form_R_MainListingDetailsModel.fromJson(res.data);
        break;

      default:
        throw res;
    }

    debugPrint('\n========== PARSED MAIN LISTING DETAILS ==========');
    if (details.data.isNotEmpty) {
      final item = details.data.first;
      if (item is Form_B_MainListingDetailsDataModel) {
        debugPrint('inspectionDate: "${item.inspectionDate}"');
        debugPrint('projectName: "${item.projectName}"');
        debugPrint('district: "${item.district}"');
        debugPrint('roadId: "${item.roadId}"');
        debugPrint('referenceNo: "${item.referenceNo}"');
        debugPrint('riverName: "${item.riverName}"');
        debugPrint('chainage: "${item.chainage}"');
        debugPrint('structureCode: "${item.structureCode}"');
        debugPrint('gpsEasting: "${item.gpsEasting}"');
        debugPrint('gpsNorthing: "${item.gpsNorthing}"');
        debugPrint('superstructure: "${item.superstructure}"');
        debugPrint('parapet: "${item.parapet}"');
        debugPrint('bearing: "${item.bearing}"');
        debugPrint('expansion: "${item.expansion}"');
        debugPrint('noOfExpansion: "${item.noOfExpansion}"');
        debugPrint('deck: "${item.deck}"');
        debugPrint('abutment: "${item.abutment}"');
        debugPrint('pier: "${item.pier}"');
        debugPrint('status: "${item.status}"');
      }
    }
    debugPrint('==================================================\n');

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return details;
  }

  Future<dynamic> showFormCMainListingDetails({required String recID}) async {
    Map<String, String> mapForm = {"recID": recID};
    debugPrint('=== showFormCMainListingDetails ===');
    debugPrint('URL: ${UrlStorage.formCMainListingDetails}');
    debugPrint('Payload: $mapForm');
    dynamic details;

    var res = await provider.store(
      UrlStorage.formCMainListingDetails,
      data: mapForm,
    );

    debugPrint('showFormCMainListingDetails status: ${res.statusCode}');
    debugPrint(
        'Raw response keys: ${res.data is Map ? res.data.keys.toList() : "not a map"}');
    if (res.data is Map &&
        res.data["data"] is List &&
        (res.data["data"] as List).isNotEmpty) {
      debugPrint(
          'First item keys: ${(res.data["data"] as List).first is Map ? (res.data["data"] as List).first.keys.toList() : "not a map"}');
    }
    _printLong('showFormCMainListingDetails response: ${jsonEncode(res.data)}');

    details = Form_C_MainListingDetailsModel.fromJson(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return details;
  }

  Future<dynamic> showInspectionDetails({required String recID}) async {
    Map<String, String> mapForm = {"recID": recID};
    dynamic details;

    final url = UrlStorage().formInspectionDetails(formType: formType);

    debugPrint('\n========== INSPECTION DETAILS API DEBUG ==========');
    debugPrint('URL: $url');
    debugPrint('formType: $formType');
    debugPrint('Request body (before interceptor): ${jsonEncode(mapForm)}');
    debugPrint('==================================================\n');

    var res = await provider.store(url, data: mapForm);

    debugPrint('\n========== API RESPONSE DEBUG ==========');
    debugPrint('Status code: ${res.statusCode}');
    debugPrint('Response headers: ${res.headers}');
    debugPrint('Response data type: ${res.data.runtimeType}');

    if (res.data is Map) {
      debugPrint('Response keys: ${res.data.keys.toList()}');
      debugPrint('http_status: ${res.data["http_status"]}');
      final rawData = res.data["data"];
      debugPrint('data type: ${rawData.runtimeType}');
      if (rawData is List) {
        debugPrint('data length: ${rawData.length}');
        if (rawData.isNotEmpty) {
          final firstItem = rawData.first;
          debugPrint('First item type: ${firstItem.runtimeType}');
          if (firstItem is Map) {
            debugPrint('First item keys: ${firstItem.keys.toList()}');
          }
        }
      }
    }
    _printLong('Full response body: ${jsonEncode(res.data)}');
    debugPrint('========================================\n');

    switch (formType) {
      case 'B':
        details = Form_B_InspectionDetailsModel.fromJson(res.data);
        break;

      case 'C':
        details = Form_C_InspectionDetailsModel.fromJson(res.data);
        break;

      case 'R':
        details = Form_R_InspectionDetailsModel.fromJson(res.data);
        break;

      case 'G':
        details = Form_G_InspectionDetailsModel.fromJson(res.data);
        break;

      default:
        throw res;
    }

    if (details is Form_B_InspectionDetailsModel) {
      debugPrint('\n========== PARSED MODEL DEBUG ==========');
      debugPrint('Parsed data count: ${details.data.length}');
      if (details.data.isNotEmpty) {
        final first = details.data.first;
        debugPrint('recID: "${first.recID}"');
        debugPrint('parentID: "${first.parentID}"');
        debugPrint('bridgeName: "${first.bridgeName}"');
        debugPrint('riverName: "${first.riverName}"');
        debugPrint('referenceNo: "${first.referenceNo}"');
        debugPrint('inspectionDate: "${first.inspectionDate}"');
        debugPrint('p1Distress: "${first.p1Distress}"');
        debugPrint('p1Severity: "${first.p1Severity}"');
        debugPrint('p2Distress: "${first.p2Distress}"');
        debugPrint('p2Severity: "${first.p2Severity}"');
        debugPrint('p3Distress: "${first.p3Distress}"');
        debugPrint('p3Severity: "${first.p3Severity}"');
        debugPrint('p4Distress: "${first.p4Distress}"');
        debugPrint('p4Severity: "${first.p4Severity}"');
        debugPrint('p5Distress: "${first.p5Distress}"');
        debugPrint('p5Severity: "${first.p5Severity}"');
        debugPrint('s1Distress: "${first.s1Distress}"');
        debugPrint('s1Severity: "${first.s1Severity}"');
        debugPrint('s2Distress: "${first.s2Distress}"');
        debugPrint('s2Severity: "${first.s2Severity}"');
        debugPrint('s3Distress: "${first.s3Distress}"');
        debugPrint('s3Severity: "${first.s3Severity}"');
        debugPrint('s4Distress: "${first.s4Distress}"');
        debugPrint('s4Severity: "${first.s4Severity}"');
        debugPrint('s5Distress: "${first.s5Distress}"');
        debugPrint('s5Severity: "${first.s5Severity}"');
        debugPrint('s6Distress: "${first.s6Distress}"');
        debugPrint('s6Severity: "${first.s6Severity}"');
        debugPrint('s7Distress: "${first.s7Distress}"');
        debugPrint('s7Severity: "${first.s7Severity}"');
      }
      debugPrint('========================================\n');
    }

    if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
    if (res.data["http_status"] != "Success.")
      throw Exception('API error: ${res.data["http_status"]}');

    return details;
  }

  Future<dynamic> showInspectionDetailsFormC({required String insRecID}) async {
    Map<String, String> mapForm = {"insRecID": insRecID};
    debugPrint('=== showInspectionDetailsFormC ===');
    debugPrint('URL: ${UrlStorage.formCInspectionDetails}');
    debugPrint('Payload: $mapForm');

    var res = await provider.store(
      UrlStorage.formCInspectionDetails,
      data: mapForm,
    );

    debugPrint('showInspectionDetailsFormC status: ${res.statusCode}');
    debugPrint('showInspectionDetailsFormC response: ${res.data}');

    final details = Form_C_InspectionDetailsModel.fromJson(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return details;
  }

  Future<dynamic> submitNewInspectionForm(
      {required Map<String, dynamic> mapForm}) async {
    mapForm.forEach((key, value) {
      debugPrint('$key: $value');
    });
    var res = await provider.store(
      UrlStorage().formNewInspection(formType: formType),
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return res;
  }

  Future<dynamic> submitNewInspectionFormB(
      {required Map<String, dynamic> mapForm}) async {
    mapForm.forEach((key, value) {
      debugPrint('$key: $value');
    });
    var res = await provider.store(
      UrlStorage.formBNewInspection,
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return res;
  }

  Future<dynamic> submitNewInspectionFormC(
      {required Map<String, dynamic> mapForm}) async {
    mapForm.forEach((key, value) {
      debugPrint('$key: $value');
    });
    var res = await provider.store(
      UrlStorage.formCNewInspection,
      data: mapForm,
    );

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return res;
  }

  Future<dynamic> updateInspectionForm(
      {required Map<String, dynamic> mapForm}) async {
    mapForm.forEach((key, value) {
      debugPrint('$key: $value');
    });
    final url = formType.toLowerCase() == "b"
        ? UrlStorage.formBEditInspection
        : UrlStorage().formEditInspection(formType: formType);
    var res = await provider.store(url, data: mapForm);

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return res;
  }

  Future<FormPhotoListingDataModel> showFormPhoto(
      {required String recID}) async {
    // The photo-list endpoint defaults to a 10-row page when no limit is
    // supplied. Inspections allow up to 20 photos, so request the complete
    // set for the details/review screen.
    Map<String, String> mapForm = {
      "recID": recID,
      "limit": "20",
    };
    var res = await provider.store(
      UrlStorage().formPhotoList(formType: formType),
      data: mapForm,
    );

    debugPrint('showFormPhoto status: ${res.statusCode}');
    debugPrint('showFormPhoto response: ${res.data}');

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    final parsed = FormPhotoListingDataModel.fromJson(res.data);
    if (parsed.data != null && parsed.data.isNotEmpty) {
      for (var i = 0; i < parsed.data.length; i++) {
        debugPrint(
            '  photo[${i}]: no=${parsed.data[i].photoNo}, image=${parsed.data[i].image}');
      }
    }
    return parsed;
  }

  Future<dynamic> uploadFormPhoto(
      {required String recID,
      required String photo,
      required String photoNo,
      String remarks = ""}) async {
    final normalizedFormType = formType.toLowerCase();
    final remarksParameter = normalizedFormType == "c"
        ? "userRemarks"
        : normalizedFormType == "b"
            ? "user_remarks"
            : "remarks";
    Map<String, String> mapForm = {
      "recID": recID,
      "photo": "base64(${photo.length} chars)",
      "photoNo": photoNo,
      remarksParameter: remarks,
    };
    debugPrint('=== uploadFormPhoto ===');
    debugPrint('URL: ${UrlStorage().formPhotoUpload(formType: formType)}');
    debugPrint(
        'Payload keys: ${mapForm.keys} (photo is base64, ${photo.length} chars)');
    debugPrint('formType: $formType');
    final payload = <String, dynamic>{
      "recID": recID,
      "photo": photo,
      "photoNo": photoNo,
      remarksParameter: remarks,
    };
    if (normalizedFormType == "b" || normalizedFormType == "c") {
      // Deployed Form B/C APIs use both variants across environments.
      payload["userRemarks"] = remarks;
      payload["user_remarks"] = remarks;
    }

    var res = await provider.store(
      UrlStorage().formPhotoUpload(formType: formType),
      data: payload,
    );

    debugPrint('uploadFormPhoto status: ${res.statusCode}');
    debugPrint('uploadFormPhoto response: ${res.data}');

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return res;
  }

  Future<dynamic> deleteFormPhoto(
      {required String recID, required String photoNo}) async {
    Map<String, String> mapForm = {"recID": recID, "photoNo": photoNo};
    var res = await provider.store(
      UrlStorage().formPhotoDelete(formType: formType),
      data: mapForm,
    );

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return res;
  }

  Future<dynamic> submitFormRemark(
      {required Map<String, dynamic> mapForm}) async {
    var res = await provider.store(
      UrlStorage().formRemarks(formType: formType),
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return res;
  }

  Future<dynamic> submitFormCRemark(
      {required Map<String, dynamic> mapForm}) async {
    final res = await provider.store(UrlStorage.formCRemark2, data: mapForm);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return res;
  }

  Future<dynamic> submitSignature(
      {required Map<String, dynamic> mapForm}) async {
    mapForm.forEach((key, value) {
      debugPrint('$key: $value');
    });
    var res = await provider.store(
      UrlStorage().formSignature(formType: formType),
      data: mapForm,
    );

    print(res.data);

    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;

    return res;
  }

  Future<dynamic> getPDFForm({required String formID}) async {
    Map<String, String> mapForm = {"id": formID};

    debugPrint('=== getPDFForm called ===');
    debugPrint('formID: $formID');
    debugPrint('formType: $formType');
    debugPrint('URL: ${UrlStorage().formPDF(formType: formType)}');
    debugPrint('Payload: $mapForm');

    try {
      var res = await provider.store(
        UrlStorage().formPDF(formType: formType),
        data: mapForm,
      );

      debugPrint('=== Response ===');
      debugPrint('statusCode: ${res.statusCode}');
      debugPrint('data: ${res.data}');

      if (res.statusCode != 200) {
        debugPrint('ERROR: Non-200 status => ${res.statusCode}');
        throw res;
      }
      if (res.data["status"] != "ok") {
        debugPrint('ERROR: Bad status field => ${res.data["status"]}');
        throw res;
      }

      debugPrint('=== Success ===');
      return res;
    } catch (e, stackTrace) {
      debugPrint('=== Exception caught ===');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<DistressModel> showDistress({required String distressGroup}) async {
    Map<String, String> mapForm = {"dt_group": distressGroup};
    final res = await provider.store(UrlStorage.distress, data: mapForm);
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return DistressModel.fromJson(res.data);
  }

  Future<RemarksModel> showRemarks({required String recID}) async {
    Map<String, String> mapForm = {"recID": recID};
    debugPrint('=== showRemarks ===');
    debugPrint('URL: ${UrlStorage().formRemarksView(formType: formType)}');
    debugPrint('Payload: $mapForm');
    debugPrint('formType: $formType');
    try {
      final res = await provider.store(
          UrlStorage().formRemarksView(formType: formType),
          data: mapForm);
      debugPrint('showRemarks statusCode: ${res.statusCode}');
      debugPrint('showRemarks response: ${res.data}');
      if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
        throw res;
      }
      return RemarksModel.fromJson(res.data);
    } catch (e) {
      debugPrint('showRemarks exception: $e');
      rethrow;
    }
  }

  Future<SignatureModel> showSignature({required String recID}) async {
    Map<String, String> mapForm = {"recID": recID};
    final res =
        await provider.store(UrlStorage.formSignatureView(), data: mapForm);
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return SignatureModel.fromJson(res.data);
  }
}

void _printLong(String message) {
  const int chunkSize = 800;
  for (int i = 0; i < message.length; i += chunkSize) {
    debugPrint(message.substring(
        i, i + chunkSize > message.length ? message.length : i + chunkSize));
  }
}
