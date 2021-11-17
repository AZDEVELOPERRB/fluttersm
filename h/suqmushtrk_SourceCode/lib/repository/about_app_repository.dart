import 'dart:async';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/db/about_app_dao.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/about_app.dart';

import 'Common/ps_repository.dart';

class AboutAppRepository extends PsRepository {
  AboutAppRepository(
      {@required RoyalBoardApiService RoyalBoardApiService, @required AboutAppDao aboutUsDao}) {
    _RoyalBoardApiService = RoyalBoardApiService;
    _aboutUsDao = aboutUsDao;
  }

  String primaryKey = 'about_id';
  RoyalBoardApiService _RoyalBoardApiService;
  AboutAppDao _aboutUsDao;

  Future<dynamic> insert(AboutApp aboutUs) async {
    return _aboutUsDao.insert(primaryKey, aboutUs);
  }

  Future<dynamic> update(AboutApp aboutUs) async {
    return _aboutUsDao.update(aboutUs);
  }

  Future<dynamic> delete(AboutApp aboutUs) async {
    return _aboutUsDao.delete(aboutUs);
  }

  Future<dynamic> getAllAboutAppList(
      StreamController<PsResource<List<AboutApp>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutApp>> _resource =
          await _RoyalBoardApiService.getAboutAppDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.deleteAll();
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == RoyalBoardConst.ERROR_CODE_10001) {
          await _aboutUsDao.deleteAll();
        }
      }
      aboutUsListStream.sink.add(await _aboutUsDao.getAll());
    }
  }

  Future<dynamic> getNextPageAboutAppList(
      StreamController<PsResource<List<AboutApp>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutApp>> _resource =
          await _RoyalBoardApiService.getAboutAppDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
      }
      aboutUsListStream.sink.add(await _aboutUsDao.getAll());
    }
  }
}
