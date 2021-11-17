import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/smooth_star_rating_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_share/flutter_share.dart';
class ShopVerticleListItem extends StatelessWidget {
  const ShopVerticleListItem(
      {Key key,
      @required this.shop,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Shop shop;
  final Function onTap;

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 0.0,
              color: RoyalBoardColors.transparent,
              child: Container(
                  margin: const EdgeInsets.all(PsDimens.space8),
                  child: ShopVerticleListItemWidget(shop: shop)),
            )),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child:
              Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child,
              ));
        });
  }
}

class ShopVerticleListItemWidget extends StatelessWidget {
  const ShopVerticleListItemWidget({
    Key key,
    @required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space4),
          child: PsNetworkImage(
            height: PsDimens.space200,
            width: double.infinity,
            photoKey: '',
            defaultPhoto: shop.defaultPhoto,
            boxfit: BoxFit.cover,
          ),
        ),
        Row(
          children:[
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space8,
                  right: PsDimens.space8,
                  top: PsDimens.space12),
              child: Text(
                shop.name,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if( shop.is_verified=='1')if(shop.jomla=='1')   Padding(
               padding: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space12),
              child: Container(height: 30,width: 30,child: Image.asset('assets/images/jomla_verified_market.png'),),
            ),
            if( shop.is_verified=='1')if(shop.jomla!='1')   Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space8,
                  right: PsDimens.space8,
                  top: PsDimens.space12),
              child: Container(height: 30,width: 30,child: Image.asset('assets/images/verified_market.png'),),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:<Widget>[

              Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space12),
                child: Text(
                  'المعرف   :  ${shop.shop_i}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.bold,color: Colors.indigoAccent),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),

                height: 30,
                width: 120,
                child:  Row(
                  children: [
                    InkWell(
                      onTap: ()async{
                        // Share.share('check out my website https://example.com');
                        // FlutterClipboard.copy('مرحبا ياصديقي را اح اشاركك بمعرف افضل المتاجر الي شفتها بحياتي بتطبيق السوق المشترك والمعرف هو ${shop.shop_i}').then(( value ) =>
                        //     Fluttertoast.showToast(
                        //         msg: 'لقد قمت بنسخ المعرف بنجاح',
                        //         toastLength: Toast.LENGTH_SHORT,
                        //         gravity: ToastGravity.BOTTOM,
                        //         backgroundColor: Colors.green,
                        //         textColor: Colors.white
                        //     )
                        // );

                        String firmwords='معرف المتجر بتطبيق السوق المشترك  ${shop.shop_i}';
                        await FlutterShare.share(title: 'شارك معرف المتجر الآن ',text: firmwords,chooserTitle: 'شارك معرف المتجر الآن ');

                        // Share.text('شارك معرف المتجر الآن ', 'مرحبا ياصديقي راح اشاركك بمعرف افضل المتاجر الي شفتها بحياتي بتطبيق السوق المشترك والمعرف الي هو ${shop.shop_i}', 'file/txt');


                      }
                      ,
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          Text('مشاركة',style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),


                  ],
                )
              ),

              // Container(
              //
              //     margin: EdgeInsets.only(top: 8),
              //     height: 25,
              //     width: 45,
              //     child:  InkWell(
              //       onTap: (){
              //         // Share.share('check out my website https://example.com');
              //         FlutterClipboard.copy('مرحبا ياصديقي را اح اشاركك بمعرف افضل المتاجر الي شفتها بحياتي بتطبيق السوق المشترك والمعرف هو ${shop.shop_i}').then(( value ) =>
              //             Fluttertoast.showToast(
              //                 msg: 'لقد قمت بنسخ المعرف بنجاح',
              //                 toastLength: Toast.LENGTH_SHORT,
              //                 gravity: ToastGravity.BOTTOM,
              //                 backgroundColor: Colors.green,
              //                 textColor: Colors.white
              //             )
              //         );
              //
              //
              //       }
              //       ,
              //       child: Row(
              //         children: [
              //
              //           Text('نسخ',style: TextStyle(fontSize: 12),)
              //         ],
              //       ),
              //     )
              // )
            ],
          ),
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          onPressed: (){
            // Share.share('check out my website https://example.com');
            FlutterClipboard.copy('معرف المتجر بتطبيق السوق المشترك  ${shop.shop_i}').then(( value ) =>
                Fluttertoast.showToast(
                    msg: 'لقد قمت بنسخ المعرف بنجاح',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white
                )
            );


          }
          ,
          child: Text('نسخ معرف المتجر  ',style: TextStyle(fontSize: 16),),
        ),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              left: PsDimens.space12,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: shop.priceLevel == RoyalBoardConst.PRICE_LOW ||
                            shop.priceLevel == RoyalBoardConst.PRICE_MEDIUM ||
                            shop.priceLevel == RoyalBoardConst.PRICE_HIGH
                        ? RoyalBoardColors.mainColor
                        : RoyalBoardColors.grey),
                maxLines: 2,
              ),
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: shop.priceLevel == RoyalBoardConst.PRICE_MEDIUM ||
                            shop.priceLevel == RoyalBoardConst.PRICE_HIGH
                        ? RoyalBoardColors.mainColor
                        : RoyalBoardColors.grey),
                maxLines: 2,
              ),
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: shop.priceLevel == RoyalBoardConst.PRICE_HIGH
                        ? RoyalBoardColors.mainColor
                        : RoyalBoardColors.grey),
                maxLines: 2,
              ),
              const SizedBox(width: PsDimens.space8),
              Expanded(
                child: Text(
                  Utils.getString(context, 'shop_open') +
                      ' ${shop.openingHour} ' +
                      '-' +
                      ' ' +
                      Utils.getString(context, 'shop_close') +
                      '${shop.closingHour}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                  maxLines: 1,
                ),
              ),

            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            "اختصاص المتجر : "+shop.specialist??"",
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            "منتجات حصرية : "+shop.ex_product??"",
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            " المناطق المشمولة بالتوصيل : "+shop.deliver??"",
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child:  Text(
            Utils.getString(context, 'اقل مبلغ للمبيعات : ') +
                shop.mini_money,
            style:
            Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child:  Text(
            Utils.getString(context, '  ايام العطل : ') +
                shop.holiday,
            style:
            Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              bottom: PsDimens.space8,
              right: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SmoothStarRating(
                      key: Key(shop.ratingDetail.totalRatingValue),
                      rating: double.parse(shop.ratingDetail.totalRatingValue),
                      allowHalfRating: false,
                      onRated: (double v) {
                        // onTap();
                      },
                      starCount: 5,
                      size: 20.0,
                      color: RoyalBoardColors.ratingColor,
                      borderColor: RoyalBoardColors.grey.withAlpha(100),
                      spacing: 0.0),
                  Text('  ( ${shop.ratingDetail.totalRatingCount} )',
                      // '${Utils.getString(context, 'feature_slider__rating')}',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
              Container(
                child: Icon(MaterialIcons.directions,
                    size: 32, color: RoyalBoardColors.mainColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
