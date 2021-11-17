import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/provider/clear_all/clear_all_data_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/clear_all_data_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/version_update_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/app_info_parameter_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/app_info/app_info_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/app_info_repository.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/ps_app_info.dart';
import 'package:provider/single_child_widget.dart';

class AppLoadingView extends StatelessWidget {
  Future<dynamic> callDateFunction(AppInfoProvider provider,
      ClearAllDataProvider clearAllDataProvider, BuildContext context) async {
    String realStartDate = '0';
    String realEndDate = '0';

    AppInfoParameterHolder appInfoParameterHolder;
    if (await Utils.checkInternetConnectivity()) {
      if (provider.psValueHolder == null ||
          provider.psValueHolder.startDate == null) {
        realStartDate =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      } else {
        realStartDate = provider.psValueHolder.endDate;
      }
      appInfoParameterHolder = AppInfoParameterHolder(
          startDate: realStartDate,
          endDate: realEndDate,
          userId: Utils.checkUserLoginId(provider.psValueHolder));

      realEndDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      final PsResource<PSAppInfo> _psAppInfo =
          await provider.loadDeleteHistory(appInfoParameterHolder.toMap());

      if (_psAppInfo.status == PsStatus.SUCCESS) {
        provider.replaceDate(realStartDate, realEndDate);
        print(Utils.getString(context, 'app_info__cancel_button_name'));
        print(Utils.getString(context, 'app_info__update_button_name'));

        if (_psAppInfo.data.userInfo.userStatus == RoyalBoardConst.USER_BANNED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__banned'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (_psAppInfo.data.userInfo.userStatus ==
            RoyalBoardConst.USER_DELECTED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__deleted'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (_psAppInfo.data.userInfo.userStatus ==
            RoyalBoardConst.USER_UN_PUBLISHED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__unpublished'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else {
          checkVersionNumber(
              context, _psAppInfo.data, provider, clearAllDataProvider);
          realStartDate = realEndDate;
        }
      } else if (_psAppInfo.status == PsStatus.ERROR) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.home,
      );
    }
  }

  dynamic callLogout(
      AppInfoProvider appInfoProvider, int index, BuildContext context) async {
    // updateSelectedIndex( index);
    appInfoProvider.replaceLoginUserId('');
    appInfoProvider.replaceLoginUserName('');
    // await deleteTaskProvider.deleteTask();
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/flutter_grocery_logo.png',
    ),
  );

  dynamic checkVersionNumber(
      BuildContext context,
      PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider,
      ClearAllDataProvider clearAllDataProvider) async {
    if (RoyalBoardConfig.app_version != psAppInfo.psAppVersion.versionNo) {
      if (psAppInfo.psAppVersion.versionNeedClearData == RoyalBoardConst.ONE) {
        await clearAllDataProvider.clearAllData();
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      } else {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      }
    } else {
      appInfoProvider.replaceVersionForceUpdateData(false);

      if (psAppInfo.shopObject.ismulti == '1') {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.singlehome,
          arguments: ShopDataIntentHolder(
              shopId: psAppInfo.shopObject.shop.id,
              shopName: psAppInfo.shopObject.shop.name),
        );
      }
    }
  }

  dynamic checkForceUpdate(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) {
    if (psAppInfo.psAppVersion.versionForceUpdate == RoyalBoardConst.ONE) {
      appInfoProvider.replaceAppInfoData(
          psAppInfo.psAppVersion.versionNo,
          true,
          psAppInfo.psAppVersion.versionTitle,
          psAppInfo.psAppVersion.versionMessage);

      Navigator.pushReplacementNamed(
        context,
        RoutePaths.force_update,
        arguments: psAppInfo.psAppVersion,
      );
    } else if (psAppInfo.psAppVersion.versionForceUpdate == RoyalBoardConst.ZERO) {
      appInfoProvider.replaceVersionForceUpdateData(false);
      callVersionUpdateDialog(context, psAppInfo);
    } else {
      if (psAppInfo.shopObject.ismulti == '1') {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.singlehome,
          arguments: ShopDataIntentHolder(
              shopId: psAppInfo.shopObject.shop.id,
              shopName: psAppInfo.shopObject.shop.name),
        );
      }
    }
  }

  dynamic callVersionUpdateDialog(BuildContext context, PSAppInfo psAppInfo) {
    showDialog<dynamic>(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return;
              },
              child: VersionUpdateDialog(
                title: psAppInfo.psAppVersion.versionTitle,
                description: psAppInfo.psAppVersion.versionMessage,
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText:
                    Utils.getString(context, 'app_info__update_button_name'),
                onCancelTap: () {
                  if (psAppInfo.shopObject.ismulti == '1') {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.singlehome,
                      arguments: ShopDataIntentHolder(
                          shopId: psAppInfo.shopObject.shop.id,
                          shopName: psAppInfo.shopObject.shop.name),
                    );
                  }
                },
                onUpdateTap: () async {
                  if (psAppInfo.shopObject.ismulti == '1') {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.singlehome,
                      arguments: ShopDataIntentHolder(
                          shopId: psAppInfo.shopObject.shop.id,
                          shopName: psAppInfo.shopObject.shop.name),
                    );
                  }
                  if (Platform.isIOS) {
                    Utils.launchAppStoreURL(iOSAppId: RoyalBoardConfig.iOSAppStoreId);
                  } else if (Platform.isAndroid) {
                    Utils.launchURL();
                  }
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    AppInfoRepository repo1;
    AppInfoProvider provider;
    ClearAllDataRepository clearAllDataRepository;
    ClearAllDataProvider clearAllDataProvider;
    PsValueHolder valueHolder;

    RoyalBoardColors.loadColor(context);
    repo1 = Provider.of<AppInfoRepository>(context);
    clearAllDataRepository = Provider.of<ClearAllDataRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (valueHolder == null) {
      return Container();
    }
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    return
        // EasyLocalizationProvider(
        //   data: data,
        //   child:
        MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ClearAllDataProvider>(
            lazy: false,
            create: (BuildContext context) {
              clearAllDataProvider = ClearAllDataProvider(
                  repo: clearAllDataRepository, psValueHolder: valueHolder);

              return clearAllDataProvider;
            }),
        ChangeNotifierProvider<AppInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider =
                  AppInfoProvider(repo: repo1, psValueHolder: valueHolder);
              callDateFunction(provider, clearAllDataProvider, context);
              return provider;
            }),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider,
            Widget child) {

          return Consumer<AppInfoProvider>(builder: (BuildContext context,
              AppInfoProvider clearAllDataProvider, Widget child) {
            var size=MediaQuery.of(context).size;
            return Container(
                height: size.height,
                width: size.width,
                color: Colors.white,
                // color: RoyalBoardColors.mainColor,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/gg.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _imageWidget,


                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        Text(
                          'السوق المشترك',
                          // Utils.getString(context, 'app_info__splash_name'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: RoyalBoardColors.black),
                        ),
                        Text(
                          'Suqmshtrk.com',
                          // Utils.getString(context, 'app_info__splash_name'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: RoyalBoardColors.black),
                        ),

                        Container(
                          padding: const EdgeInsets.all(PsDimens.space16),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: PsButtonWidget(
                              provider: provider,
                              text: Utils.getString(
                                  context, 'app_info__submit_button_name'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          });
        },
      ),
      // ),
    );
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({
    @required this.provider,
    @required this.text,
  });
  final AppInfoProvider provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(RoyalBoardColors.loadingCircleColor),
        strokeWidth: 5.0);
  }
}
