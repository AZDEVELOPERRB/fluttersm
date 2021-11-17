import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/sub_category.dart';

class Afrad_SubCategoryGridItem extends StatelessWidget {
  const Afrad_SubCategoryGridItem(
      {Key key,
        @required this.subCategory,
        this.onTap,
        this.animationController,
        this.animation})
      : super(key: key);

  final SubCategory subCategory;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap,
            child: SingleChildScrollView(

                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PsNetworkImage(
                      photoKey: '',
                      defaultPhoto: subCategory.defaultPhoto,
                      width: PsDimens.space200,
                      height:50,
                      boxfit: BoxFit.cover,
                    ),
                    Text(
                      subCategory.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),

                    ),

                  ],
                ))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child),
          );
        });
  }
}
