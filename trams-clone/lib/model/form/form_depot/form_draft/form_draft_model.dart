import 'package:tram/model/shared/draft_status_model.dart';

class FormDraft {
  int? id;
  String formType;
  String formData;
  DraftStatus status;
  String createdAt;
  String updatedAt;
  int syncRetryCount;
  String? errorLog;
  String? mediaPaths; // Stored as a JSON string array

  FormDraft({
    this.id,
    required this.formType,
    required this.formData,
    this.status = DraftStatus.draft,
    required this.createdAt,
    required this.updatedAt,
    this.syncRetryCount = 0,
    this.errorLog,
    this.mediaPaths,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_type': formType,
      'form_data': formData,
      'status': status.name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sync_retry_count': syncRetryCount,
      'error_log': errorLog,
      'media_paths': mediaPaths,
    };
  }

  factory FormDraft.fromJson(Map<String, dynamic> map) {
    // 2. Safely extract the string from the map
    String statusString = map['status'] as String? ?? 'draft';

    // 3. Convert the String back into the DraftStatus Enum
    DraftStatus parsedStatus = DraftStatus.values.firstWhere(
          (e) => e.name == statusString,
      // Fallback in case the string doesn't match any enum value
      orElse: () => DraftStatus.draft,
    );

    return FormDraft(
      id: map['id'],
      formType: map['form_type'],
      formData: map['form_data'],
      status: parsedStatus, // Pass the converted enum here
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      syncRetryCount: map['sync_retry_count'] ?? 0,
      errorLog: map['error_log'],
      mediaPaths: map['media_paths'],
    );
  }
}