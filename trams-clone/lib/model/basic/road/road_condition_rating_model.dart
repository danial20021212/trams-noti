import 'package:equatable/equatable.dart';

class RoadConditionRatingModel extends Equatable {
  const RoadConditionRatingModel({
    required this.httpStatus,
    required this.paved,
    required this.unpaved,
  });

  final String httpStatus;

  final List<List<RoadCondition>> paved;
  final List<List<RoadCondition>> unpaved;

  @override
  List<Object?> get props => [
        httpStatus,
        paved,
        unpaved,
      ];
}

// class RoadConditionRatingBeforeProceedModel extends Equatable {
//   const RoadConditionRatingBeforeProceedModel({
//     required this.httpStatus,
//     required this.pavedPkg1,
//     required this.pavedPkg2,
//     required this.pavedPkg3,
//     required this.pavedPkg4,
//     required this.pavedPkg5,
//     required this.unPavedPkg1,
//     required this.unPavedPkg2,
//     required this.unPavedPkg3,
//     required this.unPavedPkg4,
//     required this.unPavedPkg5,
//   });

//   final String httpStatus;
//   final List<List<dynamic>> pavedPkg1;
//   final List<List<dynamic>> pavedPkg2;
//   final List<List<dynamic>> pavedPkg3;
//   final List<List<dynamic>> pavedPkg4;
//   final List<List<dynamic>> pavedPkg5;
//   final List<List<dynamic>> unPavedPkg1;
//   final List<List<dynamic>> unPavedPkg2;
//   final List<List<dynamic>> unPavedPkg3;
//   final List<List<dynamic>> unPavedPkg4;
//   final List<List<dynamic>> unPavedPkg5;

//   List<List<RoadCondition>> paved() {
//     List before = [
//       pavedPkg1,
//       pavedPkg2,
//       pavedPkg3,
//       pavedPkg4,
//       pavedPkg5,
//     ];
//     List<List<RoadCondition>> after = [];
//     for (var element in before) {
//       List<RoadCondition> list = [];
//       for (var c in element) {
//         list.add(RoadCondition(key: c[0], value: c[1]));
//       }
//       after.add(list);
//     }
//     return after;
//   }

//   List<List<RoadCondition>> unpaved() {
//     List before = [
//       unPavedPkg1,
//       unPavedPkg2,
//       unPavedPkg3,
//       unPavedPkg4,
//       unPavedPkg5,
//     ];
//     List<List<RoadCondition>> after = [];
//     for (var element in before) {
//       List<RoadCondition> list = [];
//       for (var c in element) {
//         list.add(RoadCondition(key: c[0], value: c[1].toDouble()));
//       }
//       after.add(list);
//     }
//     return after;
//   }

//   factory RoadConditionRatingBeforeProceedModel.fromJson(
//       Map<String, dynamic> json) {
//     return RoadConditionRatingBeforeProceedModel(
//       httpStatus: json["http_status"] ?? "",
//       pavedPkg1: json["PavedPkg1"] == null
//           ? []
//           : List<List<dynamic>>.from(json["PavedPkg1"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       pavedPkg2: json["PavedPkg2"] == null
//           ? []
//           : List<List<dynamic>>.from(json["PavedPkg2"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       pavedPkg3: json["PavedPkg3"] == null
//           ? []
//           : List<List<dynamic>>.from(json["PavedPkg3"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       pavedPkg4: json["PavedPkg4"] == null
//           ? []
//           : List<List<dynamic>>.from(json["PavedPkg4"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       pavedPkg5: json["PavedPkg5"] == null
//           ? []
//           : List<List<dynamic>>.from(json["PavedPkg5"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       unPavedPkg1: json["UnPavedPkg1"] == null
//           ? []
//           : List<List<dynamic>>.from(json["UnPavedPkg1"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       unPavedPkg2: json["UnPavedPkg2"] == null
//           ? []
//           : List<List<dynamic>>.from(json["UnPavedPkg2"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       unPavedPkg3: json["UnPavedPkg3"] == null
//           ? []
//           : List<List<dynamic>>.from(json["UnPavedPkg3"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       unPavedPkg4: json["UnPavedPkg4"] == null
//           ? []
//           : List<List<dynamic>>.from(json["UnPavedPkg4"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//       unPavedPkg5: json["UnPavedPkg5"] == null
//           ? []
//           : List<List<dynamic>>.from(json["UnPavedPkg5"]!.map(
//               (x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x)))),
//     );
//   }

//   @override
//   List<Object?> get props => [
//         httpStatus,
//         pavedPkg1,
//         pavedPkg2,
//         pavedPkg3,
//         pavedPkg4,
//         pavedPkg5,
//         unPavedPkg1,
//         unPavedPkg2,
//         unPavedPkg3,
//         unPavedPkg4,
//         unPavedPkg5,
//       ];
// }

class RoadConditionRatingBeforeProceedModel extends Equatable {
  const RoadConditionRatingBeforeProceedModel({
    required this.httpStatus,
    required this.pavedPkg1,
    required this.pavedPkg2,
    required this.pavedPkg3,
    required this.pavedPkg4,
    required this.pavedPkg5,
    required this.unPavedPkg1,
    required this.unPavedPkg2,
    required this.unPavedPkg3,
    required this.unPavedPkg4,
    required this.unPavedPkg5,
  });

  final String httpStatus;
  final List<RoadCondition> pavedPkg1;
  final List<RoadCondition> pavedPkg2;
  final List<RoadCondition> pavedPkg3;
  final List<RoadCondition> pavedPkg4;
  final List<RoadCondition> pavedPkg5;
  final List<RoadCondition> unPavedPkg1;
  final List<RoadCondition> unPavedPkg2;
  final List<RoadCondition> unPavedPkg3;
  final List<RoadCondition> unPavedPkg4;
  final List<RoadCondition> unPavedPkg5;

  List<List<RoadCondition>> paved() {
    List before = [
      pavedPkg1,
      pavedPkg2,
      pavedPkg3,
      pavedPkg4,
      pavedPkg5,
    ];
    List<List<RoadCondition>> after = [];
    for (var element in before) {
      List<RoadCondition> list = [];
      for (var c in element) {
        list.add(RoadCondition(key: c.key, value: c.value));
      }
      after.add(list);
    }
    return after;
  }

  List<List<RoadCondition>> unpaved() {
    List before = [
      unPavedPkg1,
      unPavedPkg2,
      unPavedPkg3,
      unPavedPkg4,
      unPavedPkg5,
    ];
    List<List<RoadCondition>> after = [];
    for (var element in before) {
      List<RoadCondition> list = [];
      for (var c in element) {
        list.add(RoadCondition(key: c.key, value: c.value));
      }
      after.add(list);
    }
    return after;
  }

  RoadConditionRatingBeforeProceedModel copyWith({
    String? httpStatus,
    List<RoadCondition>? pavedPkg1,
    List<RoadCondition>? pavedPkg2,
    List<RoadCondition>? pavedPkg3,
    List<RoadCondition>? pavedPkg4,
    List<RoadCondition>? pavedPkg5,
    List<RoadCondition>? unPavedPkg1,
    List<RoadCondition>? unPavedPkg2,
    List<RoadCondition>? unPavedPkg3,
    List<RoadCondition>? unPavedPkg4,
    List<RoadCondition>? unPavedPkg5,
  }) {
    return RoadConditionRatingBeforeProceedModel(
      httpStatus: httpStatus ?? this.httpStatus,
      pavedPkg1: pavedPkg1 ?? this.pavedPkg1,
      pavedPkg2: pavedPkg2 ?? this.pavedPkg2,
      pavedPkg3: pavedPkg3 ?? this.pavedPkg3,
      pavedPkg4: pavedPkg4 ?? this.pavedPkg4,
      pavedPkg5: pavedPkg5 ?? this.pavedPkg5,
      unPavedPkg1: unPavedPkg1 ?? this.unPavedPkg1,
      unPavedPkg2: unPavedPkg2 ?? this.unPavedPkg2,
      unPavedPkg3: unPavedPkg3 ?? this.unPavedPkg3,
      unPavedPkg4: unPavedPkg4 ?? this.unPavedPkg4,
      unPavedPkg5: unPavedPkg5 ?? this.unPavedPkg5,
    );
  }

  factory RoadConditionRatingBeforeProceedModel.fromJson(
      Map<String, dynamic> json) {
    return RoadConditionRatingBeforeProceedModel(
      httpStatus: json["http_status"] ?? "",
      pavedPkg1: json["PavedPkg1"] == null
          ? []
          : List<RoadCondition>.from(
              json["PavedPkg1"]!.map((x) => RoadCondition.fromJson(x))),
      pavedPkg2: json["PavedPkg2"] == null
          ? []
          : List<RoadCondition>.from(
              json["PavedPkg2"]!.map((x) => RoadCondition.fromJson(x))),
      pavedPkg3: json["PavedPkg3"] == null
          ? []
          : List<RoadCondition>.from(
              json["PavedPkg3"]!.map((x) => RoadCondition.fromJson(x))),
      pavedPkg4: json["PavedPkg4"] == null
          ? []
          : List<RoadCondition>.from(
              json["PavedPkg4"]!.map((x) => RoadCondition.fromJson(x))),
      pavedPkg5: json["PavedPkg5"] == null
          ? []
          : List<RoadCondition>.from(
              json["PavedPkg5"]!.map((x) => RoadCondition.fromJson(x))),
      unPavedPkg1: json["UnPavedPkg1"] == null
          ? []
          : List<RoadCondition>.from(
              json["UnPavedPkg1"]!.map((x) => RoadCondition.fromJson(x))),
      unPavedPkg2: json["UnPavedPkg2"] == null
          ? []
          : List<RoadCondition>.from(
              json["UnPavedPkg2"]!.map((x) => RoadCondition.fromJson(x))),
      unPavedPkg3: json["UnPavedPkg3"] == null
          ? []
          : List<RoadCondition>.from(
              json["UnPavedPkg3"]!.map((x) => RoadCondition.fromJson(x))),
      unPavedPkg4: json["UnPavedPkg4"] == null
          ? []
          : List<RoadCondition>.from(
              json["UnPavedPkg4"]!.map((x) => RoadCondition.fromJson(x))),
      unPavedPkg5: json["UnPavedPkg5"] == null
          ? []
          : List<RoadCondition>.from(
              json["UnPavedPkg5"]!.map((x) => RoadCondition.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        pavedPkg1,
        pavedPkg2,
        pavedPkg3,
        pavedPkg4,
        pavedPkg5,
        unPavedPkg1,
        unPavedPkg2,
        unPavedPkg3,
        unPavedPkg4,
        unPavedPkg5,
      ];
}

class RoadCondition extends Equatable {
  const RoadCondition({
    required this.key,
    required this.value,
  });

  final String key;
  final double value;

  RoadCondition copyWith({
    String? key,
    double? value,
  }) {
    return RoadCondition(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  factory RoadCondition.fromJson(Map<String, dynamic> json) {
    return RoadCondition(
      key: json["ConditionCategory"] ?? "",
      value: double.tryParse("${json["Length"]}") ?? 0.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        key,
        value,
      ];
}
