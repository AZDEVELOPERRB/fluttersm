import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/basket/basket_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/basket_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/list_with_filter/product_list_with_filter_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/list_with_filter/filter/product_list_markets_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/provider/shop/shop_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/ps_widget_with_appbar.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/shop_list/item/shop_verticle_list_item.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/shop_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/touch_count_parameter_holder.dart';

class ProductListfiltermarkets extends StatefulWidget {
  const ProductListfiltermarkets(
      {@required this.productParameterHolder, @required this.appBarTitle});
  final ProductParameterHolder productParameterHolder;
  final String appBarTitle;
  @override
  _ProductListWithFilterContainerViewState createState() =>
      _ProductListWithFilterContainerViewState();
}

class _ProductListWithFilterContainerViewState
    extends State<ProductListfiltermarkets>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BasketRepository basketRepository;
  String appBarTitleName;

  void changeAppBarTitle(String categoryName) {
    appBarTitleName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    basketRepository = Provider.of<BasketRepository>(context);
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
        '............................Build UI Again< Filter Container > ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            appBarTitleName ?? widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(),
          ),
          elevation: 0,
          actions: <Widget>[
            ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BasketProvider provider =
                    BasketProvider(repo: basketRepository);
                provider.loadBasketList();
                return provider;
              },
              child: Consumer<BasketProvider>(builder: (BuildContext context,
                  BasketProvider basketProvider, Widget child) {
                return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: PsDimens.space40,
                          height: PsDimens.space40,
                          margin: const EdgeInsets.only(
                              top: PsDimens.space8,
                              left: PsDimens.space8,
                              right: PsDimens.space8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.shopping_basket,
                              color: RoyalBoardColors.mainColor,
                            ),
                          ),
                        ),
                        Positioned(
                          right: PsDimens.space4,
                          top: PsDimens.space1,
                          child: Container(
                            width: PsDimens.space28,
                            height: PsDimens.space28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: RoyalBoardColors.black.withAlpha(200),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                basketProvider.basketList.data.length > 99
                                    ? '99+'
                                    : basketProvider.basketList.data.length
                                        .toString(),
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: RoyalBoardColors.white),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.basketList,
                      );
                    });
              }),
            )
          ],
        ),
        body:
        ProductListmarketsview(
          animationController: animationController,
          productParameterHolder: widget.productParameterHolder,
          changeAppBarTitle: changeAppBarTitle,
        ),
      ),
    );
  }
}
////here start mshops



class Mshopsfilter extends StatefulWidget {
  const Mshopsfilter(
      {Key key, @required this.appBarTitle, @required this.shopParameterHolder})
      : super(key: key);
  final String appBarTitle;
  final ShopParameterHolder shopParameterHolder;
  @override
  _ShopListViewState createState() => _ShopListViewState();
}

class _ShopListViewState extends State<Mshopsfilter>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ShopProvider _shopProvider;
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
    return PsWidgetWithAppBar<ShopProvider>(
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
                                  final int count = provider.shop.data.length;
                                  print('fsdfsdaf${provider.shop.data[index].jomla}');
                                  if(provider.shop.data[index].jomla =='1'){
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
                                  }
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
          return Container();
        }
      },
    );
  }
}