import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/transaction/transaction_header_provider.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/transaction/item/transaction_list_item.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class point_user extends StatefulWidget {
  const point_user({
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

class _ProfilePageState extends State<point_user>
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
        _TransactionListViewWidget(
          scaffoldKey: widget.scaffoldKey,
          animationController: widget.animationController,
          userId: widget.userId,
        )
      ]);
    //));
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

    return SliverToBoxAdapter(
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
  double hassan;
  String yaya;

  iniState()async{

    super.initState();


  }
  List<String> Slist=[
    'assets/images/gg.jpg',
    'assets/images/aa.jpg',
    'assets/images/bb.jpg',
    'assets/images/cc.jpg',
  ];
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
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: Container(
                    color: RoyalBoardColors.backgroundColor,
                    child: Column(
                      children: <Widget>[

                        _ImageAndTextWidget(userProvider: provider),
                        _dividerWidget,
                        // _EditAndHistoryRowWidget(userProvider: provider),
                        rolletwallet(userProvider: provider),
                        _dividerWidget,
                        // _FavAndSettingWidget(userProvider: provider),
                        // walletclass(userProvider: provider),

                        // FloatingActionButton(
                     //     child:Icon(Icons.add),onPressed: ()async{
                     //
                     // SharedPreferences prefs = await SharedPreferences.getInstance();
                     //
                     // // prefs.setString('mustafa', '${DateTime.now()}');
                     // setState(() {
                     //
                     // DateTime dateTime = DateTime.parse(prefs.getString('mustafa'));
                     //
                     // DateTime n=DateTime.now();
                     // DateTime fiftyDaysAgo = n.subtract(const Duration(minutes: 15));
                     // final difference = dateTime.difference(n).inMinutes;
                     // if(fiftyDaysAgo.isAfter(dateTime)) {
                     // yaya = ' لقد انتهى الوقت';
                     // }
                     // else{
                     // yaya='  لقد مضت فقط $difference دقيقة يجب انت تنتظر  ';
                     // }
                     // });
                     //
                     // }),

                        _dividerWidget,

                        _dividerWidget,
                        SizedBox(height: 2,),

                        CarouselSlider(options: CarouselOptions(
                          scrollDirection: Axis.vertical,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          height: 450,
                        ),
                        items: Slist.map((i){
                          return Builder(builder: (BuildContext context){
                            return Column(

                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(i))
                            ],
                            );

                          },);

                        }).toList()
                        ,)

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
    final Widget _imageWidget =
    PsNetworkCircleImageForUser(
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
      height: PsDimens.space100,
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
                Text('رصيد نقاطك الشخصية'
                ),
                _spacingWidget,
                Text(
                  '${userProvider.user.data.ua} نقطة',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,

              ],
            ),
          ),
        ],
      ),
    );
  }
}
class walletclass extends StatelessWidget {
  const walletclass({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {

    final Widget _imageWidget = ClipRRect(

        borderRadius: BorderRadius.circular(50),
        child: Image.asset('assets/images/walleta.png'));
    // PsNetworkCircleImageForUser(
    //   photoKey: 'assets/images/walleta.png',
    //   imagePath: userProvider.user.data.userProfilePhoto,
    //   // width: PsDimens.space80,
    //   // height: PsDimens.space80,
    //   boxfit: BoxFit.cover,
    //   onTap: () {},
    // );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      height: PsDimens.space100,
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
                 'رصيد لعبة فرم الاسعار',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,
                Text(
                  '  ',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,

              ],
            ),
          ),
        ],
      ),
    );
  }
}
class rolletwallet extends StatelessWidget {
  const rolletwallet({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {

    final Widget _imageWidget = ClipRRect(

        borderRadius: BorderRadius.circular(50),
        child: Image.asset('assets/images/walleta.png'));
    // PsNetworkCircleImageForUser(
    //   photoKey: 'assets/images/walleta.png',
    //   imagePath: userProvider.user.data.userProfilePhoto,
    //   // width: PsDimens.space80,
    //   // height: PsDimens.space80,
    //   boxfit: BoxFit.cover,
    //   onTap: () {},
    // );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      height: PsDimens.space100,
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
                  'عدد الجواهر الزرقاء لديك ',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),

                _spacingWidget,
                Text(
                  ' ${userProvider.user.data.rolletua} جوهرة',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,

              ],
            ),
          ),
        ],
      ),
    );
  }
}
