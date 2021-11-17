import 'dart:async';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/blog_dao.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/blog.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class BlogRepository extends PsRepository {
  BlogRepository(
      {@required RoyalBoardApiService RoyalBoardApiService, @required BlogDao blogDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _blogDao = blogDao;
  }

  String primaryKey = 'id';
  RoyalBoardApiService _RoyalBoardApiService;
  BlogDao _blogDao;

  Future<dynamic> insert(Blog blog) async {
    return _blogDao.insert(primaryKey, blog);
  }

  Future<dynamic> update(Blog blog) async {
    return _blogDao.update(blog);
  }

  Future<dynamic> delete(Blog blog) async {
    return _blogDao.delete(blog);
  }

  Future<dynamic> getAllBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _RoyalBoardApiService.getBlogList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.deleteAll();
        await _blogDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _blogDao.deleteAll();
        }
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getNextPageBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _RoyalBoardApiService.getBlogList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, _resource.data);
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getAllBlogListByShopId(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    blogListStream.sink
        .add(await _blogDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _RoyalBoardApiService.getBlogListByShopId(shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.deleteWithFinder(finder);
        await _blogDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _blogDao.deleteWithFinder(finder);
        }
      }
      blogListStream.sink.add(await _blogDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageBlogListByShopId(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    blogListStream.sink
        .add(await _blogDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _RoyalBoardApiService.getBlogListByShopId(shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, _resource.data);
      }
      blogListStream.sink.add(await _blogDao.getAll(finder: finder));
    }
  }
}
