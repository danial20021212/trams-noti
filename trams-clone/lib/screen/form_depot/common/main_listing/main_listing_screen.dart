import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:tram/controller/form_depot/main_listing/main_listing_controller.dart';
import '../../../../components/Neumorphic/dropdown.dart';
import '../../../../controller/form_depot/main_listing/main_listing_filter_controller.dart';
import '../../../../model/form/form_depot/form_B/form_B_search_model.dart';
import '../../../../model/form/form_depot/form_C/form_C_main_listing_model.dart';
import '../../../../model/form/form_depot/main_listing/form_main_listing_model.dart';
import '../../../../widget/form_depot/form_depot_text_scope.dart';

class MainListingScreen extends StatefulWidget {
  const MainListingScreen({super.key});

  @override
  State<MainListingScreen> createState() => _MainListingScreenState();
}

class _MainListingScreenState extends State<MainListingScreen> {
  final formType = Get.arguments['formType'] ?? 'Unknown';
  final formTitle = Get.arguments['formTitle'] ?? 'Unknown';

  final controller = Get.find<MainListingController>();
  final filterController = Get.find<MainListingFilterController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xfff3f8fe),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leadingWidth: 60,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Form $formType",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              formTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: CustomNeumorphicIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Get.back(),
            ),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: CustomNeumorphicIconButton(
                icon: Icons.tune,
                onPressed: () => _showFilterDialog(),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshList(),
        child: SafeArea(
          child: Column(
            children: [
              // -- Header
              Obx(() {
                if (controller.isFilterApplied.value &&
                    controller.searchQuery.value.isEmpty &&
                    controller.formType.toLowerCase() == "c") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Road Code:",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                filterController.roadCode.value ?? '-',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Road Name:",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  filterController.roadName.value ?? '-',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),

              // --- Search bar with Package Warning
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    // A. The Search Field
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffe8eef6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) {
                            controller.updateSearchQuery(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.search,
                                color: Colors.grey, size: 18),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 38,
                              minHeight: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // B. The "Select Package" Warning
                    Obx(() {
                      final pkg = filterController.packageID.value;
                      final bool isPkgMissing = pkg == null || pkg.isEmpty;

                      if (!isPkgMissing) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          _showPackageSelectionDialog();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 24,
                              ),
                              Text(
                                "Select Pkg",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),

                    // --- Pagination Dropdown
                    Obx(() {
                      if (controller.isFilterApplied.value &&
                          controller.formType.toLowerCase() == 'c') {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8.0, bottom: 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => _showPaginationModal(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${controller.currentPage.value}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ],
                ),
              ),

              // --- 2. List of data
              Expanded(
                child: Obx(() {
                  if (!controller.isFilterApplied.value &&
                      controller.searchQuery.value.isEmpty) {
                    return const Center(
                      child: Text(
                        "Apply filter to view data",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // ======================================
                      // FORM B SPECIFIC DESIGN
                      // ======================================
                      if (controller.formType.toLowerCase() == "b")
                        Expanded(
                          child: PagedListView<int, FormBSearchModel>(
                            pagingController: controller.pagingControllerB,
                            padding: const EdgeInsets.all(12),
                            builderDelegate:
                                PagedChildBuilderDelegate<FormBSearchModel>(
                              itemBuilder: (context, item, index) {
                                return RepaintBoundary(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3E8EF),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.blueGrey.withOpacity(0.25),
                                          offset: const Offset(4, 4),
                                          blurRadius: 8,
                                        ),
                                        const BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4, -4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(12),
                                      titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      subtitleTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Package: ${item.package.isEmpty ? "-" : item.package}'),
                                          Text(
                                              'District: ${item.district.isEmpty ? "-" : item.district}'),
                                          Text(
                                              'Road Code: ${item.roadName.isEmpty ? "-" : item.roadName}'),
                                          if (item.bridgeName != null &&
                                              item.bridgeName!.isNotEmpty)
                                            Text(
                                                'Bridge Name: ${item.bridgeName}'),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomNeumorphicIconButton(
                                            icon: Icons.find_in_page_outlined,
                                            iconSize: 24,
                                            padding: const EdgeInsets.all(8),
                                            onPressed: () {
                                              Get.toNamed(
                                                '/main_listing_form_details',
                                                arguments: {
                                                  'formType': formType,
                                                  'formTitle': formTitle,
                                                  'parentID': item.parentID,
                                                  'recID': item.parentID,
                                                  'isMainListing': true,
                                                  'packageID': filterController
                                                      .packageID.value,
                                                  'districtID': filterController
                                                      .districtID.value,
                                                  'routeID': filterController
                                                      .routeID.value,
                                                  'bridgeName': item.bridgeName,
                                                  'packageName': item.package,
                                                  'districtName': item.district,
                                                  'roadName': item.roadName,
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      // ======================================
                      // FORM C SPECIFIC DESIGN
                      // ======================================
                      if (controller.formType.toLowerCase() == "c")
                        Expanded(
                          child: PagedListView<int, FormCMainListingModel>(
                            pagingController: controller.pagingControllerC,
                            padding: const EdgeInsets.all(16),
                            // 3. CHANGE TO FormCMainListingModel
                            builderDelegate: PagedChildBuilderDelegate<
                                FormCMainListingModel>(
                              itemBuilder: (context, item, index) {
                                return RepaintBoundary(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey
                                              .withValues(alpha: 0.2),
                                          offset: const Offset(4, 4),
                                          blurRadius: 8,
                                        ),
                                        BoxShadow(
                                          color: Colors.blueGrey
                                              .withValues(alpha: 0.1),
                                          offset: const Offset(-4, -4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(12),
                                      titleTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                      title: Text(
                                        'Ref. Code: ${item.referenceNo == "" ? "-" : item.referenceNo}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                '/main_listing_form_details',
                                                arguments: {
                                                  'formType': formType,
                                                  'formTitle': formTitle,
                                                  'recID': item.recID,
                                                  'isMainListing': true,
                                                  'packageID': filterController
                                                      .packageID.value,
                                                  'districtID': filterController
                                                      .districtID.value,
                                                  'routeID': filterController
                                                      .routeID.value,
                                                  'refNo': item.referenceNo,

                                                  // 4. THIS IS NOW A FormCMainListingModel!
                                                  'selectedModel': item,
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue
                                                        .withOpacity(0.3),
                                                    offset: const Offset(2, 2),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: const Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              firstPageErrorIndicatorBuilder: (context) => Center(
                                  child: Text(
                                      'Error: ${controller.pagingControllerC.error}')),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  const Center(child: Text('No items found.')),
                            ),
                          ),
                        ),

                      // ======================================
                      // ALL OTHER FORMS
                      // ======================================
                      if (controller.formType.toLowerCase() != "c" &&
                          controller.formType.toLowerCase() != "b")
                        Expanded(
                          child: PagedListView<int, FormMainListingModel>(
                            pagingController: controller.pagingControllerMain,
                            padding: const EdgeInsets.all(16),
                            builderDelegate:
                                PagedChildBuilderDelegate<FormMainListingModel>(
                              itemBuilder: (context, item, index) {
                                return RepaintBoundary(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3E8EF),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.blueGrey.withOpacity(0.25),
                                          offset: const Offset(4, 4),
                                          blurRadius: 8,
                                        ),
                                        const BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4, -4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(18),
                                      titleTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                      subtitleTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Ref. Code: ${item.referenceNo}',
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Road Name: ${filterController.roadName}'),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomNeumorphicIconButton(
                                            icon: Icons.find_in_page_outlined,
                                            iconSize: 30,
                                            padding: const EdgeInsets.all(10),
                                            onPressed: () {
                                              Get.toNamed(
                                                '/main_listing_form_details',
                                                arguments: {
                                                  'formType': formType,
                                                  'formTitle': formTitle,
                                                  'recID': item.recID,
                                                  'isMainListing': true,
                                                  'packageID': filterController
                                                      .packageID.value,
                                                  'districtID': filterController
                                                      .districtID.value,
                                                  'routeID': filterController
                                                      .routeID.value,
                                                  'refNo': item.referenceNo,
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              firstPageErrorIndicatorBuilder: (context) => Center(
                                  child: Text(
                                      'Error: ${controller.pagingControllerMain.error}')),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  const Center(child: Text('No items found.')),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      FormDepotTextScope(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: _buildFilterDialogContent(),
        ),
      ),
    );
  }

  Widget _buildFilterDialogContent() {
    final bool usesDivisionFilter =
        {"b", "c"}.contains(controller.formType.toLowerCase());
    return Obx(() => Container(
          width: Get.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xfff3f8fe),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeumorphicDropdown(
                wtitle: const Text("Package:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                placeholder: "-",
                items: filterController.packageDropdown.toList(),
                selected: filterController.packageID.value,
                onChanged: (value) {
                  filterController.selectPackage(value);
                },
              ),
              const SizedBox(height: 16),
              NeumorphicDropdown(
                wtitle: const Text("Division :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                placeholder: "-",
                items: usesDivisionFilter
                    ? filterController.divisionDropdown.toList()
                    : filterController.districtDropdown.toList(),
                selected: filterController.districtID.value,
                onChanged: (value) {
                  filterController.selectDistrict(value);
                },
              ),
              const SizedBox(height: 16),
              NeumorphicDropdown(
                wtitle: const Text("Route :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                placeholder: "-",
                items: filterController.routeDropdown.toList(),
                selected: filterController.routeID.value,
                onChanged: (value) {
                  filterController.selectRoute(value);
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  /// CLEAR BUTTON
                  Expanded(
                    child: _buildActionButton(
                      text: "Clear",
                      icon: Icons.clear,
                      color: const Color(0xFFD9534F),
                      textColor: Colors.white,
                      onPressed: () {
                        controller.searchQuery.value = "";
                        filterController.clearAll();
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 18),

                  /// APPLY BUTTON
                  Expanded(
                    child: _buildActionButton(
                      text: "Filter",
                      icon: Icons.filter_alt,
                      color: const Color(0xFFE0C158),
                      textColor: Colors.black,
                      onPressed: () {
                        filterController.applyFilter();
                        Get.back();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildActionButton({
    required String text,
    IconData? icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return CustomNeumorphicTextButton(
      text: text,
      icon: icon,
      baseColor: color,
      textColor: textColor,
      padding: const EdgeInsets.all(14),
      onPressed: onPressed,
    );
  }

  void _showPackageSelectionDialog() {
    Get.dialog(
      FormDepotTextScope(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: Get.width * 0.8,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xfff3f8fe),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 28, color: Colors.blueGrey),
                const SizedBox(height: 8),
                const Text(
                  "Select Package Required",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "To use the search feature, you must select a package first.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                Obx(() => NeumorphicDropdown(
                      wtitle: const Text("Package:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      placeholder: "Choose a Package",
                      items: filterController.packageDropdown.toList(),
                      selected: filterController.packageID.value,
                      onChanged: (value) {
                        filterController.selectPackage(value);
                      },
                    )),
                const SizedBox(height: 16),
                CustomNeumorphicTextButton(
                  text: "Confirm & Search",
                  baseColor: const Color(0xFFE0C158),
                  textColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                  onPressed: () {
                    if (filterController.packageID.value != null &&
                        filterController.packageID.value!.isNotEmpty) {
                      Get.back();
                      if (controller.searchQuery.value.isNotEmpty) {
                        controller.pagingControllerMain.refresh();
                        controller.load();
                      }
                    } else {
                      Get.snackbar(
                        "Selection Required",
                        "Please select a package to continue",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaginationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FormDepotTextScope(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEF6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Page",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close,
                          size: 28, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.totalPages.value,
                    separatorBuilder: (c, i) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final int pageNum = index + 1;
                      return Obx(() {
                        final bool isSelected =
                            pageNum == controller.currentPage.value;
                        return GestureDetector(
                          onTap: () {
                            controller.jumpToPage(pageNum);
                            Get.back();
                          },
                          child: Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              "$pageNum",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- NEW CUSTOM STANDARD FLUTTER WIDGETS ---

class CustomNeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CustomNeumorphicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(9),
  });

  @override
  State<CustomNeumorphicIconButton> createState() =>
      _CustomNeumorphicIconButtonState();
}

class _CustomNeumorphicIconButtonState
    extends State<CustomNeumorphicIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: const Color(0xFFE3E8EF),
          shape: BoxShape.circle,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Icon(widget.icon, size: widget.iconSize, color: Colors.black),
      ),
    );
  }
}

class CustomNeumorphicTextButton extends StatefulWidget {
  final String text;
  final Color baseColor;
  final Color textColor;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;

  const CustomNeumorphicTextButton({
    super.key,
    required this.text,
    required this.baseColor,
    required this.textColor,
    this.icon,
    this.padding = const EdgeInsets.all(10),
    required this.onPressed,
  });

  @override
  State<CustomNeumorphicTextButton> createState() =>
      _CustomNeumorphicTextButtonState();
}

class _CustomNeumorphicTextButtonState
    extends State<CustomNeumorphicTextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.3),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.textColor, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
