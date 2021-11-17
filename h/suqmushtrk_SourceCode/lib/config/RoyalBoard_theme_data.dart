import 'package:flutter/material.dart';
import 'RoyalBoard_colors.dart';
import 'RoyalBoard_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    RoyalBoardColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: RoyalBoardColors.mainColor,
      primaryColorDark: RoyalBoardColors.mainDarkColor,
      primaryColorLight: RoyalBoardColors.mainLightColor,
      textTheme: TextTheme(
        headline1: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        headline2: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        headline3: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        headline4: TextStyle(
          color: RoyalBoardColors.textPrimaryColor,
          fontFamily: RoyalBoardConfig.ps_default_font_family,
        ),
        headline5: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        subtitle1: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        subtitle2: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        bodyText1: TextStyle(
          color: RoyalBoardColors.textPrimaryColor,
          fontFamily: RoyalBoardConfig.ps_default_font_family,
        ),
        bodyText2: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        button: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        caption: TextStyle(
            color: RoyalBoardColors.textPrimaryLightColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
        overline: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family),
      ),
      iconTheme: IconThemeData(color: RoyalBoardColors.iconColor),
      appBarTheme: AppBarTheme(color: RoyalBoardColors.coreBackgroundColor),
    );
  } else {
    RoyalBoardColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: RoyalBoardColors.mainColor,
        primaryColorDark: RoyalBoardColors.mainDarkColor,
        primaryColorLight: RoyalBoardColors.mainLightColor,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          headline2: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          headline3: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          headline4: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
          ),
          headline5: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          subtitle1: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            color: RoyalBoardColors.textPrimaryColor,
            fontFamily: RoyalBoardConfig.ps_default_font_family,
          ),
          bodyText2: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          button: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          caption: TextStyle(
              color: RoyalBoardColors.textPrimaryLightColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
          overline: TextStyle(
              color: RoyalBoardColors.textPrimaryColor,
              fontFamily: RoyalBoardConfig.ps_default_font_family),
        ),
        iconTheme: IconThemeData(color: RoyalBoardColors.iconColor),
        appBarTheme: AppBarTheme(color: RoyalBoardColors.coreBackgroundColor));
  }
}
