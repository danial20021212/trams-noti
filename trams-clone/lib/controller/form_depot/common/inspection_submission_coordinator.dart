import '../../../model/shared/draft_status_model.dart';

typedef MainInspectionSubmit = Future<dynamic> Function();
typedef SubmissionIDResolver = String Function(dynamic responseData);
typedef SupplementaryInspectionSubmit = Future<void> Function(
  String inspectionID,
  bool resumeExistingUploads,
);
typedef SubmissionFallback = Future<bool> Function(
  DraftStatus status,
  String errorLog,
);

class InspectionSubmissionResult {
  const InspectionSubmissionResult._({
    required this.inspectionID,
    required this.completed,
    required this.savedForRetry,
    this.error,
  });

  factory InspectionSubmissionResult.completed(String inspectionID) =>
      InspectionSubmissionResult._(
        inspectionID: inspectionID,
        completed: true,
        savedForRetry: false,
      );

  factory InspectionSubmissionResult.deferred({
    required String inspectionID,
    required bool savedForRetry,
    required Object error,
  }) =>
      InspectionSubmissionResult._(
        inspectionID: inspectionID,
        completed: false,
        savedForRetry: savedForRetry,
        error: error,
      );

  final String inspectionID;
  final bool completed;
  final bool savedForRetry;
  final Object? error;
}

class InspectionSubmissionCoordinator {
  const InspectionSubmissionCoordinator({
    this.mainFormTimeout = const Duration(seconds: 60),
    this.afterMainSubmitDelay = const Duration(milliseconds: 500),
  });

  final Duration mainFormTimeout;
  final Duration afterMainSubmitDelay;

  Future<InspectionSubmissionResult> submit({
    String? existingInspectionID,
    required MainInspectionSubmit submitMain,
    required SubmissionIDResolver resolveInspectionID,
    required void Function(String inspectionID) onInspectionIDResolved,
    required SupplementaryInspectionSubmit submitSupplementary,
    required SubmissionFallback saveFallback,
  }) async {
    var inspectionID = existingInspectionID?.trim() ?? '';
    final isPendingSyncRetry = inspectionID.isNotEmpty;

    try {
      if (inspectionID.isEmpty) {
        final response = await submitMain().timeout(mainFormTimeout);
        inspectionID = resolveInspectionID(response).trim();
        if (inspectionID.isEmpty || inspectionID.toLowerCase() == 'null') {
          throw StateError('Submission response is missing an inspection ID');
        }
        onInspectionIDResolved(inspectionID);
        if (afterMainSubmitDelay > Duration.zero) {
          await Future.delayed(afterMainSubmitDelay);
        }
      }

      await submitSupplementary(inspectionID, isPendingSyncRetry);
      return InspectionSubmissionResult.completed(inspectionID);
    } catch (error) {
      //print('SUBMIT FAILED: $error'); 
      final status =
          inspectionID.isEmpty ? DraftStatus.draft : DraftStatus.pendingSync;
      final saved = await saveFallback(status, error.toString());
      return InspectionSubmissionResult.deferred(
        inspectionID: inspectionID,
        savedForRetry: saved,
        error: error,
      );
    }
  }
}

String resolveGeneralInspectionID(
  dynamic responseData, {
  required String formType,
}) {
  if (responseData is! Map) {
    throw StateError('Form $formType submission response is not a JSON object');
  }
  for (final key in const ['recID', 'subID', 'insRecID', 'inspectionID']) {
    final value = responseData[key]?.toString().trim() ?? '';
    if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
  }
  throw StateError('New Form $formType inspection response is missing recID');
}
