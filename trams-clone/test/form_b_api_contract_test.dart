import 'package:flutter_test/flutter_test.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_model.dart';

void main() {
  group('Form B API contract', () {
    test('uses the documented endpoint URLs', () {
      final urls = UrlStorage();

      expect(UrlStorage.filterDivision, '$rootapi/api_tblDivisionToken');
      expect(UrlStorage.filterRoute2, '$rootapi/api_tblRoute2Token');
      expect(UrlStorage.formBSearch, '$rootapi/Api_formBsearch2Token');
      expect(
          UrlStorage.formBMainListing, '$rootapi/Api_formBMainListing2Token');
      expect(UrlStorage.formBNewInspection,
          '$rootapi/Api_formBnewInspection2Token');
      expect(UrlStorage.formBEditInspection,
          '$rootapi/Api_formBeditInspection2Token');
      expect(urls.formMainListingDetails(formType: 'B'),
          '$rootapi/Api_formBMainListingDetailsToken');
      expect(urls.formInspectionDetails(formType: 'B'),
          '$rootapi/Api_formBInspectionDetailsToken');
      expect(urls.formPhotoUpload(formType: 'B'),
          '$rootapi/Api_formBphotoUploadToken');
      expect(urls.formPhotoList(formType: 'B'),
          '$rootapi/Api_formBlistPhotoToken');
      expect(urls.formPhotoDelete(formType: 'B'),
          '$rootapi/Api_formBdeletePhotoToken');
      expect(urls.formRemarks(formType: 'B'), '$rootapi/Api_formBremarksToken');
      expect(urls.formRemarksView(formType: 'B'),
          '$rootapi/Api_formBremarksviewToken');
      expect(urls.formSignature(formType: 'B'),
          '$rootapi/Api_formBsignatureToken');
      expect(urls.formPDF(formType: 'B'), '$rootapi/Api_formBpdfToken');
    });

    test('new inspection contains every documented input field', () {
      final payload = FormBModel(
        parentID: 'parent-1',
        inspectionDate: '2026-09-05',
      ).toApiSubmitJson();

      final expectedKeys = <String>{'parentID', 'inspection_date'};
      for (final member in [
        'p1',
        'p2',
        'p3',
        'p4',
        'p5',
        's1',
        's2',
        's3',
        's4',
        's5',
        's6',
        's7',
      ]) {
        expectedKeys.addAll({
          '${member}_material',
          '${member}_material_other',
          '${member}_distress',
          '${member}_other_distress',
          '${member}_severity',
        });
      }

      expect(payload.keys.toSet(), expectedKeys);
      expect(payload['parentID'], 'parent-1');
      expect(payload['inspection_date'], '2026-09-05');
    });

    test('draft parsing keeps bridge name separate from river name', () {
      final model = FormBModel.fromJson({
        'bridgeName': 'Batang Bridge',
        'RiverName': 'Batang River',
      });

      expect(model.bridgeName, 'Batang Bridge');
      expect(model.riverName, 'Batang River');
    });
  });
}
