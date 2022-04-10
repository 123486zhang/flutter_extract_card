import 'dart:convert' as convert;



class StringUtils{

  static String base64Decode(String data){
    List<int> bytes =  convert.base64Decode(data);
    String result = convert.utf8.decode(bytes);
    return result;
  }

  static String getStringValue(dynamic value) {
    if (value == null) {
      return '';
    }
    return '${value}';
  }

  static List<String> getStringWithNumber(int num) {
    List<String> values = [];
    for (int i = 0; i < num; i++) {
      if (i < 10 ) {
        values.add("0${i.toString()}");
      } else {
        values.add("${i.toString()}");
      }
    }
    return values;
  }

  static String convertNumberToString(int num) {
    if (num < 10 ) {
      return "0${num.toString()}";
    }
    return num.toString();
  }

  static bool isNull(String value) {
    if (value == null || value.isEmpty || value.length == 0) {
      return true;
    }
    return false;
  }
}