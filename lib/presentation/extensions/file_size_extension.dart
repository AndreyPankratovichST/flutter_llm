extension FileSizeExtension on int {
  static const _gb = 1024 * 1024 * 1024;
  static const _mb = 1024 * 1024;

  String get sizeFormatted {
    if (this >= _gb) {
      return '${(this / _gb).toStringAsFixed(1)} GB';
    }
    return '${(this / _mb).toStringAsFixed(1)} MB';
  }
}
