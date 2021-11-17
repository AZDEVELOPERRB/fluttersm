import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/shop/branch/shop_branch_list_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop_info.dart';

class ShopBranchContainerView extends StatefulWidget {
  const ShopBranchContainerView({
    Key key,
    @required this.shopId,
    @required this.shopInfo,
  }) : super(key: key);

  final String shopId;
  final ShopInfo shopInfo;
  @override
  _ShopBranchContainerViewState createState() =>
      _ShopBranchContainerViewState();
}

class _ShopBranchContainerViewState extends State<ShopBranchContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
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
          Navigator.pop(context, true);
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
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: RoyalBoardColors.mainColorWithWhite),
          title: Text(Utils.getString(context, 'shop_info__branch'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: RoyalBoardColors.mainColorWithWhite)),
          elevation: 0,
        ),
        body: Container(
          color: RoyalBoardColors.coreBackgroundColor,
          height: double.infinity,
          child: ShopBranchListView(
            data: widget.shopInfo,
            scrollController: _scrollController,
            shopId: widget.shopId,
          ),
        ),
      ),
    );
  }
}
