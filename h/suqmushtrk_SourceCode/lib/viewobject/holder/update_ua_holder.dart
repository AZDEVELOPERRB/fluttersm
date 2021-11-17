import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class Updateuaholder
    extends PsHolder<Updateuaholder> {
  Updateuaholder(
      {@required this.userId, @required this.userPassword});

  final String userId;
  final String userPassword;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['ua'] = userPassword;

    return map;
  }

  @override
  Updateuaholder fromMap(dynamic dynamicData) {
    return Updateuaholder(
      userId: dynamicData['user_id'],
      userPassword: dynamicData['user_password'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userPassword != '') {
      key += userPassword;
    }
    return key;
  }
}
