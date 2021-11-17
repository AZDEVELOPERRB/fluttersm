import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:RoyalBoard_Common_sooq/config/router.dart' as router;
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_theme_data.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_theme_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/RoyalBoard_provider_dependencies.dart';
import 'package:RoyalBoard_Common_sooq/repository/ps_theme_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'config/RoyalBoard_colors.dart';
import 'config/RoyalBoard_config.dart';
import 'db/common/ps_shared_preferences.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

 await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }



  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }

  Firebase.initializeApp();
  // NativeAdmob(adUnitID: Utils.getAdAppId());

  //check is apple signin is available
  // await Utils.checkAppleSignInAvailable();


  runApp(EasyLocalization(
      // data: data,
      // assetLoader: CsvAssetLoader(),
      path: 'assets/langs',
      supportedLocales: getSupportedLanguages(),
      child: RoyalApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in RoyalBoardConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }

  return localeList;
}

class RoyalApp extends StatefulWidget {
  @override
  _RoyalAppState createState() => _RoyalAppState();
}

Future<dynamic> initAds() async {

  if (RoyalBoardConfig.showAdMob && await Utils.checkInternetConnectivity()) {}
}

class _RoyalAppState extends State<RoyalApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {

    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      //SharedPreferences sh = await
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();

        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in RoyalBoardConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    final vscreen=Markets_repo().getVendor_first_Screen();


    // init Color
    RoyalBoardColors.loadColor(context);

    
    FlutterStatusbarManager.setNavigationBarColor( Colors.grey[900],
        animated: true);
    FlutterStatusbarManager.setNavigationBarStyle(NavigationBarStyle.LIGHT);
    FlutterStatusbarManager.setColor( RoyalBoardColors.transparent, animated: true);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'السوق المشترك',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));
  }
}
