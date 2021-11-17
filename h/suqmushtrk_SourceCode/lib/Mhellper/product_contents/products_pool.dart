import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';



import 'package:RoyalBoard_Common_sooq/ui/category/item/category_vertical_list_item.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/category_parameter_holder.dart';

import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/provider/category/category_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/category_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'all_products_pool.dart';


class Products_pool_switcher extends StatefulWidget {
  String user_id;
  String shop_id;
  String joomla;

  Products_pool_switcher(this.user_id, this.shop_id,{this.joomla});

  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<Products_pool_switcher>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;
  final CategoryParameterHolder categoryParameterHolder =
  CategoryParameterHolder().getLatestParameterHolder();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {


    if(widget.joomla!=null){

      categoryParameterHolder.isjomla=widget.joomla;
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider.nextCategoryList(categoryParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;

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

    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    var size=MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _requestPop,
        child: Container(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.only(top:25.0),
            child: ChangeNotifierProvider<CategoryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final CategoryProvider provider =
                  CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
                  if(widget.joomla!=null){
                    categoryParameterHolder.isjomla=widget.joomla;
                  }
                  print('dfhlghjfdklgjdfklgj${categoryParameterHolder.isjomla}');
                  provider.loadCategoryList(categoryParameterHolder);
                  _categoryProvider = provider;
                  return _categoryProvider;
                },
                child: Consumer<CategoryProvider>(builder: (BuildContext context,
                    CategoryProvider provider, Widget child) {
                  return Stack(children: <Widget>[
                    Column(children: <Widget>[
                      const PsAdMobBannerWidget(),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: PsDimens.space8,
                                right: PsDimens.space8,
                                top: PsDimens.space8,
                                bottom: PsDimens.space8),
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
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                      delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                          if (provider.categoryList.data != null ||
                                              provider
                                                  .categoryList.data.isNotEmpty) {
                                            final int count =
                                                provider.categoryList.data.length;
                                            return CategoryVerticalListItem(
                                              animationController:
                                              animationController,
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
                                              category:
                                              provider.categoryList.data[index],
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context)=>Products_pool(widget.shop_id,'${provider.categoryList.data[index].id}',widget.user_id)

                                                ));




                                              },
                                            );
                                          } else {
                                            return null;
                                          }
                                        },
                                        childCount:
                                        provider.categoryList.data.length,
                                      ),
                                    ),
                                  ]),
                              onRefresh: () {
                                return provider
                                    .resetCategoryList(categoryParameterHolder);
                              },
                            )),
                      ),
                    ]),
                    PSProgressIndicator(provider.categoryList.status)
                  ]);
                })),
          ),
        ));
  }
}
