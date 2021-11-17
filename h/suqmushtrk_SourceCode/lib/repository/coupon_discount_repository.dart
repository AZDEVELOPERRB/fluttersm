import 'dart:async';
import 'package:RoyalBoard_Common_sooq/viewobject/coupon_discount.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';

import 'Common/ps_repository.dart';

class CouponDiscountRepository extends PsRepository {
  CouponDiscountRepository({
    @required RoyalBoardApiService RoyalBoardApiService,
  }) {
    _RoyalBoardApiService = RoyalBoardApiService;
  }
  String primaryKey = 'id';
  RoyalBoardApiService _RoyalBoardApiService;

  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<CouponDiscount> _resource =
        await _RoyalBoardApiService.postCouponDiscount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<CouponDiscount>> completer =
          Completer<PsResource<CouponDiscount>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
