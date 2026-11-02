import 'package:get/get.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/screen/form_depot/common/form_depot_registry.dart';

class BaseFormBinding extends Bindings {
  static void Function()? _disposeActiveEditor;

  void _resetRouteScopedEditors() {
    _disposeActiveEditor?.call();
    _disposeActiveEditor = null;

    if (Get.isRegistered<BaseFormController>()) {
      Get.delete<BaseFormController>(force: true);
    }
  }

  @override
  void dependencies() {
    final String formType = Get.arguments['formType'] ?? 'Unknown';
    final String formPage = Get.arguments['formPage'] ?? 'Unknown';

    // All form editors share this named route and BaseFormController. Reset
    // the route-scoped controllers before registering the next editor so a
    // review can never leak into a later insert form. Future forms receive the
    // same lifecycle by registering through _registerEditor below.
    _resetRouteScopedEditors();

    //Get.lazyPut(()=>RootFormController());
    Get.lazyPut(() => BaseFormController());

    // Editors opened from a details screen use the controller already owned by
    // that screen. Editors opened from Local Drafts intentionally have no
    // details controller. Registering a placeholder here creates stale routing
    // context and can make a successful submission fail during refresh.

    // FormDraftController is already initialized in RootHomeBinding.
    // Do NOT re-register it here or it will overwrite the existing instance
    // and create a new one with an uninitialized database.

    final module = FormDepotRegistry.moduleForRoute(formType, formPage);
    if (module == null) {
      throw Exception('Invalid form: ${formType}_$formPage');
    }
    module.registerEditor();
    _disposeActiveEditor = module.disposeEditor;
  }
}
