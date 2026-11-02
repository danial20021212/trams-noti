import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tram/components/Neumorphic/card_1.dart';
import 'package:tram/components/Neumorphic/card_2.dart';
import 'package:tram/controller/detail/achievement_kppi_controller.dart';
import 'package:tram/controller/detail/statistic_listing_controller.dart';

import '../../components/Neumorphic/navbar.dart';
import '../../model/shared/loader_state_model.dart';

class StatisticListingScreen extends StatefulWidget {
  const StatisticListingScreen({super.key});

  @override
  State<StatisticListingScreen> createState() => _StatisticListingState();
}

class _StatisticListingState extends State<StatisticListingScreen> {
  final controller = Get.find<StatisticListingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicNavBar(
        title: "Road Asset Statistic Listing",
        showDrawer: false,
        color: Color(0xfff3f8fe),
      ),
      body: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xfff3f8fe),
        ),
        child: Column(
          children: [
            Neumorphic(
                child: Container(
              padding: EdgeInsets.all(10),
              height: 80,
              width: Get.width,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'State : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const TextSpan(
                          text: 'Sarawak',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Package : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Package ${controller.pkg}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Obx(() {
              switch (controller.state.value) {
                case LoaderState.initial:
                case LoaderState.loading:
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case LoaderState.loaded:
                  return Expanded(
                    child: SfDataGrid(
                      onCellTap: (details) {
                        if (details.column.columnName == 'id') {
                          final selected = controller.roadAsset!
                              .dataReader[details.rowColumnIndex.rowIndex - 1];
                          controller.navigate(selected);
                        }
                        // details.column
                      },
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columnWidthCalculationRange:
                          ColumnWidthCalculationRange.allRows,
                      headerRowHeight: 70,
                      rowHeight: 49,
                      source: controller.roadDataSource.value,
                      columns: [
                        GridColumn(
                          columnName: 'id',
                          minimumWidth: 100,
                          label: Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Route No.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          minimumWidth: 100,
                          columnName: 'name',
                          label: Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Road Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          minimumWidth: 150,
                          columnName: 'distance',
                          label: Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Road Length (KM)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                case LoaderState.failure:
                  return Expanded(
                    child: Center(
                      child: Text(
                        controller.roadAsset?.error == ""
                            ? "Failed to load data"
                            : controller.roadAsset?.error ??
                                "Failed to load data",
                      ),
                    ),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
