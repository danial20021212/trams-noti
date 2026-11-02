const String rooturl = "https://prims.ipaves.my";
const String rootapi = "$rooturl/site";

// ignore: constant_identifier_names
// const String StorageApi = "$rooturl/public/storage/";

class UrlStorage {
  static String login = "$rootapi/api_LoginToken";
  static String roadLength = "$rootapi/api_dashRoadLengthToken";
  static String roadLengthStatewide =
      "$rootapi/api_dashStatewideRoadLengthToken";
  static String pai = "$rootapi/api_dashPAIToken";
  static String spi = "$rootapi/api_dashSPIToken";
  static String roadMaintenanceState = "$rootapi/api_dashStateRMIToken";
  static String roadMaintenancePackge = "$rootapi/api_dashPackageRMIToken";
  static String roadRoughnessIndexState = "$rootapi/api_dashStateIRIToken";
  static String roadRouhghnessIndexPackge = "$rootapi/api_dashPackageIRIToken";
  static String roadConditionRating = "$rootapi/api_dashRdCondRatingToken";
  static String roadConditionRatingCost =
      "$rootapi/api_dashRdCondRatingCostToken";
  static String asetInventory = "$rootapi/api_dashAssetInventoryToken";
  static String dashUpdateDate = "$rootapi/api_dashUpdatedDateToken";
  static String mapCompany(String value) =>
      "$rootapi/api_dashPackage${value}DistributionToken";
  static String packageDetail = "$rootapi/api_dashRdConditionToken";
  static String districtRMI = "$rootapi/api_districtRMIToken";
  static String divisionRMI = "$rootapi/api_divisionRMIToken";
  static String packageRMI = "$rootapi/api_packageRMIToken";

  static String packageRoadAsset =
      "$rootapi/api_PackageRoadAssetStatisticToken";
  static String divisionRoadAsset =
      "$rootapi/api_DivisionRoadAssetStatisticToken";
  static String districtRoadAsset =
      "$rootapi/api_DistrictRoadAssetStatisticToken";

  static String filterPackage = "$rootapi/api_tblPackageToken";
  static String filterDivision = "$rootapi/api_tblDivisionToken";
  static String filterDistrict = "$rootapi/api_tblDistrictToken";
  static String filterRoute = "$rootapi/api_tblRouteToken";
  static String filterRoute2 = "$rootapi/api_tblRoute2Token";
  static String filterCondition = "$rootapi/api_tblConditionNameToken";
  static String filterPavement = "$rootapi/api_gisPavementToken";

  static String filterInventory = "$rootapi/api_tblInventoryItemToken";
  static String filterBridgeCategory = "$rootapi/api_tblBridgeCategoryToken";
  static String filterBridgeType = "$rootapi/api_tblBridgeTypeToken";
  static String filterRoadAsset = "$rootapi/api_gisRoadAssetToken";

  static String filterWorkProgram = "$rootapi/api_tblWorkProgramByToken";
  static String filterMaintenanceWork = "$rootapi/api_gisMaintenanceWorkToken";

  static String workHistory = "$rootapi/api_workHistoryToken";

  static String document = "$rootapi/api_sysDocumentToken";

  static String pavementMap = "https://prims.ipaves.my/primsapp/";

  static String filterBtSuperstructure = "$rootapi/Api_BtSuperstructureToken";
  static String filterBtParapet = "$rootapi/Api_BtParapetToken";
  static String filterBtBearing = "$rootapi/Api_BtBearingToken";
  static String filterBtExpansion = "$rootapi/Api_BtExpansionToken";
  static String filterBtDeck = "$rootapi/Api_BtDeckToken";
  static String filterBtAbutment = "$rootapi/Api_BtAbutmentToken";
  static String filterBtPier = "$rootapi/Api_BtPierToken";

  static String distress = "$rootapi/Api_BtDistressToken";

  String formMainListing({required String formType}) =>
      "$rootapi/Api_form${formType}MainListingToken";

  String formMainListingDetails({required String formType}) =>
      "$rootapi/Api_form${formType}MainListingDetailsToken";

  String formNewInspection({required String formType}) =>
      "$rootapi/Api_form${formType}newInspectionToken";

  String formEditInspection({required String formType}) =>
      "$rootapi/Api_form${formType}editInspectionToken";

  String formInspectionDetails({required String formType}) =>
      "$rootapi/Api_form${formType}InspectionDetailsToken";

  String formPhotoList({required String formType}) =>
      "$rootapi/Api_form${formType}listPhotoToken";

  String formPhotoUpload({required String formType}) =>
      "$rootapi/Api_form${formType}photoUploadToken";

  String formPhotoDelete({required String formType}) =>
      "$rootapi/Api_form${formType}deletePhotoToken";

  String formRemarks({required String formType}) =>
      "$rootapi/Api_form${formType}remarksToken";

  String formRemarksView({required String formType}) =>
      "$rootapi/Api_form${formType}remarksviewToken";

  String formSignature({required String formType}) =>
      "$rootapi/Api_form${formType}signatureToken";

  String formPDF({required String formType}) =>
      "$rootapi/Api_form${formType}pdfToken";

  String formSearch({required String formType}) =>
      "$rootapi/Api_form${formType}searchToken";

  static String formSignatureView() => "$rootapi/Api_UserSignatureToken";

  static String formBSearch = "$rootapi/Api_formBsearch2Token";
  static String formBMainListing = "$rootapi/Api_formBMainListing2Token";
  static String formBNewInspection = "$rootapi/Api_formBnewInspection2Token";
  static String formBEditInspection = "$rootapi/Api_formBeditInspection2Token";

  static String formCMainListing = "$rootapi/Api_formCMainListing2Token";
  static String formCMainListingDetails = "$rootapi/Api_formCMainListingDetails2Token";
  static String formCNewInspection = "$rootapi/Api_formCnewInspection2Token";
  static String formCEditInspection = "$rootapi/Api_formCeditInspection2Token";
  static String formCInspectionDetails = "$rootapi/Api_formCInspectionDetails2Token";
  static String formCPhotoList = "$rootapi/Api_formClistPhotoToken";
  static String formCPhotoUpload = "$rootapi/Api_formCphotoUploadToken";
  static String formCPhotoDelete = "$rootapi/Api_formCdeletePhotoToken";
  static String formCRemark2 = "$rootapi/Api_formCremarks2Token";
  static String formCSignature = "$rootapi/Api_formCsignatureToken";
  static String formCRemarksView = "$rootapi/api_formCremarksviewToken";
  static String formCPDF = "$rootapi/api_formCpdfToken";
}
