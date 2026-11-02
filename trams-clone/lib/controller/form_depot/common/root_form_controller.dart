// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:get/get.dart';
// import 'package:tram/controller/form_depot/main_listing/main_listing_controller.dart';
// import 'package:tram/model/shared/loader_state_model.dart';
// import 'package:tram/repository/form_repository.dart';
// import 'package:tram/repository/pavement_repository.dart';
// //need remove this after basa_form_controller done
// class RootFormController extends GetxController {
//   Rx<LoaderState> state = LoaderState.initial.obs;
//   final pavementRepository = PavementRepository();
//
//   MainListingController? get mainListingController =>
//       Get.isRegistered<MainListingController>() ? Get.find<MainListingController>() : null;
//
//   RxString packageName = "".obs;
//   RxString districtName = "".obs;
//   RxString routeName = "".obs;
//
//   RxBool isReadOnly = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     state.listen((v) {
//       switch (v) {
//         case LoaderState.initial:
//         case LoaderState.loading:
//           SmartDialog.showLoading(
//             clickMaskDismiss: false,
//           );
//           break;
//         case LoaderState.loaded:
//         case LoaderState.failure:
//           SmartDialog.dismiss();
//           break;
//       }
//     });
//   }
//
//   String? formType;
//
//   Future<void> setupFormType({
//     required String? formType,
//   }) async {
//     this.formType = formType;
//   }
//
//   Future<void> submitForm({
//     required Map<String, dynamic> mapForm,
//   }) async {
//     try {
//       state.value = LoaderState.loading;
//       final response = await FormRepository(formType: formType ?? "")
//           .submitNewInspectionForm(mapForm: mapForm);
//       state.value = LoaderState.loaded;
//       SmartDialog.showToast(response.data['data']);
//     } catch (e) {
//       print(e);
//       state.value = LoaderState.failure;
//       SmartDialog.showToast("Failed submit");
//     }
//   }
//
//   Future<void> updateForm({required Map<String, dynamic> mapForm}) async {
//     try {
//       state.value = LoaderState.loading;
//       final response = await FormRepository(formType: formType!)
//           .updateInspectionForm(mapForm: mapForm);
//       state.value = LoaderState.loaded;
//       Get.back();
//       Get.back();
//       mainListingController!.refreshList();
//       SmartDialog.showToast(response.data['data']);
//     } catch (e) {
//       print(e);
//       state.value = LoaderState.failure;
//       SmartDialog.showToast("Failed update");
//     }
//   }
// }
