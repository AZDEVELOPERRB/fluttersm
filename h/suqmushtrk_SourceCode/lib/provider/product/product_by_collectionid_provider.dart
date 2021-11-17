import 'dart:async';

import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class ProductByCollectionIdProvider extends PsProvider {
  ProductByCollectionIdProvider(
      {@required ProductRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Product By Collection Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = productCollectionListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productCollectionList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Product>>> productCollectionListStream;

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Product>> _productCollectionList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productCollectionList => _productCollectionList;
  StreamSubscription<PsResource<List<Product>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    productCollectionListStream.close();
    isDispose = true;
    print('Product By Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByCollectionId(String collectionId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllproductListByCollectionId(
        productCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProductListByCollectionId(String collectionId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageproductListByCollectionId(
          productCollectionListStream,
          isConnectedToInternet,
          collectionId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductListByCollectionId(String collectionId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllproductListByCollectionId(
        productCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
