import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/basket.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';

class CheckoutCalculationHelper {
  CheckoutCalculationHelper();
  int totalItemCount = 0;
  double subTotalPrice = 0.00;
  String subTotalPriceFormattedString = '';
  double totalDiscount = 0.00;
  String totalDiscountFormattedString = '';
  double couponDiscount = 0.00;
  String couponDiscountFormattedString = '';
  double tax = 0.00;
  String taxFormattedString = '';
  double shippingTax = 0.00;
  String shippingTaxFormattedString = '';
  double shippingCost = 0.00;
  String shippingCostFormattedString = '';
  double totalPrice = 0.00;
  String totalPriceFormattedString = '';
  double totalOriginalPrice = 0.00;
  String totalOriginalPriceFormattedString = '';

  void reset() {
    totalItemCount = 0;
    subTotalPrice = 0.00;
    subTotalPriceFormattedString = '';
    totalDiscount = 0.00;
    totalDiscountFormattedString = '';
    couponDiscount = 0.00;
    couponDiscountFormattedString = '';
    tax = 0.00;
    taxFormattedString = '';
    shippingTax = 0.00;
    shippingTaxFormattedString = '';
    totalPrice = 0.00;
    totalPriceFormattedString = '';
    totalOriginalPrice = 0.00;
    totalOriginalPriceFormattedString = '';
  }

  void calculate(
      {@required List<Basket> basketList,
      @required String couponDiscountString,
      @required PsValueHolder psValueHolder,
      @required String shippingPriceStringFormatting}) {
    // reset Data
    reset();

    //  Product Discount and Product Original Price Calculation and  Product Count
    if (basketList.isNotEmpty) {
      for (Basket basket in basketList) {
        //Product Original Price Calculation
        totalOriginalPrice +=
            double.parse(basket.basketPrice) * double.parse(basket.qty);

        // Items Total Discount Calculation
        // totalDiscount += double.parse(basket.product.discountAmount) *
        //     double.parse(basket.qty);
        totalDiscount=0;

        totalItemCount += int.parse(basket.qty);
      }
      // Product Count Calculation
//here payment details
      // SubTotal Calculation
      subTotalPrice = totalOriginalPrice
          ;

      // Coupon Discount Calculation
      // subTotalPrice - coupondiscount = subTotalPrice  after coupon discount
      if (couponDiscountString != null &&
          couponDiscountString != '-' &&
          couponDiscountString != '') {
        couponDiscount = double.parse(couponDiscountString);
        subTotalPrice = subTotalPrice - couponDiscount;
      }

      // Tax Calculation
      // subTotalPrice * Tax Percentage = Tax Amount
      if (psValueHolder.overAllTaxLabel != '0') {
        tax = subTotalPrice * double.parse(psValueHolder.overAllTaxValue);
      }

      if (shippingPriceStringFormatting != '0.0' &&
          shippingPriceStringFormatting != '') {
        shippingCost = double.parse(shippingPriceStringFormatting);
        // Shipping Cost Calculation
        // shippingCost * Shipping Cost Percentage = Shipping Cost Amount
        if (psValueHolder.shippingTaxLabel != '0' && shippingCost != 0.0) {
          shippingTax =
              shippingCost * double.parse(psValueHolder.shippingTaxValue);
        }
      } else {
        shippingCost = 0.0;
        shippingTax = 0.0;
      }

      // Total Payable Amount
      //  subTotalPrice + Tax Amount  + shippingTax Amount + shippingCost Amount  + shippingTax Amount = Total
      totalPrice = subTotalPrice + tax + shippingTax + shippingCost;

      // Formatted String
      // - Total Product Original Price
      // - Total Discount Amount
      // - Coupon Discount Amount
      // - Sub Total Price
      // - Tax Amount
      // - Total Payable
      totalOriginalPriceFormattedString =
          getPriceFormat(totalOriginalPrice.toString());
      totalDiscountFormattedString = getPriceFormat(totalDiscount.toString());
      couponDiscountFormattedString = getPriceFormat(couponDiscount.toString());
      subTotalPriceFormattedString = getPriceFormat(subTotalPrice.toString());
      taxFormattedString = getPriceFormat(tax.toString());
      shippingTaxFormattedString = getPriceFormat(shippingTax.toString());
      shippingCostFormattedString = getPriceFormat(shippingCost.toString());
      totalPriceFormattedString = getPriceFormat(totalPrice.toString());
    }
  }
}

String getPriceFormat(String price) {
  // final NumberFormat RoyalBoardConst.psFormat = NumberFormat('###.00');
  return RoyalBoardConst.psFormat.format(double.parse(price));
}

String getPriceTwoDecimalFormat(String price) {
  return RoyalBoardConst.priceTwoDecimalFormat.format(double.parse(price));
}
