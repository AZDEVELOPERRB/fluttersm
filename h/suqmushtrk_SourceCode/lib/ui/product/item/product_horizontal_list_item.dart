import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_hero.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';

class ProductHorizontalListItem extends StatelessWidget {
  const ProductHorizontalListItem({
    Key key,
    @required this.product,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: RoyalBoardColors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: PsDimens.space4, vertical: PsDimens.space12),
            decoration: BoxDecoration(
              color: RoyalBoardColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
            ),
            width: PsDimens.space180,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(PsDimens.space8)),
                    ),
                    child: ClipPath(
                      child: PsNetworkImage(
                        photoKey: '$coreTagKey${RoyalBoardConst.HERO_TAG__IMAGE}',
                        defaultPhoto: product.defaultPhoto,
                        width: PsDimens.space180,
                        height: double.infinity,
                        boxfit: BoxFit.cover,
                        onTap: () {
                          Utils.psPrint(product.defaultPhoto.imgParentId);
                          onTap();
                        },
                      ),
                      clipper: const ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(PsDimens.space8),
                                  topRight: Radius.circular(PsDimens.space8)))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space8,
                      top: PsDimens.space4,
                      right: PsDimens.space8,
                      bottom: PsDimens.space4),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          // Expanded(
                          //     child: PsHero(
                          //   tag: '$coreTagKey$RoyalBoardConst.HERO_TAG__UNIT_PRICE',
                          //   flightShuttleBuilder: Utils.flightShuttleBuilder,
                          //   child: Material(
                          //     type: MaterialType.transparency,
                          Expanded(
                            child: Text(
                                '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice)}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: RoyalBoardColors.mainColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                          ),
                          SizedBox(width: 10,),
                          Row(
                            children: <Widget>[
                              // Expanded(
                              //     child: PsHero(
                              //   tag: '$coreTagKey$RoyalBoardConst.HERO_TAG__UNIT_PRICE',
                              //   flightShuttleBuilder: Utils.flightShuttleBuilder,
                              //   child: Material(
                              //     type: MaterialType.transparency,
                              if(product.second_price!=null&&product.second_price!=''&&product.second_price!=0&&product.second_price!='0')    Text(
                                  '${product.currencySymbol}${Utils.getPriceFormat(product.second_price)}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    color:Colors.pink,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              //),
                              // )
                              // ),
                              // const SizedBox(width: PsDimens.space2),

                              // if (product.isDiscount == RoyalBoardConst.ONE)
                              //   Text(
                              //     '     ${product.discountPercent}% ' +
                              //         Utils.getString(
                              //             context, 'product_detail__discount_off'),
                              //     textAlign: TextAlign.start,
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodyText2
                              //         .copyWith(color: RoyalBoardColors.discountColor),
                              //   )
                              // else
                              //   Container()
                            ],
                          ),
                          //),
                          // )
                          // ),
                          // const SizedBox(width: PsDimens.space2),
                          // Expanded(
                          //   child: Text(
                          //     ' ${Utils.getPriceFormat(product.productUnitValue)}'
                          //     ' ${product.productUnit}',
                          //     overflow: TextOverflow.ellipsis,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyText1
                          //         .copyWith(fontSize: PsDimens.space12),
                          //     maxLines: 1,
                          //   ),
                          // ),
                          // if (product.isDiscount == RoyalBoardConst.ONE)
                          //   Text(
                          //     '     ${product.discountPercent}% ' +
                          //         Utils.getString(
                          //             context, 'product_detail__discount_off'),
                          //     textAlign: TextAlign.start,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyText2
                          //         .copyWith(color: RoyalBoardColors.discountColor),
                          //   )
                          // else
                          //   Container()
                        ],
                      ),

                    ],
                  ),
                ),
                // Padding(
                //       padding: const EdgeInsets.only(
                //           left: PsDimens.space2,
                //           top: PsDimens.space8,
                //           right: PsDimens.space8,
                //           bottom: PsDimens.space2),
                //             child:
                //              product.isDiscount == RoyalBoardConst.ONE ?
                //               Text(
                //                 '  ${product.discountPercent}% ' +
                //                     Utils.getString(
                //                         context, 'product_detail__discount_off'),
                //                 textAlign: TextAlign.start,
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .bodyText2
                //                     .copyWith(color: RoyalBoardColors.discountColor),
                //               )
                //             :
                //               Text(
                //                 '',
                //                 textAlign: TextAlign.start,
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .bodyText2
                //                     .copyWith(color: RoyalBoardColors.discountColor),
                //               )
                //           ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space8,
                        right: PsDimens.space8,
                        bottom: PsDimens.space12),
                    child: PsHero(
                      tag: '$coreTagKey${RoyalBoardConst.HERO_TAG__TITLE}',
                      child: Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space1,
                        right: PsDimens.space8,
                        bottom: PsDimens.space12),
                    child: PsHero(
                      tag: '$coreTagKey${RoyalBoardConst.HERO_TAG__ORIGINAL_PRICE}',
                      child: Text(
                        product.shop.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: RoyalBoardColors.mainColor),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
