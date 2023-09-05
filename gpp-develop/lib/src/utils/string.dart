extension StringExtensions on String? {
  String? get capitalize {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return this;
    }
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  String? get toTitleCase {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return this;
    }
    var words = this!.toLowerCase().split(' ');
    for (var i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }
}
