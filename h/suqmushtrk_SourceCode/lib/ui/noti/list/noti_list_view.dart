import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/ps_widget_with_appbar.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/link_noti_products_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/noti_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/noti/noti_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/noti_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/category.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import '../item/noti_list_item.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/all_Orders_ui.dart';
class NotiListView extends StatefulWidget {
  const NotiListView({this.category,this.userId});
  final Category category;
  final userId;
  @override
  _NotiListViewState createState() {
    return _NotiListViewState();
  }
}

class _NotiListViewState extends State<NotiListView>
    with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final ScrollController _scrollController = ScrollController();

  NotiProvider _notiProvider;

  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var aIni=new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosIni=new IOSInitializationSettings();
    var inis=new InitializationSettings(android: aIni,iOS: iosIni,);
    localNotificationsPlugin =new FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(inis);
    super.initState();
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String loginUserId =
            Utils.checkUserLoginId(_notiProvider.psValueHolder);
        final GetNotiParameterHolder getNotiParameterHolder =
            GetNotiParameterHolder(
          userId: loginUserId,
          deviceToken: _notiProvider.psValueHolder.deviceToken,
        );
        _notiProvider.nextNotiList(getNotiParameterHolder.toMap());
      }
    });
  }
  bool fcir=false;
Future sn() async{
  setState(() {
    fcir =true;
  });
    var androiddetail=new AndroidNotificationDetails("channelId", "channelName", "channelDescription",
      importance: Importance.max,
      priority: Priority.max,
       );

    var IosDetail=new IOSNotificationDetails();
    var generalnotificattion=new NotificationDetails(android: androiddetail,iOS: IosDetail);

    await localNotificationsPlugin.show(0, 'title', 'body', generalnotificattion);
  setState(() {
    fcir =false;
  });

}
  NotiRepository repo1;
  PsValueHolder psValueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && RoyalBoardConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);
    if (!isConnectedToInternet && RoyalBoardConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }
    final ProductParameterHolder productParameterHolder = ProductParameterHolder().getLatestParameterHolder();

    timeDilation = 1.0;
    repo1 = Provider.of<NotiRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return Scaffold(

      body: WillPopScope(
        onWillPop: _requestPop,
        child:ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(provider.getCurrentFirebaseUser());
            if (provider.psValueHolder.loginUserId == null ||
                provider.psValueHolder.loginUserId == '') {
              provider.getUser(provider.psValueHolder.loginUserId);
            } else {
              provider.getUser(provider.psValueHolder.loginUserId);
            }
            return provider;
          },
          child: Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider userprovider, Widget child) {
    if (userprovider.user != null && userprovider.user.data != null) {
      return PsWidgetWithAppBar<NotiProvider>(

          appBarTitle:
          Utils.getString(context, 'noti_list__toolbar_name') ?? '',

          initProvider: () {
            return NotiProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (NotiProvider provider) {
            final String loginUserId =
            Utils.checkUserLoginId(provider.psValueHolder);

            final GetNotiParameterHolder getNotiParameterHolder =
            GetNotiParameterHolder(
              userId: loginUserId,
              deviceToken: provider.psValueHolder.deviceToken,
            );
            getNotiParameterHolder.added_date=userprovider.user.data.addedDate;
            provider.getNotiList(getNotiParameterHolder.toMap());

            _notiProvider = provider;
          },
          builder: (BuildContext context, NotiProvider provider, Widget child) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        color: RoyalBoardColors.coreBackgroundColor,
                        child: RefreshIndicator(
                          child: ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: provider.notiList.data.length,
                              itemBuilder: (BuildContext context, int index) {


                                final int count = provider.notiList.data.length;
                                DateTime user_addedDate=DateTime.parse('${userprovider.user.data.addedDate}');
                                DateTime noti_date=DateTime.parse('${provider.notiList.data[index].addedDate}');


                                if(provider!=null&&provider.isLoading){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('يرجى الانتظار جاري تجهيز هذا الاشعار'),
                                  );
                                }

                                if(user_addedDate.isBefore(noti_date)){
                                if (provider.notiList.data[index].for_user ==
                                    '0' ||
                                    provider.notiList.data[index].for_user ==
                                        provider.psValueHolder.loginUserId) {
                                  return NotiListItem(
                                    animationController: animationController,
                                    animation: Tween<double>(
                                        begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    noti: provider.notiList.data[index],
                                    onTap: () async {
                                      if (provider.notiList.data[index]
                                          .is_buy == '0') {
                                        print(provider.notiList.data[index]
                                            .defaultPhoto.imgPath);

                                        final dynamic retrunData =
                                        await Navigator.pushNamed(
                                          context,
                                          RoutePaths.noti,
                                          arguments: provider.notiList
                                              .data[index],
                                        );
                                        if (retrunData != null &&
                                            retrunData) {
                                          final String loginUserId =
                                          Utils.checkUserLoginId(
                                              provider.psValueHolder);

                                          final GetNotiParameterHolder
                                          getNotiParameterHolder =
                                          GetNotiParameterHolder(
                                            userId: loginUserId,
                                            deviceToken:
                                            provider.psValueHolder
                                                .deviceToken,
                                          );
                                          return _notiProvider.resetNotiList(
                                              getNotiParameterHolder.toMap());
                                        }
                                        if (retrunData != null &&
                                            retrunData) {
                                          print('Return data ');
                                        } else {
                                          print('Return datafalse ');
                                        }
                                      } else if (provider.notiList.data[index]
                                          .is_buy == '3') {

                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (ctx) =>
                                                All_Orders_Ui(provider.notiList
                                                    .data[index]
                                                    .shop_id, provider.notiList
                                                    .data[index]
                                                    .for_user,
                                                  is_notification: true,
                                                  order_id: provider.notiList
                                                      .data[index]
                                                      .order_id,)
                                        ));
                                      }
                                      else {
                                        //if The Notifications is products
                                        productParameterHolder.searchTerm =
                                            provider.notiList.data[index]
                                                .product_name;
                                        Utils.psPrint(
                                            productParameterHolder.searchTerm);
                                        Navigator.pushNamed(context, RoutePaths
                                            .filterProductList_doublenew,
                                            arguments: LinkNotiProductsList(
                                                appBarTitle: Utils.getString(
                                                    context,
                                                    'home_search__app_bar_title'),
                                                productParameterHolder: productParameterHolder,
                                                prod_id: provider.notiList
                                                    .data[index].product_id
                                            ));
                                      }
                                    },
                                  );
                                }else{
                                  return Center(
                                    child: Container(
                                      child: Center(child: Text('لا توجد اشعارات حاليا')),
                                    ),
                                  );
                                }
                                }
                                else {
                                  return Center(
                                    child: Container(
                                      child: Center(child: Text('لا توجد اشعارات حاليا')),
                                    ),
                                  );
                                }
                              }),
                          onRefresh: () async {
                            final GetNotiParameterHolder
                            getNotiParameterHolder = GetNotiParameterHolder(
                              userId: provider.psValueHolder.loginUserId,
                              deviceToken: provider.psValueHolder.deviceToken,
                            );

                            return _notiProvider
                                .resetNotiList(getNotiParameterHolder.toMap());
                          },
                        )),
                    PSProgressIndicator(provider.notiList.status)
                  ]),
                )
              ],
            );
          });
    }
    else{
      return Container();}
    }
          ),
        ),
      ),
    );
  }
}
