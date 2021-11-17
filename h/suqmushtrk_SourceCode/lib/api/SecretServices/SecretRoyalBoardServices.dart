import 'package:http/http.dart' as http;
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
class RoyalBoardSercetServices{
 static post(String url,Map body)async{
    return await http.post(url,body: body).catchError((e){
      RoyalBoardConst.RoyalBoardToast("يوجد خطأ في الانترنت",false);
      return null;
    });
  }
}