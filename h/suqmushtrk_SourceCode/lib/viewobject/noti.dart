import 'package:quiver/core.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_object.dart';
import 'default_photo.dart';

class Noti extends PsObject<Noti> {
  Noti(
      {this.id,
      this.description,
      this.product_id,
      this.product_name,
      this.for_user,
      this.is_buy,
      this.order_id,
      this.shop_id,
      this.message,
      this.addedDate,
      this.addedUserId,
      this.isRead,
      this.addedDateStr,
      this.defaultPhoto});

  String id;
  String description;
  String product_id;
  String product_name;
  String for_user;
  String is_buy;
  String order_id;
  String shop_id;
  String message;
  String addedDate;
  String addedUserId;
  String isRead;
  String addedDateStr;
  DefaultPhoto defaultPhoto;

  @override
  bool operator ==(dynamic other) => other is Noti && id == other.id;
  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Noti fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Noti(
          id: dynamicData['id'],
          description: dynamicData['description'],
          product_id: dynamicData['product_id'],
          product_name: dynamicData['product_name'],
          for_user: dynamicData['for_user'],
          is_buy: dynamicData['is_buy'],
          order_id: dynamicData['order_id'],
          shop_id: dynamicData['shop_id'],
          message: dynamicData['message'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          isRead: dynamicData['is_read'],
          addedDateStr: dynamicData['added_date_str'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Noti object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['message'] = object.message;
      data['description'] = object.description;
      data['product_id'] = object.product_id;
      data['product_name'] = object.product_name;
      data['for_user'] = object.for_user;
      data['is_buy'] = object.is_buy;
      data['order_id'] = object.order_id;
      data['shop_id'] = object.shop_id;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['is_read'] = object.isRead;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Noti> fromMapList(List<dynamic> dynamicDataList) {
    final List<Noti> subCategoryList = <Noti>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Noti> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Noti data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
