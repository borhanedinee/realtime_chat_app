class Services {
  static String calculateMembershipDuration(DateTime memberSince) {
    Duration membershipDuration = DateTime.now().difference(memberSince);

    int years = membershipDuration.inDays ~/ 365;
    int months = (membershipDuration.inDays % 365) ~/ 30;
    int days = membershipDuration.inDays % 30;

    String durationAsString = '';

    if (years > 0) {
      durationAsString += '$years ${years == 1 ? 'year' : 'years'} ';
    }
    if (months > 0) {
      durationAsString += '$months ${months == 1 ? 'month' : 'months'} ';
    }
    if (days > 0) {
      durationAsString += '$days ${days == 1 ? 'day' : 'days'}';
    }

    if (durationAsString.isEmpty) {
      durationAsString = 'less than a day'; // If the duration is less than a day
    }

    return durationAsString;
  }
  static DateTime parseStringToDateTime(String dateString) {
  try {
    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime;
  } catch (error) {
    // Handle parsing errors
    print("Error parsing date string: $error");
    return DateTime.now();
  }
}

}
