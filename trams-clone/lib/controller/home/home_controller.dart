import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tram/constant/pinned_position.dart';
import 'package:tram/model/basic/map/company_detail_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/map_repository.dart';
import 'package:tram/widget/dialog/map_dialog.dart';

import '../auth/auth_controller.dart';

class HomeController extends GetxController {
  final repository = MapRepository();
  late GoogleMapController mapController;
  Rx<LoaderState> state = LoaderState.initial.obs;
  final auth = Get.find<AuthController>();

  Rx<CompanyDetailModel?> selected = Rxn();

  RxList<Marker> makers = RxList();
  RxList<PinDetail> visiblePins = RxList();
  List<CompanyDetailModel> companies = [];
  CameraPosition initialPlex = const CameraPosition(
    target: LatLng(
      2.707019689157567,
      113.85710510289833,
    ),
    zoom: 4.5,
  );

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    state.listen((v) {
      switch (v) {
        case LoaderState.initial:
        case LoaderState.loading:
          SmartDialog.showLoading(usePenetrate: true);
          break;
        case LoaderState.failure:
        case LoaderState.loaded:
          SmartDialog.dismiss();
          break;
      }
    });
    load();

    super.onInit();
  }

  loadMarkers(List<PinDetail> pins) {
    visiblePins.assignAll(pins);
    makers.value = pins
        .map<Marker>(
          (e) => Marker(
            markerId: MarkerId(e.id),
            position: e.coordinate,
            onTap: () => showDialog(e.pkgName),
          ),
        )
        .toList();
  }

  List<PinDetail> filterMarkers(List<PinDetail> pins) {
    final pkg = companies.map((e) => e.package);
    if (auth.getUserPackage()?.isEmpty ?? true) {
      var filtered = pins
          .where(
            (element) => pkg.contains(element.pkgName),
          )
          .toList();
      return filtered;
    } else {
      var package = "Package ${auth.getUserPackage()}";
      var filtered = pins
          .where(
            (element) => element.pkgName == package,
          )
          .toList();
      return filtered;
    }
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      List<CompanyDetailModel> result = await Future.wait([
        repository.showCompanyDetail("1"),
        repository.showCompanyDetail("2"),
        repository.showCompanyDetail("3"),
        repository.showCompanyDetail("4"),
        repository.showCompanyDetail("5"),
      ], eagerError: false);
      result =
          result.where((element) => element.httpStatus == "Success.").toList();
      companies = result;
      loadMarkers(
        filterMarkers(pinedLocations),
      );
      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state.value = LoaderState.failure;
    }
  }

  showDialog(String pkg) async {
    if (selected.value != null) SmartDialog.dismiss(tag: "dlg");
    CompanyDetailModel? res =
        companies.firstWhereOrNull((element) => element.package == pkg);
    selected.value = res;
    SmartDialog.show(
      tag: "dlg",
      usePenetrate: true,
      builder: (context) {
        return const MapDialog();
      },
    );
  }
}
