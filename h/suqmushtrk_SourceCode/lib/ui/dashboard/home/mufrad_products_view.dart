import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/ui/afrad/OffersTapBar.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/provider/product/search_product_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/product/item/product_vertical_list_item_for_home.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/category.dart';
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
import 'package:RoyalBoard_Common_sooq/ui/subcategory/list/sub_cat_market_products.dart';

class MufradProductListView extends StatefulWidget {
  const MufradProductListView(
      {Key key,
      @required this.catId,
      @required this.shopId,

      @required this.flag,
        this.subcat,
        this.category,
        this.isOffer,
        this.isJomla,
      @required this.isFeaturedItem, this.shopid, this.gridvalue, this.isfeatered})
      : super(key: key);

  final String catId;
  final subcat;
  final String shopId;
  final String isOffer;
  final String isJomla;
  final bool flag;

  final bool isFeaturedItem;
  final shopid;
  final int gridvalue;
  final bool isfeatered;
  final Category category;


  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<MufradProductListView>
    with AutomaticKeepAliveClientMixin {
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
        _searchProductProvider.nextProductListByKey(holder);
      }
      setState(() {
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
    });
  }

  final double _containerMaxHeight = 60;
  double _offset, _delta = 0, _oldOffset = 0;
  ProductRepository repo1;
  dynamic data;
  PsValueHolder valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  String cache;
  ProductParameterHolder holder;

  @override
  Widget build(BuildContext context) {
    super.build(context);
var size =MediaQuery.of(context).size;
    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    print(
        '............................Build UI Again ............................');
    return Scaffold(
      floatingActionButton:Container(
        height: 40,
        child: FloatingActionButton(
          child: Icon(Icons.expand_more_sharp),
          onPressed: (){

            _searchProductProvider.nextProductListByKey(holder);

          },

        ),
      ),
      body: ChangeNotifierProvider<SearchProductProvider>(
          lazy: false,
          create: (BuildContext context) {
            final SearchProductProvider provider = SearchProductProvider(
                repo: repo1, limit: 30);


            if (widget.isFeaturedItem) {
              provider.productParameterHolder =
                  ProductParameterHolder().getFeaturedParameterHolder();
              holder = ProductParameterHolder().getFeaturedParameterHolder();
            } else {
              provider.productParameterHolder =
                  ProductParameterHolder().getLatestParameterHolder();
              holder = ProductParameterHolder().getLatestParameterHolder();
            }

            if(widget.subcat!=null&&widget.subcat!=''){
              holder.subCatId='';
              holder.subCatId=widget.subcat;
            }
            if (widget.catId == RoyalBoardConst.mainMenu) {
              holder.catId = '';

            } else if (widget.catId == RoyalBoardConst.featuredItem) {
              holder.catId = '';

            } else {
              holder.catId = widget.catId;

            }
            if(widget.shopId!=null&&widget.shopId!=''&&widget.shopId!='widget.shopId'){
              holder.shopId='';
              holder.shopId=widget.shopId;
            }
            if(widget.isOffer!=null&&widget.isOffer!=''){
              holder.isOffer='';
              holder.isOffer=widget.isOffer;
            }
            if(widget.isJomla!=null&&widget.isJomla!=''){
              holder.isJomla='';
              holder.isJomla=widget.isJomla;
            }
            holder.orderBy=RoyalBoardConst.FILTERING__TRENDING;


            // if ((cache != null && cache != widget.catId) || widget.isFirstTime) {
            if (widget.flag) {
              print('dfhijlsglkdsj$holder');
              provider.loadProductListByKeyFromDB(holder);
              print('CALL FROM DB');
            } else {
              provider.loadProductListByKey(holder);
              print('CALL FROM server');
            }
            // }
            cache = widget.catId;
            _searchProductProvider = provider;
            _searchProductProvider.productParameterHolder =
                provider.productParameterHolder;
            return _searchProductProvider;
          },
          child: Consumer<SearchProductProvider>(builder: (BuildContext context,
              SearchProductProvider provider, Widget child) {
            return Column(
              children: <Widget>[
                //const PsAdMobBannerWidget(),
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
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    SliverPadding(

                                        padding: EdgeInsets.all(0),
                                        sliver :SliverList(

                                            delegate: SliverChildListDelegate(
                                                [
                                                  Container(
                                                    height:size.height/7,
                                                    child: SubCatMP(category: widget.category,shopid: 'widget.shopId',
                                                      key: widget.key,  subcat: '',flag: widget.flag,isfeatered: false,gridvalue: 80,isOffer: '0',
                                                    ),
                                                  )
                                                ]
                                            ))),
                                  SliverPadding(
                                    padding: EdgeInsets.all(0),


                                    sliver: SliverList(

                                      delegate: SliverChildListDelegate(
                                        [
                                          Container(
                                            height: size.height*0.27,
                                            child: Column(
                                              children: [
                                                OffersTapBar(
                                                  widget.catId
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                                    SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 300,
                                              childAspectRatio: 0.53),
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          if (provider.productList.data != null ||
                                              provider
                                                  .productList.data.isNotEmpty) {
                                            // final int count =
                                            //     provider.productList.data.length;
                                            return ProductVeticalListItemForHome(
                                              coreTagKey:
                                                  provider.hashCode.toString() +
                                                      provider.productList
                                                          .data[index].id,
                                              // animationController:
                                              //     widget.animationController,
                                              // animation: Tween<double>(
                                              //         begin: 0.0, end: 1.0)
                                              //     .animate(
                                              //   CurvedAnimation(
                                              //     parent:
                                              //         widget.animationController,
                                              //     curve: Interval(
                                              //         (1 / count) * index, 1.0,
                                              //         curve:
                                              //             Curves.fastOutSlowIn),
                                              //   ),
                                              // ),
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
                                return provider.resetLatestProductList(holder);
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



                      PSProgressIndicator(provider.productList.status),

                    ]),
                  ),
                ),

              ],
            );
          })),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText({this.searchProductProvider});
  final SearchProductProvider searchProductProvider;

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
