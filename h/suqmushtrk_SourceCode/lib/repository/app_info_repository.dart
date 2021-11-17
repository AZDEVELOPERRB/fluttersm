import 'dart:async';

import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/ps_app_info.dart';

class AppInfoRepository extends PsRepository {
  AppInfoRepository({
    @required RoyalBoardApiService RoyalBoardApiService,
  }) {
    _RoyalBoardApiService = RoyalBoardApiService;
  }
  RoyalBoardApiService _RoyalBoardApiService;

  Future<PsResource<PSAppInfo>> postDeleteHistory(Map<dynamic, dynamic> jsonMap,
      {bool isLoadFromServer = true}) async {
    final PsResource<PSAppInfo> _resource =
        await _RoyalBoardApiService.postPsAppInfo(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      if (_resource.data.deleteObject.isNotEmpty) {}
      return _resource;
    } else {
      final Completer<PsResource<PSAppInfo>> completer =
          Completer<PsResource<PSAppInfo>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
