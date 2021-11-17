// Copyright (c) 2021, the ٌRoyal Board.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// ٌRoyal Board license that can be found in the LICENSE file.

import 'package:RoyalBoard_Common_sooq/viewobject/common/language.dart';
import 'package:RoyalBoard_Common_sooq/api/ENC_RoyalServices.dart';

class RoyalBoardConfig {
  RoyalBoardConfig._();
  static const String app_version = '1.0';
  static const String RoyalBoardServerLanucher = 'royalBoardCompany';
  static final String RoyalBoardCoreUrl =ENC_Royal_Services.RBU;
  static final String RoyalBoardAppUrl = RoyalBoardCoreUrl + '/index.php/';
  static final String RoyalBoardImagesUrl = ENC_Royal_Services.RBUt + '/uploads/';
  static final String RoyalBoardThumbsUrl = RoyalBoardCoreUrl + '/thumbnail/';
  static const Duration animation_duration = Duration(milliseconds: 500);

  static const List<String> admobKeywords = <String>[
    'RoyalBoardCompany',
    'RoyalBoardCompany',
    'RoyalBoardCompany',
    'RoyalBoardCompany'
  ];
  static const String admobContentUrl = 'https://flutter.io';
  static const String ps_default_font_family = 'Product Sans';

  /// Default Language
  // static const ps_default_language = 'en';

  // static const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
  static const String ps_app_db_name = 'ps_db.db';

  ///
  /// For default language change, please check
  /// LanguageFragment for language code and country code
  /// ..............................................................
  /// Language             | Language Code     | Country Code
  /// ..............................................................
  /// "English"            | "en"              | "US"
  /// "Arabic"             | "ar"              | "DZ"
  /// "India (Hindi)"      | "hi"              | "IN"
  /// "German"             | "de"              | "DE"
  /// "Spainish"           | "es"              | "ES"
  /// "French"             | "fr"              | "FR"
  /// "Indonesian"         | "id"              | "ID"
  /// "Italian"            | "it"              | "IT"
  /// "Japanese"           | "ja"              | "JP"
  /// "Korean"             | "ko"              | "KR"
  /// "Malay"              | "ms"              | "MY"
  /// "Portuguese"         | "pt"              | "PT"
  /// "Russian"            | "ru"              | "RU"
  /// "Thai"               | "th"              | "TH"
  /// "Turkish"            | "tr"              | "TR"
  /// "Chinese"            | "zh"              | "CN"
  /// ..............................................................
  ///
  static final Language defaultLanguage =
  Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),

  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  static const String priceFormat = ',##0.00';

  ///
  /// Date Time Format
  ///
  static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  ///
  /// Default Date Time For Minute
  ///
  static const int defaultOrderTime = 20;

  ///
  /// iOS App No
  ///
  static const String iOSAppStoreId = '000000000';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'RoyalBoard_Common_sooq';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  static const bool USE_THUMBNAIL_AS_PLACEHOLDER = false;

  ///
  /// Token Id
  ///
  static const bool isShowTokenId = false;

  ///
  ///ShowSubCategory
  ///
  static const bool isShowSubCategory = true;

  ///
  /// Facebook Key
  ///
  static const String fbKey = '1316734058679794';
  // static const String fbKey = '0000000000000000';

  ///
  ///Admob Setting
  ///
  static bool showAdMob = false;


  static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey =  'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';

  ///
  /// Image Size
  ///
  static const int profileImageAize = 512;

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 30;
  static const int CATEGORY_LOADING_LIMIT = 12;
  static const int COLLECTION_PRODUCT_LOADING_LIMIT = 12;
  static const int DISCOUNT_PRODUCT_LOADING_LIMIT = 12;
  static const int FEATURE_PRODUCT_LOADING_LIMIT = 12;
  static const int LATEST_PRODUCT_LOADING_LIMIT = 12;
  static const int TRENDING_PRODUCT_LOADING_LIMIT = 12;
  static const int SHOP_LOADING_LIMIT = 10;

  ///
  ///Login Setting
  ///
  static bool showFacebookLogin = false;
  static bool showGoogleLogin = false;
  static bool showPhoneLogin = true;

  ///
  /// Dashboard Setting
  ///
  static bool showHome = false;
  static bool showSpecialCollections = false;
  static bool showFeaturedItems = false;

  ///
  /// Default Location
  ///
  static String lat = '1.331117';
  static String lng = '103.849622';

  ///
  /// Razor Currency
  ///
  static bool isRazorSupportMultiCurrency = false;
  static String defaultRazorCurrency = 'INR';
}
