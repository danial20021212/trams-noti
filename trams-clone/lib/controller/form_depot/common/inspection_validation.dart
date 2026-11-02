List<String> commonInspectionValidationErrors({
  required int photoCount,
  required int photoLimit,
  required Iterable<int> photosMissingRemarks,
  required String investigation,
}) {
  final errors = <String>[];
  if (photoCount == 0) {
    errors.add('At least one photograph is required.');
  }
  if (photoCount > photoLimit) {
    errors.add('A maximum of $photoLimit photographs is allowed.');
  }
  final missingRemarks = photosMissingRemarks.toList(growable: false);
  if (missingRemarks.isNotEmpty) {
    errors.add(
      'Remarks are required for: ${missingRemarks.map((number) => 'Photo $number').join(', ')}.',
    );
  }
  if (investigation.trim().isEmpty) {
    errors.add('Approval details are missing.');
  }
  return errors;
}
