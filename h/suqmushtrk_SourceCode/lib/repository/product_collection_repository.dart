import 'dart:async';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/product_collection_header_dao.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';

class ProductCollectionRepository extends PsRepository {
  ProductCollectionRepository(
      {@required RoyalBoardApiService RoyalBoardApiService,
      @required ProductCollectionDao productCollectionDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _productCollectionDao = productCollectionDao;
  }

  RoyalBoardApiService _RoyalBoardApiService;
  ProductCollectionDao _productCollectionDao;
  final String _primaryKey = 'id';

  void sinkProductListStream(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      PsResource<List<ProductCollectionHeader>> dataList) {
    if (dataList != null) {
      productCollectionListStream.sink.add(dataList);
    }
  }

  void sinkProductStream(
      StreamController<PsResource<ProductCollectionHeader>>
          productCollectionStream,
      PsResource<ProductCollectionHeader> data) {
    if (data != null) {
      productCollectionStream.sink.add(data);
    }
  }

  Future<dynamic> insert(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.insert(_primaryKey, productCollectionHeader);
  }

  Future<dynamic> update(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.update(productCollectionHeader);
  }

  Future<dynamic> delete(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.delete(productCollectionHeader);
  }

  Future<dynamic> getProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _RoyalBoardApiService.getProductCollectionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _productCollectionDao.deleteAll();
        }
        await _productCollectionDao.insertAll(_primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _productCollectionDao.deleteAll();
        }
      }
      sinkProductListStream(
          productCollectionListStream, await _productCollectionDao.getAll());
    }
  }

  Future<dynamic> getNextPageProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _RoyalBoardApiService.getProductCollectionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _productCollectionDao
            .insertAll(_primaryKey, _resource.data)
            .then((dynamic data) async {
          sinkProductListStream(productCollectionListStream,
              await _productCollectionDao.getAll());
        });
      } else {
        sinkProductListStream(
            productCollectionListStream, await _productCollectionDao.getAll());
      }
    }
  }

  Future<dynamic> getProductCollectionListByShopId(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _RoyalBoardApiService.getProductCollectionListByShopId(
              shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _productCollectionDao.deleteAll();
        }
        await _productCollectionDao.insertAll(_primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _productCollectionDao.deleteAll();
        }
      }
      sinkProductListStream(
          productCollectionListStream, await _productCollectionDao.getAll());
    }
  }

  Future<dynamic> getNextPageProductCollectionListByShopId(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _RoyalBoardApiService.getProductCollectionListByShopId(
              shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _productCollectionDao
            .insertAll(_primaryKey, _resource.data)
            .then((dynamic data) async {
          sinkProductListStream(productCollectionListStream,
              await _productCollectionDao.getAll());
        });
      } else {
        sinkProductListStream(
            productCollectionListStream, await _productCollectionDao.getAll());
      }
    }
  }
}
