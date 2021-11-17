import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/comment/comment_header_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/comment_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/ps_widget_with_appbar.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_textfield_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/comment_header.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/comment_header_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item/comment_list_item.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  _CommentListViewState createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  CommentHeaderRepository commentHeaderRepo;
  PsValueHolder psValueHolder;
  CommentHeaderProvider _commentHeaderProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentHeaderProvider.nextCommentList(widget.product.id);
      }
    });
    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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

    commentHeaderRepo = Provider.of<CommentHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CommentHeaderProvider>(
        appBarTitle: Utils.getString(context, 'comment_list__title') ?? '',
        initProvider: () {
          return CommentHeaderProvider(
              repo: commentHeaderRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (CommentHeaderProvider provider) {
          provider.loadCommentList(widget.product.id);
          _commentHeaderProvider = provider;
        },
        builder: (BuildContext context, CommentHeaderProvider provider,
            Widget child) {
          if (_commentHeaderProvider.commentHeaderList != null &&
              _commentHeaderProvider.commentHeaderList.data != null) {
            return Container(
              color: RoyalBoardColors.baseColor,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const PsAdMobBannerWidget(),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(bottom: PsDimens.space8),
                          child: CustomScrollView(
                              controller: _scrollController,
                              reverse: true,
                              slivers: <Widget>[
                                CommentListWidget(
                                    animationController: animationController,
                                    provider: provider),
                              ]),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              width: double.infinity,
                              child: EditTextAndButtonWidget(
                                provider: provider,
                                product: widget.product,
                              ))),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: provider.commentHeaderList.status ==
                              PsStatus.PROGRESS_LOADING
                          ? 1.0
                          : 0.0,
                      child: const LinearProgressIndicator(),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key key,
    @required this.provider,
    @required this.product,
  }) : super(key: key);

  final CommentHeaderProvider provider;
  final Product product;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  bool isLoading=false;
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.provider.commentHeaderList != null &&
        widget.provider.commentHeaderList.data != null) {
      return SizedBox(
        width: double.infinity,
        height: PsDimens.space72,
        child: Container(
          decoration: BoxDecoration(
            color: RoyalBoardColors.backgroundColor,
            border: Border.all(color: RoyalBoardColors.mainLightShadowColor),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PsDimens.space12),
                topRight: Radius.circular(PsDimens.space12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: RoyalBoardColors.mainShadowColor,
                blurRadius: 4.0, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
                offset: const Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space1),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: PsDimens.space4,
                ),
                Expanded(
                    flex: 6,
                    child: PsTextFieldWidget(
                      hintText: Utils.getString(
                          context, 'comment_list__comment_hint'),
                      textEditingController: commentController,
                      showTitle: false,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: PsDimens.space44,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      color: RoyalBoardColors.mainColor,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(color: RoyalBoardColors.mainShadowColor),
                    ),
                    child: widget.provider.IsLO==true?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ) :InkWell(
                      child:Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Icon(
                          Icons.send,
                          color: RoyalBoardColors.white,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () async {
                        widget.provider.setisLoading(true);

                        if (commentController.text.isEmpty) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context,
                                      Utils.getString(
                                          context, 'comment__empty')),
                                  onPressed: () {},
                                );
                              });
                        } else {
                          if (await Utils.checkInternetConnectivity()) {
                            Utils.navigateOnUserVerificationView(context,
                                () async {
                              final CommentHeaderParameterHolder
                                  commentHeaderParameterHolder =
                                  CommentHeaderParameterHolder(
                                      userId: widget
                                          .provider.psValueHolder.loginUserId,
                                      productId: widget.product.id,
                                      headerComment: commentController.text,
                                      shopId: widget.product.shop.id);

                              final PsResource<List<CommentHeader>> _apiStatus =
                                  await widget.provider.postCommentHeader(
                                      commentHeaderParameterHolder.toMap());
                              if (_apiStatus.data != null) {
                                widget.provider
                                    .resetCommentList(widget.product.id);
                                commentController.clear();
                              } else {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorDialog(
                                        message: Utils.getString(
                                            context,
                                            Utils.getString(
                                                context, _apiStatus.message)),
                                      );
                                    });
                              }
                            });
                          } else {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorDialog(
                                    message: Utils.getString(
                                        context, 'error_dialog__no_internet'),
                                  );
                                });
                          }
                        }
                        widget.provider.setisLoading(false);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: PsDimens.space4,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  Widget loading(String message){
    Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.all(PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: RoyalBoardColors.mainColor),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: PsDimens.space4,
                    ),
                    Icon(
                      Icons.warning,
                      color: RoyalBoardColors.white,
                    ),
                    const SizedBox(
                      width: PsDimens.space4,
                    ),
                    Text(Utils.getString(context, 'warning_dialog__warning'),
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: RoyalBoardColors.white)),
                  ],
                )),
            const SizedBox(
              height: PsDimens.space20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                  top: PsDimens.space8,
                  bottom: PsDimens.space8),
              child: Text(
                message,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            const SizedBox(
              height: PsDimens.space20,
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Theme.of(context).iconTheme.color,
            ),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: Text(
                Utils.getString(context, 'dialog__ok'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: RoyalBoardColors.mainColor),
              ),
            )
          ],
        ));
  }
}

class CommentListWidget extends StatefulWidget {
  const CommentListWidget({
    Key key,
    this.animationController,
    this.provider,
  }) : super(key: key);

  final AnimationController animationController;
  final CommentHeaderProvider provider;
  @override
  _CommentListWidgetState createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          widget.animationController.forward();
          final int count = widget.provider.commentHeaderList.data.length;
          return CommetListItem(
            animationController: widget.animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            ),
            comment: widget.provider.commentHeaderList.data[index],
            onTap: () async {
              final dynamic data = await Navigator.pushNamed(
                  context, RoutePaths.commentDetail,
                  arguments: widget.provider.commentHeaderList.data[index]);

              if (data != null) {
                await widget.provider.syncCommentByIdAndLoadCommentList(
                    widget.provider.commentHeaderList.data[index].id,
                    widget.provider.commentHeaderList.data[index].productId);
              }
            },
          );
        },
        childCount: widget.provider.commentHeaderList.data.length,
      ),
    );
  }
}
