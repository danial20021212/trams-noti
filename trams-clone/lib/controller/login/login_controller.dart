// import 'package:flutter/material.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:get/get.dart';
// import 'package:tram/controller/auth/auth_controller.dart';
//
// import '../../model/form/login/login_form_model.dart';
// import '../../model/shared/loader_state_model.dart';
// import '../../repository/login_repository.dart';
//
// class LoginController extends GetxController {
//   final LoginRepository repository = LoginRepository();
//   final auth = Get.find<AuthController>();
//
//   final Rx<LoaderState> state = LoaderState.initial.obs;
//
//   late Rx<LoginFormModel> form;
//   final formKey = GlobalKey<FormState>();
//
//   RxBool invisiblePassword = true.obs;
//
//   @override
//   void onInit() {
//     form = LoginFormModel().obs;
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
//     super.onInit();
//   }
//
//   void submit() async {
//     try {
//       if (!formKey.currentState!.validate()) return;
//       FocusManager.instance.primaryFocus?.unfocus();
//       state.value = LoaderState.loading;
//       final data = await repository.login(form.value);
//       if (data.tokenData == null || data.tokenData!.accessToken.isEmpty) {
//         state.value = LoaderState.loaded;
//         return SmartDialog.showToast(data.httpStatus);
//       }
//       await auth.login(data);
//       state.value = LoaderState.loaded;
//       Get.offAllNamed("/home");
//     } catch (err) {
//       print(err);
//       state.value = LoaderState.failure;
//       SmartDialog.showToast("Failed Login");
//     }
//   }
//
//   set email(String value) => form.value.email = value;
//   set password(String value) => form.value.passowrd = value;
// }

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';

import '../../model/form/login/login_form_model.dart';
import '../../model/shared/loader_state_model.dart';
import '../../repository/login_repository.dart';

class LoginController extends GetxController {
  final LoginRepository repository = LoginRepository();
  final auth = Get.find<AuthController>();

  final Rx<LoaderState> state = LoaderState.initial.obs;

  // OPTIMIZATION 1: Initialize directly instead of using 'late'
  final Rx<LoginFormModel> form = LoginFormModel().obs;
  final formKey = GlobalKey<FormState>();

  RxBool invisiblePassword = true.obs;

  @override
  void onInit() {
    super.onInit();

    // OPTIMIZATION 2: Use 'ever' instead of 'listen' for GetX state.
    // Also, removed LoaderState.initial from showing a loading dialog,
    // otherwise the app might flash a loading screen as soon as it boots.
    ever(state, (v) {
      if (v == LoaderState.loading) {
        SmartDialog.showLoading(clickMaskDismiss: false);
      } else if (v == LoaderState.loaded || v == LoaderState.failure) {
        SmartDialog.dismiss();
      }
    });
  }

  void submit() async {
    try {
      if (!formKey.currentState!.validate()) return;

      FocusManager.instance.primaryFocus?.unfocus();
      state.value = LoaderState.loading;

      final data = await repository.login(form.value);

      if (data.tokenData == null || data.tokenData!.accessToken.isEmpty) {
        state.value = LoaderState.loaded;
        SmartDialog.showToast(data.httpStatus);
        return;
      }

      await auth.login(data);

      // OPTIMIZATION 3: Sequence the CPU tasks for old phones
      // 1. Trigger the dialog dismiss animation first
      state.value = LoaderState.loaded;

      // 2. Let the old phone's CPU finish the dismiss animation
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. ONLY THEN build the new screen
      Get.offAllNamed("/home");

    } catch (err) {
      Get.log("Login Error: $err"); // Safer logging than print()
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed Login");
    }
  }

  // OPTIMIZATION 4: Use form.update() to properly trigger GetX reactivity
  set email(String value) => form.update((val) { val?.email = value; });
  set password(String value) => form.update((val) { val?.password = value; });
}