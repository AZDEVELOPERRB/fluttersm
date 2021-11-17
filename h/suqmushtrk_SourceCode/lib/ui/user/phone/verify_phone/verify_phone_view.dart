import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';

import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/success_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_button_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/api_status.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/phone_login_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/resend_code_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView(
      {Key key,
      @required this.userName,
      @required this.phoneNumber,
      @required this.phoneId,
      @required this.animationController,
      this.onProfileSelected,
      this.onSignInSelected})
      : super(key: key);

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final AnimationController animationController;
  final Function onProfileSelected, onSignInSelected;
  @override
  _VerifyPhoneViewState createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  UserRepository repo1;
  PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: valueHolder);
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return SingleChildScrollView(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                color: RoyalBoardColors.backgroundColor,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _dividerWidget,
                      _HeaderTextWidget(
                          userProvider: provider,
                          phoneNumber: widget.phoneNumber),
                      _TextFieldAndButtonWidget(
                        userName: widget.userName,
                        phoneNumber: widget.phoneNumber,
                        phoneId: widget.phoneId,
                        provider: provider,
                        onProfileSelected: widget.onProfileSelected,
                      ),
                      Column(
                        children: const <Widget>[
                          SizedBox(
                            height: PsDimens.space16,
                          ),
                          Divider(
                            height: PsDimens.space1,
                          ),
                          SizedBox(
                            height: PsDimens.space32,
                          )
                        ],
                      ),
                      GestureDetector(
                          child: Text(
                            Utils.getString(
                                context, 'phone_signin__back_login'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: RoyalBoardColors.mainColor),
                          ),
                          onTap: () {
                            if (widget.onSignInSelected != null) {
                              widget.onSignInSelected();
                            } else {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                RoutePaths.user_phone_signin_container,
                              );
                            }
                          })
                    ],
                  ),
                )),
          ],
        ));
      }),
    );
  }
}

class _TextFieldAndButtonWidget extends StatefulWidget {
  const _TextFieldAndButtonWidget({
    @required this.userName,
    @required this.phoneNumber,
    @required this.phoneId,
    @required this.provider,
    this.onProfileSelected,
  });

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final UserProvider provider;
  final Function onProfileSelected;

  @override
  __TextFieldAndButtonWidgetState createState() =>
      __TextFieldAndButtonWidgetState();
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

    final PsResource<User> _apiStatus =
        await provider.postPhoneLogin(phoneLoginParameterHolder.toMap());

    if (_apiStatus.data != null) {
      provider.replaceVerifyUserData('', '', '', '');
      provider.replaceLoginUserId(_apiStatus.data.userId);

      if (onProfileSelected != null) {
        await provider.replaceVerifyUserData('', '', '', '');
        await provider.replaceLoginUserId(_apiStatus.data.userId);
        await onProfileSelected(_apiStatus.data.userId);
      } else {
        Navigator.pop(context, _apiStatus.data);
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

class __TextFieldAndButtonWidgetState extends State<_TextFieldAndButtonWidget> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController userIdTextField = TextEditingController();
bool isnew=false;
bool isloading=false;
bool enterotp=false;
Timer _timer;
int seconds=40;
@override
  void initState() {


    super.initState();
  }
@override
  void dispose() {
super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space40,
        ),
        Container(
          width: MediaQuery.of(context).size.width -8,
          child: TextField(
            textAlign: TextAlign.center,
            controller: codeController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(35.0),
                borderSide:  BorderSide(color: Colors.indigoAccent ),

              ),
              focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(35.0),
                borderSide:  BorderSide(color: Colors.indigoAccent ),

              ),
              hintText: "ادخل رمز التحقق",
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: RoyalBoardColors.textPrimaryLightColor),
            ),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        const SizedBox(
          height: PsDimens.space16,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space16, right: PsDimens.space16),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText:isloading?"يرجى الانتظار جاري التحقق": "ارسال",
            onPressed: isloading?(){}:() async {
              setState(() {
                isloading=true;
              });
              await verify();
              setState(() {
                isloading=false;
              });

            },
          ),
        )
      ],
    );
  }
  verify()async{
    if (codeController.text.isEmpty) {
      callWarningDialog(context,
          "يرجى ادخال رمز التحقق");
    } else if (codeController.text.length != 6) {
      callWarningDialog(context, 'رمز التحقق غير صحيح');
    } else {
      final fb_auth.User user =
          fb_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('correct code');
        await gotoProfile(
            context,
            // widget.phoneId,
            user.uid,
            widget.userName,
            widget.phoneNumber,
            widget.provider,
            widget.onProfileSelected,
            false);
      } else {
        final fb_auth.AuthCredential credential =
        fb_auth.PhoneAuthProvider.credential(
            verificationId: widget.phoneId,
            smsCode: codeController.text);

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
                  widget.userName,
                  widget.phoneNumber,
                  widget.provider,
                  widget.onProfileSelected,
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
    }
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget(
      {@required this.userProvider, @required this.phoneNumber});
  final UserProvider userProvider;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: PsDimens.space200,
      width: double.infinity,
      child: Stack(children: <Widget>[
        Container(
            color: RoyalBoardColors.mainColor,
            padding: const EdgeInsets.only(
                left: PsDimens.space16, right: PsDimens.space16),
            height: PsDimens.space160,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space28,
                ),
                Text(
                  Utils.getString(context, 'phone_signin__title1'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: RoyalBoardColors.white),
                ),
                Text(
                  (phoneNumber == null) ? '' : phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: RoyalBoardColors.white),
                ),
              ],
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            child: const CircleAvatar(
              backgroundImage:
                  ExactAssetImage('assets/images/verify_email_icon.jpg'),
            ),
          ),
        )
      ]),
    );
  }
}

class _ChangeEmailAndRecentCodeWidget extends StatefulWidget {
  const _ChangeEmailAndRecentCodeWidget({
    @required this.provider,
    @required this.userEmailText,
    this.onSignInSelected,
  });
  final UserProvider provider;
  final String userEmailText;
  final Function onSignInSelected;

  @override
  __ChangeEmailAndRecentCodeWidgetState createState() =>
      __ChangeEmailAndRecentCodeWidgetState();
}

class __ChangeEmailAndRecentCodeWidgetState
    extends State<_ChangeEmailAndRecentCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          splashColor: RoyalBoardColors.transparent,
          highlightColor: RoyalBoardColors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__change_email')),
          textColor: RoyalBoardColors.mainColor,
          onPressed: () {
            if (widget.onSignInSelected != null) {
              widget.onSignInSelected();
            } else {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_register_container,
              );
            }
          },
        ),
        MaterialButton(
          splashColor: RoyalBoardColors.transparent,
          highlightColor: RoyalBoardColors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__resent_code')),
          textColor: RoyalBoardColors.mainColor,
          onPressed: () async {
            if (await Utils.checkInternetConnectivity()) {
              final ResendCodeParameterHolder resendCodeParameterHolder =
                  ResendCodeParameterHolder(
                userEmail: widget.provider.psValueHolder.userEmailToVerify,
              );

              final PsResource<ApiStatus> _apiStatus = await widget.provider
                  .postResendCode(resendCodeParameterHolder.toMap());

              if (_apiStatus.data != null) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessDialog(
                        message: _apiStatus.data.message,
                      );
                    });
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
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          },
        ),
      ],
    );
  }
}
