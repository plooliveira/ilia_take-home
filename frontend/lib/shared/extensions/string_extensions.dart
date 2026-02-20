extension StringExtensions on String {
  String get initials {
    if (trim().isEmpty) return '';

    final names = trim().split(RegExp(r'\s+'));
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }

    final firstInitial = names.first[0];
    final lastInitial = names.last[0];
    return '$firstInitial$lastInitial'.toUpperCase();
  }
}
