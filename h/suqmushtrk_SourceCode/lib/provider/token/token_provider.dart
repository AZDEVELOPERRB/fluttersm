import 'dart:async';
import 'package:RoyalBoard_Common_sooq/repository/token_repository.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/api_status.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/provider/common/ps_provider.dart';
import 'package:flutter/cupertino.dart';

class TokenProvider extends PsProvider {
  TokenProvider({@required TokenRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Token Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  TokenRepository _repo;
  @override
  void dispose() {
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final PsResource<ApiStatus> _resource =
        await _repo.getToken(isConnectedToInternet, PsStatus.SUCCESS);
    return _resource;
  }
}
