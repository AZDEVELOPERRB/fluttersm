import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/more/more_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';

class MoreContainerView extends StatefulWidget {
  const MoreContainerView({@required this.userName});

  final String userName;

  @override
  _MoreContainerViewState createState() => _MoreContainerViewState();
}

class _MoreContainerViewState extends State<MoreContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  //Function callLogoutCallBack;

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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            widget.userName,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Container(
          color: RoyalBoardColors.mainDividerColor,
          height: double.infinity,
          child: MoreView(
            //callLogoutCallBack: callLogoutCallBack,
            animationController: animationController,
          ),
        ),
      ),
    );
  }
}
