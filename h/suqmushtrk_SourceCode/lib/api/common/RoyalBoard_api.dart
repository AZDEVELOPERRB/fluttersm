import 'dart:convert';
import 'dart:io';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_api_reponse.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_object.dart';

abstract class RoyalBoardApi {
  PsResource<T> psObjectConvert<T>(dynamic dataList, T data) {
    return PsResource<T>(dataList.status, dataList.message, data);
  }

  Future<List<dynamic>> getList(String url) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get('${RoyalBoardConfig.RoyalBoardAppUrl}$url');

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != '') {
        // parse into List
        final List<dynamic> parsed = json.decode(response.body);

        return parsed;
      } else {
        throw Exception('Error in loading...');
      }
    } finally {
      client.close();
    }
  }


  Future<PsResource<R>> getServerCall<T extends PsObject<dynamic>, R>(
      T obj, String url) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get('${RoyalBoardConfig.RoyalBoardAppUrl}$url');


      final RoyalBoardApiResponse _RoyalBoardApiResponse = RoyalBoardApiResponse(response);
      if (_RoyalBoardApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, _RoyalBoardApiResponse.errorMessage, null);
      }
    } catch (e) {
      print(e.toString());
      return PsResource<R>(PsStatus.ERROR, e.toString(), null); //e.message ??
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postData<T extends PsObject<dynamic>, R>(
      T obj, String url, Map<dynamic, dynamic> jsonMap) async {
    final Client client = http.Client();
    try {
      final Response response = await client
          .post('${RoyalBoardConfig.RoyalBoardAppUrl}$url',
              headers: <String, String>{'content-type': 'application/json'},
              body: const JsonEncoder().convert(jsonMap))
          .catchError((dynamic e) {
        print('** Error Post Data');
        print(e.message);
        return PsResource<R>(PsStatus.ERROR, 'Connection Error!', null);
      });

      final RoyalBoardApiResponse _RoyalBoardApiResponse = RoyalBoardApiResponse(response);

      if (_RoyalBoardApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, _RoyalBoardApiResponse.errorMessage, null);
      }
    } catch (e) {
      print(e.toString());
      return PsResource<R>(PsStatus.ERROR, e.toString(), null); //e.message ??s
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postUploadImage<T extends PsObject<dynamic>, R>(T obj,
      String url, String userId, String platformName, File imageFile) async {
    final Client client = http.Client();
    try {
      final ByteStream stream =
          http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse('${RoyalBoardConfig.RoyalBoardAppUrl}$url');

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      request.fields['user_id'] = userId;
      request.fields['platform_name'] = platformName;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();

      final RoyalBoardApiResponse _RoyalBoardApiResponse =
          RoyalBoardApiResponse(await http.Response.fromStream(response));

      if (_RoyalBoardApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(_RoyalBoardApiResponse.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, _RoyalBoardApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }
}
