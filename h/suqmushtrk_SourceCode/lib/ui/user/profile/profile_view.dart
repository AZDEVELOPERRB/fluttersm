import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/RoyalBoard_provider_dependencies.dart';
import 'package:RoyalBoard_Common_sooq/provider/transaction/transaction_header_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/Friends_applied.dart';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/friends_list.dart';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/send_frequest.dart';
import 'package:RoyalBoard_Common_sooq/ui/transaction/item/transaction_list_item.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/ui/user/congratulation/congratulation.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    @required this.scaffoldKey,
  }) : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  @override
  Widget build(BuildContext context) {

    widget.animationController.forward();


    return
        // SingleChildScrollView(
        //     child: Container(
        //   color: RoyalBoardColors.coreBackgroundColor,
        //   height: widget.flag ==
        //           RoyalBoardConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
        //       ? MediaQuery.of(context).size.height - 100
        //       : MediaQuery.of(context).size.height - 40,
        //   child:
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
      _ProfileDetailWidget(
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve:
                const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        userId: widget.userId,
      ),
          Friends_list_req(
            animationController: widget.animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve:
                const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            userId: widget.userId,
          ),
      // _TransactionListViewWidget(
      //   scaffoldKey: widget.scaffoldKey,
      //   animationController: widget.animationController,
      //   userId: widget.userId,
      // )
    ]);
    //));
  }
}


class Friends_list_req extends StatefulWidget {
  const Friends_list_req({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  __ProfileDetailWidgetStateFriends createState() => __ProfileDetailWidgetStateFriends();
}

class __ProfileDetailWidgetStateFriends extends State<Friends_list_req> {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);
    return SliverToBoxAdapter(

      child: Container(
          height: 150,
          child: Friends_Apllied(provider.psValueHolder.loginUserId)
      ),
    );
  }
}

class _TransactionListViewWidget extends StatelessWidget {
  const _TransactionListViewWidget(
      {Key key,
      @required this.animationController,
      @required this.userId,
      @required this.scaffoldKey})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    TransactionHeaderRepository transactionHeaderRepository;
    PsValueHolder psValueHolder;
    transactionHeaderRepository =
        Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return

      SliverToBoxAdapter(
        child: ChangeNotifierProvider<TransactionHeaderProvider>(
            lazy: false,
            create: (BuildContext context) {
              final TransactionHeaderProvider provider =
                  TransactionHeaderProvider(
                      repo: transactionHeaderRepository,
                      psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.loadTransactionList(userId);
              } else {
                provider
                    .loadTransactionList(provider.psValueHolder.loginUserId);
              }

              return provider;
            },
            child: Consumer<TransactionHeaderProvider>(builder:
                (BuildContext context, TransactionHeaderProvider provider,
                    Widget child) {
              if (provider.transactionList != null &&
                  provider.transactionList.data.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space44),
                  child: Column(children: <Widget>[
                    _OrderAndSeeAllWidget(),
                    Container(
                        child: RefreshIndicator(
                      child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.transactionList.data != null ||
                                      provider
                                          .transactionList.data.isNotEmpty) {
                                    final int count =
                                        provider.transactionList.data.length;
                                    return TransactionListItem(
                                      scaffoldKey: scaffoldKey,
                                      animationController: animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      transaction:
                                          provider.transactionList.data[index],
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutePaths.transactionDetail,
                                            arguments: provider
                                                .transactionList.data[index]);
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount:
                                    provider.transactionList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetTransactionList();
                      },
                    )),
                  ]),
                );
              } else {
                return Container();
              }
            })));
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);
    bool isloading=false;



    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(provider.getCurrentFirebaseUser());
            if (provider.psValueHolder.loginUserId == null ||
                provider.psValueHolder.loginUserId == '') {
              provider.getUser(widget.userId);
            } else {
              provider.getUser(provider.psValueHolder.loginUserId);
            }
            return provider;
          },
          child: Consumer<UserProvider>(builder:
              (BuildContext context, UserProvider provider, Widget child) {
            if (provider.user != null && provider.user.data != null) {
              if(int.parse(provider.user.data.first_gift)!=1){



                return congratulation_class(provider);
              }
              else {
                return AnimatedBuilder(
                    animation: widget.animationController,
                    child: Container(
                      color: RoyalBoardColors.backgroundColor,
                      child: Column(
                        children: <Widget>[
                          _ImageAndTextWidget(userProvider: provider),
                          _dividerWidget,
                          _EditAndHistoryRowWidget(userProvider: provider),
                          _dividerWidget,
                          Text('المعرف لحسابك هو : ${provider.user.data.ref_id}'),
                          Container(
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                color: Colors.blue,


                                child: Text('نسخ',style: TextStyle(color: Colors.white),),
                                onPressed: (){
                                  FlutterClipboard.copy('${provider.user.data.ref_id}');
                                  Fluttertoast.showToast(
                                      msg:
                                      'تم النسخ بنجاح',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:Colors.green,
                                      textColor:Colors.white);
                                },
                              ),
                            ),
                          ),
                          _dividerWidget,
                          _FavAndSettingWidget(userProvider: provider),
                          Friends_Core_Widget(userProvider: provider,),
                         provider.user.data.is_gift_given!=null&&provider.user.data.is_gift_given!=''&&int.parse(provider.user.data.is_gift_given)==0?whoiy(prov: provider):Container(),
                          _dividerWidget,
                          _JoinDateWidget(userProvider: provider),

                          _dividerWidget,
                        ],
                      ),
                    ),
                    builder: (BuildContext context, Widget child) {
                      return FadeTransition(
                          opacity: widget.animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child,
                          ));
                    });
              }
            } else {
              return Container();
            }
          })),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__join_on'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(
                  userProvider.user.data.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(userProvider.user.data.addedDate),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            )));
  }
}

class Friends_Core_Widget extends StatelessWidget {
  const Friends_Core_Widget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx)=>Friends_List(userProvider.psValueHolder.loginUserId)
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    'قائمة الاصدقاء',
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx)=>Send_FRequest(userProvider.psValueHolder.loginUserId)
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.send,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                  'ارسال طلب صداقة',
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  const _FavAndSettingWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteProductList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.more,
                    arguments: userProvider.user.data.userName);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__more'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget({@required this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space48,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 0,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 1,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 2,
        )
      ],
    );
  }
}

class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key key,
    @required this.userProvider,
    @required this.checkText,
  }) : super(key: key);

  final UserProvider userProvider;
  final int checkText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () async {
              if (checkText == 0) {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData != null && returnData is bool) {
                  userProvider.getUser(userProvider.psValueHolder.loginUserId);
                }
              } else if (checkText == 1) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.historyList,
                );
              } else if (checkText == 2) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.transactionList,
                );
              }
            },
            child: checkText == 0
                ? Text(
                    Utils.getString(context, 'profile__edit'),
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : checkText == 1
                    ? Text(
                        Utils.getString(context, 'profile__history'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Utils.getString(context, 'profile__transaction'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold),
                      )));
  }
}
class whoiy extends StatefulWidget {
  UserProvider prov;
  whoiy({this.prov});
  @override
  _whoiyState createState() => _whoiyState(prov: prov);
}

class _whoiyState extends State<whoiy> {
  TextEditingController ref_id=new TextEditingController();
  bool isload;
  UserProvider prov;
  _whoiyState({this.prov});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -6,

      child:
    new TextField(
      controller: ref_id,
      decoration: InputDecoration(
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(35.0),
            borderSide:  BorderSide(color: Colors.indigoAccent ),

          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(35.0),
            borderSide:  BorderSide(color: Colors.indigoAccent ),

          ),
          suffixIcon:isload==true?Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ): InkWell(child: Icon(Icons.send),
          onTap: ()async{
            setState(() {
              isload=true;
            });

            var mar = {
              'referal_id':ref_id.text ,
              'user_id':prov.user.data.userId

            };
            String ur = '${RoyalBoardConfig
                .RoyalBoardAppUrl}rest/users/ref_id_gift/api_key/${RoyalBoardConfig
                .RoyalBoardServerLanucher}';




            var response= await http.post(ur,body: mar);
            var message=jsonDecode(response.body)['message'];
            if(message=='they_same'){
              Fluttertoast.showToast(
                  msg:
                      'لقد قمت بادخال معرفك وهذا لايجوز يجب ادخال معرف  من دعاك',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor:Colors.red,
                  textColor:Colors.white);
            }
            else if(message=='no_rights'){
              Fluttertoast.showToast(
                  msg:
                  'لقد قمت بادخال المعرف سابقاً',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor:Colors.red,
                  textColor:Colors.white);

            }

            else if(message=='success_updated'){
              Fluttertoast.showToast(
                  msg:
                  'لقد تم تسجيل البيانات بنجاح   ',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor:Colors.green,
                  textColor:Colors.white);

            }
            else if(message=='not_updated'){
              Fluttertoast.showToast(
                  msg:
                  'لقد حصل خطأ في الاتصال يرجى المحاولة لاحقاً',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                  backgroundColor:Colors.red,
                  textColor:Colors.white);

            }
            else if(message=='notexist')
              {


                Fluttertoast.showToast(
                    msg:
                    'لايوجد هكذا معرف',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor:Colors.red,
                    textColor:Colors.white);



              }


            setState(() {
              isload=false;
            });
          },
          ),
          filled: true,
          hintStyle: Utils.isLightMode(context)? new TextStyle(color: Colors.grey[400]):new TextStyle(color: Colors.black),
          hintText: "اكتب معرف من قام بدعوتك",
          fillColor: Colors.white70),
    )
      ,);
  }
}

class _OrderAndSeeAllWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutePaths.transactionList,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(Utils.getString(context, 'profile__order'),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
            InkWell(
              child: Text(
                Utils.getString(context, 'profile__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: RoyalBoardColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider.user.data.userProfilePhoto,
      // width: PsDimens.space80,
      // height: PsDimens.space80,
      boxfit: BoxFit.cover,
      onTap: () {},
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(top: PsDimens.space16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: PsDimens.space16),
              Container(
                  width: PsDimens.space80,
                  height: PsDimens.space80,
                  child: _imageWidget),
              const SizedBox(width: PsDimens.space16),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  userProvider.user.data.userName,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userPhone != ''
                      ? userProvider.user.data.userPhone
                      : Utils.getString(context, 'profile__phone_no'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: RoyalBoardColors.textPrimaryLightColor),
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userAboutMe != ''
                      ? userProvider.user.data.userAboutMe
                      : Utils.getString(context, 'profile__about_me'),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: RoyalBoardColors.textPrimaryLightColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                _spacingWidget,
                Text('يرجى تحديث ملفك الشخصي لضمان حسابك')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class congratulation_class extends StatefulWidget {
  UserProvider provider;

  congratulation_class(this.provider);

  @override
  _congratulation_classState createState() => _congratulation_classState();
}

class _congratulation_classState extends State<congratulation_class> {
  bool isloading=false;
  @override
   initState() {
    secondstogo();

    super.initState();
  }


  secondstogo()async{
    if(isloading==false) {
      await Future.delayed(Duration(seconds: 8)).then((value) {
        congratulation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isloading = true;
          });

          await congratulation();

          setState(() {
            isloading = false;
          });
        },
        child: isloading ? Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('جاري تجهيز الهدية لك'),
                SizedBox(height: 10,),

                CircularProgressIndicator(),
              ],
            ),
          ),
        ) : Container(
          height: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/congratulation.gif'),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child:
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'اضغط على تهانينا  اذا اردت الغاء هذا الاشعار',
                              style: TextStyle(color: Colors.blue),))))
              ],

            ),
          ),
        ),
      ),
    );
  }

  congratulation() async {
    var mar = {
      'user_id': widget.provider.psValueHolder.loginUserId,
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/update_gift/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';


    var response = await http.post(ur, body: mar);
    var message = jsonDecode(response.body)['message'];

    if (message == 'gift_true') {
      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (ctx) => DashboardView()), (route) => false);
    }
  }

}
