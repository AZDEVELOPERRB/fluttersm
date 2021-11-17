import 'dart:io';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/Friends_applied.dart';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/friends_list.dart';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/send_frequest.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/link_noti_products_holder.dart';
import 'package:RoyalBoard_Common_sooq/RoyalBoard_functions/common.dart';
import 'package:RoyalBoard_Common_sooq/ui/app_info/app_info_view.dart';
import 'package:http/http.dart' as http;
import 'package:RoyalBoard_Common_sooq/ui/gm/Firm/firm_gifts.dart';
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/ui/noti/list/noti_list_view.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/notification_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/delete_task/delete_task_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/shop_info/shop_info_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/notification_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/basket_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/delete_task_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_info_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/basket/list/basket_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/category/list/category_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/category/list/category_list_markets.dart';
import 'package:RoyalBoard_Common_sooq/ui/collection/header_list/collection_header_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/contact/contact_us_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/confirm_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/home/main_cat_dashview.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/home/main_dashboard_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog.dart';
import 'package:RoyalBoard_Common_sooq/ui/history/list/history_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/language/setting/language_setting_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/points/point.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/favourite/favourite_product_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/list_with_filter/product_list_with_filter_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/shopsvendor/mshops.dart';
import 'package:RoyalBoard_Common_sooq/ui/shopsvendor/Mufrad.dart';
import 'package:RoyalBoard_Common_sooq/ui/shopsvendor/searched_markets.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/shop_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/ui/search/home_item_search_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/transaction/list/transaction_list_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/setting/setting_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/forgot_password/forgot_password_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/login/login_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/profile/profile_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/register/register_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/verify/verify_email_view.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/blog_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/ui/app_info/app_instruction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:provider/single_child_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_info_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_list_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/provider/shop/new_shop_provider.dart';

class DashboardView extends StatefulWidget {
  String indexss;
  DashboardView({this.indexss});

  @override
  _HomeViewState createState() => _HomeViewState(indexss: indexss);
}

class _HomeViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  String indexss;
  _HomeViewState({this.indexss});
  NewShopProvider newShopProvider;

  AnimationController animationController;

  Animation<double> animation;
  BasketRepository basketRepository;

  String appBarTitle = 'Home';
  TextEditingController searchi = new TextEditingController();
  bool _isSearching=false;

  final ProductParameterHolder productParameterHolder =
  ProductParameterHolder().getLatestParameterHolder();
  int _currentIndex = RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
bool brightload=false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ShopInfoProvider shopInfoProvider;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  Future<bool> allWillpopfunction(){
    setState(() {
      _currentIndex=RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    });
  }
  Future<void> RoyalBoardLaunchURL() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri RBU = dynamicLink?.link;
          if (RBU != null) {
            setState(() {_currentIndex=RoyalBoardConst.dynamic_link_progress;});
           String a='${RBU}';
           var product_id=a.split('itemId=');
            Map mar = {'user_id':  valueHolder.loginUserId, 'product_id':'${product_id.first}'};
            String url = '${RoyalBoardConfig.RoyalBoardAppUrl}rest/users/get_product_name/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';var response= await http.post(url,body: mar);var message=jsonDecode(response.body)['message'];
            productParameterHolder.searchTerm = '${message}';Utils.psPrint(productParameterHolder.searchTerm);setState(() {_currentIndex=RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;});



            Navigator.pushNamed(context, RoutePaths.filterProductList_new,
                arguments: LinkNotiProductsList(
                    appBarTitle: Utils.getString(
                        context, 'home_search__app_bar_title'),
                    productParameterHolder: productParameterHolder,
                    prod_id:product_id.first
                ));

          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri RBU = data?.link;
    if (RBU != null) {
      setState(() {
        _currentIndex=RoyalBoardConst.dynamic_link_progress;
      });
      String a='${RBU}';
      var product_id=a.split('itemId=');Map mar = {'user_id':  valueHolder.loginUserId, 'product_id':'${product_id.first}'};String ur = '${RoyalBoardConfig.RoyalBoardAppUrl}rest/users/get_product_name/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';var response= await http.post(ur,body: mar);var message=jsonDecode(response.body)['message'];
      productParameterHolder.searchTerm = '${message}';Utils.psPrint(productParameterHolder.searchTerm);setState(() {_currentIndex=RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;});



      Navigator.pushNamed(context, RoutePaths.filterProductList_new,
          arguments: LinkNotiProductsList(
              appBarTitle: Utils.getString(
                  context, 'home_search__app_bar_title'),
              productParameterHolder: productParameterHolder,
              prod_id:product_id.first
          ));

    }
  }
  @override
  void initState() {
    RoyalBoardLaunchURL();
    if(indexss!=null&&indexss=='afrad'){
      appBarTitle = 'title';
      _currentIndex = RoyalBoardConst.afrad_section;
    }

    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);

    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case RoyalBoardConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT:
        index = 1;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
        index = 2;
        break;
      case RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT:
        index = 3;

        break;
      case RoyalBoardConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = Utils.getString(context, 'app_name');
        break;
      case 1:
        // index = RoyalBoardConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT;
        index = RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT;
        title = Utils.getString(context, 'home__menu_drawer_favourite');
        break;
      case 2:
        index = RoyalBoardConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_basket_list');

        break;
      case 3:
        index = RoyalBoardConst.REQUEST_CODE__MENU_bloglist;
        title = 'التعليمات';
        break;
      case 4:
        index = RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (psValueHolder == null ||
            psValueHolder.userIdToVerify == null ||
            psValueHolder.userIdToVerify == '')
            ? Utils.getString(context, 'home__bottom_app_bar_login')
            : Utils.getString(context, 'home__bottom_app_bar_verify_email');
        break;
      default:
        index = 0;
        title = Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  ShopInfoRepository shopInfoRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  NotificationRepository notificationRepository;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;

  @override
  Widget build(BuildContext context) {
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);
    productRepository = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString(context, 'app_name');

      Utils.subscribeToTopic(valueHolder.notiSetting ?? true);

      Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
      isFirstTime = false;
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<void> updateSelectedIndexWithAnimationUserId(
        String title, int index, String userId) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }
        if (userId != null) {
          _userId = userId;
        }
        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }
    bool isDarkOrWhite = false;

    Future<bool> _onWillPop() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
    }
    int _lastTimeBackButtonWasTapped;
     const exitTimeInMillis = 2000;
    Future<bool> _handleWillPops() async {
      return false;
    Navigator.push(context, MaterialPageRoute(
      builder: (ctx)=>DashboardView()
    ));
    }
    Future<bool> _handleWillPop() async {
      final _currentTime = DateTime.now().millisecondsSinceEpoch;

      if (_lastTimeBackButtonWasTapped != null &&
          (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'home__quit_dialog_description'),
                  leftButtonText: Utils.getString(
                      context, 'app_info__cancel_button_name'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () {
                    SystemNavigator.pop();
                  });
            }) ??
            false;
      } else {
        _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      }
    }
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return brightload==true?Center(child: CircularProgressIndicator(),): Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<UserProvider>(
                lazy: false,
                create: (BuildContext context) {
                  return UserProvider(
                      repo: userRepository, psValueHolder: valueHolder);
                }),
            ChangeNotifierProvider<DeleteTaskProvider>(
                lazy: false,
                create: (BuildContext context) {
                  deleteTaskProvider = DeleteTaskProvider(
                      repo: deleteTaskRepository, psValueHolder: valueHolder);
                  return deleteTaskProvider;
                }),
          ],
          child: Consumer<UserProvider>(
            builder:
                (BuildContext context, UserProvider provider, Widget child) {
              print(provider.psValueHolder.loginUserId);
              return
                ListView(padding: EdgeInsets.zero, children: <Widget>[
                _DrawerHeaderWidget(),
                ListTile(
                  title: Text(
                      Utils.getString(context, 'app_name')),
                ),
                _DrawerMenuWidget(
                    icon: Icons.home,
                    title: Utils.getString(context, 'home__drawer_menu_home'),
                    index: RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(
                          Utils.getString(context, 'app_name'), index);
                    }),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                          icon: Icons.gamepad_rounded,
                          title: 'ارباح لعبة فرم الاسعار',
                          index:
                          RoyalBoardConst.firm_prices_gifts,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          },
                        ),
                      ),
                _DrawerMenuWidget(
                    icon: Icons.schedule,
                    title: Utils.getString(
                        context, 'home__drawer_menu_latest_product'),
                    index: RoyalBoardConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),

                _DrawerMenuWidget(
                    icon: Icons.store,
                    title:'متاجر الجملة',
                    index: RoyalBoardConst.REQUEST_CODE__MENU_vendors_FRAGMENT,
                    onTap: (String title, int index) {

                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title:'متاجر المفرد',
                      index: RoyalBoardConst.REQUEST_CODE__MENU_mufrad,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                _DrawerMenuWidget(
                    icon: FontAwesome5.gem,
                    title: Utils.getString(
                        context, 'home__menu_drawer_featured_product'),
                    index:
                        RoyalBoardConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                _DrawerMenuWidget(
                    icon: Icons.trending_up,
                    title: Utils.getString(
                        context, 'home__drawer_menu_trending_product'),
                    index:
                        RoyalBoardConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                const Divider(
                  height: PsDimens.space1,
                ),
                ListTile(
                  title: Text(Utils.getString(
                      context, 'home__menu_drawer_user_info')),
                ),
                _DrawerMenuWidget(
                    icon: Icons.person,
                    title:
                        Utils.getString(context, 'home__menu_drawer_profile'),
                    index:
                        RoyalBoardConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      title = (valueHolder == null ||
                              valueHolder.userIdToVerify == null ||
                              valueHolder.userIdToVerify == '')
                          ? Utils.getString(
                              context, 'home__menu_drawer_profile')
                          : Utils.getString(
                              context, 'home__bottom_app_bar_verify_email');
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                if (provider != null)
                  if (provider.psValueHolder.loginUserId != null &&
                      provider.psValueHolder.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                          icon: Icons.favorite_border,
                          title: Utils.getString(
                              context, 'home__menu_drawer_favourite'),
                          index:
                              RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          }),
                    ),
                if (provider != null)
                  if (provider.psValueHolder.loginUserId != null &&
                      provider.psValueHolder.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                        icon: Icons.swap_horiz,
                        title: Utils.getString(
                            context, 'home__menu_drawer_transaction'),
                        index:
                            RoyalBoardConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        },
                      ),
                    ),
                Visibility(
                  visible: true,
                  child: _DrawerMenuWidget(
                    icon: Icons.attach_money,
                    title: Utils.getString(
                        context, 'home__menu_drawer_Pointsss'),
                    index:
                    RoyalBoardConst.REQUEST_CODE__MENU_HOME_point,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    },
                  ),
                ),

                if (provider != null)
                  if (provider.psValueHolder.loginUserId != null &&
                      provider.psValueHolder.loginUserId != '')
                if (provider != null)
                  if (provider.psValueHolder.loginUserId != null &&
                      provider.psValueHolder.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: ListTile(
                        leading: Icon(
                          Icons.power_settings_new,
                          color: RoyalBoardColors.mainColorWithWhite,
                        ),
                        title: Text(
                          Utils.getString(
                              context, 'home__menu_drawer_logout'),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmDialogView(
                                    description: Utils.getString(context,
                                        'home__logout_dialog_description'),
                                    leftButtonText: Utils.getString(context,
                                        'home__logout_dialog_cancel_button'),
                                    rightButtonText: Utils.getString(context,
                                        'home__logout_dialog_ok_button'),
                                    onAgreeTap: () async {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _currentIndex = RoyalBoardConst
                                            .REQUEST_CODE__MENU_HOME_FRAGMENT;
                                      });
                                      provider.replaceLoginUserId('');
                                      await deleteTaskProvider.deleteTask();
                                      await FacebookLogin().logOut();
                                      await GoogleSignIn().signOut();
                                      await FirebaseAuth.instance.signOut();
                                    });
                              });
                        },
                      ),
                    ),
                const Divider(
                  height: PsDimens.space1,
                ),
                ListTile(
                  title:
                      Text(Utils.getString(context, 'home__menu_drawer_app')),
                ),
                  _DrawerMenuWidget(
                      icon: Icons.info,
                      title:
                      'حولنا',
                      index: RoyalBoardConst.App_Info,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                _DrawerMenuWidget(
                    icon: Icons.contacts,
                    title: Utils.getString(
                        context, 'home__menu_drawer_contact_us'),
                    index: RoyalBoardConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),

                _DrawerMenuWidget(
                    icon: Icons.settings,
                    title:
                        Utils.getString(context, 'home__menu_drawer_setting'),
                    index: RoyalBoardConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                _DrawerMenuWidget(
                    icon: Icons.info_outline,
                    title: Utils.getString(
                        context, 'privacy_policy__toolbar_name'),
                    index: RoyalBoardConst
                        .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      updateSelectedIndexWithAnimation(title, index);
                    }),
                ListTile(
                  leading: Icon(
                    Icons.star_border,
                    color: RoyalBoardColors.mainColorWithWhite,
                  ),
                  title: Text(
                    Utils.getString(
                        context, 'home__menu_drawer_rate_this_app'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (Platform.isIOS) {
                      Utils.launchAppStoreURL(
                          iOSAppId: RoyalBoardConfig.iOSAppStoreId,
                          writeReview: true);
                    } else {
                      Utils.launchURL();
                    }
                  },
                )
              ]);
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: RoyalBoardColors.backgroundColor,
        title:  Container(
          width: 200,
          height: 35,
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
            controller: searchi,
            cursorColor: Colors.blue,
            decoration: InputDecoration.collapsed(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(17.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[600]),
                hintText: "ابحث معرف المتجر",
                fillColor: Colors.white),
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: RoyalBoardColors.textPrimaryColor),
        textTheme: Theme.of(context).textTheme,
        brightness: Utils.getBrightnessForAppBar(context),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching==false?   Icons.search_rounded:Icons.close),
            onPressed:() {
              if(searchi.text==''){
                Fluttertoast.showToast(
                    msg:
                    'يجب ان لايكون المعرف فارغ',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor:Colors.red,
                    textColor:Colors.white);
                return;
              }
              if(_isSearching==true){

                setState(() {
                  _isSearching=false;
                });
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                 builder: (ctx)=>DashboardView()
               ), (route) => false);
              }
              if(_isSearching==false){
                updateSelectedIndexWithAnimation('المتجر الذي تبحث عنه',  RoyalBoardConst.REQUEST_CODE__MENU_search);

                setState(() {
                  _isSearching=true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: Color(0xfffdd835),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (ctx)=>NotiListView(userId: _userId,)
              ));
            },
          ),
          IconButton(
            icon: Utils.isLightMode(context)?Container(
            height: 30,
              child: Image.asset(
                "assets/images/moon.png",
                height: 30,

              ),
            ):Icon(Icons.wb_twighlight),
            onPressed: () {
              RoyalBoardColors.loadColor2(isDarkOrWhite);
              changeBrightness(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
              _currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
          _currentIndex ==
              RoyalBoardConst.REQUEST_CODE__MENU_bloglist ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
          ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: getBottonNavigationIndex(_currentIndex),
                showUnselectedLabels: false,
                backgroundColor: RoyalBoardColors.backgroundColor,
                selectedItemColor: RoyalBoardColors.mainColor,
                elevation: 10,
                showSelectedLabels: false,
                onTap: (int index) {


                    final dynamic _returnValue =
                    getIndexFromBottonNavigationIndex(index);

                    updateSelectedIndexWithAnimation(
                        _returnValue[0], _returnValue[1]);


                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/hhom.png",
                      height: 30,

                    ),
                    label: Utils.getString(context, 'dashboard__home'),
                  ),
                  BottomNavigationBarItem(
                    icon:Image.asset(
                      "assets/images/liked.png",
                      height: 30,

                    ),
                    label: Utils.getString(
                        context, 'home__drawer_menu_category'),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/shim.png",
                      height: 30,

                    ),
                    label: Utils.getString(
                        context, 'home__bottom_app_bar_login'),
                  ),
                  BottomNavigationBarItem(
                    icon:  Image.asset(
                      "assets/images/bookread.png",
                      height: 30,

                    ),
                    label: Utils.getString(
                        context, 'home__bottom_app_bar_search'),
                  ),
                  BottomNavigationBarItem(
                    icon:  Image.asset(
                      "assets/images/pers.png",
                      height: 30,

                    ),
                    label: Utils.getString(
                        context, 'home__bottom_app_bar_basket_list'),
                  ),
                ],
              )
          : null,
      floatingActionButton: _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst
                      .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
          _currentIndex ==
              RoyalBoardConst.REQUEST_CODE__MENU_bloglist ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
              _currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
          ? Container(
              height: 65.0,
              width: 65.0,
              child: FittedBox(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: RoyalBoardColors.mainColor.withOpacity(0.3),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Container()),
              ),
            )
          : null,
      body: ChangeNotifierProvider<NotificationProvider>(
        lazy: false,
        create: (BuildContext context) {
          final NotificationProvider provider = NotificationProvider(
              repo: notificationRepository, psValueHolder: valueHolder);

          if (provider.psValueHolder.deviceToken == null ||
              provider.psValueHolder.deviceToken == '') {
            final FirebaseMessaging _fcm = FirebaseMessaging();
            Utils.saveDeviceToken(_fcm, provider);
          } else {
            print(
                'Notification Token is already registered. Notification Setting : true.');
          }

          return provider;
        },

        child: Builder(
          builder: (BuildContext context) {
            if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              return  WillPopScope(
                onWillPop: (){},
                child: ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      final UserProvider provider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);
                      //provider.getUserLogin();
                      return provider;
                    },
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                      if (provider == null ||
                          provider.psValueHolder.userIdToVerify == null ||
                          provider.psValueHolder.userIdToVerify == '') {
                        if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '') {
                          return _CallLoginWidget(
                              currentIndex: _currentIndex,
                              animationController: animationController,
                              animation: animation,
                              updateCurrentIndex: (String title, int index) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                              },
                              updateUserCurrentIndex:
                                  (String title, int index, String userId) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                                if (userId != null) {
                                  _userId = userId;
                                  provider.psValueHolder.loginUserId = userId;
                                }
                              });
                        } else {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    })),
              );
            }
            if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
              // 2nd Way
              //SearchProductProvider searchProductProvider;

              return CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  HomeItemSearchView(
                      animationController: animationController,
                      animation: animation,
                      productParameterHolder:
                          ProductParameterHolder().getLatestParameterHolder())
                ],
              );
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: RoyalBoardColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                    Widget>[
                  PhoneSignInView(
                      animationController: animationController,
                      goToLoginSelected: () {
                        animationController
                            .reverse()
                            .then<dynamic>((void data) {
                          if (!mounted) {
                            return;
                          }
                          if (_currentIndex ==
                              RoyalBoardConst
                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                          }
                          if (_currentIndex ==
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                RoyalBoardConst
                                    .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                          }
                        });
                      },
                      phoneSignInSelected:
                          (String name, String phoneNo, String verifyId) {
                        phoneUserName = name;
                        phoneNumber = phoneNo;
                        phoneId = verifyId;
                        if (_currentIndex ==
                            RoyalBoardConst
                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home_verify_phone'),
                              RoyalBoardConst
                                  .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                        } else if (_currentIndex ==
                            RoyalBoardConst
                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home_verify_phone'),
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                        } else {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home_verify_phone'),
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                        }
                      })
                ])
              ]);
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              return _CallVerifyPhoneWidget(
                  userName: phoneUserName,
                  phoneNumber: phoneNumber,
                  phoneId: phoneId,
                  animationController: animationController,
                  animation: animation,
                  currentIndex: _currentIndex,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) async {
                    if (userId != null) {
                      _userId = userId;
                    }
                    setState(() {
                      appBarTitle = title;
                      _currentIndex = index;
                    });
                  });
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ProfileView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController,
                  flag: _currentIndex,
                  userId: _userId,
                ),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
              return WillPopScope(
                  onWillPop: allWillpopfunction,child: CategoryListView());
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ProductListWithFilterView(
                  key: const Key('1'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getLatestParameterHolder(),
                ),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ProductListWithFilterView(
                  key: const Key('2'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getDiscountParameterHolder(),
                ),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ProductListWithFilterView(
                  key: const Key('3'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getTrendingParameterHolder(),
                ),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ProductListWithFilterView(
                  key: const Key('4'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getFeaturedParameterHolder(),
                ),
              );
            } else if (_currentIndex ==
                    RoyalBoardConst
                        .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: RoyalBoardColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      ForgotPasswordView(
                        animationController: animationController,
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                RoyalBoardConst
                                    .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                RoyalBoardConst
                                    .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  RoyalBoardConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        },
                      )
                    ])
              ]);
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: RoyalBoardColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                    Widget>[
                  RegisterView(
                      animationController: animationController,
                      onRegisterSelected: (String userId) {
                        _userId = userId;
                        // widget.provider.psValueHolder.loginUserId = userId;
                        if (_currentIndex ==
                            RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home__verify_email'),
                              RoyalBoardConst
                                  .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                        } else if (_currentIndex ==
                            RoyalBoardConst
                                .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home__verify_email'),
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                        } else {
                          updateSelectedIndexWithAnimationUserId(
                              Utils.getString(
                                  context, 'home__menu_drawer_profile'),
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                              userId);
                        }
                      },
                      goToLoginSelected: () {
                        animationController
                            .reverse()
                            .then<dynamic>((void data) {
                          if (!mounted) {
                            return;
                          }
                          if (_currentIndex ==
                              RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                          }
                          if (_currentIndex ==
                              RoyalBoardConst
                                  .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                RoyalBoardConst
                                    .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                          }
                        });
                      })
                ])
              ]);
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                _currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              return _CallVerifyEmailWidget(
                  animationController: animationController,
                  animation: animation,
                  currentIndex: _currentIndex,
                  userId: _userId,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) async {
                    if (userId != null) {
                      _userId = userId;
                    }
                    setState(() {
                      appBarTitle = title;
                      _currentIndex = index;
                    });
                  });
            } else if (_currentIndex ==
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
              return _CallLoginWidget(
                  currentIndex: _currentIndex,
                  animationController: animationController,
                  animation: animation,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) {
                    setState(() {
                      if (index != null) {
                        appBarTitle = title;
                        _currentIndex = index;
                      }
                    });
                    if (userId != null) {
                      _userId = userId;
                    }
                  });
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      final UserProvider provider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);

                      return provider;
                    },
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                      if (provider == null ||
                          provider.psValueHolder.userIdToVerify == null ||
                          provider.psValueHolder.userIdToVerify == '') {
                        if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '') {
                          return Stack(
                            children: <Widget>[
                              Container(
                                color: RoyalBoardColors.mainLightColorWithBlack,
                                width: double.infinity,
                                height: double.maxFinite,
                              ),
                              CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  slivers: <Widget>[
                                    LoginView(
                                      animationController: animationController,
                                      animation: animation,
                                      onGoogleSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = RoyalBoardConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      },
                                      onFbSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = RoyalBoardConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      },
                                      onPhoneSignInSelected: () {
                                        if (_currentIndex ==
                                            RoyalBoardConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              RoyalBoardConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            RoyalBoardConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              RoyalBoardConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            RoyalBoardConst
                                                .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              RoyalBoardConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            RoyalBoardConst
                                                .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              RoyalBoardConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              RoyalBoardConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        }
                                      },
                                      onProfileSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = RoyalBoardConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        });
                                      },
                                      onForgotPasswordSelected: () {
                                        setState(() {
                                          _currentIndex = RoyalBoardConst
                                              .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                          appBarTitle = Utils.getString(
                                              context, 'home__forgot_password');
                                        });
                                      },
                                      onSignInSelected: () {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home__register'),
                                            RoyalBoardConst
                                                .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                      },
                                    ),
                                  ])
                            ],
                          );
                        } else {
                          return WillPopScope(
                            onWillPop: allWillpopfunction,
                            child: ProfileView(
                              scaffoldKey: scaffoldKey,
                              animationController: animationController,
                              flag: _currentIndex,
                            ),
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    })),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: FavouriteProductListView(
                    animationController: animationController),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: TransactionListView(
                    scaffoldKey: scaffoldKey,
                    animationController: animationController),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: HistoryListView(
                    animationController: animationController),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.App_Info) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: AppInfoView(
                    ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: CollectionHeaderListView(
                    animationController: animationController,
                    shopId: valueHolder.shopId),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: LanguageSettingView(
                    animationController: animationController,
                    languageIsChanged: () {}),
              );
            }
    else if (_currentIndex ==
    RoyalBoardConst.markets_categories ) {
              return CategoryListMarkets(
                valueHolder.loginUserId,
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.afrad_section ) {
              animationController.forward();

              return MainDashboardViewWidget(animationController, context);
            }
            else if (_currentIndex ==
                RoyalBoardConst.dynamic_link_progress ) {
              animationController.forward();

              return Scaffold(
                body: Container(
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20,),
                      Text('جاري التصويت وتحويلك الى المنتج ')
                    ],
                  ),),
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.friends_core ) {
              animationController.forward();

              return  WillPopScope(
                  onWillPop: allWillpopfunction,child: Friends_List(valueHolder.loginUserId));
            }
            else if (_currentIndex ==
                RoyalBoardConst.friends_send_request ) {
              animationController.forward();

              return  WillPopScope(
                  onWillPop: allWillpopfunction,child: Send_FRequest(valueHolder.loginUserId));
            }
            else if (_currentIndex ==
                RoyalBoardConst.friends_applied ) {
              animationController.forward();

              return  WillPopScope(
                  onWillPop: allWillpopfunction,child: Friends_Apllied(valueHolder.loginUserId));
            }

            else if (_currentIndex ==
                RoyalBoardConst.rollet_game ) {

              return  WillPopScope(
                onWillPop: allWillpopfunction,
                child: RoGame(
                    valueHolder.loginUserId,
                  valueHolder.ua
                    ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_HOME_point) {
              return   WillPopScope(
                onWillPop: allWillpopfunction,
                child: point_user(
                  animationController: animationController,
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.firm_prices_gifts) {
              return  WillPopScope(
                onWillPop: allWillpopfunction,
                child: Firm_Gifts(
                  valueHolder.loginUserId,
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_vendors_FRAGMENT) {

              return  WillPopScope(
                onWillPop: allWillpopfunction,
                child: Mshops(
                  appBarTitle: Utils.getString(
                      context, 'shop_dashboard__trending_shop'),
                  shopParameterHolder: ShopParameterHolder()
                      .get_jomla_shops(),
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_mufrad) {
              return  WillPopScope(
                onWillPop: allWillpopfunction,
                child: Mufrad(
                  appBarTitle: Utils.getString(
                      context, 'shop_dashboard__trending_shop'),
                  shopParameterHolder: ShopParameterHolder()
                      .get_mufrad_shops(),
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_search) {

              ShopParameterHolder _shop_i=     ShopParameterHolder()
                  .getShopbyreferal();
              _shop_i.shop_i=searchi.text;

              return   WillPopScope(
                onWillPop: allWillpopfunction,
                child: SearchedMarkets(
                  appBarTitle: Utils.getString(
                      context, 'shop_dashboard__trending_shop'),
                  shopParameterHolder: _shop_i,
                  shpoi: searchi.text,
                ),
              );
            }

            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
              return WillPopScope(
                  onWillPop: allWillpopfunction,child: ContactUsView(animationController: animationController));
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: Container(
                  color: RoyalBoardColors.coreBackgroundColor,
                  height: double.infinity,
                  child: SettingView(
                    animationController: animationController,
                  ),
                ),
              );
            } else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: TermsAndConditionsView(
                  animationController: animationController,
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT) {
              return WillPopScope(
                onWillPop: allWillpopfunction,
                child: BasketListView(
                  animationController: animationController,
                ),
              );
            }
            else if (_currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_bloglist) {
              return WillPopScope(
                  onWillPop: allWillpopfunction,child: AppInstructionView());
            }else {
              // animationController.forward();
              // return MainDashboardcatViewWidget(animationController, context);
              return CategoryListMarkets(
                valueHolder.loginUserId,
              );


            }
          },
        ),
      ),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: RoyalBoardColors
              .mainLightColorWithBlack, //ps_wtheme_core_background_color,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    RoyalBoardConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    RoyalBoardConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    RoyalBoardConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == RoyalBoardConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else
            // if (currentIndex ==
            //     RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT)
            {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home_phone_signin'),
                  RoyalBoardConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
            } else if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home_phone_signin'),
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
            }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex,
      @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  RoyalBoardConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else

            {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  RoyalBoardConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                RoyalBoardConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  RoyalBoardConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: RoyalBoardColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}
class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_grocery_logo.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
        ],
      ),
      decoration: BoxDecoration(
          // color: RoyalBoardColors.mainColor
      color: const Color(0xff7c94b6),
    image: const DecorationImage(
    image: AssetImage('assets/images/ramdan.jpg'),
    fit: BoxFit.cover,

      ),
    ));
  }
}
