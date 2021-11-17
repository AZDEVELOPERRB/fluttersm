import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_theme_data.dart';
import 'package:RoyalBoard_Common_sooq/db/common/ps_shared_preferences.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';

class PsThemeRepository extends PsRepository {
  PsThemeRepository({@required PsSharedPreferences psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  PsSharedPreferences _psSharedPreferences;

  Future<void> updateTheme(bool isDarkTheme) async {
    await _psSharedPreferences.shared
        .setBool(RoyalBoardConst.THEME__IS_DARK_THEME, isDarkTheme);
  }

  ThemeData getTheme() {
    final bool isDarkTheme =
        _psSharedPreferences.shared.getBool(RoyalBoardConst.THEME__IS_DARK_THEME) ??
            false;

    if (isDarkTheme) {
      return themeData(ThemeData.dark());
    } else {
      return themeData(ThemeData.light());
    }
  }
}
