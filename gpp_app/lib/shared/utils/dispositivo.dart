class Dispositivo {
  static mobile(double maxWidth) {
    if (maxWidth < 767.9) {
      return true;
    } else {
      return false;
    }
  }

  static tablet(double maxWidth) {
    if (maxWidth >= 768 && maxWidth < 991.98) {
      return true;
    } else {
      return false;
    }
  }
}
