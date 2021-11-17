import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/shop/shop_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/appBar_for_RoyalBoard.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/shop_list/item/shop_verticle_list_item.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/shop_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:provider/provider.dart';

class SearchedMarkets extends StatefulWidget {
  const SearchedMarkets(
      {Key key, @required this.appBarTitle, @required this.shopParameterHolder,@required this.shpoi})
      : super(key: key);
  final String appBarTitle;
  final String shpoi;
  final ShopParameterHolder shopParameterHolder;
  @override
  _ShopListViewState createState() => _ShopListViewState(shpoi);
}

class _ShopListViewState extends State<SearchedMarkets>
    with TickerProviderStateMixin {
  _ShopListViewState(this.shopi);
  final ScrollController _scrollController = ScrollController();
  ShopProvider _shopProvider;
  String shopi;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _shopProvider.nextShopListByKey(widget.shopParameterHolder);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  PsValueHolder valueHolder;
  ShopRepository repo1;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ShopRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

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

    print(
        '............................Build UI Again ............................');
    return RoyalBoardAppBar<ShopProvider>(
      appBarTitle: Utils.getString(context, widget.appBarTitle) ?? '',
      initProvider: () {
        return ShopProvider(
          repo: repo1,
        );
      },
      onProviderReady: (ShopProvider provider) {
        provider.loadShopListByKey(widget.shopParameterHolder);
        _shopProvider = provider;
      },
      builder: (BuildContext context, ShopProvider provider, Widget child) {
        if (provider.shop != null &&
            provider.shop.data != null &&
            provider.shop.data.isNotEmpty) {
          return WillPopScope(
            onWillPop: _requestPop,
            child: Stack(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        top: PsDimens.space8,
                        bottom: PsDimens.space8),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[

                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      print('dghjdfgdfghdfghdfgh${shopi}');

                                  final int count = provider.shop.data.length;



                                  return ShopVerticleListItem(
                                    animationController: animationController,
                                    animation:
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    shop: provider.shop.data[index],
                                    onTap: () {
                                      final String loginUserId =
                                      Utils.checkUserLoginId(valueHolder);

                                      final TouchCountParameterHolder
                                      touchCountParameterHolder =
                                      TouchCountParameterHolder(
                                          typeId:
                                          provider.shop.data[index].id,
                                          typeName: RoyalBoardConst
                                              .FILTERING_TYPE_NAME_SHOP,
                                          userId: loginUserId,
                                          shopId:
                                          provider.shop.data[index].id);
                                      provider.postTouchCount(
                                          touchCountParameterHolder.toMap());

                                      provider.replaceShop(
                                          provider.shop.data[index].id,
                                          provider.shop.data[index].name);
                                      Navigator.pushNamed(
                                          context, RoutePaths.shop_dashboard,
                                          arguments: ShopDataIntentHolder(
                                              shopId:
                                              provider.shop.data[index].id,
                                              shopName: provider
                                                  .shop.data[index].name));
                                    },
                                  );




                                    },

                                childCount: provider.shop.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider
                            .resetShopList(widget.shopParameterHolder);
                      },
                    )),
                PSProgressIndicator(provider.shop.status)
              ],
            ),
          );
        } else {

         if(provider.shop!=null&&provider.shop.data!=null&&provider.shop.data.isEmpty&&provider.isLoading){
           Widget d=Text('يرجى الانتظار');


          return Container(
            child: Center(child: d),
          );
         }

         else{
           return Container(
             child: Center(child: Text('لا يوجد هكذا معرف')),
           );
         }
        }
      },
    );
  }
}
