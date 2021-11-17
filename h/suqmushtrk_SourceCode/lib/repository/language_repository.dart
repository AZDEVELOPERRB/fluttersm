import 'dart:async';

import 'package:RoyalBoard_Common_sooq/viewobject/common/language_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/common/ps_shared_preferences.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/language.dart';

class LanguageRepository extends PsRepository {
  LanguageRepository({@required PsSharedPreferences psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  final StreamController<PsLanguageValueHolder> _valueController =
      StreamController<PsLanguageValueHolder>();
  Stream<PsLanguageValueHolder> get psValueHolder => _valueController.stream;

  PsSharedPreferences _psSharedPreferences;

  void loadLanguageValueHolder() {
    final String _languageCodeKey = _psSharedPreferences.shared
        .getString(RoyalBoardConst.LANGUAGE__LANGUAGE_CODE_KEY);
    final String _countryCodeKey = _psSharedPreferences.shared
        .getString(RoyalBoardConst.LANGUAGE__COUNTRY_CODE_KEY);
    final String _languageNameKey = _psSharedPreferences.shared
        .getString(RoyalBoardConst.LANGUAGE__LANGUAGE_NAME_KEY);

    _valueController.add(PsLanguageValueHolder(
      languageCode: _languageCodeKey,
      countryCode: _countryCodeKey,
      name: _languageNameKey,
    ));
  }

  Future<void> addLanguage(Language language) async {
    await _psSharedPreferences.shared
        .setString(RoyalBoardConst.LANGUAGE__LANGUAGE_CODE_KEY, language.languageCode);
    await _psSharedPreferences.shared
        .setString(RoyalBoardConst.LANGUAGE__COUNTRY_CODE_KEY, language.countryCode);
    await _psSharedPreferences.shared
        .setString(RoyalBoardConst.LANGUAGE__LANGUAGE_NAME_KEY, language.name);
    await _psSharedPreferences.shared.setString('locale',
        Locale(language.languageCode, language.countryCode).toString());
    loadLanguageValueHolder();
  }

  Language getLanguage() {
    final String languageCode = _psSharedPreferences.shared
            .getString(RoyalBoardConst.LANGUAGE__LANGUAGE_CODE_KEY) ??
        RoyalBoardConfig.defaultLanguage.languageCode;
    final String countryCode = _psSharedPreferences.shared
            .getString(RoyalBoardConst.LANGUAGE__COUNTRY_CODE_KEY) ??
        RoyalBoardConfig.defaultLanguage.countryCode;
    final String languageName = _psSharedPreferences.shared
            .getString(RoyalBoardConst.LANGUAGE__LANGUAGE_NAME_KEY) ??
        RoyalBoardConfig.defaultLanguage.name;

    return Language(
        languageCode: languageCode,
        countryCode: countryCode,
        name: languageName);
  }
}
