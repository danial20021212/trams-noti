import 'package:equatable/equatable.dart';

class DocumentListModel extends Equatable {
  const DocumentListModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<DocumentModel> data;

  DocumentListModel copyWith({
    String? httpStatus,
    List<DocumentModel>? data,
  }) {
    return DocumentListModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory DocumentListModel.fromJson(Map<String, dynamic> json) {
    return DocumentListModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<DocumentModel>.from(
              json["data"]!.map((x) => DocumentModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class DocumentModel extends Equatable {
  const DocumentModel({
    required this.package,
    required this.documentName,
    required this.uploadDate,
    required this.url,
  });

  final String package;
  final String documentName;
  final String uploadDate;
  final String url;

  DocumentModel copyWith({
    String? package,
    String? documentName,
    String? uploadDate,
    String? url,
  }) {
    return DocumentModel(
      package: package ?? this.package,
      documentName: documentName ?? this.documentName,
      uploadDate: uploadDate ?? this.uploadDate,
      url: url ?? this.url,
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      package: json["package"] ?? "",
      documentName: json["document_name"] ?? "",
      uploadDate: json["upload_date"] ?? "",
      url: json["url"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        package,
        documentName,
        uploadDate,
        url,
      ];
}
