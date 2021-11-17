import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'basket_list_view.dart';

class BasketListContainerView extends StatefulWidget {
  const BasketListContainerView({
    Key key,
  }) : super(key: key);

  @override
  _CityBasketListContainerViewState createState() =>
      _CityBasketListContainerViewState();
}

class _CityBasketListContainerViewState extends State<BasketListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            Utils.getString(context, 'basket_list_container__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0,
        ),
        body: Container(
          color: RoyalBoardColors.coreBackgroundColor,
          height: double.infinity,
          child: BasketListView(
            animationController: animationController,
          ),
        ),
      ),
    );
  }
}
