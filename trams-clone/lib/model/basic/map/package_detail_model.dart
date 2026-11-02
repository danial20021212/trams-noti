import 'package:equatable/equatable.dart';

class PackageDetailModel extends Equatable {
  const PackageDetailModel({
    required this.httpStatus,
    required this.package,
    required this.division,
    required this.district,
  });

  final String httpStatus;
  final PackageModel? package;
  final List<DivisionModel> division;
  final List<DistrictModel> district;

  PackageDetailModel copyWith({
    String? httpStatus,
    PackageModel? package,
    List<DivisionModel>? division,
    List<DistrictModel>? district,
  }) {
    return PackageDetailModel(
      httpStatus: httpStatus ?? this.httpStatus,
      package: package ?? this.package,
      division: division ?? this.division,
      district: district ?? this.district,
    );
  }

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      httpStatus: json["http_status"] ?? "",
      package: json["package"] == null
          ? null
          : PackageModel.fromJson(json["package"]),
      division: json["division"] == null
          ? []
          : List<DivisionModel>.from(
              json["division"]!.map((x) => DivisionModel.fromJson(x))),
      district: json["district"] == null
          ? []
          : List<DistrictModel>.from(
              json["district"]!.map((x) => DistrictModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        package,
        division,
        district,
      ];
}

class DistrictModel extends Equatable {
  const DistrictModel({
    required this.district,
    required this.totalRoadLength,
    required this.pavedRoadLength,
    required this.unPavedRoadLength,
    required this.pavedRdCond1,
    required this.pavedRdCond2,
    required this.pavedRdCond3,
    required this.unPavedRdCond1,
    required this.unPavedRdCond2,
    required this.unPavedRdCond3,
    required this.rmi,
  });

  final String district;
  final String totalRoadLength;
  final String pavedRoadLength;
  final String unPavedRoadLength;
  final String pavedRdCond1;
  final String pavedRdCond2;
  final String pavedRdCond3;
  final String unPavedRdCond1;
  final String unPavedRdCond2;
  final String unPavedRdCond3;
  final int rmi;

  DistrictModel copyWith({
    String? district,
    String? totalRoadLength,
    String? pavedRoadLength,
    String? unPavedRoadLength,
    String? pavedRdCond1,
    String? pavedRdCond2,
    String? pavedRdCond3,
    String? unPavedRdCond1,
    String? unPavedRdCond2,
    String? unPavedRdCond3,
    int? rmi,
  }) {
    return DistrictModel(
      district: district ?? this.district,
      totalRoadLength: totalRoadLength ?? this.totalRoadLength,
      pavedRoadLength: pavedRoadLength ?? this.pavedRoadLength,
      unPavedRoadLength: unPavedRoadLength ?? this.unPavedRoadLength,
      pavedRdCond1: pavedRdCond1 ?? this.pavedRdCond1,
      pavedRdCond2: pavedRdCond2 ?? this.pavedRdCond2,
      pavedRdCond3: pavedRdCond3 ?? this.pavedRdCond3,
      unPavedRdCond1: unPavedRdCond1 ?? this.unPavedRdCond1,
      unPavedRdCond2: unPavedRdCond2 ?? this.unPavedRdCond2,
      unPavedRdCond3: unPavedRdCond3 ?? this.unPavedRdCond3,
      rmi: rmi ?? this.rmi,
    );
  }

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      district: json["district"] ?? "",
      totalRoadLength: json["total_road_length"] ?? "",
      pavedRoadLength: json["Paved_road_length"] ?? "",
      unPavedRoadLength: json["UnPaved_road_length"] ?? "",
      pavedRdCond1: json["PavedRdCond1"] ?? "",
      pavedRdCond2: json["PavedRdCond2"] ?? "",
      pavedRdCond3: json["PavedRdCond3"] ?? "",
      unPavedRdCond1: json["UnPavedRdCond1"] ?? "",
      unPavedRdCond2: json["UnPavedRdCond2"] ?? "",
      unPavedRdCond3: json["UnPavedRdCond3"] ?? "",
      rmi: json["RMI"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        district,
        totalRoadLength,
        pavedRoadLength,
        unPavedRoadLength,
        pavedRdCond1,
        pavedRdCond2,
        pavedRdCond3,
        unPavedRdCond1,
        unPavedRdCond2,
        unPavedRdCond3,
        rmi,
      ];
}

class DivisionModel extends Equatable {
  const DivisionModel({
    required this.totalRoadLength,
    required this.pavedRoadLength,
    required this.unPavedRoadLength,
    required this.pavedRdCond1,
    required this.pavedRdCond2,
    required this.pavedRdCond3,
    required this.unPavedRdCond1,
    required this.unPavedRdCond2,
    required this.unPavedRdCond3,
    required this.rmi,
    required this.division,
  });

  final String totalRoadLength;
  final String pavedRoadLength;
  final String unPavedRoadLength;
  final String pavedRdCond1;
  final String pavedRdCond2;
  final String pavedRdCond3;
  final String unPavedRdCond1;
  final String unPavedRdCond2;
  final String unPavedRdCond3;
  final int rmi;
  final String division;

  DivisionModel copyWith({
    String? totalRoadLength,
    String? pavedRoadLength,
    String? unPavedRoadLength,
    String? pavedRdCond1,
    String? pavedRdCond2,
    String? pavedRdCond3,
    String? unPavedRdCond1,
    String? unPavedRdCond2,
    String? unPavedRdCond3,
    int? rmi,
    String? division,
  }) {
    return DivisionModel(
      totalRoadLength: totalRoadLength ?? this.totalRoadLength,
      pavedRoadLength: pavedRoadLength ?? this.pavedRoadLength,
      unPavedRoadLength: unPavedRoadLength ?? this.unPavedRoadLength,
      pavedRdCond1: pavedRdCond1 ?? this.pavedRdCond1,
      pavedRdCond2: pavedRdCond2 ?? this.pavedRdCond2,
      pavedRdCond3: pavedRdCond3 ?? this.pavedRdCond3,
      unPavedRdCond1: unPavedRdCond1 ?? this.unPavedRdCond1,
      unPavedRdCond2: unPavedRdCond2 ?? this.unPavedRdCond2,
      unPavedRdCond3: unPavedRdCond3 ?? this.unPavedRdCond3,
      rmi: rmi ?? this.rmi,
      division: division ?? this.division,
    );
  }

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      totalRoadLength: json["total_road_length"] ?? "",
      pavedRoadLength: json["Paved_road_length"] ?? "",
      unPavedRoadLength: json["UnPaved_road_length"] ?? "",
      pavedRdCond1: json["PavedRdCond1"] ?? "",
      pavedRdCond2: json["PavedRdCond2"] ?? "",
      pavedRdCond3: json["PavedRdCond3"] ?? "",
      unPavedRdCond1: json["UnPavedRdCond1"] ?? "",
      unPavedRdCond2: json["UnPavedRdCond2"] ?? "",
      unPavedRdCond3: json["UnPavedRdCond3"] ?? "",
      rmi: json["RMI"] ?? 0,
      division: json["division"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        totalRoadLength,
        pavedRoadLength,
        unPavedRoadLength,
        pavedRdCond1,
        pavedRdCond2,
        pavedRdCond3,
        unPavedRdCond1,
        unPavedRdCond2,
        unPavedRdCond3,
        rmi,
        division,
      ];
}

class PackageModel extends Equatable {
  const PackageModel({
    required this.package,
    required this.totalRoadLength,
    required this.pavedRoadLength,
    required this.unPavedRoadLength,
    required this.pavedRdCond1,
    required this.pavedRdCond2,
    required this.pavedRdCond3,
    required this.unPavedRdCond1,
    required this.unPavedRdCond2,
    required this.unPavedRdCond3,
    required this.rmi,
  });

  final int package;
  final double totalRoadLength;
  final double pavedRoadLength;
  final double unPavedRoadLength;
  final double pavedRdCond1;
  final double pavedRdCond2;
  final double pavedRdCond3;
  final double unPavedRdCond1;
  final double unPavedRdCond2;
  final double unPavedRdCond3;
  final int rmi;

  PackageModel copyWith({
    int? package,
    double? totalRoadLength,
    double? pavedRoadLength,
    double? unPavedRoadLength,
    double? pavedRdCond1,
    double? pavedRdCond2,
    double? pavedRdCond3,
    double? unPavedRdCond1,
    double? unPavedRdCond2,
    double? unPavedRdCond3,
    int? rmi,
  }) {
    return PackageModel(
      package: package ?? this.package,
      totalRoadLength: totalRoadLength ?? this.totalRoadLength,
      pavedRoadLength: pavedRoadLength ?? this.pavedRoadLength,
      unPavedRoadLength: unPavedRoadLength ?? this.unPavedRoadLength,
      pavedRdCond1: pavedRdCond1 ?? this.pavedRdCond1,
      pavedRdCond2: pavedRdCond2 ?? this.pavedRdCond2,
      pavedRdCond3: pavedRdCond3 ?? this.pavedRdCond3,
      unPavedRdCond1: unPavedRdCond1 ?? this.unPavedRdCond1,
      unPavedRdCond2: unPavedRdCond2 ?? this.unPavedRdCond2,
      unPavedRdCond3: unPavedRdCond3 ?? this.unPavedRdCond3,
      rmi: rmi ?? this.rmi,
    );
  }

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      package: json["package"] ?? 0,
      totalRoadLength: double.tryParse('${json["total_road_length"]}') ?? 0.0,
      pavedRoadLength: double.tryParse('${json["Paved_road_length"]}') ?? 0.0,
      unPavedRoadLength: double.tryParse('${json["UnPaved_road_length"]}') ?? 0.0,
      pavedRdCond1: double.tryParse('${json["PavedRdCond1"]}') ?? 0.0,
      pavedRdCond2: double.tryParse('${json["PavedRdCond2"]}') ?? 0.0,
      pavedRdCond3: double.tryParse('${json["PavedRdCond3"]}') ?? 0.0,
      unPavedRdCond1: double.tryParse('${json["UnPavedRdCond1"]}') ?? 0.0,
      unPavedRdCond2: double.tryParse('${json["UnPavedRdCond2"]}') ?? 0.0,
      unPavedRdCond3: double.tryParse('${json["UnPavedRdCond3"]}') ?? 0.0,
      rmi: json["RMI"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        package,
        totalRoadLength,
        pavedRoadLength,
        unPavedRoadLength,
        pavedRdCond1,
        pavedRdCond2,
        pavedRdCond3,
        unPavedRdCond1,
        unPavedRdCond2,
        unPavedRdCond3,
        rmi,
      ];
}
