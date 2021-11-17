import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/provider/basket/basket_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/basket_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/coupon_discount_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/success_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_textfield_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/basket.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/coupon_discount.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/coupon_discount_holder.dart';
import 'package:provider/provider.dart';

class Checkout2View extends StatefulWidget {
  const Checkout2View({
    Key key,
    @required this.basketList,
    @required this.publishKey,
  }) : super(key: key);

  final List<Basket> basketList;
  final String publishKey;
  @override
  _Checkout2ViewState createState() => _Checkout2ViewState();
}

class _Checkout2ViewState extends State<Checkout2View> {
  final TextEditingController couponController = TextEditingController();
  CouponDiscountRepository couponDiscountRepo;
  TransactionHeaderRepository transactionHeaderRepo;
  BasketRepository basketRepository;
  UserRepository userRepository;
  PsValueHolder valueHolder;
  CouponDiscountProvider couponDiscountProvider;
  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    couponDiscountRepo = Provider.of<CouponDiscountRepository>(context);
    transactionHeaderRepo = Provider.of<TransactionHeaderRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);

    valueHolder = Provider.of<PsValueHolder>(context);
    userRepository = Provider.of<UserRepository>(context);

    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget child) {
      couponDiscountProvider = Provider.of<CouponDiscountProvider>(context,
          listen: false); // Listen : False is important.
      userProvider = Provider.of<UserProvider>(context,
          listen: false); // Listen : False is important.

      final BasketProvider basketProvider =
          Provider.of<BasketProvider>(context);

      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: RoyalBoardColors.backgroundColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              padding: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: PsDimens.space16, right: PsDimens.space16),
                  //   child: Text(
                  //     Utils.getString(
                  //         context, 'transaction_detail__coupon_discount'),
                  //     style: Theme.of(context).textTheme.subtitle1.copyWith(),
                  //   ),
                  // ),
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  // const SizedBox(
                  //   height: PsDimens.space16,
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Expanded(
                  //         child: PsTextFieldWidget(
                  //       hintText:
                  //           Utils.getString(context, 'checkout__coupon_code'),
                  //       textEditingController: couponController,
                  //       showTitle: false,
                  //     )),
                  //     Container(
                  //       margin: const EdgeInsets.only(right: PsDimens.space8),
                  //       child: RaisedButton(
                  //         color: RoyalBoardColors.mainColor,
                  //         shape: const BeveledRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(7.0)),
                  //         ),
                  //         child: Row(
                  //           children: <Widget>[
                  //             Icon(MaterialCommunityIcons.ticket_percent,
                  //                 color: RoyalBoardColors.white),
                  //             const SizedBox(
                  //               width: PsDimens.space4,
                  //             ),
                  //             Text(
                  //               Utils.getString(
                  //                   context, 'checkout__claim_button_name'),
                  //               textAlign: TextAlign.start,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .button
                  //                   .copyWith(color: RoyalBoardColors.white),
                  //             ),
                  //           ],
                  //         ),
                  //         onPressed: () async {
                  //           if (couponController.text.isNotEmpty) {
                  //             final CouponDiscountParameterHolder
                  //                 couponDiscountParameterHolder =
                  //                 CouponDiscountParameterHolder(
                  //                     couponCode: couponController.text,
                  //                     shopId:
                  //                         userProvider.psValueHolder.shopId);
                  //
                  //             final PsResource<CouponDiscount> _apiStatus =
                  //                 await couponDiscountProvider
                  //                     .postCouponDiscount(
                  //                         couponDiscountParameterHolder
                  //                             .toMap());
                  //
                  //             if (_apiStatus.data != null &&
                  //                 couponController.text ==
                  //                     _apiStatus.data.couponCode) {
                  //               final BasketProvider basketProvider =
                  //                   Provider.of<BasketProvider>(context,
                  //                       listen: false);
                  //
                  //               basketProvider.checkoutCalculationHelper
                  //                   .calculate(
                  //                       basketList: widget.basketList,
                  //                       couponDiscountString:
                  //                           _apiStatus.data.couponAmount,
                  //                       psValueHolder: valueHolder,
                  //                       shippingPriceStringFormatting:
                  //                           userProvider.selectedArea.price);
                  //
                  //               showDialog<dynamic>(
                  //                   context: context,
                  //                   builder: (BuildContext context) {
                  //                     return SuccessDialog(
                  //                       message: Utils.getString(context,
                  //                           'checkout__couponcode_add_dialog_message'),
                  //                     );
                  //                   });
                  //
                  //               couponController.clear();
                  //               print(_apiStatus.data.couponAmount);
                  //               setState(() {
                  //                 couponDiscountProvider.couponDiscount =
                  //                     _apiStatus.data.couponAmount;
                  //               });
                  //             } else {
                  //               showDialog<dynamic>(
                  //                   context: context,
                  //                   builder: (BuildContext context) {
                  //                     return ErrorDialog(
                  //                       message: _apiStatus.message,
                  //                     );
                  //                   });
                  //             }
                  //           } else {
                  //             showDialog<dynamic>(
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return WarningDialog(
                  //                     message: Utils.getString(context,
                  //                         'checkout__warning_dialog_message'),
                  //                     onPressed: () {},
                  //                   );
                  //                 });
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: PsDimens.space16,
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: PsDimens.space16, right: PsDimens.space16),
                  //   child: Text(
                  //       Utils.getString(context, 'checkout__description'),
                  //       style: Theme.of(context).textTheme.bodyText2),
                  // ),
                  // const SizedBox(
                  //   height: PsDimens.space16,
                  // ),
                ],
              ),
            ),
            _OrderSummaryWidget(
              psValueHolder: valueHolder,
              basketList: widget.basketList,
              couponDiscount: couponDiscountProvider.couponDiscount ?? '-',
              basketProvider: basketProvider,
              userProvider: userProvider,
            ),
          ],
        ),
      );
    });
  }
}

class _OrderSummaryWidget extends StatelessWidget {
  const _OrderSummaryWidget({
    Key key,
    @required this.basketList,
    @required this.couponDiscount,
    @required this.psValueHolder,
    @required this.basketProvider,
    @required this.userProvider,
  }) : super(key: key);

  final List<Basket> basketList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final BasketProvider basketProvider;
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    String currencySymbol;

    if (basketList.isNotEmpty) {
      currencySymbol = basketList[0].product.currencySymbol;
    }

    basketProvider.checkoutCalculationHelper.calculate(
        basketList: basketList,
        couponDiscountString: couponDiscount,
        psValueHolder: psValueHolder,
        shippingPriceStringFormatting: userProvider.selectedArea.price);

    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space12,
    );

    return Container(
        color: RoyalBoardColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Utils.getString(context, 'checkout__order_summary'),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: basketProvider
                  .checkoutCalculationHelper.totalItemCount
                  .toString(),
              title:
                  '${Utils.getString(context, 'checkout__total_item_count')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '${basketList[0].product.currencySymbol} ${basketProvider.checkoutCalculationHelper.totalOriginalPriceFormattedString}',
              title:
                  '${Utils.getString(context, 'checkout__total_item_price')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${basketProvider.checkoutCalculationHelper.totalDiscountFormattedString}',
              title: '${Utils.getString(context, 'checkout__discount')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText: couponDiscount == '-'
                  ? '-'
                  : '$currencySymbol ${basketProvider.checkoutCalculationHelper.couponDiscountFormattedString}',
              title:
                  '${Utils.getString(context, 'checkout__coupon_discount')} :',
            ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${basketProvider.checkoutCalculationHelper.subTotalPriceFormattedString}',
              title: '${Utils.getString(context, 'checkout__sub_total')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${basketProvider.checkoutCalculationHelper.taxFormattedString}',
              title:
                  '${Utils.getString(context, 'checkout__tax')} (${psValueHolder.overAllTaxLabel} %) :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${double.parse(userProvider.selectedArea.price == '' ? '0.0' : userProvider.selectedArea.price)}',
              title: '${Utils.getString(context, 'checkout__shipping_cost')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${Utils.calculateShippingTax(userProvider.selectedArea.price == '' ? '0.0' : userProvider.selectedArea.price, psValueHolder.shippingTaxValue == '' ? '0.0' : psValueHolder.shippingTaxValue)}',
              title:
                  '${Utils.getString(context, 'checkout__shipping_tax')} (${psValueHolder.shippingTaxLabel} %) :',
            ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText:
                  '$currencySymbol ${basketProvider.checkoutCalculationHelper.totalPriceFormattedString}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total')} :',
            ),
            _spacingWidget,
          ],
        ));
  }
}

class _OrderSummeryTextWidget extends StatelessWidget {
  const _OrderSummeryTextWidget({
    Key key,
    @required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
