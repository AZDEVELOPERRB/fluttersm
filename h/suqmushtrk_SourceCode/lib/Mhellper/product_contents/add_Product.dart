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
import 'products_pool.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/vendor_dashboard.dart';
import 'dart:io';
import 'dart:convert';
import 'package:numberpicker/numberpicker.dart';
class Add_new_product_by_venor extends StatefulWidget {
  String shop_id;
  String user_id;
  String joomla;


  Add_new_product_by_venor(this.shop_id, this.user_id,{ this.joomla});

  @override
  _Add_new_product_by_venorState createState() => _Add_new_product_by_venorState();
}

class _Add_new_product_by_venorState extends State<Add_new_product_by_venor> {
  String Categories_file=Files_Names.Categories_data;
  final _formkey=GlobalKey<FormState>();
  var subcat=null;
  TextEditingController _productName= TextEditingController();
  TextEditingController _description= TextEditingController();
  TextEditingController _second_price= TextEditingController();
  TextEditingController _mainprice= TextEditingController();
  TextEditingController _shareCount= TextEditingController(text: '1');
  TextEditingController _miniOrder= TextEditingController();
Markets_repo Market_helper=Markets_repo();
String _selectedValue;
String subcategoryid;
bool subcatbool;
var sc;
bool subloading=false;
int sharecount=1;
  List img_paths=[];

  List<String> base64=[];
  List<String> basename=[];
  Color yellow=Color(0xfff9a825);
String value_name='';
bool _iscreating=false;
  List<Asset> images = <Asset>[];
  int timeout_counter=0;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  Widget divider= SizedBox(height: 5,);
  @override

  Widget build(BuildContext context) {
    // var a =  Market_helper.getCategories(widget.shop_id);
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

                    child: Center(child: Text('اضافة المنتجات',style: TextStyle(fontSize:19,color: Colors.white),)),

                  ),
                  SizedBox(height: 15,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),

                    ),
                    color: yellow,
                    child: Text('نسخ المنتج من مسبح المنتجات',style: TextStyle(color: Colors.white),),
                    onPressed: ()async{



                      Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context)=>Products_pool_switcher(widget.user_id,widget.shop_id,joomla: widget.joomla,)
                      )
                      );

                    },

                  ),
                  divider,
                  Container(
                    height: size.height/9,
                    width: size.width,
                    child:     Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(   autofocus: false,
                        decoration: InputDecoration(

                            labelText: "اسم المنتج",
                            labelStyle: TextStyle(color: Colors.blue)
                            ,border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                        ),
                        validator: (v){
                          if(v.isEmpty){
                            return "هذا الحقل مطلوب";
                          }

                        },
                        controller:_productName,
                        cursorColor: Colors.black,

                      ),
                    ),
                  ),
                  divider,
                  Container(
                    height: size.height/9,
                    width: size.width,
                    child:     Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(   autofocus: false,

                        decoration: InputDecoration(
                            labelText: "وصف المنتج",
                            labelStyle: TextStyle(color: Colors.blue)
                            ,border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                        ),
                        validator: (v){
                          if(v.isEmpty){
                            return "هذا الحقل مطلوب";
                          }

                        },
                        controller:_description,
                        cursorColor: Colors.black,

                      ),
                    ),
                  ),
                  divider,
                  FutureBuilder(
                    future: getcategorie(),
                    builder: (context,categories){
                      if(categories.hasData){

                        return   Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 20,left: 20),
                          child: DropdownButtonFormField(
                            hint: Text('اختر القسم المناسب للمنتج' ,style: TextStyle(color: Colors.blue),),
    items:
    [
    for (var name in categories.data)
    DropdownMenuItem(
    value: '${name['id']}',
    child: Text(
    '${name['name']}',
    ),
    )
    ],
    value: _selectedValue,
    onChanged: (newVal) async{

      setState(() {
            _selectedValue = newVal;
            subcategoryid=null;
      });

      var subc = await getSubcategorie();

      print('sdgdafgasfsaf${subc}');
      print('hdfgsdgdsgd${newVal}');

      for (var d in await subc){
        if(d['data']['id']==newVal){

        setState(() {

          sc=d['subcat'];
        });
        }
      }

      setState(() {

      });

    }),
                        );

                      }
                      else{
                        return Container();
                      }
                    },
                  ),
                  divider,
                  sc==null?Container():new Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 20,left: 20),
                    child: DropdownButtonFormField(
                        hint: Text('اختر الفرع المناسب للمنتج' ,style: TextStyle(color: Colors.blue),),
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
                  divider,
                  Container(
                    height: 35,

                    child: Container(
                      child:     Padding(
                          padding: const EdgeInsets.all(3),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),

                            ),
                            color:img_paths.length==0? Colors.teal:Colors.lightGreen,
                            child: img_paths.length==0?Text('اضف صور جميلة لمنتجك',style: TextStyle(color: Colors.white),):Text('تم تحديد الصور',style: TextStyle(color: Colors.white),),
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
                     Text(' يرجى كتابة الاسعار بالارقام الأنكليزية 123 ')

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
                          child: TextFormField(   autofocus: false,

                            decoration: InputDecoration(
                                labelText: "السعر المخفض \$",
                                labelStyle: TextStyle(color: Colors.blue)
                                ,border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                            ),
                            keyboardType: TextInputType.number,

                            validator: (v){
                              if(v.isEmpty){
                                return "هذا الحقل مطلوب";
                              }

                            },
                            controller:_second_price
                            ,
                            cursorColor: Colors.black,

                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: size.height/14,
                        width: size.width/2-10,

                        child:     Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(   autofocus: false,
                            decoration: InputDecoration(
                                labelText: "سعر البيع المباشر \$",
                                labelStyle: TextStyle(color: Colors.blue)
                                ,border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                            ),
                            keyboardType: TextInputType.number,

                            validator: (v){
                              if(v.isEmpty){
                                return "هذا الحقل مطلوب";
                              }

                            },
                            controller:_mainprice,
                            cursorColor: Colors.black,

                          ),
                        ),
                      ),
                    ],
                  ),
                  divider,
                  Container(



                      child:     Padding(
                        padding: const EdgeInsets.only(top:7,right: 12),
                        child: Row(
                          children: [
                            Text('عدد مشاركات المنتج المطلوبة'),
                          ],
                        ),)),
                  Row(
                    children: [
                      // Container(
                      //   height: size.height/14,
                      //   width: size.width/2-10,
                      //   child:     Padding(
                      //     padding: const EdgeInsets.all(3.0),
                      //     child: TextFormField(   autofocus: false,
                      //       decoration: InputDecoration(
                      //           labelText: "اقل كمية لطلب هذا المنتج",
                      //           labelStyle: TextStyle(color: Colors.blue)
                      //           ,border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(25)
                      //       )
                      //       ),
                      //       keyboardType: TextInputType.number,
                      //
                      //       validator: (v){
                      //         if(v.isEmpty){
                      //           return "هذا الحقل مطلوب";
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
                                width: size.width/2-20,
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
                              Text('عدد المشاركات  ${sharecount}',style: TextStyle(color: Colors.red),)
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
                          child: Text('يضاف السعر بالدولار ويتحول الى العراقي بحسب سعر الصرف المحلي اسفل الشاشة ',style: TextStyle(fontSize: 11,color: Colors.white),),
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
                                // Text('جاري رفع الصور الى السيرفر و انشاء المنتج')
                              ],
                            ),
                          ):  RaisedButton(
                            child: Text('نشر المنتج الآن',style: TextStyle(color: Colors.white),),
                            color: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),

                            ),
                            onPressed: ()async{
                              if(subcategoryid==''||subcategoryid==null){
                                Fluttertoast.showToast(
                                    msg:'يرجى اختيار القسم الفرعي',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:Colors.red,
                                    textColor:Colors.white);
                                return;
                              }

                              if(_formkey.currentState.validate()) {
                                if(!isNumeric(_second_price.text)||!isNumeric(_mainprice.text)||!isNumeric(_shareCount.text)){
                                  Fluttertoast.showToast(
                                      msg:'يجب ان يكون السعر المخفض وسعر البيع المباشر فقط ارقام',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:Colors.red,
                                      textColor:Colors.white);
                                  return;

                                }
                              await  Creating_product();
                              }




                            },
                          ),
                          divider,
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
                                                    child:Text('سعر صرف الدولار لهذا اليوم  ${index.data['message']['dollar']}',style: TextStyle(color: Colors.white,fontSize: 11),)
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
                                  child: Text('جاري تحضير البيانات من الانترنت'),
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
  Creating_product()async{
 // setState(() {
 //   _iscreating = true;
 // });
    setState(() {
      _iscreating = true;
    });
 Future.delayed(Duration(seconds:timeout_counter==0? 3:20)).then((value) {
   if(_iscreating==true){
     timeout_counter++;

     Creating_product().cancel;


     Creating_product();

     return;
   }
 });


    // setState(() {
    //   _iscreating = true;
    // });







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
    };
    to_server['images64']='${base64}';
    to_server['name64']='${basename}';





    var funct= await Market_helper.Create_product_now(widget.shop_id,RoyalBoardConst.PLATFORM,to_server);


if(_iscreating) {
  if (funct['msg'] == 'cat_not_active') {
    Fluttertoast.showToast(
        msg:
        'لقد تم اخفاء هذا القسم يجب استبداله',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    setState(() {
      _iscreating = false;
    });
    return;
  }
  else if (funct['msg'] == 'name_exist') {
    Fluttertoast.showToast(
        msg: 'لا يمكن استخدام هذا الاسم لانه موجود بالفعل',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    setState(() {
      _iscreating = false;
    });
    return;
  }
  else if (funct['msg'] == 'no_cat') {
    Fluttertoast.showToast(
        msg:
        'لفد نم حذف هذا القسم بواسطة الشركة يرجى اختيار غيره',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    setState(() {
      _iscreating = false;
    });
    return;
  }
}
   if (funct['msg'] == 'success') {
    Fluttertoast.showToast(
        msg:
        'تم انشاء المنتج بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

    setState(() {
      _iscreating = false;
    });
    Navigator.pop(context);

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
    base64=[];
    basename=[];
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
      List pics=[];

        var value=image;
        File imgcode=File(value.path);
        String base645=await base64Encode( imgcode.readAsBytesSync());
        String filename= imgcode.path.split("/").last.split(".").last;
        await  base64.add("'${base645}'");
        basename.add("'${filename}'");


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
  getcategorie()async {

    var insider_data =await Market_helper.read_all_data_model(Categories_file);
    Market_helper.getCategories(widget.shop_id);
    if (insider_data == 'false') {
      var a = await Market_helper.getCategories(widget.shop_id);
      return a;
    }
    else{
      return insider_data;
    }
  }
  getSubcategorie()async {

    var insider_data =await Market_helper.read_all_data_model(Files_Names.SubCategories_data);
    if (insider_data == 'false') {
      var a = await Market_helper.getSubCategories(widget.shop_id);
    }
    else{
      Market_helper.getSubCategories(widget.shop_id);
      return insider_data;
    }
  }
}
