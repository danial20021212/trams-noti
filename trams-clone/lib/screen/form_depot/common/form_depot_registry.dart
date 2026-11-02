import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_B_controller.dart';
import '../../../controller/form_depot/form_C_controller.dart';
import '../../../controller/form_depot/form_G_controller.dart';
import '../../../controller/form_depot/form_R_controller.dart';
import '../form_B/formB1_review_screen.dart';
import '../form_B/formB2_review_screen.dart';
import '../form_B/new_inspection_form_B.dart';
import '../form_B/new_record_form_B_screen.dart';
import '../form_C/formC1_review_screen.dart';
import '../form_C/formC2_review_screen.dart';
import '../form_C/new_inspection_form_C.dart';
import '../form_C/new_record_form_C_screen.dart';
import '../form_G/formG1_review_screen.dart';
import '../form_G/formG2_review_screen.dart';
import '../form_G/new_inspection_form_G.dart';
import '../form_G/new_record_form_G_screen.dart';
import '../form_R/formR1_review_screen.dart';
import '../form_R/formR2_review_screen.dart';
import '../form_R/new_inspection_form_R.dart';
import '../form_R/new_record_form_R_screen.dart';

typedef FormPageBuilder = Widget Function();

class FormDepotModule {
  const FormDepotModule._({
    required this.formType,
    required this.controllerType,
    required this.pages,
    required this.registerEditor,
    required this.disposeEditor,
  });

  static FormDepotModule create<T extends GetxController>({
    required String formType,
    required T Function() controllerBuilder,
    required Map<String, FormPageBuilder> pages,
  }) {
    return FormDepotModule._(
      formType: formType,
      controllerType: T,
      pages: Map.unmodifiable(pages),
      registerEditor: () {
        if (Get.isRegistered<T>()) Get.delete<T>(force: true);
        Get.lazyPut<T>(controllerBuilder);
      },
      disposeEditor: () {
        if (Get.isRegistered<T>()) Get.delete<T>(force: true);
      },
    );
  }

  final String formType;
  final Type controllerType;
  final Map<String, FormPageBuilder> pages;
  final void Function() registerEditor;
  final void Function() disposeEditor;

  bool supportsPage(String formPage) => pages.containsKey(formPage);

  Widget buildPage(String formPage) => pages[formPage]!();
}

class FormDepotRegistry {
  const FormDepotRegistry._();

  static final Map<String, FormDepotModule> modules = Map.unmodifiable({
    'B': FormDepotModule.create<FormBController>(
      formType: 'B',
      controllerBuilder: FormBController.new,
      pages: {
        'record': NewRecordFormBScreen.new,
        'inspection': NewInspectionFormBScreen.new,
        'review_B1': FormB1ReviewScreen.new,
        'review_B2': FormB2ReviewScreen.new,
      },
    ),
    'C': FormDepotModule.create<FormCController>(
      formType: 'C',
      controllerBuilder: FormCController.new,
      pages: {
        'record': NewRecordFormCScreen.new,
        'inspection': NewInspectionFormCScreen.new,
        'review_C1': FormC1ReviewScreen.new,
        'review_C2': FormC2ReviewScreen.new,
      },
    ),
    'G': FormDepotModule.create<FormGController>(
      formType: 'G',
      controllerBuilder: FormGController.new,
      pages: {
        'record': NewRecordFormGScreen.new,
        'inspection': NewInspectionFormGScreen.new,
        'review_G1': FormG1ReviewScreen.new,
        'review_G2': FormG2ReviewScreen.new,
      },
    ),
    'R': FormDepotModule.create<FormRController>(
      formType: 'R',
      controllerBuilder: FormRController.new,
      pages: {
        'record': NewRecordFormRScreen.new,
        'inspection': NewInspectionFormRScreen.new,
        'review_R1': FormR1ReviewScreen.new,
        'review_R2': FormR2ReviewScreen.new,
      },
    ),
  });

  static FormDepotModule? moduleFor(String formType) =>
      modules[formType.trim().toUpperCase()];

  static FormDepotModule? moduleForRoute(
    String formType,
    String formPage,
  ) {
    final module = moduleFor(formType);
    return module?.supportsPage(formPage) == true ? module : null;
  }
}
