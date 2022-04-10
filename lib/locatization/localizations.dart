
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';

class JYLocalizations {
  final Locale locale;
  JYLocalizations(this.locale);

  static String localizedString(String key) {
    return of(navigatorContext).getLocalizedString(key);
  }

  static JYLocalizations of(BuildContext context) {
    return Localizations.of(context, JYLocalizations);
  }

  static Map<String, Map<String, String>> _localizeValues = {};

  static bool currentLocalIsEnglish(){
    Locale locale = Localizations.localeOf(navigatorContext);
    if (locale.languageCode == "en") {
      return true;
    }
    return false;
  }

  Future loadJson() async {
    // 1.加载json文件
    final jsonString = await rootBundle.loadString("assets/json/localization.json");

    // 2.对json进行解析
    Map<String, dynamic> map = json.decode(jsonString);

    _localizeValues = map.map((key, value) {
      return MapEntry(key, value.cast<String, String>());
    });
  }

  String getLocalizedString(String key) {
    String value = _localizeValues[locale.languageCode][key];
    if (StringUtils.isNull(value)) {
      value = key;
    }
    return value;
  }
}