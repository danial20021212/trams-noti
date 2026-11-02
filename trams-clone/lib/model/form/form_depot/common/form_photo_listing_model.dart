class FormPhotoListingDataModel {
  const FormPhotoListingDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormPhotoListingModel> data;

  FormPhotoListingDataModel copyWith({
    String? httpStatus,
    List<FormPhotoListingModel>? data,
  }) {
    return FormPhotoListingDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormPhotoListingDataModel.fromJson(Map<String, dynamic> json) {
    return FormPhotoListingDataModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormPhotoListingModel>.from(
              json["data"]!.map((x) => FormPhotoListingModel.fromJson(x))),
    );
  }

  List<FormPhotoListingModel> orderedByPhotoNumber() {
    final indexedPhotos = data.asMap().entries.toList();
    indexedPhotos.sort((left, right) {
      final photoNumberComparison =
          left.value.photoNumber.compareTo(right.value.photoNumber);
      return photoNumberComparison != 0
          ? photoNumberComparison
          : left.key.compareTo(right.key);
    });
    return indexedPhotos.map((entry) => entry.value).toList();
  }

  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FormPhotoListingModel {
  final String image;
  final String photoNo;
  final String remarks;

  const FormPhotoListingModel({
    required this.image,
    required this.photoNo,
    this.remarks = "",
  });

  FormPhotoListingModel copyWith({
    String? image,
    String? photoNo,
    String? remarks,
  }) {
    return FormPhotoListingModel(
      image: image ?? this.image,
      photoNo: photoNo ?? this.photoNo,
      remarks: remarks ?? this.remarks,
    );
  }

  factory FormPhotoListingModel.fromJson(Map<String, dynamic> json) {
    dynamic readValue(List<String> acceptedKeys) {
      for (final key in acceptedKeys) {
        final value = json[key];
        if (value != null) return value;
      }

      final normalizedKeys = acceptedKeys
          .map((key) => key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''))
          .toSet();
      for (final entry in json.entries) {
        final normalizedKey =
            entry.key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (normalizedKeys.contains(normalizedKey) && entry.value != null) {
          return entry.value;
        }
      }
      return null;
    }

    return FormPhotoListingModel(
      image: json['image'] ?? "",
      photoNo: json["photoNo"] ?? "",
      remarks: (readValue(const [
                "userRemarks",
                "user_remarks",
                "userRemark",
                "remarks",
                "remark",
                "photo_remarks",
                "photoRemark",
              ]) ??
              "")
          .toString(),
    );
  }

  int get photoNumber {
    final match = RegExp(r'\d+').firstMatch(photoNo);
    return int.tryParse(match?.group(0) ?? '') ?? 0x7fffffff;
  }

  List<Object?> get props => [image, photoNo, remarks];
}
