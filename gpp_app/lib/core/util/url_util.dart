class UrlUtil {
  static String mergeUrl(String url, String other) {
    if (url.endsWith('/')) {
      if (other.startsWith('/')) {
        return url + other.replaceFirst('/', '');
      } else {
        return url + other;
      }
    } else {
      if (other.startsWith('/')) {
        return url + other;
      } else {
        return url + '/' + other;
      }
    }
  }

  static Uri parse(String url) {
    return Uri.parse(url);
  }
}
