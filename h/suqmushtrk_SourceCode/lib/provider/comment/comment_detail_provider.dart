import 'dart:async';
import 'package:RoyalBoard_Common_sooq/repository/comment_detail_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/comment_detail.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';

class CommentDetailProvider extends PsProvider {
  CommentDetailProvider(
      {@required CommentDetailRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('CommentDetail Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    commentDetailListStream =
        StreamController<PsResource<List<CommentDetail>>>.broadcast();
    subscription = commentDetailListStream.stream
        .listen((PsResource<List<CommentDetail>> resource) {
      updateOffset(resource.data.length);

      _commentDetailList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CommentDetailRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<CommentDetail>> _commentDetail =
      PsResource<List<CommentDetail>>(PsStatus.NOACTION, '', null);
  PsResource<List<CommentDetail>> get user => _commentDetail;

  PsResource<List<CommentDetail>> _commentDetailList =
      PsResource<List<CommentDetail>>(PsStatus.NOACTION, '', <CommentDetail>[]);

  PsResource<List<CommentDetail>> get commentDetailList => _commentDetailList;
  StreamSubscription<PsResource<List<CommentDetail>>> subscription;
  StreamController<PsResource<List<CommentDetail>>> commentDetailListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('commentDetail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCommentDetailList(String headerId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllCommentDetailList(headerId, commentDetailListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextCommentDetailList(String headerId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCommentDetailList(
          headerId,
          commentDetailListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCommentDetailList(String headerId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllCommentDetailList(headerId, commentDetailListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postCommentDetail(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _commentDetail = await _repo.postCommentDetail(commentDetailListStream,
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _commentDetail;
  }
}
