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
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'dart:io';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:numberpicker/numberpicker.dart';
class Edit_Pool extends StatefulWidget {
  String shop_id;
  String user_id;
  String product_id;

  Edit_Pool({this.shop_id, this.user_id,this.product_id});

  @override
  _Add_new_product_by_venorState createState() => _Add_new_product_by_venorState();
}

class _Add_new_product_by_venorState extends State<Edit_Pool> {

  Products_repo products_st=Products_repo();
  String Categories_file=Files_Names.Categories_data;
  final _formkey=GlobalKey<FormState>();


  Markets_repo Market_helper=Markets_repo();
  String _selectedValue;
  String subcategoryid;
  bool subcatbool;
  var sc;
  Color yellow=Color(0xfff9a825);
  String value_name='';
  bool _iscreating=false;
  List<Asset> images = <Asset>[];
  @override
  var product_data;
  Product _product;
  int sharecount=1;
  List img_paths=[];
  int timeout_counter=0;
  String timeout;
  bool fir=false;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  iniState()async{

    var s= await getProduct_detail();
    s=product_data;
    super.initState();

  }
  dispose(){
    super.dispose();
  }
  getCategories(String cat_id)async{
    // var Categories=await Market_helper.read_all_data_model(Categories_file);
    // for (var s in Categories){
    //   if(s['id']==cat_id){
    //
    //     _selectedValue=s['id'];
    //
    //
    //   }
    // }
  }
  TextEditingController _productName=new TextEditingController();
  TextEditingController _description=new TextEditingController();
  TextEditingController _second_price=new TextEditingController();
  TextEditingController _mainprice=new TextEditingController();
  TextEditingController _shareCount=new TextEditingController();
  TextEditingController _miniOrder=new TextEditingController();
  getProduct_detail()async{
    var a=await products_st.getProductDetail(widget.product_id);
    _product=Product().fromMap(a['message']['data'][0]);
    if(fir==false){
      fir=true;
      _selectedValue=_product.catId;
      var subc=await getSubcategorie();

      for (var d in subc){
        if(d['data']['id']==_selectedValue){
          setState(() {
            sc=d['subcat'];


          });
        }
      }
      print('hdfhsdhgsdghds${_product.subCatId}');
      if(_product.subCatId!=null&&_product.subCatId!=''){


        subcategoryid=_product.subCatId;
      }

      _second_price= TextEditingController(text: '${a['message']['sp']}');
      _description= TextEditingController(text: _product.description);
      _mainprice= TextEditingController(text:'${a['message']['up']}');
      _shareCount= TextEditingController(text: _product.share_count);
      sharecount=int.parse(_product.share_count);
      _miniOrder= TextEditingController(text: _product.minimumOrder);
    }


    return a;
  }
  updateProduct_Now(bool isp)async{
    if(subcategoryid==''||subcategoryid==null&&isp==true){
      Fluttertoast.showToast(
          msg:'يرجى اختيار القسم الفرعي',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
      return;
    }


    Future.delayed(Duration(seconds:timeout_counter==0? 10:20)).then((value) {
      if(_iscreating==true) {
        timeout_counter++;

        updateProduct_Now(false).cancel;

        updateProduct_Now(true);

        return;
      }
    });

    setState(() {
      _iscreating = true;
    });




    List pics=[];

    Map to_server={
      'id':_product.id,
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
      'is_pool':'1'



    };






    var funct= await Market_helper.Create_product_now(widget.shop_id,RoyalBoardConst.PLATFORM,to_server);

    if(funct['msg']=='cat_not_active'){
      Fluttertoast.showToast(
          msg:
          'لقد تم اخفاء هذا القسم يجب استبداله',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(funct['msg']=='name_exist'){
      Fluttertoast.showToast(
          msg:'لا يمكن استخدام هذا الاسم لانه موجود بالفعل',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(funct['msg']=='no_cat'){
      Fluttertoast.showToast(
          msg:
          'لفد نم حذف هذا القسم بواسطة الشركة يرجى اختيار غيره',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);
    }
    else if(funct['msg']=='success'){
      Fluttertoast.showToast(
          msg:
          'تم نسخ المنتج بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.green,
          textColor:Colors.white);
      Navigator.pop(context);

    }
    setState(() {
      _iscreating = false;
    });
    return;
  }

  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return FutureBuilder(
        future: getProduct_detail(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data['message']['msg']=='no_product'){
              return  Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),

                          ),
                          color: Colors.red,
                          child: Text('رجوع',style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('لايوجد هكذا منتج قد يكون محذف او مغلق من الادارة'),
                        )
                      ],
                    ),
                  ),
                ),
              );


            }

            var cat=getCategories(_product.catId);


            return Scaffold(

              body: Container(
                width:size.width,
                height: size.height,
                child: Stack(
                  children: [
                    // Positioned(
                    //   bottom: 2,
                    //   right: 1,
                    //   child:   Container(
                    //     width: size.width/3,
                    //     height: size.height/6,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(25),
                    //       color: Colors.pink,
                    //     ),
                    //
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Text('يضاف السعر بالدولار ويتحول الى العراقي بحسب سعر الصرف المحلي اسفل الشاشة ',style: TextStyle(fontSize: 11,color: Colors.white),),
                    //     ),
                    //   ),
                    // ),

                    SingleChildScrollView(
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
                                timeout==null?Container():  Container(
                                  height: 40,
                                  width: size.width-40,
                                  decoration: BoxDecoration(
                                      color: Colors.red,

                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child:Center(child:  Text('لا تقلق عند تأخر الطلب فالتطبيق مبرمج على اعادة الطلب كل عشر ثواني',style: TextStyle(color: Colors.white,fontSize: 11),),)
                                  ),
                                ),

                                Container(
                                  height: size.height/9,
                                  width: size.width,
                                  child:     Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
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
                                Container(
                                  height: size.height/9,
                                  width: size.width,
                                  child:     Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
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
                                FutureBuilder(
                                  future: getcategorie(),
                                  builder: (context,categories){
                                    if(categories.hasData){
                                      return   Padding(
                                        padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 20,left: 20),
                                        child: DropdownButtonFormField(
                                            hint: Text('اختر الفرع المناسب للمنتج' ,style: TextStyle(color: Colors.blue),),
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
                                ),
                                sc==null||sc==''?Container():new Padding(
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
                                images.length==0?SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(

                                    children: [
                                      for (var img in snapshot.data['message']['img'])
                                        Container(
                                          width: size.width/4,
                                          height: size.height/5,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:  NetworkImage( 'https://suqmshtrk.com/dashboardpanel/controller/uploads/${img['img_path']}'),
                                                fit: BoxFit.fill,

                                              )
                                          ),

                                        )


                                    ],
                                  ),
                                ):  Row(
                                  children: [
                                    for (var img in images)
                                      FutureBuilder(
                                        future: setContainer(img),
                                        builder: (ctx,im){
                                          if(im.hasData){
                                            return Container(
                                              width: size.width/images.length,
                                              height: size.height/4,
                                              child: Image.file(im.data),
                                            );
                                          }
                                          else{
                                            return   Container();
                                          }
                                        },
                                      )

                                  ],
                                ),
                                SizedBox(height: 25,),
                                // Flexible(
                                //   child: Container(
                                //     child:     Padding(
                                //         padding: const EdgeInsets.all(3),
                                //         child: RaisedButton(
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(25),
                                //
                                //           ),
                                //           color: images.length==0? Colors.teal:Colors.lightGreen,
                                //           child: images.length==0?Text('اضف صور جميلة لمنتجك',style: TextStyle(color: Colors.white),):Text('تم تحديد الصور',style: TextStyle(color: Colors.white),),
                                //           onPressed: ()async{
                                //             if (await Utils.checkInternetConnectivity()) {
                                //               requestGalleryPermission().then((bool status) async {
                                //                 if (status) {
                                //                   await _PickImage();
                                //                 }
                                //               });
                                //             } else {
                                //               showDialog<dynamic>(
                                //                   context: context,
                                //                   builder: (BuildContext context) {
                                //                     return ErrorDialog(
                                //                       message:
                                //                       Utils.getString(context, 'error_dialog__no_internet'),
                                //                     );
                                //                   });
                                //             }
                                //           },
                                //         )
                                //     ),
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Container(
                                      height: size.height/9,
                                      width: size.width/2-10,
                                      child:     Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: TextFormField(
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
                                    Container(
                                      height: size.height/9,
                                      width: size.width/2-10,

                                      child:     Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: TextFormField(
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
                                    //   height: size.height/9,
                                    //   width: size.width/2-10,
                                    //   child:     Padding(
                                    //     padding: const EdgeInsets.all(3.0),
                                    //     child: TextFormField(
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
                                              Text('جاري نسخ المنتج'),
                                              images.length!=0?Text('وجاري رفع الصور قد ياخذ وقت'):Container()
                                            ],
                                          ),
                                        ):  RaisedButton(
                                          child: Text('نسخ  المنتج',style: TextStyle(color: Colors.white),),
                                          color: Colors.black87,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),

                                          ),
                                          onPressed: ()async{


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
                                              var updated = await updateProduct_Now(true);
                                            }


                                          },
                                        ),
                                        // FutureBuilder(
                                        //   future: get_dollar_price_and_product_count(widget.shop_id),
                                        //   builder: (ctx,index){
                                        //     if(index.hasData){
                                        //
                                        //       return Column(
                                        //         children: [
                                        //
                                        //           Row(
                                        //             children: [
                                        //               Padding(
                                        //                 padding: const EdgeInsets.all(8.0),
                                        //                 child: Container(
                                        //
                                        //                   child: Row(
                                        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     children: [
                                        //                       Container(
                                        //                           color:Colors.red,
                                        //                           padding:const EdgeInsets.all(3.0),
                                        //                           child:Text('سعر صرف الدولار لهذا اليوم  ${index.data['message']['dollar']}',style: TextStyle(color: Colors.white,fontSize: 11),)
                                        //                       ),
                                        //
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               )
                                        //             ],),
                                        //         ],
                                        //       );
                                        //     }
                                        //     else{
                                        //       return Container(
                                        //         child: Text('جاري تحضير البيانات من الانترنت'),
                                        //       );
                                        //     }
                                        //   },
                                        // ),
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
                  ],
                ),
              ),
            );
          }
          else{
            return Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('جاري فحص معلومات وتراخيص المنتج'),
                      )
                    ],
                  ),
                ),
              ),
            );

          }

        }
    );
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
    var x=await Market_helper.Dollar_Price(shop_id);
    return x;
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
}
