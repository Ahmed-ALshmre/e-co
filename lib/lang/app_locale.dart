import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocale {
  Locale locale;
  AppLocale(this.locale);
  Map<String, String> _loadedLocaleValues;
  static AppLocale of(BuildContext context) {
    return Localizations.of(context, AppLocale);
  }

  Future loadLang() async {
    String _langFile =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> _loadValues = jsonDecode(_langFile);
    _loadedLocaleValues =
        _loadValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslated(String key) {
    return _loadedLocaleValues[key];
  }

  static const LocalizationsDelegate<AppLocale> delegate =
      _AppLocaleDelegates();
}

class _AppLocaleDelegates extends LocalizationsDelegate<AppLocale> {
  const _AppLocaleDelegates();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  // ignore: missing_return
  Future<AppLocale> load(Locale locale) async {
    AppLocale appLocale = AppLocale(locale);
    await appLocale.loadLang();
    return appLocale;
  }

  @override
  bool shouldReload(_AppLocaleDelegates old) => false;
}
