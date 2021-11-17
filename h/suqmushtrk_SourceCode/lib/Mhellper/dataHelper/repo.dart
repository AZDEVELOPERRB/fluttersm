import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_url.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_api_reponse.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:async/async.dart';
import 'package:RoyalBoard_Common_sooq/api/SecretServices/SecretRoyalBoardServices.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'dart:async';
import 'package:hive/hive.dart';
class Markets_repo  {
  var RoyalBoard;

  Create_new_Shop(File imageFile ,String platformName,var data )async{
    var res=await http.post(url,body: data).catchError((e){
      return RoyalBoard;
    });


    if(res==null){return {'status':'NOINTERNET'};}
    var data_json= json.decode(res.body);

    if(data_json['message']['every']=='excelent'){
      Map shop={
        'point':'success',
        'shop_data':data_json['message']['all_data'],
        'user_id':data['user_id']
      };
      await save_data_all_model(shop, Tajer_file_checker);

   await save_data_model(data_json['message']['all_data']);


    var photo= await Upload_tajer_image(imageFile,platformName,data['user_id'],data_json['message']['all_data']['id'],1);
        return {'status':'success'};


    }
    






  }
Edit_Shop( String platformName,var data )async{
    var res=await http.post(url,body: data);
    var data_json= json.decode(res.body);

    if(data_json['message']['every']=='excelent'){

      await save_data_model(data_json['message']['all_data']);





      return {'status':'success'};


    }
    else{
      return {'status':'success'};
    }







  }
  save_data_all_model(var datas,String filename_sys)async{
    var data=json.encode(datas);

    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+filename_sys);
    await file.writeAsStringSync(data,
        flush: true,encoding: utf8,mode: FileMode.write);
    return true;

  }
  getCategories(String shop_id)async{
var response=await http.post(Categories_list_url,body: {
  'shop_id':shop_id
});
var res =json.decode(response.body);
save_data_all_model(res['message']['data'], Categories_file);
save_data_all_model(res['message']['categories'], Files_Names.SubCategories_data);

return res['message']['data'];

  }
  getSubCategories(String shop_id)async{
    var response=await http.post(Categories_list_url,body: {
      "shop_id":shop_id
    });
    var res =json.decode(response.body);
    save_data_all_model(res['message']['categories'], Files_Names.SubCategories_data);

    return res['message']['categories'];

  }
  save_data_model(var datas)async{
    var data=json.encode(datas);

    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+Tajer_file_name);
    await file.writeAsStringSync(data,
        flush: true,encoding: utf8,mode: FileMode.write);
    return true;

  }
  save_data_checker_model(var datas)async{
    var data=json.encode(datas);

    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+Tajer_file_name);
    await file.writeAsStringSync(data,
        flush: true,encoding: utf8,mode: FileMode.write);
    return true;

  }

  getVendor_first_Screen()async{
    var response=await http.post(vendor_screen_info_url,body: {

    });
    var res =json.decode(response.body);
  if(res['message']['msg']=='success'){

    await save_data_all_model(res['message']['data'],vendor_Screen_info_file );
  }

  }
  ch_SVI()async{
    var data=await read_all_data_model(vendor_Screen_info_file);
    print('dfsghljdsgkldsjg${data}');
    if(data=='false'){
      return 'false';

    }
    else{
      return data;
    }
  }
  update_vendor_informations(String user_id)async{
    var response=await http.post(update_vendor_info,body: {
      'uid':user_id
    });
    var res =json.decode(response.body);
    await save_data_model(res['message']['data']);
 return res['message']['data'];
  }
  read_data_model()async{



    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+Tajer_file_name);
    if(file.existsSync()){
     var jsonencod= file.readAsStringSync();
     var json_decode=json.decode(jsonencod);
     return json_decode;
    }
    return {'nono':'nono'};
  }
  get_shop_image(String shop_id)async{
var response=await http.post(shop_image,body: {'shop_id':shop_id});
var res=json.decode(response.body);
await save_data_model_image(res['message']['data'],Image_file);
print('afasafasffasfs${res}');

return res;
  }
  save_data_model_image(var datas,String Image_fil)async{
    var data=json.encode(datas);

    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+Image_fil);
    await file.writeAsStringSync(data,
        flush: true,encoding: utf8,mode: FileMode.write);
    return true;

  }

  read_all_data_model(String filename)async{



    var dir=await getTemporaryDirectory();
    File file=File(dir.path+"/"+filename);

    if(file.existsSync()){
      var jsonencod= file.readAsStringSync();

      var json_decode=json.decode(jsonencod);
      print('ghjdhsdfghdfsgh${json_decode}');


      return json_decode;
    }
    return'false';
  }
Create_product_now(String shop_id,String platform,var d)async{
int index=0;

    var resourse=await http.post(Create_product_url,body: d);
    var res=json.decode(resourse.body);

    var data= res['message'];
    print('gsdgasfgasfas${res}');
     return data;
    // if(data['msg']=='success'){
    //   for(var pic in pics){
    //
    //
    //     var a =await Upload_products_image(pic,platform,'product','${data['data']['id']}',int.parse(d['is_new']),index);
    //     index++;
    //
    //     if(a['index']==pics.length){
    //       return {
    //         'msg':'success'
    //       } ;
    //     }
    //
    //   }
    //
    //   // return {
    //   //   'msg':'success'
    //   // } ;
    // }

}
check_shop_exist(String user_id)async{
print('fdhgsdgsdg${urlt_of_checker}');
var res=await http.post(urlt_of_checker,body: {"user_id":user_id});
var jd=json.decode(res.body);
print('gdsgasgfasfas${jd}');
if(jd['message']['point']=='success'){
 await save_data_model(jd['message']['shop_data']);
 await save_data_all_model(jd['message'], Tajer_file_checker);


}
else if(jd['message']['point']=='deleted'){
  await save_data_model(jd['message']);

}
return jd['message'];
}

getproducts_listlimit(String shop_id,)async{
    var bod={
      'shop_id':shop_id,
      'limit':'10'
    };

    var responses=await http.post(product_list_limitted_url,body: bod);



     var res=json.decode(responses.body);
    print('fasfasfasfas${res}');

    await save_data_all_model(res['message']['data'],Product_list_limitted_file);
  return res['message']['data'];



}
Dollar_Price(String shop_id)async{
    var response=await  http.post(dollar_url,body: {'shop_id':shop_id}) ;
    var res=json.decode(response.body);
    save_data_all_model(res,Files_Names.dollarPrice);
   return res;

}
  check_permission_for_shop(String user_id)async{

    Response res=await RoyalBoardSercetServices.post(urlt_of_checker,{"user_id":user_id});
    if(res==null){

      return RoyalBoard;
    }
    var jd=json.decode(res.body);

    print('hdfhgsdhgsdh${user_id}');
    print('gdsgasgfasfas${jd}');
    if(jd['message']['point']=='success'){
      await save_data_model(jd['message']['shop_data']);
      await save_data_all_model(jd['message'],Tajer_file_checker);


    }
    else if(jd['message']['point']=='deleted'){
      await save_data_model(jd['message']);

    }
    return jd;
  }

  Upload_tajer_image(File imageFile ,String platformName,String userId,String img_parent,int is_new)async{
    final Client client = http.Client();
    try {
      final ByteStream stream =
      http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse(urli);

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      request.fields['user_id'] = userId;
      request.fields['img_parent'] = img_parent;
      request.fields['is_new'] = '${is_new}';
      request.fields['platform_name'] = platformName;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
       var resp=json.decode(value);
       print('sdfghklsjgasdgfakffafaslsdjglk$resp');


       if(resp['message']['data']=='uploaded'){

            save_data_model_image(resp['message']['img'],Image_file);



         complete=true;

       return {'status':'success'};
       }
       else{
         return {'status':'broken'};
       }
      });

    } finally {
    client.close();
    }
  }
//product images




  Upload_products_image(var imageFile ,String platformName,String img_type,String img_parent,int is_new,int index)async{
    final Client client = http.Client();
    try {


      final Uri uri = Uri.parse(product_create_image_url);

      final MultipartRequest request = http.MultipartRequest('POST', uri);


      request.fields['img_parent'] = img_parent;
      request.fields['is_new'] = '${is_new}';
      request.fields['platform_name'] = platformName;
      request.fields['img_type'] = img_type;
      request.fields['index'] = '${index}';
      request.fields['is_default'] = '${index}';



        ByteStream stream =
        http.ByteStream(Stream.castFrom(imageFile.openRead()));
        int length = await imageFile.length();
        MultipartFile multipartFile = http.MultipartFile(
            'file', stream, length,
            filename: basename(imageFile.path));
        request.files.add(multipartFile);


      final StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        var resp=json.decode(value);
        print('fjhsfdgsdgsdggasgassd${resp}');
        if(resp['message']['data']=='uploaded'){
          complete=true;

          return {'status':'success',};
        }
        else{
          return {'status':'broken'};
        }
      });
      await complete==true;
return {'status':'success','index':index};
    } finally {
      client.close();
    }
  }



  ////product images end




  String Tajer_file_name=Files_Names.Market_info;
  String Tajer_file_checker=Files_Names.Market_info_checker;
  String Tajer_file_key=Files_Names.Market_info_checker_key;
  String Product_list_limitted_file=Files_Names.products_list_limitted;
  String Market_info_file=Files_Names.Market_ingo;
  String url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Create_Shop_url;
  String urli=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Create_Shop_Image_url;
  String product_create_image_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Insert_new_product_images_url;
  String urlt_of_checker=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.shop_exist;
  String shop_image=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.shop_image_getter;
  String product_list_limitted_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Shop_products_list_limitted;
  String dollar_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.dollar_and_pro;
  String Categories_list_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.categories_list_url;
  String update_vendor_info=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.update_vendor_info;
  String vendor_screen_info_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getVendorFirstScreen;
  String Create_product_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Create_product__now;
  String Image_file=Files_Names.Market_ingo;
  String vendor_Screen_info_file=Files_Names.Screen_vendor_info;
  String Categories_file=Files_Names.Categories_data;

  bool complete=false;
}