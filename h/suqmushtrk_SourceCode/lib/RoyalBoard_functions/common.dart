import 'package:flutter/material.dart';

///
/// ps_static static constants.dart
/// ----------------------------

///

import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:ntp/ntp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RoyalBoard_Common{
  voit_for_product(String uid,sent_id,pid)async{
    print('hsdghasdgasgas');

    var timenow=await NTP.now();
    DateTime _dtnet=DateTime.parse("${timenow}");
    var mar = {
      'user_id': uid,
      'sent_code': sent_id,
      'product_id':pid,
      'is_sent_id':"1",
      'now': '${_dtnet.subtract(Duration(hours: 24))}',
      'now_real':'${_dtnet}'
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/share_voit_apply/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';


    var response = await http.post(ur, body: mar);
    var message = jsonDecode(
        response.body)['message'];
    if(message=='they_same'){
      Fluttertoast.showToast(
          msg:
          'لايمكنك التصويت لنفسك',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(message=='time_over'){
      Fluttertoast.showToast(
          msg:
          'لقد انتهى وقت التصويت',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(message=='already_win'){
      Fluttertoast.showToast(
          msg:
          'المتسابق فاز بالفعل ولايحتاج لتصويت',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.pink,
          textColor:Colors.white);
    }
    else if(message=='success_voited'){

      Fluttertoast.showToast(
          msg:
          'لقد  تم التصويت بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.green,
          textColor:Colors.white);
    }
return true;
  }
}