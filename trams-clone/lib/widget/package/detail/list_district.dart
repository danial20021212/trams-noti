import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/components/Neumorphic/button_1.dart';
import 'package:tram/controller/detail/package_detail_listing_controller.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/widget/package/dialog/district_dialog.dart';

class ListDistrict extends GetView<PackageDetailListingController> {
  const ListDistrict({super.key});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, DistrictModel>(
      pagingController: controller.p2,
      builderDelegate: PagedChildBuilderDelegate<DistrictModel>(
        itemBuilder: (context, item, index) => _item(
          item,
        ),
      ),
    );
  }

  Widget _item(DistrictModel district) {
    return NeumorphicButton1(
      onPressed: () {
        SmartDialog.show(
          builder: (context) {
            return DistrictDialog(
              district: district,
              pkg: controller.pkg,
            );
          },
        );
      },
      title: Text(
        district.district,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
