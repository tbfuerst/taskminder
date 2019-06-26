class DateTimeHelper {
  datetimeToReadableString(DateTime datetime) {
    return datetime.day.toString().padLeft(2, "0") +
        "." +
        datetime.month.toString().padLeft(2, "0") +
        "." +
        datetime.year.toString();
  }

  datetimeToDatabaseString(DateTime datetime) {
    return datetime.year.toString() +
        datetime.month.toString().padLeft(2, "0") +
        datetime.day.toString().padLeft(2, "0");
  }

  databaseStringToReadable(String databaseString) {
    return databaseString.substring(6, 8) +
        "." +
        databaseString.substring(4, 6) +
        "." +
        databaseString.substring(0, 4);
  }
}
