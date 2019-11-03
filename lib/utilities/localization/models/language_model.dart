import 'dart:ui';

import 'package:movies_app/utilities/localization/models/translation_model.dart';

class LanguageModel {
  final String name;
  final String iconPath;
  final Locale locale;
  final TranslationModel translation;

  LanguageModel({
    String code,
    this.name,
    this.iconPath,
    this.translation,
  }) : locale = Locale(code);
}
