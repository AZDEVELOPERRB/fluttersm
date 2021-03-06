import 'dart:async';
import 'package:RoyalBoard_Common_sooq/repository/coupon_discount_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/coupon_discount.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';

class CouponDiscountProvider extends PsProvider {
  CouponDiscountProvider(
      {@required CouponDiscountRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('CouponDiscount Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CouponDiscountRepository _repo;
  String couponDiscount = '0.0';

  PsResource<CouponDiscount> _couponDiscount =
      PsResource<CouponDiscount>(PsStatus.NOACTION, '', null);
  PsResource<CouponDiscount> get user => _couponDiscount;
  @override
  void dispose() {
    isDispose = true;
    print('CouponDiscount Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postCouponDiscount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _couponDiscount = await _repo.postCouponDiscount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _couponDiscount;
  }
}
