extension NumFormat on num {
  String toGameFormat({bool currency = true}) {
    final suffix = currency ? '₺' : '';
    if (this >= 1e12) {
      return '${(this / 1e12).toStringAsFixed(2)}T$suffix';
    } else if (this >= 1e9) {
      return '${(this / 1e9).toStringAsFixed(2)}B$suffix';
    } else if (this >= 1e6) {
      return '${(this / 1e6).toStringAsFixed(2)}M$suffix';
    } else if (this >= 1e3) {
      return '${(this / 1e3).toStringAsFixed(2)}K$suffix';
    } else {
      return '${toStringAsFixed(0)}$suffix';
    }
  }
}

extension StringExtensions on String {
  String toTurkishLower() => toLowerCase().replaceAll('I', 'ı').replaceAll('İ', 'i');
  String toTurkishUpper() => toUpperCase().replaceAll('i', 'İ').replaceAll('ı', 'I');
}
