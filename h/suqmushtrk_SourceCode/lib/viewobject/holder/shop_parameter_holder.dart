import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_holder.dart';

class ShopParameterHolder extends PsHolder<dynamic> {
  shopParameterHolderShopParameterHolder() {
    isFeatured = '0';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';
  }

  String isFeatured;
  String orderBy;
  String orderType;
  String isjomla='';
  String shop_i='';
  String cat_id='';
  String lat;
  String lng;
  String miles;

  ShopParameterHolder getShopNearYouParameterHolder() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '10';

    return this;
  }

  ShopParameterHolder getTrendingShopParameterHolder() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';

    return this;
  }
  ShopParameterHolder get_jomla_shops() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    isjomla='1';
    miles = '';

    return this;
  }
  ShopParameterHolder get_mufrad_shops() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    isjomla='0';
    miles = '';

    return this;
  }
  ShopParameterHolder getMufradShops() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';
    isjomla='0';

    return this;
  }
  ShopParameterHolder getShopbyreferal() {
    isFeatured = '';
    shop_i = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';

    return this;
  }
  ShopParameterHolder getTrendingShopParameterHolderforcats(String catid) {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING_TRENDING;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    isjomla='1';
    cat_id=catid;
    lng = '';
    miles = '';

    return this;
  }

  ShopParameterHolder resetParameterHolder() {
    isFeatured = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['is_featured'] = isFeatured;
    map['shop_i'] = shop_i;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['jomla'] = isjomla;
    map['catid'] = cat_id;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = miles;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    isFeatured = '';
    shop_i = '';
    orderBy = RoyalBoardConst.FILTERING__ADDED_DATE;
    orderType = RoyalBoardConst.FILTERING__DESC;
    lat = '';
    lng = '';
    miles = '';

    return this;
  }

  @override
  String getParamKey() {
    const String newshop = 'New Shops';
    const String featured = 'Featured Shops';
    const String popularshop = 'Popular Shops';

    String result = '';

    if (isFeatured != '' && isFeatured != '0') {
      result += featured + ':';
    }
    if (shop_i != '' && shop_i != '0') {
      result += shop_i + ':';
    }

    if (newshop != '') {
      result += newshop + ':';
    }

    if (popularshop != '') {
      result += popularshop + ':';
    }

    if (orderBy != '') {
      result += orderBy + ':';
    }

    if (orderType != '') {
      result += orderType;
    }
    if (isjomla != '') {
      result += isjomla;
    }
    if (cat_id != '') {
      result += cat_id;
    }

    if (lat != '') {
      result += lat + ':';
    }

    if (lng != '') {
      result += lng + ':';
    }

    if (miles != '') {
      result += miles;
    }

    return result;
  }
}
