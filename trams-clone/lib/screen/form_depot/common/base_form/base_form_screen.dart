//This class is the form handling for automatically selects and displays different forms
//depending on the combination of formType and formPage.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../form_depot_registry.dart';

class BaseFormScreen extends StatelessWidget {
  const BaseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String formType = Get.arguments['formType'] ?? 'Unknown';
    final String formPage = Get.arguments['formPage'] ?? 'Unknown';
    final String form = "${formType}_$formPage";

    final module = FormDepotRegistry.moduleForRoute(formType, formPage);
    if (module != null) return module.buildPage(formPage);

    return Scaffold(body: Center(child: Text('Invalid form: $form')));
  }
}
