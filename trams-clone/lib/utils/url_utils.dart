class UrlUtils {
  static String toQueryString(Map<String, String> query) {
    return Uri(queryParameters: query).query;
  }
}
