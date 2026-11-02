import 'package:equatable/equatable.dart';

class FilterWorkProgramModel extends Equatable {
  const FilterWorkProgramModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FilterWorkProgram> data;

  FilterWorkProgramModel copyWith({
    String? httpStatus,
    List<FilterWorkProgram>? data,
  }) {
    return FilterWorkProgramModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FilterWorkProgramModel.fromJson(Map<String, dynamic> json) {
    return FilterWorkProgramModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FilterWorkProgram>.from(
              json["data"]!.map(
                (x) => FilterWorkProgram.fromJson(x),
              ),
            ),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FilterWorkProgram extends Equatable {
  const FilterWorkProgram({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  FilterWorkProgram copyWith({
    String? id,
    String? name,
  }) {
    return FilterWorkProgram(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory FilterWorkProgram.fromJson(Map<String, dynamic> json) {
    return FilterWorkProgram(
      id: '${json["id"]}',
      name: json["value"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
