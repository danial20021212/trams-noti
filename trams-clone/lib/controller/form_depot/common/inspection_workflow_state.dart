class InspectionWorkflowState {
  InspectionWorkflowState({
    this.activeDraftId,
    this.submittedInspectionID,
    this.isResumeDraft = false,
  });

  factory InspectionWorkflowState.fromArguments(dynamic arguments) {
    if (arguments is! Map) return InspectionWorkflowState();
    final rawDraftID = arguments['draftId'];
    final draftID = rawDraftID is int
        ? rawDraftID
        : int.tryParse(rawDraftID?.toString() ?? '');
    final submittedID =
        arguments['submittedInspectionID']?.toString().trim() ?? '';
    return InspectionWorkflowState(
      activeDraftId: draftID,
      submittedInspectionID: submittedID.isEmpty ? null : submittedID,
      isResumeDraft: arguments['isResumeDraft'] == true,
    );
  }

  int? activeDraftId;
  String? submittedInspectionID;
  bool isResumeDraft;
  bool isSubmitting = false;
  bool isSavingDraft = false;
  bool submissionCompleted = false;

  bool beginSubmission() {
    if (isSubmitting || submissionCompleted) return false;
    isSubmitting = true;
    return true;
  }

  void endSubmission() => isSubmitting = false;

  bool beginDraftSave({bool allowDuringSubmission = false}) {
    if (submissionCompleted ||
        isSavingDraft ||
        (isSubmitting && !allowDuringSubmission)) {
      return false;
    }
    isSavingDraft = true;
    return true;
  }

  void endDraftSave() => isSavingDraft = false;

  void attachDraft(int draftID) {
    activeDraftId = draftID;
    isResumeDraft = true;
  }

  void clearDraft() {
    activeDraftId = null;
    isResumeDraft = false;
  }

  void restoreSubmittedInspectionID(Map<String, dynamic> data) {
    final value = data['submitted_inspection_id']?.toString().trim() ?? '';
    submittedInspectionID = value.isEmpty ? null : value;
  }
}
