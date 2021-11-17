import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_button_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/utils/ps_progress_dialog.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:RoyalBoard_Common_sooq/viewobject/holder/phone_login_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';

class PhoneSignInView extends StatefulWidget {
  const PhoneSignInView(
      {Key key,
        this.animationController,
        this.goToLoginSelected,
        this.phoneSignInSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  final Function phoneSignInSelected;
  @override
  _PhoneSignInViewState createState() => _PhoneSignInViewState();
}

class _PhoneSignInViewState extends State<PhoneSignInView>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  UserRepository repo1;
  PsValueHolder psValueHolder;
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
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
          UserProvider(repo: repo1, psValueHolder: psValueHolder);
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _CardWidget(
                            nameController: nameController,
                            phoneController: phoneController,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          _SendButtonWidget(
                            provider: provider,
                            nameController: nameController,
                            phoneController: phoneController,
                            phoneSignInSelected: widget.phoneSignInSelected,
                          ),
                          const SizedBox(
                            height: PsDimens.space16,
                          ),
                          _TextWidget(
                              goToLoginSelected: widget.goToLoginSelected),
                        ],
                      ),
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - animation.value), 0.0),
                            child: child,
                          ),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        Utils.getString(context, 'phone_signin__back_login'),
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: RoyalBoardColors.mainColor),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(Utils.getString(context, 'app_name'),
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: RoyalBoardColors.mainColor));

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/flutter_grocery_logo.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget(
      {@required this.nameController, @required this.phoneController});

  final TextEditingController nameController;
  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetsforCard,
            child: TextField(
              controller: nameController,
              style: Theme.of(context).textTheme.bodyText2.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: RoyalBoardColors.textPrimaryLightColor),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          const Divider(
            height: PsDimens.space1,
          ),
          Container(
            margin: _marginEdgeInsetsforCard,
            child: Directionality(
                textDirection: Directionality.of(context) == TextDirection.ltr
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: TextField(
                  controller: phoneController,
                  textDirection: TextDirection.ltr,
                  textAlign: Directionality.of(context) == TextDirection.ltr
                      ? TextAlign.left
                      : TextAlign.right,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '07701112223',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: RoyalBoardColors.textPrimaryLightColor),
                      icon: Icon(Icons.phone,
                          color: Theme.of(context).iconTheme.color)),
                  // keyboardType: TextInputType.number,
                )),
          ),
        ],
      ),
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget(
      {@required this.provider,
        @required this.nameController,
        @required this.phoneController,
        @required this.phoneSignInSelected});
  final UserProvider provider;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final Function phoneSignInSelected;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  Future<String> verifyPhone() async {
    String verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      print('code has been send');
      PsProgressDialog.dismissDialog();

      if (widget.phoneSignInSelected != null) {
        widget.phoneSignInSelected(widget.nameController.text,
            '+964${widget.phoneController.text}', verificationId);
      } else {
        Navigator.pushReplacementNamed(
            context, RoutePaths.user_phone_verify_container,
            arguments: VerifyPhoneIntentHolder(
                userName: widget.nameController.text,
                phoneNumber: '+964${widget.phoneController.text}',
                phoneId: verificationId));
      }
    };
    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) async{
     await successverified(user);
      PsProgressDialog.dismissDialog();
    };
    final PhoneVerificationFailed verifyFail =
        (FirebaseAuthException exception) {
      print('${exception.message}');
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: '${exception.message}',
            );
          });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+964${widget.phoneController.text}',
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(minutes: 2),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFail);
    return verificationId;
  }
  successverified(AuthCredential credential)async{
    String phone='+964${widget.phoneController.text}';

      try {
        await fb_auth.FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((fb_auth.UserCredential user) async {
          if (user != null) {
            print('correct code again');
            await gotoProfile(
                context,
                // widget.phoneId,
                user.user.uid,
                widget.nameController.text,
                phone,
                widget.provider,
                null,
                true);
          }
        });
      } on Exception {
        print('show error');
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(
                    context, 'error_dialog__code_wrong'),
              );
            });
      }
    }
  dynamic gotoProfile(
      BuildContext context,
      String phoneId,
      String userName,
      String phoneNumber,
      UserProvider provider,
      Function onProfileSelected,
      bool isn) async {
    if (await Utils.checkInternetConnectivity()) {
      final PhoneLoginParameterHolder phoneLoginParameterHolder =
      PhoneLoginParameterHolder(
        phoneId: phoneId,
        userName: userName,
        userPhone: phoneNumber,
        deviceToken: provider.psValueHolder.deviceToken,
      );

      final PsResource _apiStatus =
      await provider.postPhoneLogin(phoneLoginParameterHolder.toMap());
      PsProgressDialog.dismissDialog();
      if (_apiStatus.data != null) {
        provider.replaceVerifyUserData('', '', '', '');
        provider.replaceLoginUserId(_apiStatus.data.userId);

        if (onProfileSelected != null) {
          await provider.replaceVerifyUserData('', '', '', '');
          await provider.replaceLoginUserId(_apiStatus.data.userId);
          await onProfileSelected(_apiStatus.data.userId);
        } else {

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (ctx)=>DashboardView()
          ), (route) => false);
        }
        print('you can go to profille');
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'login__phone_signin'),
        onPressed: () async {
          if (widget.nameController.text.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_name'));
          } else if ('+964${widget.phoneController.text}'.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_phone'));
          } else {
            await PsProgressDialog.showDialog(context);
            await verifyPhone();
          }
        },
      ),
    );
  }
}
