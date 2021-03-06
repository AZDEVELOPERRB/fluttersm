import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/item/product_vertical_list_item.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/Offers/offers_provider.dart';

class ProductListWithFilterWithOffers extends StatefulWidget {
  const ProductListWithFilterWithOffers(
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

class _ProductListWithFilterViewState extends State<ProductListWithFilterWithOffers>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  OffersProvider _searchProductProvider;
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
    return ChangeNotifierProvider<OffersProvider>(
        lazy: false,
        create: (BuildContext context) {
          final OffersProvider provider =
          OffersProvider(repo: repo1);
          provider.loadProductListByKey(widget.productParameterHolder);
          _searchProductProvider = provider;
          _searchProductProvider.productParameterHolder =
              widget.productParameterHolder;
          return _searchProductProvider;
        },
        child: Consumer<OffersProvider>(builder: (BuildContext context,
            OffersProvider provider, Widget child) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(),
              Expanded(
                child: Container(
                  color: RoyalBoardColors.coreBackgroundColor,
                  child: Stack(children: <Widget>[
                    if (provider.productList.data.isNotEmpty &&
                        provider.productList.data != null)
                      Container(
                          color: RoyalBoardColors.coreBackgroundColor,
                          margin: const EdgeInsets.only(
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              top: PsDimens.space4,
                              bottom: PsDimens.space4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 220,
                                        childAspectRatio: 0.6),
                                    delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        if (provider.productList.data != null ||
                                            provider
                                                .productList.data.isNotEmpty) {
                                          final int count =
                                              provider.productList.data.length;
                                          return ProductVeticalListItem(
                                            coreTagKey:
                                            provider.hashCode.toString() +
                                                provider.productList
                                                    .data[index].id,
                                            animationController:
                                            widget.animationController,
                                            animation: Tween<double>(
                                                begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                    Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            product: provider
                                                .productList.data[index],
                                            onTap: () {
                                              final Product product = provider
                                                  .productList.data[index];
                                              final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                product: product,
                                                heroTagImage: provider.hashCode
                                                    .toString() +
                                                    product.id +
                                                    RoyalBoardConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                    .toString() +
                                                    product.id +
                                                    RoyalBoardConst.HERO_TAG__TITLE,
                                                heroTagOriginalPrice: provider
                                                    .hashCode
                                                    .toString() +
                                                    product.id +
                                                    RoyalBoardConst
                                                        .HERO_TAG__ORIGINAL_PRICE,
                                                heroTagUnitPrice: provider
                                                    .hashCode
                                                    .toString() +
                                                    product.id +
                                                    RoyalBoardConst
                                                        .HERO_TAG__UNIT_PRICE,
                                              );

                                              Navigator.pushNamed(context,
                                                  RoutePaths.productDetail,
                                                  arguments: holder);
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                      provider.productList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetLatestProductList(
                                  _searchProductProvider
                                      .productParameterHolder);
                            },
                          ))
                    else if (provider.productList.status !=
                        PsStatus.PROGRESS_LOADING &&
                        provider.productList.status != PsStatus.BLOCK_LOADING &&
                        provider.productList.status != PsStatus.NOACTION)
                      Align(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_empty_item_grey_24.png',
                                height: 100,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: PsDimens.space32,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space20,
                                    right: PsDimens.space20),
                                child: Text(
                                  Utils.getString(
                                      context, 'procuct_list__no_result_data'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(),
                                ),
                              ),
                              const SizedBox(
                                height: PsDimens.space20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: _offset,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space12,
                            top: PsDimens.space8,
                            right: PsDimens.space12,
                            bottom: PsDimens.space16),
                        child: Container(
                            width: double.infinity,
                            height: _containerMaxHeight,
                            child: BottomNavigationImageAndText(
                              searchProductProvider: _searchProductProvider,
                              changeAppBarTitle: widget.changeAppBarTitle,
                            )),
                      ),
                    ),
                    PSProgressIndicator(provider.productList.status),
                  ]),
                ),
              )
            ],
          );
        }));
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {this.searchProductProvider, this.changeAppBarTitle});
  final OffersProvider searchProductProvider;
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
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: MaterialCommunityIcons.format_list_bulleted_type,
                  color: isClickBaseLineList
                      ? RoyalBoardColors.mainColor
                      : RoyalBoardColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__category'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineList
                            ? RoyalBoardColors.mainColor
                            : RoyalBoardColors.textPrimaryColor)),
              ],
            ),
            onTap: () async {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[RoyalBoardConst.CATEGORY_ID] =
                  widget.searchProductProvider.productParameterHolder.catId;
              dataHolder[RoyalBoardConst.SUB_CATEGORY_ID] =
                  widget.searchProductProvider.productParameterHolder.subCatId;
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.filterExpantion,
                  arguments: dataHolder);

              if (result != null) {
                widget.searchProductProvider.productParameterHolder.catId =
                result[RoyalBoardConst.CATEGORY_ID];
                widget.searchProductProvider.productParameterHolder.subCatId =
                result[RoyalBoardConst.SUB_CATEGORY_ID];
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);

                if (result[RoyalBoardConst.CATEGORY_ID] == '' &&
                    result[RoyalBoardConst.SUB_CATEGORY_ID] == '') {
                  isClickBaseLineList = false;
                } else {
                  widget.changeAppBarTitle(result[RoyalBoardConst.CATEGORY_NAME]);
                  isClickBaseLineList = true;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? RoyalBoardColors.mainColor
                      : RoyalBoardColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineTune
                            ? RoyalBoardColors.mainColor
                            : RoyalBoardColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments:
                  widget.searchProductProvider.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider.productParameterHolder = result;
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);

                if (widget.searchProductProvider.productParameterHolder
                    .isFiltered()) {
                  isClickBaseLineTune = true;
                } else {
                  isClickBaseLineTune = false;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: RoyalBoardColors.mainColor,
                ),
                Text(Utils.getString(context, 'search__sort'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineTune
                            ? RoyalBoardColors.mainColor
                            : RoyalBoardColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSort,
                  arguments:
                  widget.searchProductProvider.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider.productParameterHolder = result;
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);
              }
            },
          ),
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
