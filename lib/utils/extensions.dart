extension DateComparison on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }
  String toReadableString(){
    return '$day/$month/$year';
  }
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
          && day == other.day;
  }
}