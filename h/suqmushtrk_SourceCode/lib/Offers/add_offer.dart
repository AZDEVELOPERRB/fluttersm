import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/vendor_dashboard.dart';
import 'dart:io';
import 'dart:convert';
import 'package:numberpicker/numberpicker.dart';


class Add_New_Offer extends StatefulWidget {
  String shop_id;
  String user_id;

  Add_New_Offer(this.shop_id, this.user_id);

  @override
  sub_state createState() => sub_state();
}

class sub_state extends State<Add_New_Offer> {
  String Categories_file=Files_Names.Categories_data;
  final _formkey=GlobalKey<FormState>();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  TextEditingController _productName=new TextEditingController();
  TextEditingController _description=new TextEditingController();
  TextEditingController _second_price=new TextEditingController();
  TextEditingController _mainprice=new TextEditingController();
  TextEditingController _shareCount=new TextEditingController();
  TextEditingController _miniOrder=new TextEditingController();
  Markets_repo Market_helper=Markets_repo();
  String _selectedValue;
  String subcategoryid;
  bool subcatbool;
  var sc;
  Color yellow=Color(0xfff9a825);
  String value_name='';
  bool _iscreating=false;
  List<Asset> images = <Asset>[];
  int sharecount=1;
  List img_paths=[];
  int timeout_counter=0;
  Widget divider= SizedBox(height: 5,);

  @override

  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(


          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Column(
                children: [
                  Container(

                    width: size.width/3,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black87
                    ),

                    child: Center(child: Text('?????????? ????????????????',style: TextStyle(fontSize:19,color: Colors.white),)),

                  ),
                  SizedBox(height: 15,),

                  Container(
                    height: size.height/9,
                    width: size.width,
                    child:     Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "?????? ????????????",
                            labelStyle: TextStyle(color: Colors.blue)
                            ,border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                        ),
                        validator: (v){
                          if(v.isEmpty){
                            return "?????? ?????????? ??????????";
                          }

                        },
                        controller:_productName,
                        cursorColor: Colors.black,

                      ),
                    ),
                  ),
                  Container(
                    height: size.height/9,
                    width: size.width,
                    child:     Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "?????? ????????????",
                            labelStyle: TextStyle(color: Colors.blue)
                            ,border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                        ),
                        validator: (v){
                          if(v.isEmpty){
                            return "?????? ?????????? ??????????";
                          }

                        },
                        controller:_description,
                        cursorColor: Colors.black,

                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getcategorie(),
                    builder: (context,categories){
                      if(categories.hasData){
                        return   Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 20,left: 20),
                          child: DropdownButtonFormField(
                              hint: Text('???????? ?????????? ?????????????? ????????????' ,style: TextStyle(color: Colors.blue),),
                              items:
                              [
                                for (var name in categories.data)
                                  DropdownMenuItem(
                                    value: '${name['id']}',
                                    child: Text(
                                      name['name'],
                                    ),
                                  )
                              ],
                              value: _selectedValue,
                              onChanged: (newVal) async{
                                setState(() {
                                  _selectedValue = newVal;
                                  subcategoryid=null;
                                });
                                var subc=await getSubcategorie();

                                for (var d in subc){
                                  if(d['data']['id']==newVal){
                                    print('dfhjdfklhgjdsklgjfasfdslkgj${d['subcat']}');
                                    setState(() {
                                      sc=d['subcat'];
                                    });
                                  }
                                }
                              }),
                        );

                      }
                      else{
                        return Container();
                      }
                    },
                  ),  sc==null?Container():new Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 20,left: 20),
                    child: DropdownButtonFormField(
                        hint: Text('???????? ?????????? ?????????????? ????????????' ,style: TextStyle(color: Colors.blue),),
                        items:
                        [
                          for(var name in sc)
                            new DropdownMenuItem(
                              value: '${name['id']}',
                              child: Text(
                                '${name['name']}',
                              ),
                            )
                        ],
                        value: subcategoryid,
                        onChanged: (newVal) {

                          setState(() {
                            subcatbool=true;
                            subcategoryid = newVal;


                          });
                        }),
                  ),
                  img_paths.length==0?Container():Row(
                    children: [
                      for (var i in img_paths)
                        Container(
                          width: size.width/img_paths.length,
                          height: size.height/4,
                          child: Image.file(i),
                        )
                    ],
                  ),
                  Container(
                    height: 35,
                    child: Container(
                      child:     Padding(
                          padding: const EdgeInsets.all(3),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),

                            ),
                            color: images.length==0? Colors.teal:Colors.lightGreen,
                            child: images.length==0?Text('?????? ?????? ?????????? ????????????',style: TextStyle(color: Colors.white),):Text('???? ?????????? ??????????',style: TextStyle(color: Colors.white),),
                            onPressed: ()async{
                              if (await Utils.checkInternetConnectivity()) {
                                requestGalleryPermission().then((bool status) async {
                                  if (status) {
                                    await _PickImage();
                                  }
                                });
                              } else {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorDialog(
                                        message:
                                        Utils.getString(context, 'error_dialog__no_internet'),
                                      );
                                    });
                              }
                            },
                          )
                      ),
                    ),
                  ),
                  divider,
                  divider,
                  Row(
                    children: [
                      SizedBox(width: 12,),
                      Text(' ???????? ?????????? ?????????????? ???????????????? ???????????????????? 123 ')

                    ],
                  ),
                  divider,
                  Row(
                    children: [
                      Container(
                        height: size.height/14,

                        width: size.width/2-10,
                        child:     Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "?????????? ???????????? \$",
                                labelStyle: TextStyle(color: Colors.blue)
                                ,border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                            ),
                            keyboardType: TextInputType.number,

                            validator: (v){
                              if(v.isEmpty){
                                return "?????? ?????????? ??????????";
                              }

                            },
                            controller:_second_price
                            ,
                            cursorColor: Colors.black,

                          ),
                        ),
                      ),
                      Container(
                        height: size.height/14,
                        width: size.width/2-10,

                        child:     Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "?????? ?????????? ?????????????? \$",
                                labelStyle: TextStyle(color: Colors.blue)
                                ,border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                            ),
                            keyboardType: TextInputType.number,

                            validator: (v){
                              if(v.isEmpty){
                                return "?????? ?????????? ??????????";
                              }

                            },
                            controller:_mainprice,
                            cursorColor: Colors.black,

                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(



                      child:     Padding(
                        padding: const EdgeInsets.only(top:7,right: 12),
                        child: Row(
                          children: [
                            Text('?????? ?????????????? ???????????? ????????????????'),
                          ],
                        ),)),
                  Row(
                    children: [
                      // Container(
                      //   height: size.height/14,
                      //   width: size.width/2-10,
                      //   child:     Padding(
                      //     padding: const EdgeInsets.all(3.0),
                      //     child: TextFormField(
                      //       decoration: InputDecoration(
                      //           labelText: "?????? ???????? ???????? ?????? ????????????",
                      //           labelStyle: TextStyle(color: Colors.blue)
                      //           ,border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(25)
                      //       )
                      //       ),
                      //       keyboardType: TextInputType.number,
                      //
                      //       validator: (v){
                      //         if(v.isEmpty){
                      //           return "?????? ?????????? ??????????";
                      //         }
                      //
                      //       },
                      //       controller:_miniOrder
                      //       ,
                      //       cursorColor: Colors.black,
                      //
                      //     ),
                      //   ),
                      // ),
                      Container(



                        child:     Padding(
                            padding: const EdgeInsets.all(3.0),
                            child:Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: size.width/2-10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color:Colors.blue)
                                  ),
                                  child: NumberPicker.integer(initialValue: sharecount, minValue: 1,highlightSelectedValue : true,scrollDirection:Axis.horizontal, maxValue: 10,onChanged: (val){
                                    sharecount=val;
                                    _shareCount.text='${val}';
                                    setState(() {

                                    });

                                  }),
                                ),
                                SizedBox(width: 25,),
                                Text('?????? ??????????????????  ${sharecount}',style: TextStyle(color: Colors.red),)
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.pink,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('???????? ?????????? ???????????????? ???????????? ?????? ?????????????? ???????? ?????? ?????????? ???????????? ???????? ???????????? ',style: TextStyle(fontSize: 11,color: Colors.white),),
                        ),
                      ),

                      Column(
                        children: [
                          _iscreating==true?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                                // Text('???????? ?????? ?????????? ?????? ?????????????? ?? ?????????? ????????????')
                              ],
                            ),
                          ):  RaisedButton(
                            child: Text('?????? ?????????? ????????',style: TextStyle(color: Colors.white),),
                            color: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),

                            ),
                            onPressed: ()async{
                              if(_formkey.currentState.validate()) {
                                if(!isNumeric(_second_price.text)||!isNumeric(_mainprice.text)||!isNumeric(_shareCount.text)){
                                  Fluttertoast.showToast(
                                      msg:'?????? ???? ???????? ?????????? ???????????? ???????? ?????????? ?????????????? ?????? ??????????',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:Colors.red,
                                      textColor:Colors.white);
                                  return;

                                }
                                Creating_Product();

                            }}
                          ),
                          FutureBuilder(
                            future: get_dollar_price_and_product_count(widget.shop_id),
                            builder: (ctx,index){
                              if(index.hasData){

                                return Column(
                                  children: [

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    color:Colors.red,
                                                    padding:const EdgeInsets.all(3.0),
                                                    child:Text('?????? ?????? ?????????????? ???????? ??????????  ${index.data['message']['dollar']}',style: TextStyle(color: Colors.white,fontSize: 11),)
                                                ),

                                              ],
                                            ),
                                          ),
                                        )
                                      ],),
                                  ],
                                );
                              }
                              else{
                                return Container(
                                  child: Text('???????? ?????????? ???????????????? ???? ????????????????'),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Creating_Product()async{
    if(subcategoryid==''||subcategoryid==null){
      Fluttertoast.showToast(
          msg:'???????? ???????????? ?????????? ????????????',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
      return;
    }
    // Future.delayed(Duration(seconds:timeout_counter==0? 15:25)).then((value) {
    //   if(_iscreating==true){
    //     timeout_counter++;
    //
    //     Creating_Product().cancel;
    //
    //     Creating_Product();
    //
    //     return;
    //   }
    // });
    setState(() {
      _iscreating = true;
    });





    List<String> base64=[];
    List<String> basename=[];
    List pics=[];
    for (var img in img_paths){
      var value=img;

      File imgcode=File(value.path);
      String base645=base64Encode( imgcode.readAsBytesSync());
      String filename= imgcode.path.split("/").last.split(".").last;
      base64.add("'${base645}'");
      basename.add("'${filename}'");

    }
    Map to_server={
      'cat_id':_selectedValue,
      'subcat':subcategoryid,
      'shop_id':widget.shop_id,
      'name':_productName.text,
      'des':_description.text,

      'unit_price':_mainprice.text,
      'second_price':_second_price.text,
      'share_count':'${sharecount}',
      'is_new':'1',
      'minimum_order':_miniOrder.text,
      'is_pool':'0',
      'isoffer':'1'




    };

    to_server['images64']='${base64}';
    to_server['name64']='${basename}';




    var funct= await Market_helper.Create_product_now(widget.shop_id,RoyalBoardConst.PLATFORM,to_server);

    if(funct['msg']=='cat_not_active'){
      Fluttertoast.showToast(
          msg:
          '?????? ???? ?????????? ?????? ?????????? ?????? ????????????????',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(funct['msg']=='name_exist'){
      Fluttertoast.showToast(
          msg:'???? ???????? ?????????????? ?????? ?????????? ???????? ?????????? ????????????',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
      setState(() {
        _iscreating=false;
      });
      return;
    }
    else if(funct['msg']=='no_cat'){
      Fluttertoast.showToast(
          msg:
          '?????? ???? ?????? ?????? ?????????? ???????????? ???????????? ???????? ???????????? ????????',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(funct['msg']=='success'){
      Fluttertoast.showToast(
          msg:
          '???? ?????????? ???????????? ??????????',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.green,
          textColor:Colors.white);
    }
    setState(() {
      _iscreating = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=>Vendor_Dashboard(widget.user_id)
    ));

  }
  setContainer(var im)async{
    File image= await Utils.getImageFileFromAssets(
        im, RoyalBoardConfig.profileImageAize);
    return image;
  }
  Future<bool> requestGalleryPermission() async {
    // final Map<PermissionGroup, PermissionStatus> permissionss =
    //     await PermissionHandler()
    //         .requestPermissions(<PermissionGroup>[PermissionGroup.photos]);
    // if (permissionss != null &&
    //     permissionss.isNotEmpty &&
    //     permissionss[PermissionGroup.photos] == PermissionStatus.granted) {
    //   return true;
    // } else {
    //   return false;
    // }
    final Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();

    if (permissionss != null && permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
  _PickImage()async {
    List<Asset> resultList = <Asset>[];
    img_paths=[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
            takePhotoIcon: 'chat',
            backgroundColor: '' +
                Utils.convertColorToString(RoyalBoardColors.whiteColorWithBlack)),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(RoyalBoardColors.black),
          actionBarTitleColor: Utils.convertColorToString(RoyalBoardColors.white),
          statusBarColor: Utils.convertColorToString(RoyalBoardColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
          Utils.convertColorToString(RoyalBoardColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }
    for(var s in resultList){
      File image= await Utils.getImageFileFromAssets(
          s, RoyalBoardConfig.profileImageAize);
      img_paths.add(image);

    }
    setState(() {
      images = resultList;
    });
    if (images.isNotEmpty) {
      if (images[0].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
      } else {
        print('hdfhdfsh');
      }
    }
  }
  get_dollar_price_and_product_count(String shop_id)async{
    var data=await Market_helper.read_all_data_model(Files_Names.dollarPrice);

    if(data is Map){
      if(data.containsKey('message')){
        if(data['message'] is Map) {
          Map dollar=data['message'];
          if(dollar.containsKey('dollar')){

            var x = Market_helper.Dollar_Price(shop_id);
            return data;
          }}
      }
    }
    var x=await Market_helper.Dollar_Price(shop_id);
    await Market_helper.save_data_all_model(x,Files_Names.dollarPrice);
    return x;
  }
  getSubcategorie()async {

    var insider_data =await Market_helper.read_all_data_model(Files_Names.SubCategories_data);
    print('hfdshsdhgsdahgs${insider_data}');
    if (insider_data == 'false') {
      var a = await Market_helper.getSubCategories(widget.shop_id);
      return a;
    }
    else{
      return insider_data;
    }
  }
  getcategorie()async {

    var insider_data =await Market_helper.read_all_data_model(Categories_file);
    print('hfdshsdhgsdahgs${insider_data}');
    if (insider_data == 'false') {
      var a = await Market_helper.getCategories(widget.shop_id);
      return a;
    }
    else{
      return insider_data;
    }
  }
}
