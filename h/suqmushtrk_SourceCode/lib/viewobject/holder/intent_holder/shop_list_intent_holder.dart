import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/shop_parameter_holder.dart';

class ShopListIntentHolder {
  const ShopListIntentHolder({
    @required this.shopParameterHolder,
    @required this.appBarTitle,
  });
  final ShopParameterHolder shopParameterHolder;
  final String appBarTitle;
}
