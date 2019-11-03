import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:movies_app/utilities/localization/models/all.dart';
import 'package:movies_app/utilities/localization/translations/all.dart';

class Localizer {
  TranslationModel translation;
  LanguageModel currentLanguage;

  Localizer(Locale newLocale) {
    currentLanguage = supportedLanguages.firstWhere((LanguageModel language) => language.locale.languageCode == newLocale.languageCode);
    translation = currentLanguage.translation;
  }

  static final List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'bs',
      name: 'Bosanski',
      translation: translationBosnian,
      iconPath: 'assets/photos/flags/bosnian.png',
    ),
    LanguageModel(
      code: 'en',
      name: 'English',
      translation: translationEnglish,
      iconPath: 'assets/photos/flags/english.png',
    ),
  ];

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  static const _Delegate delegate = _Delegate();

  static LanguageModel get defaultLanguage => supportedLanguages[0];

  static Locale getSupportedLocale(Locale deviceLocale, Iterable<Locale> supportedLocales) {
    bool deviceLocaleSupported = supportedLocales.any((Locale locale) => deviceLocale.languageCode == locale.languageCode);

    return deviceLocaleSupported ? deviceLocale : defaultLanguage.locale;
  }
}

class _Delegate extends LocalizationsDelegate<Localizer> {
  const _Delegate();

  @override
  bool isSupported(Locale locale) {
    return Localizer.supportedLanguages.map((LanguageModel language) => language.locale.languageCode).contains(locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return SynchronousFuture<Localizer>(Localizer(locale));
  }

  @override
  bool shouldReload(_Delegate old) => false;
}
