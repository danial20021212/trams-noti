import 'package:get/get.dart';
import 'package:tram/binding/asset/asset_inventory_binding.dart';
import 'package:tram/binding/detail/achievement_kppi_binding.dart';
import 'package:tram/binding/detail/package_detail_listing_binding.dart';
import 'package:tram/binding/detail/statistic_listing_binding.dart';
import 'package:tram/binding/form_depot/form_draft_binding.dart';
import 'package:tram/binding/form_depot/inspection_details_binding.dart';
import 'package:tram/binding/form_depot/main_listing_binding.dart';
import 'package:tram/binding/form_depot/base_form_binding.dart';

import 'package:tram/binding/home/home_binding.dart';
import 'package:tram/binding/home/root_home_binding.dart';
import 'package:tram/binding/other/pai_binding.dart';
import 'package:tram/binding/other/spi_binding.dart';
import 'package:tram/binding/road/road_condition_rating_binding.dart';
import 'package:tram/binding/road/road_length_binding.dart';
import 'package:tram/binding/road/road_maintenance_binding.dart';
import 'package:tram/binding/road/road_roughness_index_binding.dart';
import 'package:tram/screen/asset/asset_inventory_screen.dart';
import 'package:tram/screen/detail/achievement_kppi_screen.dart';
import 'package:tram/screen/detail/package_detail_listing_screen.dart';
import 'package:tram/screen/detail/statistic_listing_screen.dart';
import 'package:tram/screen/form_depot/common/inspection_details_screen.dart';
import 'package:tram/screen/form_depot/common/main_listing/main_listing_screen.dart';
import 'package:tram/screen/form_depot/common/base_form/base_form_screen.dart';
import 'package:tram/screen/form_depot/form_draft/form_draft_screen.dart';
import 'package:tram/screen/home/root_home_screen.dart';
import 'package:tram/screen/other/pai_screen.dart';
import 'package:tram/screen/other/spi_screen.dart';
import 'package:tram/screen/road/road_condition_rating_screen.dart';
import 'package:tram/screen/road/road_length_screen.dart';
import 'package:tram/screen/road/road_maintenance_screen.dart';
import 'package:tram/screen/road/roughness_index_screen.dart';

import '../binding/login/login_binding.dart';
import '../binding/splash_binding.dart';
import '../screen/form_depot/common/main_listing/main_listing_details_screen.dart';
import '../screen/login/login_screen.dart';
import '../screen/splash_screen.dart';
import '../widget/form_depot/form_depot_text_scope.dart';

import 'package:tram/screen/notification/notification_screen.dart';

List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => const SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: '/home',
    page: () => const RootHomeScreen(),
    bindings: [RootHomeBinding(), HomeBinding()],
  ),
  GetPage(
    name: '/package_detail',
    page: () => const PackageDetailListingScreen(),
    binding: PackagedetailListingBinding(),
  ),
  GetPage(
    name: '/road_length',
    page: () => const RoadLenthScreen(),
    binding: RoadLengthBinding(),
  ),
  GetPage(
    name: '/road_maintenance',
    page: () => const RoadMaintenanceScreen(),
    binding: RoadMaintenanceBinding(),
  ),
  GetPage(
    name: '/roughness_index',
    page: () => const RoadRoughnessIndexScreen(),
    binding: RoadRoughnessIndexBinding(),
  ),
  GetPage(
    name: '/road_condition',
    page: () => const RoadConditionRatingScreen(),
    binding: RoadConditionRatingBinding(),
  ),
  GetPage(
    name: '/asset_inventory',
    page: () => const AssetInventoryScreen(),
    binding: AssetInventoryBinding(),
  ),
  GetPage(
    name: '/pai',
    page: () => const PAIScreen(),
    binding: PAIBinding(),
  ),
  GetPage(
    name: '/spi',
    page: () => const SPIScreen(),
    binding: SPIBinding(),
  ),
  GetPage(
    name: '/achievement_kppi',
    page: () => const AchievementKPPIScreen(),
    binding: AchievementKPPIBinding(),
  ),
  GetPage(
    name: '/road_statistic_listing',
    page: () => const StatisticListingScreen(),
    binding: StatisticListingBinding(),
  ),

  GetPage(
    name: '/main_listing_form',
    page: () => const FormDepotTextScope(child: MainListingScreen()),
    binding: MainListingBinding(),
  ),

  GetPage(
    name: '/main_listing_form_details',
    page: () => const FormDepotTextScope(child: MainListingDetailsScreen()),
    binding: MainListingBinding(),
  ),

  GetPage(
    name: '/base_form',
    page: () => const FormDepotTextScope(child: BaseFormScreen()),
    binding: BaseFormBinding(),
  ),

  GetPage(
    name: '/inspection_details',
    page: () => const FormDepotTextScope(child: InspectionDetailsScreen()),
    binding: InpectionDetailsBinding(),
  ),
  GetPage(
    name: '/notifications',
    page: () => const NotificationScreen(),
  ),

  // GetPage(
  //   name: '/form_draft',
  //   page: () => const FormDraftScreen(),
  //   binding: FormDraftBinding(),
  // ),

  // GetPage(
  //   name: '/all_gis_map',
  //   page: () => const AllGisMapScreen(),
  //   binding: AllGisMapBinding(),
  // ),
];
