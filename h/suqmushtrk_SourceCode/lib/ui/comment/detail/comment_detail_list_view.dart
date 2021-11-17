import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/provider/comment/comment_detail_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/comment_detail_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/base/ps_widget_with_appbar.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/warning_dialog_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_textfield_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/comment_detail.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/comment_header.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/comment_detail_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_detail_list_item_view.dart';

class CommentDetailListView extends StatefulWidget {
  const CommentDetailListView({
    Key key,
    @required this.commentHeader,
  }) : super(key: key);

  final CommentHeader commentHeader;
  @override
  _CommentDetailListViewState createState() => _CommentDetailListViewState();
}

class _CommentDetailListViewState extends State<CommentDetailListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  CommentDetailProvider _commentDetailProvider;
  CommentDetailRepository commentDetailRepo;
  PsValueHolder psValueHolder;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentDetailProvider.nextCommentDetailList(widget.commentHeader.id);
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

  bool controlProgressBar = false;

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

    commentDetailRepo = Provider.of<CommentDetailRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CommentDetailProvider>(
        appBarTitle:
            Utils.getString(context, 'comment_detail__app_bar_name') ?? '',
        initProvider: () {
          return CommentDetailProvider(
              repo: commentDetailRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (CommentDetailProvider provider) {
          provider.loadCommentDetailList(widget.commentHeader.id);
          _commentDetailProvider = provider;
        },
        builder: (BuildContext context, CommentDetailProvider provider,
            Widget child) {
          return Container(
            color: RoyalBoardColors.baseColor,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const PsAdMobBannerWidget(),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: PsDimens.space8),
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
                              commentHeader: widget.commentHeader)),
                    )
                  ],
                ),
                if (provider.commentDetailList.data != null &&
                    provider.commentDetailList != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: provider.commentDetailList.status ==
                              PsStatus.PROGRESS_LOADING
                          ? 1.0
                          : 0.0,
                      child: const LinearProgressIndicator(),
                    ),
                  )
                else
                  const PSProgressIndicator(PsStatus.SUCCESS)
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key key,
    @required this.provider,
    @required this.commentHeader,
  }) : super(key: key);

  final CommentDetailProvider provider;
  final CommentHeader commentHeader;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: PsDimens.space72,
      child: Container(
        decoration: BoxDecoration(
          color: RoyalBoardColors.backgroundColor,
          border: Border.all(color: RoyalBoardColors.mainLightColor),
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
                        context, 'comment_detail__comment_hint'),
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
                    border: Border.all(color: RoyalBoardColors.mainLightShadowColor),
                  ),
                  child: InkWell(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Icon(
                        Icons.send,
                        color: RoyalBoardColors.white,
                        size: PsDimens.space20,
                      ),
                    ),
                    onTap: () async {
                      if (commentController.text.isEmpty) {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningDialog(
                                message: Utils.getString(context,
                                    Utils.getString(context, 'comment__empty')),
                                onPressed: () {},
                              );
                            });
                      } else {
                        if (await Utils.checkInternetConnectivity()) {
                          Utils.navigateOnUserVerificationView(context,
                              () async {
                            final CommentDetailParameterHolder
                                commentHeaderParameterHolder =
                                CommentDetailParameterHolder(
                                    userId: widget
                                        .provider.psValueHolder.loginUserId,
                                    headerId: widget.commentHeader.id,
                                    detailComment: commentController.text,
                                    shopId:
                                        widget.provider.psValueHolder.shopId);

                            final PsResource<List<CommentDetail>> _apiStatus =
                                await widget.provider.postCommentDetail(
                                    commentHeaderParameterHolder.toMap());
                            if (_apiStatus.data != null) {
                              widget.provider.resetCommentDetailList(
                                  widget.commentHeader.id);
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
  }
}

class CommentListWidget extends StatefulWidget {
  const CommentListWidget({
    Key key,
    this.animationController,
    this.provider,
  }) : super(key: key);

  final AnimationController animationController;
  final CommentDetailProvider provider;
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
          final int count = widget.provider.commentDetailList.data.length;
          return CommetDetailListItemView(
            animationController: widget.animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            ),
            comment: widget.provider.commentDetailList.data[index],
            onTap: () {},
          );
        },
        childCount: widget.provider.commentDetailList.data.length,
      ),
    );
  }
}