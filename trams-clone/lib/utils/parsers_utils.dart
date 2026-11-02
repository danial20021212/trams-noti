class ParsersUtils {
  /// Safely converts a dynamic value to a string
  static String? parseToString(dynamic value) {
    if (value == null || value == "") return "";
    return value.toString().trim().isEmpty ? "" : value.toString();
  }

  /// Safely parses a comma-separated string to a list of strings
  static List<String>? parseToStringList(dynamic value) {
    if (value == null ||  value == "") return [];
    if (value is String) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  /// Safely converts a dynamic value to a double
  static double? parseToDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}
