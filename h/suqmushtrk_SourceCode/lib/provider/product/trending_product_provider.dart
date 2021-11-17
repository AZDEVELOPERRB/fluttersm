import 'dart:async';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';

class TrendingProductProvider extends PsProvider {
  TrendingProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('TrendingProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;

  ProductParameterHolder trendingProductParameterHolder =
      ProductParameterHolder().getTrendingParameterHolder();
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Trending Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList(
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getProductList(productListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
  }

  Future<dynamic> nextProductList(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getProductList(productListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
    }
  }

  Future<dynamic> resetTrendingProductList(
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    updateOffset(0);

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductList(productListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
  }
}
