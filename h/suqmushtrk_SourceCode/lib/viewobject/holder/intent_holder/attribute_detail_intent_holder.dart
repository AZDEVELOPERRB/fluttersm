import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/customized_detail.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';

class AttributeDetailIntentHolder {
  const AttributeDetailIntentHolder({
    @required this.product,
    @required this.attributeDetail,
  });
  final Product product;
  final List<CustomizedDetail> attributeDetail;
}
