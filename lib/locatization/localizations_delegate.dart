import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphic_conversion/locatization/localizations.dart';

class JYLocalizationsDelegate extends LocalizationsDelegate<JYLocalizations> {
  static JYLocalizationsDelegate delegate = JYLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["zh", "en"].contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<JYLocalizations> old) {
    return false;
  }

  @override
  Future<JYLocalizations> load(Locale locale) async {
    final localizations = JYLocalizations(locale);
    await localizations.loadJson();
    return localizations;
  }
}