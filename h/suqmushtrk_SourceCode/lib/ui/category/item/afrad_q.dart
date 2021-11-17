import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/category.dart';

class Afrad_Q extends StatelessWidget {
  const Afrad_Q(
      {Key key,
      @required this.category,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Category category;

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
                elevation: 0.3,
                child: Container(

                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space200,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/cc.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Container(
                              //   width: 200,
                              //   height: double.infinity,
                              //   color: RoyalBoardColors.black.withAlpha(110),
                              // )
                            )
                            // Container(
                            //   width: 200,
                            //   height: double.infinity,
                            //   color: RoyalBoardColors.black.withAlpha(110),
                            // )
                          ],
                        )),
                    Positioned(
                      top: 0,
                      right: 1,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.black45),
                        child:  Text(
                        'قسم الافراد',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: RoyalBoardColors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    ,
                    // Container(
                    //     child: Positioned(
                    //   bottom: 10,
                    //   left: 10,
                    //   child: Container(
                    //     width: PsDimens.space40,
                    //     height: PsDimens.space40,
                    //     child: PsNetworkCircleIconImage(
                    //       photoKey: '',
                    //       defaultIcon: category.defaultIcon,
                    //       // width: PsDimens.space40,
                    //       // height: PsDimens.space40,
                    //       boxfit: BoxFit.cover,
                    //       onTap: onTap,
                    //     ),
                    //   ),
                    // )),
                  ],
                )))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child,
            ),
          );
        });
  }
}
