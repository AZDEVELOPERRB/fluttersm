import 'dart:async';

import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:sembast/sembast.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:RoyalBoard_Common_sooq/db/sub_category_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/sub_category.dart';

class SubCategoryRepository extends PsRepository {
  SubCategoryRepository(
      {@required RoyalBoardApiService RoyalBoardApiService,
      @required SubCategoryDao subCategoryDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _subCategoryDao = subCategoryDao;
  }

  RoyalBoardApiService _RoyalBoardApiService;
  SubCategoryDao _subCategoryDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(SubCategory subCategory) async {
    return _subCategoryDao.insert(_primaryKey, subCategory);
  }

  Future<dynamic> update(SubCategory subCategory) async {
    return _subCategoryDao.update(subCategory);
  }

  Future<dynamic> delete(SubCategory subCategory) async {
    return _subCategoryDao.delete(subCategory);
  }

  Future<dynamic> getSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource =
        await _RoyalBoardApiService.getSubCategoryList(limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getAllSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true,String shopid}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

      final PsResource<List<SubCategory>> _resource
      =shopid=="noshopid"?
      await _RoyalBoardApiService.getAllSubCategoryList(categoryId):   await _RoyalBoardApiService.getAllSubCategoryList(categoryId,shopid: shopid);


    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageSubCategoryList(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource =
        await _RoyalBoardApiService.getSubCategoryList(limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      _subCategoryDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        subCategoryListStream.sink
            .add(await _subCategoryDao.getAll(finder: finder));
      });
    } else {
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }
}
