import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    shopId = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
  }

  String orderBy;
  String shopId;
  String isjomla='0';

  CategoryParameterHolder getTrendingParameterHolder() {
    shopId = '';
    orderBy = RoyalBoardConst.FILTERING__TRENDING;

    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    shopId = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['shop_id'] = shopId;
    map['isjomla'] = isjomla;
    map['order_by'] = orderBy;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    shopId = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (shopId != '') {
      result += shopId + ':';
    }
    if (orderBy != '') {
      result += orderBy + ':';
    }
    if (isjomla != '') {
      result += isjomla + ':';
    }

    return result;
  }
}
