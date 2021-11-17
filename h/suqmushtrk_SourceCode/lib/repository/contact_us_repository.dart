import 'dart:async';
import 'package:RoyalBoard_Common_sooq/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';

import 'Common/ps_repository.dart';

class ContactUsRepository extends PsRepository {
  ContactUsRepository({
    @required RoyalBoardApiService RoyalBoardApiService,
  }) {
    _RoyalBoardApiService = RoyalBoardApiService;
  }
  String primaryKey = 'id';
  RoyalBoardApiService _RoyalBoardApiService;

  Future<PsResource<ApiStatus>> postContactUs(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _RoyalBoardApiService.postContactUs(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
