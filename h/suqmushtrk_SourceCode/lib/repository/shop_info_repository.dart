import 'dart:async';

import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/shop_info_dao.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:sembast/sembast.dart';
import 'Common/ps_repository.dart';

class ShopInfoRepository extends PsRepository {
  ShopInfoRepository(
      {@required RoyalBoardApiService RoyalBoardApiService,
      @required ShopInfoDao shopInfoDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _shopInfoDao = shopInfoDao;
  }

  String primaryKey = 'id';
  RoyalBoardApiService _RoyalBoardApiService;
  ShopInfoDao _shopInfoDao;

  Future<dynamic> insert(ShopInfo shopInfo) async {
    return _shopInfoDao.insert(primaryKey, shopInfo);
  }

  Future<dynamic> update(ShopInfo shopInfo) async {
    return _shopInfoDao.update(shopInfo);
  }

  Future<dynamic> delete(ShopInfo shopInfo) async {
    return _shopInfoDao.delete(shopInfo);
  }

  Future<dynamic> getShopInfo(
      StreamController<PsResource<ShopInfo>> shopInfoListStream,
      String shopId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('id', shopId));
    shopInfoListStream.sink
        .add(await _shopInfoDao.getOne(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<ShopInfo> _resource =
          await _RoyalBoardApiService.getShopInfo(shopId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopInfoDao.deleteAll();
        await _shopInfoDao.insert(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _shopInfoDao.deleteAll();
        }
      }
      shopInfoListStream.sink.add(await _shopInfoDao.getOne());
    }
  }
}
