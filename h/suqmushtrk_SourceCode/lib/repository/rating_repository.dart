import 'dart:async';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/rating_dao.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/rating.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:sembast/sembast.dart';
import 'Common/ps_repository.dart';

class RatingRepository extends PsRepository {
  RatingRepository(
      {@required RoyalBoardApiService RoyalBoardApiService, @required RatingDao ratingDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _ratingDao = ratingDao;
  }

  String primaryKey = 'id';
  RoyalBoardApiService _RoyalBoardApiService;
  RatingDao _ratingDao;

  Future<dynamic> insert(Rating rating) async {
    return _ratingDao.insert(primaryKey, rating);
  }

  Future<dynamic> update(Rating rating) async {
    return _ratingDao.update(rating);
  }

  Future<dynamic> delete(Rating rating) async {
    return _ratingDao.delete(rating);
  }

  Future<dynamic> getAllRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      String productId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('product_id', productId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _RoyalBoardApiService.getRatingList(productId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _ratingDao.deleteWithFinder(finder);
        }
        await _ratingDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _ratingDao.deleteWithFinder(finder);
        }
      }
      ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      String productId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('product_id', productId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _RoyalBoardApiService.getRatingList(productId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _ratingDao.insertAll(primaryKey, _resource.data);
      }
      ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
    }
  }

  Future<PsResource<Rating>> postRating(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      {bool isLoadFromServer = true}) async {
    final PsResource<Rating> _resource =
        await _RoyalBoardApiService.postRating(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      ratingListStream.sink
          .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
      return _resource;
    } else {
      final Completer<PsResource<Rating>> completer =
          Completer<PsResource<Rating>>();
      completer.complete(_resource);
      ratingListStream.sink
          .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
      return completer.future;
    }
  }
}