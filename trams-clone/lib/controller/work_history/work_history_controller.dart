import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/model/basic/work_history/work_history_model.dart';
import 'package:tram/repository/work_history_repository.dart';

import '../../components/Neumorphic/card_4.dart';

enum WorkHistoryState { empty, loading, loaded, failure }

class WorkHistoryController extends GetxController {
  final repository = WorkHistoryRepository();
  final PagingController<int, WorkHistoryModel> pagingController =
      PagingController(firstPageKey: 0);
  Rx<WorkHistoryState> state = WorkHistoryState.empty.obs;
  late Widget pagedView;

  RxInt index = 0.obs;

  @override
  void onInit() {
    pagedView = PagedListView<int, WorkHistoryModel>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<WorkHistoryModel>(
        itemBuilder: (context, item, index) => _item(
          item: item,
        ),
      ),
    );

    pagingController.addPageRequestListener((pageKey) {
      print("$package $district $route $year");
      if (package == null ||
          district == null ||
          route == null ||
          year == null) {
        loadEmpty();
      } else {
        load();
      }
    });
    super.onInit();
  }

  load() async {
    try {
      state.value = WorkHistoryState.loading;
      final data = await repository.showWorkHistory(
        package: package!,
        district: district!,
        route: route!,
        year: year!,
      );
      index.value = 1;
      pagingController.appendLastPage(data.data);
      state.value = WorkHistoryState.loaded;
    } catch (err) {
      index.value = 1;
      state.value = WorkHistoryState.failure;
    }
  }

  String? package;
  String? district;
  String? route;
  String? year;

  apply({
    required String package,
    required String district,
    required String route,
    required String year,
  }) {
    state.value = WorkHistoryState.loading;
    index.value = 0;
    this.package = package;
    this.district = district;
    this.route = route;
    this.year = year;

    pagingController.refresh();
  }

  reset() {
    loadEmpty();
  }

  loadEmpty() {
    state.value = WorkHistoryState.empty;
    package = null;
    district = null;
    route = null;
    year = null;
    pagingController.appendLastPage([]);
  }
}

Widget _item({
  required WorkHistoryModel item,
}) {
  return NeumorphicCard4(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text("Survey Year", item.surveyYear),
        _text("Route", item.routeNo),
        _text("Direction", item.direction),
        _text("Lane", item.lane),
        _text("Start Km", item.startKm),
        _text("End Km", item.endKm),
        _text("Total Length (m)", item.totalLength.toString()),
        _text("Maintenance Type", item.maintenanceType),
        _text("Plan Start Date", item.planStartDate),
        _text("Plan End Date", item.planEndDate),
        _text("Actual Start Date", item.actualStartDate),
        _text("Actual End Date", item.actualEndDate),
        _text("Completion (%)", item.completion),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: CachedNetworkImage(
                width: 150,
                height: 150,
                imageUrl: item.beforeImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: CachedNetworkImage(
                width: 150,
                height: 150,
                imageUrl: item.afterImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _text(String title, String value) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "$title : ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            color: Color.fromARGB(255, 99, 104, 133),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}
