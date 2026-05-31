String shortenSentence(String text, {int maxLength = 100}) {
  final trimmedText = text.trim();
  final firstSentence = trimmedText.split(RegExp(r'[.?!]')).first.trim();
  if (firstSentence.isEmpty) {
    return trimmedText.length <= maxLength
        ? trimmedText
        : '${trimmedText.substring(0, maxLength)}...';
  }

  if (firstSentence.length <= maxLength) {
    return '$firstSentence.';
  }

  return '${firstSentence.substring(0, maxLength)}...';
}
