import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneContainerView extends StatefulWidget {
  const VerifyPhoneContainerView({
    Key key,
    @required this.userName,
    @required this.phoneNumber,
    @required this.phoneId,
  }) : super(key: key);
  final String userName;
  final String phoneNumber;
  final String phoneId;
  @override
  _CityVerifyPhoneContainerViewState createState() =>
      _CityVerifyPhoneContainerViewState();
}

class _CityVerifyPhoneContainerViewState extends State<VerifyPhoneContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  UserRepository userRepo;

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
    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: RoyalBoardColors.mainColor,
              brightness: Utils.getBrightnessForAppBar(context),
              iconTheme: Theme.of(context).iconTheme.copyWith(),
              title: Text(
                Utils.getString(context, 'home_verify_phone'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
            ),
            body: VerifyPhoneView(
              userName: widget.userName,
              phoneNumber: widget.phoneNumber,
              phoneId: widget.phoneId,
              animationController: animationController,
            )));
  }
}
