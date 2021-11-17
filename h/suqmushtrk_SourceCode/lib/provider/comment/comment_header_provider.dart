import 'dart:async';
import 'package:RoyalBoard_Common_sooq/repository/comment_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/comment_header.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';

class CommentHeaderProvider extends PsProvider {
  CommentHeaderProvider(
      {@required CommentHeaderRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('CommentHeader Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    commentHeaderListStream =
        StreamController<PsResource<List<CommentHeader>>>.broadcast();
    subscription = commentHeaderListStream.stream
        .listen((PsResource<List<CommentHeader>> resource) {
      updateOffset(resource.data.length);

      _commentHeaderList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CommentHeaderRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<CommentHeader>> _commentHeader =
      PsResource<List<CommentHeader>>(PsStatus.NOACTION, '', null);
  PsResource<List<CommentHeader>> get user => _commentHeader;

  PsResource<List<CommentHeader>> _commentHeaderList =
      PsResource<List<CommentHeader>>(PsStatus.NOACTION, '', <CommentHeader>[]);

  PsResource<List<CommentHeader>> get commentHeaderList => _commentHeaderList;
  StreamSubscription<PsResource<List<CommentHeader>>> subscription;
  StreamController<PsResource<List<CommentHeader>>> commentHeaderListStream;
bool isLoading=false;
bool get IsLO=>isLoading;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('CommentHeader Provider Dispose: $hashCode');
    super.dispose();
  }
setisLoading(bool value){
  isLoading=value;
  notifyListeners();
}
  Future<dynamic> refreshCommentList(String productId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllCommentList(productId, commentHeaderListStream,
        isConnectedToInternet, limit, 0, PsStatus.PROGRESS_LOADING,
        isNeedDelete: false);
  }

  Future<dynamic> syncCommentByIdAndLoadCommentList(
      String commentId, String productId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.syncCommentByIdAndLoadCommentList(
        commentId,
        productId,
        commentHeaderListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadCommentList(String productId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllCommentList(productId, commentHeaderListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextCommentList(String productId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCommentList(productId, commentHeaderListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCommentList(String productId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllCommentList(productId, commentHeaderListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postCommentHeader(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _commentHeader = await _repo.postCommentHeader(commentHeaderListStream,
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _commentHeader;
  }
}
