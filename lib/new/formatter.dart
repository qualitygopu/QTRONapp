String formatDays(List<int>? days) {
  if (days == null || days.isEmpty) {
    return 'No days selected';
  }

  final List<String> dayAbbreviations = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  // Sort the days to ensure consistent output
  final sortedDays = days.toList()..sort();

  // Check for all days selected
  if (sortedDays.length == 7) {
    return 'Everyday';
  }

  // Format individual days
  return sortedDays.map((dayIndex) {
    if (dayIndex >= 0 && dayIndex < dayAbbreviations.length) {
      return dayAbbreviations[dayIndex];
    }
    return ''; // Should not happen with valid input
  }).join(', ');
}

/// Converts a 24-hour integer to a 12-hour AM/PM format string.
String amPm(int hour) {
  if (hour == 0) return '12 AM'; // Midnight
  if (hour == 12) return '12 PM'; // Noon
  if (hour < 12) {
    return '$hour AM';
  }
  return '${hour - 12} PM';
}
