import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/model/basic/document/document_list_model.dart';
import 'package:tram/repository/document_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../model/shared/loader_state_model.dart';
import '../auth/auth_controller.dart';

class DocumentController extends GetxController {
  final repository = DocumentRepository();
  final PagingController<int, DocumentModel> pagingController =
      PagingController(firstPageKey: 0);
  Rx<LoaderState> state = LoaderState.initial.obs;
  final auth = Get.find<AuthController>();

  DocumentListModel? model;

  RxInt index = 0.obs;

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      load();
    });

    super.onInit();
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      model = await repository.indexDocument(
        package: package != null ? package! : (auth.getUserPackage() ?? ""),
        docName: docName != null ? docName! : "",
      );
      print(model);
      pagingController.appendLastPage(model!.data);
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
      pagingController.error = err;
    }
  }

  String? package;
  String? docName;

  apply({required String package, required String docName}) {
    state.value = LoaderState.loading;
    index.value = 0;
    this.package = package;
    this.docName = docName;

    pagingController.refresh();
  }
  
  view(DocumentModel item) async {
    _launchUrl(Uri.parse(item.url));
  }

  Future<bool> _launchUrl(Uri url) async {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
    return true;
  }
}
