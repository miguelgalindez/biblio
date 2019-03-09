class JsonHelpers {
  /*
  static List<dynamic> parseListOfDynamic(json){
    if(json!=null)
  }
  */
  
  static List<String> parseListOfString(json) {
    if (json != null && json is List<dynamic>) {
      return List<String>.from(json);
    } else {
      return null;
    }
  }

  static DateTime parseDateTime(json) {
    if (json != null && json is String) {
      DateTime date = DateTime.tryParse(json);
      if (date != null) {
        return date;
      } else {
        List<String> parts = json.split("-");
        if (parts.length > 0 && parts[0].length == 4) {
          try {
            int year = int.parse(parts[0]);
            int month = parts.length > 1 ? int.parse(parts[1]) : 0;
            int day = parts.length > 2 ? int.parse(parts[2]) : 0;

            date = DateTime(year, month, day);
            return date;
          } catch (e) {}
        }
      }
    }
    return null;
  }
}
