import 'dart:async';
import 'package:RoyalBoard_Common_sooq/repository/tansaction_detail_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/transaction_detail.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';

class TransactionDetailProvider extends PsProvider {
  TransactionDetailProvider(
      {@required TransactionDetailRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Transaction Detail Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionDetailListStream =
        StreamController<PsResource<List<TransactionDetail>>>.broadcast();
    subscription = transactionDetailListStream.stream
        .listen((PsResource<List<TransactionDetail>> resource) {
      updateOffset(resource.data.length);

      _transactionDetailList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionDetailRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<TransactionDetail>> _transactionDetailList =
      PsResource<List<TransactionDetail>>(
          PsStatus.NOACTION, '', <TransactionDetail>[]);

  PsResource<List<TransactionDetail>> get transactionDetailList =>
      _transactionDetailList;
  StreamSubscription<PsResource<List<TransactionDetail>>> subscription;
  StreamController<PsResource<List<TransactionDetail>>>
      transactionDetailListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transaction Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransactionDetailList(
      TransactionHeader transaction) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransactionDetailList(
      TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransactionDetailList(
          transactionDetailListStream,
          transaction,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransactionDetailList(TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
