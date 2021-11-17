import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/product/trending_product_provider.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_frame_loading_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/afrad/horizontalListOffers.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product_collection_header.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';

class OffersTapBar extends StatefulWidget {

String catid;
  @override
  _OffersTapBarState createState() => _OffersTapBarState();

OffersTapBar(this.catid);
}

class _OffersTapBarState extends State<OffersTapBar> {
  TrendingProductProvider _trendingProductProvider;

  ProductRepository repo2;

  @override
  Widget build(BuildContext context) {
    repo2 = Provider.of<ProductRepository>(context);
    var size =MediaQuery.of(context).size;
    return ChangeNotifierProvider<TrendingProductProvider>(
        lazy: false,
        create: (BuildContext context) {
          ProductParameterHolder trend =
          ProductParameterHolder().getOffersProduct();
          trend.catId=widget.catid;
          trend.isOffer='1';
          // trend.isJomla='tru';


          _trendingProductProvider = TrendingProductProvider(
              repo: repo2,
              limit: 100);
           _trendingProductProvider.loadProductList(
              trend);

          return _trendingProductProvider;
        },
      child: Consumer<TrendingProductProvider>(
        builder: (BuildContext context, TrendingProductProvider productProvider,
            Widget child) {
          return (productProvider.productList.data != null &&
              productProvider.productList.data.isNotEmpty)
              ? Column(

            children: <Widget>[


              Container(
                  color: RoyalBoardColors.backgroundColor,
                  height:150,

                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                      productProvider.productList.data.length,
                      padding:
                      const EdgeInsets.only(left: PsDimens.space16),
                      itemBuilder: (BuildContext context, int index) {
                        if (productProvider.productList.status ==
                            PsStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: RoyalBoardColors.grey,
                              highlightColor: RoyalBoardColors.white,
                              child: Row(children: const <Widget>[
                                PsFrameUIForLoading(),
                              ]));
                        } else {
                          final Product product =
                          productProvider.productList.data[index];
                          return SingleChildScrollView(
                            child: Container(
                              height: 150,
                              child: HorizontalListOffers(
                                coreTagKey:
                                productProvider.hashCode.toString() +
                                    product.id,
                                product:
                                productProvider.productList.data[index],
                                onTap: () {
                                  print(productProvider.productList
                                      .data[index].defaultPhoto.imgPath);
                                  final ProductDetailIntentHolder holder =
                                  ProductDetailIntentHolder(
                                    product: productProvider
                                        .productList.data[index],
                                    heroTagImage: productProvider.hashCode
                                        .toString() +
                                        product.id +
                                        RoyalBoardConst.HERO_TAG__IMAGE,
                                    heroTagTitle: productProvider.hashCode
                                        .toString() +
                                        product.id +
                                        RoyalBoardConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice: productProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        RoyalBoardConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice: productProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        RoyalBoardConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              ),
                            ),
                          );
                        }
                      })),
              const SizedBox(height: PsDimens.space8),
            ],
          )
              : productProvider!=null&&productProvider.isLoading?Container(
            child: Text('جاري العرض'),
          ):productProvider!=null&&productProvider.productList!=null&&productProvider.productList.data.isEmpty?Container(
            child: Text('لايوجد منتجات'),
          ):Container(
            child: Text(' جاري المعالجة '),
          );
        },
      ),
    );
  }
}