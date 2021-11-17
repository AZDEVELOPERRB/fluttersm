import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_holder.dart';
import 'package:flutter/cupertino.dart';

class GetNotiParameterHolder extends PsHolder<GetNotiParameterHolder> {
  GetNotiParameterHolder({@required this.userId, @required this.deviceToken});

  final String userId;
  final String deviceToken;
   String added_date;

  @override
  Map<dynamic, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    if(added_date!=null){
      map['added_date'] = added_date;
    }

    map['device_token'] = deviceToken;

    return map;
  }

  @override
  GetNotiParameterHolder fromMap(dynamic dynamicData) {
    return GetNotiParameterHolder(
      userId: dynamicData['user_id'],
      deviceToken: dynamicData['device_token'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }

    if (added_date != '') {
      key += added_date;
    }
    if (deviceToken != '') {
      key += deviceToken;
    }
    return key;
  }
}
