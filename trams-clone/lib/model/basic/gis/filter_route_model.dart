import 'package:equatable/equatable.dart';

class FilterRouteModel extends Equatable {
  const FilterRouteModel({
    required this.httpStatus,
    required this.tblRoute,
  });

  final String httpStatus;

  final List<FilterRoute> tblRoute;

  FilterRouteModel copyWith({
    String? httpStatus,
    List<FilterRoute>? tblRoute,
  }) {
    return FilterRouteModel(
      httpStatus: httpStatus ?? this.httpStatus,
      tblRoute: tblRoute ?? this.tblRoute,
    );
  }

  factory FilterRouteModel.fromJson(Map<String, dynamic> json) {
    List<FilterRoute> route = [];

    if (json["tbl_route"] != null) {
      final typeTbl = json["tbl_route"].runtimeType;

      if (typeTbl == List) {
        route = List<FilterRoute>.from(
          json["tbl_route"]!.map(
                (x) => FilterRoute.fromJson(x),
          ),
        );
      }
    }
    return FilterRouteModel(
      httpStatus: json["http_status"] ?? "",
      tblRoute: route,
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    tblRoute,
  ];
}

class FilterRoute extends Equatable {
  const FilterRoute({
    required this.routeId,
    required this.packageId,
    required this.districtId,
    required this.routeNo,
    required this.routeName,
  });

  final String routeId;
  final String packageId;
  final String districtId;
  final String routeNo;
  final String routeName;

  FilterRoute copyWith({
    String? routeId,
    String? packageId,
    String? districtId,
    String? routeNo,
    String? routeName,
  }) {
    return FilterRoute(
      routeId: routeId ?? this.routeId,
      packageId: packageId ?? this.packageId,
      districtId: districtId ?? this.districtId,
      routeNo: routeNo ?? this.routeNo,
      routeName: routeName ?? this.routeName,
    );
  }

  factory FilterRoute.fromJson(Map<String, dynamic> json) {
    return FilterRoute(
      routeId: json["route_id"] ?? "",
      packageId: json["package_id"] ?? "",
      districtId: json["district_id"] ?? "",
      routeNo: json["route_no"] ?? "",
      routeName: json["route_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "route_id": routeId,
    "package_id": packageId,
    "district_id": districtId,
    "route_no": routeNo,
    "route_name": routeName,
  };

  @override
  List<Object?> get props => [
    routeId,
    packageId,
    districtId,
    routeNo,
    routeName,
  ];
}
