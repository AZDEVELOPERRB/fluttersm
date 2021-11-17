import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/provider/transaction/transaction_header_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/transaction/item/transaction_list_item.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView(
      {Key key, @required this.animationController, @required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _TransactionListViewState createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionHeaderProvider _transactionProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionProvider.nextTransactionList();
      }
    });

    super.initState();
  }

  TransactionHeaderRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && RoyalBoardConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && RoyalBoardConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    repo1 = Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return  WillPopScope(
      onWillPop: (){},
      child: ChangeNotifierProvider<TransactionHeaderProvider>(
        lazy: false,
        create: (BuildContext context) {
          final TransactionHeaderProvider provider = TransactionHeaderProvider(
              repo: repo1, psValueHolder: psValueHolder);
          provider.loadTransactionList(psValueHolder.loginUserId);
          _transactionProvider = provider;
          return _transactionProvider;
        },
        child: Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
            TransactionHeaderProvider provider, Widget child) {
          if (provider.transactionList.data != null &&
              provider.transactionList.data.isNotEmpty) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      RefreshIndicator(
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count =
                                        provider.transactionList.data.length;
                                    return TransactionListItem(
                                      scaffoldKey: widget.scaffoldKey,
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      transaction:
                                          provider.transactionList.data[index],
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.transactionDetail,
                                            arguments: provider
                                                .transactionList.data[index]);
                                      },
                                    );
                                  },
                                  childCount:
                                      provider.transactionList.data.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetTransactionList();
                        },
                      ),
                      PSProgressIndicator(provider.transactionList.status)
                    ],
                  ),
                )
              ],
            );
          } else {
            return Container(
              child: Center(child: Text('لايوجد اي طلب سابق'),),
            );
          }
        }),
      ),
    );
  }
}
