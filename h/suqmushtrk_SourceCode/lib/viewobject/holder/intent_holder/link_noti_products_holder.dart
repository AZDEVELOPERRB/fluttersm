import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/cupertino.dart';

class LinkNotiProductsList {
  const LinkNotiProductsList({
    @required this.productParameterHolder,
    @required this.appBarTitle,
    @required this.prod_id,

  });
  final ProductParameterHolder productParameterHolder;
  final String appBarTitle;
  final String prod_id;
}
