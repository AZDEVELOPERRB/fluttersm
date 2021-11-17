import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/provider/product/search_product_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/provider/shop/shop_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/appBar_for_RoyalBoard.dart';
import 'package:RoyalBoard_Common_sooq/ui/shop_list/item/shop_verticle_list_item.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/shop_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/touch_count_parameter_holder.dart';
class ProductListmarketsview extends StatefulWidget {
  const ProductListmarketsview(
      {Key key,
      @required this.productParameterHolder,
      @required this.animationController,
      this.changeAppBarTitle})
      : super(key: key);

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Function changeAppBarTitle;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListmarketsview>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SearchProductProvider _searchProductProvider;
  bool isVisible = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchProductProvider.nextProductListByKey(
            _searchProductProvider.productParameterHolder);
      }
      //setState(() {
      final double offset = _scrollController.offset;
      _delta += offset - _oldOffset;
      if (_delta > _containerMaxHeight)
        _delta = _containerMaxHeight;
      else if (_delta < 0) {
        _delta = 0;
      }
      _oldOffset = offset;
      _offset = -_delta;
    });

    print(' Offset $_offset');
    //});
  }

  final double _containerMaxHeight = 60;
  double _offset, _delta = 0, _oldOffset = 0;
  ProductRepository repo1;
  dynamic data;
  PsValueHolder valueHolder;
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
    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && RoyalBoardConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again < Filter View >............................');
    return ChangeNotifierProvider<SearchProductProvider>(
        lazy: false,
        create: (BuildContext context) {
          final SearchProductProvider provider =
              SearchProductProvider(repo: repo1);
          provider.loadProductListformarkets(widget.productParameterHolder);
          _searchProductProvider = provider;
          _searchProductProvider.productParameterHolder =
              widget.productParameterHolder;
          return _searchProductProvider;
        },
        child: Consumer<SearchProductProvider>(builder: (BuildContext context,
            SearchProductProvider provider, Widget child) {
          if (provider.productList.data.isNotEmpty &&
              provider.productList.data != null){
            List asd=[];

            for(var hassan in provider.productList.data ){
              asd.add(hassan.shopid);


            }


              return     Mshopsmarkets(
                  asd,widget.productParameterHolder
              );


          }
          else if(provider.productList.data ==null){
            return Center(child: Text('غير متوفر في هذا الوقت'));

          }
          else if(provider.isLoading){

          return    Center(child:CircularProgressIndicator());
          }
          else{
            return Center(child: Text("لا توجد متاجر حالياً في هذا القسم"));

          }

        }));
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider searchProductProvider;
  final Function changeAppBarTitle;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    if (widget.searchProductProvider.productParameterHolder.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchProductProvider.productParameterHolder
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: RoyalBoardColors.mainLightShadowColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: RoyalBoardColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: RoyalBoardColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // GestureDetector(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       PsIconWithCheck(
          //         icon: MaterialCommunityIcons.format_list_bulleted_type,
          //         color: isClickBaseLineList
          //             ? RoyalBoardColors.mainColor
          //             : RoyalBoardColors.iconColor,
          //       ),
          //       Text(Utils.getString(context, 'search__category'),
          //           style: Theme.of(context).textTheme.bodyText1.copyWith(
          //               color: isClickBaseLineList
          //                   ? RoyalBoardColors.mainColor
          //                   : RoyalBoardColors.textPrimaryColor)),
          //     ],
          //   ),
          //   onTap: () async {
          //     final Map<String, String> dataHolder = <String, String>{};
          //     dataHolder[RoyalBoardConst.CATEGORY_ID] =
          //         widget.searchProductProvider.productParameterHolder.catId;
          //     dataHolder[RoyalBoardConst.SUB_CATEGORY_ID] =
          //         widget.searchProductProvider.productParameterHolder.subCatId;
          //     final dynamic result = await Navigator.pushNamed(
          //         context, RoutePaths.filterExpantion,
          //         arguments: dataHolder);
          //
          //     if (result != null) {
          //       widget.searchProductProvider.productParameterHolder.catId =
          //           result[RoyalBoardConst.CATEGORY_ID];
          //       widget.searchProductProvider.productParameterHolder.subCatId =
          //           result[RoyalBoardConst.SUB_CATEGORY_ID];
          //       widget.searchProductProvider.resetLatestProductList(
          //           widget.searchProductProvider.productParameterHolder);
          //
          //       if (result[RoyalBoardConst.CATEGORY_ID] == '' &&
          //           result[RoyalBoardConst.SUB_CATEGORY_ID] == '') {
          //         isClickBaseLineList = false;
          //       } else {
          //         widget.changeAppBarTitle(result[RoyalBoardConst.CATEGORY_NAME]);
          //         isClickBaseLineList = true;
          //       }
          //     }
          //   },
          // ),
          // GestureDetector(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       PsIconWithCheck(
          //         icon: Icons.filter_list,
          //         color: isClickBaseLineTune
          //             ? RoyalBoardColors.mainColor
          //             : RoyalBoardColors.iconColor,
          //       ),
          //       Text(Utils.getString(context, 'search__filter'),
          //           style: Theme.of(context).textTheme.bodyText1.copyWith(
          //               color: isClickBaseLineTune
          //                   ? RoyalBoardColors.mainColor
          //                   : RoyalBoardColors.textPrimaryColor))
          //     ],
          //   ),
          //   onTap: () async {
          //     final dynamic result = await Navigator.pushNamed(
          //         context, RoutePaths.itemSearch,
          //         arguments:
          //             widget.searchProductProvider.productParameterHolder);
          //     if (result != null) {
          //       widget.searchProductProvider.productParameterHolder = result;
          //       widget.searchProductProvider.resetLatestProductList(
          //           widget.searchProductProvider.productParameterHolder);
          //
          //       if (widget.searchProductProvider.productParameterHolder
          //           .isFiltered()) {
          //         isClickBaseLineTune = true;
          //       } else {
          //         isClickBaseLineTune = false;
          //       }
          //     }
          //   },
          // ),
          // GestureDetector(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       PsIconWithCheck(
          //         icon: Icons.sort,
          //         color: RoyalBoardColors.mainColor,
          //       ),
          //       Text(Utils.getString(context, 'search__sort'),
          //           style: Theme.of(context).textTheme.bodyText1.copyWith(
          //               color: isClickBaseLineTune
          //                   ? RoyalBoardColors.mainColor
          //                   : RoyalBoardColors.textPrimaryColor))
          //     ],
          //   ),
          //   onTap: () async {
          //     final dynamic result = await Navigator.pushNamed(
          //         context, RoutePaths.itemSort,
          //         arguments:
          //             widget.searchProductProvider.productParameterHolder);
          //     if (result != null) {
          //       widget.searchProductProvider.productParameterHolder = result;
          //       widget.searchProductProvider.resetLatestProductList(
          //           widget.searchProductProvider.productParameterHolder);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}

class PsIconWithCheck extends StatelessWidget {
  const PsIconWithCheck({Key key, this.icon, this.color}) : super(key: key);
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? RoyalBoardColors.grey);
  }
}


class Mshopsmarkets extends StatefulWidget {
  Mshopsmarkets(this.shid,this.productParameterHolder);
List shid=[];
  final ProductParameterHolder productParameterHolder;


   String appBarTitle='hassan';
   ShopParameterHolder shopParameterHolder;
  @override

  _ShopListViewState createState() => _ShopListViewState(shid);
}

class _ShopListViewState extends State<Mshopsmarkets>
    with TickerProviderStateMixin {
  List shid=[];
  _ShopListViewState(this.shid);
  final ScrollController _scrollController = ScrollController();
  ShopProvider _shopProvider;
  List list;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('dfhgkljfdslhgkjsdlkgjlk}');
        // _shopProvider.nextShopListByKey(widget.shopParameterHolder);
        final sh=ShopParameterHolder().getTrendingShopParameterHolderforcats(widget.productParameterHolder.catId);
        _shopProvider.loadShopListByKey(sh);
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
      appBarTitle: '' ?? '',
      initProvider: () {
        return ShopProvider(
          repo: repo1,
        );
      },
      onProviderReady: (ShopProvider provider) {
        final sh=ShopParameterHolder().getTrendingShopParameterHolderforcats(widget.productParameterHolder.catId);
        provider.devloadShopListByKey(sh);
        _shopProvider = provider;
      },
      builder: (BuildContext context, ShopProvider provider, Widget child) {
        if (provider.shop != null &&
            provider.shop.data != null &&
            provider.shop.data.isNotEmpty) {
          return WillPopScope(
            onWillPop: _requestPop,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(


                 decoration: BoxDecoration(
                   color: Colors.red,
                   borderRadius: BorderRadius.circular(15)
                 ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()async{
                          final dynamic result =
                          await Navigator.pushNamed(context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                appBarTitle:
                                Utils.getString(context, 'home_search__app_bar_title'),
                                productParameterHolder:
                                ProductParameterHolder().getOffers_rate_Product(widget.productParameterHolder.catId),
                              ));


                        },
                        child: Container(


                          child:                          Text('اضغط للعروض المميزة %',style: TextStyle(color: Colors.white,fontSize: 14),)
                          ,

                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Stack(
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
                                  //here start developing

                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {

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
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
