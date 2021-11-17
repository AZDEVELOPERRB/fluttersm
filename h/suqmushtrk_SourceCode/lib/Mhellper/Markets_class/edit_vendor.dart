import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/TimeHellper/Times_class.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/dialog/error_dialog.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'dart:io';
import 'dart:convert';
import 'vendor_dashboard.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/vendor_dashboard.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/models/Tajer_Model.dart';

class Editting_vendor extends StatefulWidget {
  var userid;
  Vendor_Model data;

  Editting_vendor(this.userid,this.data);

  @override
  _Jomla_RegisterState createState() => _Jomla_RegisterState();
}

class _Jomla_RegisterState extends State<Editting_vendor> {
  final _formkey=GlobalKey<FormState>();
  TextEditingController tujar_type=new TextEditingController();
  TextEditingController tujar_number=new TextEditingController();
  TextEditingController tujar_email=new TextEditingController();
  TextEditingController tujar_delivery=new TextEditingController();
  TextEditingController tujar_name=new TextEditingController();
  TextEditingController tujar_ex_product=new TextEditingController();
  TextEditingController tujar_address=new TextEditingController();
  TextEditingController tujar_minimum_selling=new TextEditingController();
  TextEditingController _mini_money=new TextEditingController();
  TextEditingController holiday=new TextEditingController();

  bool _isloading=false;
  var kind_of_type;
  var Timeclosing;
  TextStyle blue_s=TextStyle(color: Colors.blue);
  TimePickerWidget Time_picker =TimePickerWidget('وقت انتهاء الدوام');
  TimePickerWidget Time_picker_start =TimePickerWidget('وقت ابتداء الدوام');
  Markets_repo Market_helper=Markets_repo();
  List<Asset> images = <Asset>[];
@override
  void initState() {


    super.initState();
  }
  fdata()async{
  if(tujar_name.text==''){
    if(widget.data.start_time.contains('AM')){


      Time_picker=TimePickerWidget('وقت انتهاء الدوام',amtype: "AM",a:widget.data.closing_time);
      Time_picker_start=TimePickerWidget('وقت ابتداء الدوام',amtype: "AM",a:widget.data.start_time);
      setState(() {

      });
    }

    if(widget.data!=null){
      tujar_type=new TextEditingController(text: widget.data.specialist);
      tujar_number=new TextEditingController(text: widget.data.phone);
      tujar_email=new TextEditingController(text: widget.data.email);
      tujar_delivery=new TextEditingController(text: widget.data.deliver);
      tujar_name=new TextEditingController(text: widget.data.name);
      tujar_ex_product=new TextEditingController(text: widget.data.ex_product);
      tujar_address=new TextEditingController(text: widget.data.address1);
      tujar_minimum_selling=new TextEditingController(text: widget.data.minmum_amount);
      _mini_money= TextEditingController(text: widget.data.mini_money);
      holiday= TextEditingController(text: widget.data.holiday);


      setState(() {


      });
    }
  }
    return 'a';
  }
  bool _isUploading=false;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (ctx)=>Vendor_Dashboard(widget.userid)
          ));
        },
        child: FutureBuilder(
          future: fdata(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Container(
                  height: size.height,
                  width: size.width,
                  child: Stack(
                    children: [
                      // Container(
                      //   height: size.height/5,
                      //   child: Center(
                      //     child: Positioned(
                      //       top: 1,
                      //       child:  Container(
                      //    width: size.width/2,
                      //         height: 35,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: Colors.black87
                      //         ),
                      //
                      //         child: Center(child: Text(' تجار الجملة والشركات',style: TextStyle(fontSize:19,color: Colors.white),)),
                      //
                      //       ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(

                                    width: size.width/2,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black87
                                    ),

                                    child: Center(child: Text(' تجار الجملة والشركات',style: TextStyle(fontSize:19,color: Colors.white),)),

                                  ),
                                  //   Container(                    width: size.width-25,
                                  //   child:  DropdownButton      (
                                  //     value: kind_of_type,
                                  //
                                  //   items: <String>['قسم مواد التجميل', 'B', 'قسم جملة الانشائيات', 'D'].map((String value) {
                                  //
                                  //
                                  //   return DropdownMenuItem<String>(
                                  //   value: value,
                                  //   child: Container(
                                  //
                                  //       child: new Text(value,style: TextStyle(color: Colors.blue),)),
                                  //
                                  //   );
                                  //   }).toList(),
                                  //     onChanged: (v) {
                                  // setState(() {
                                  //   kind_of_type=v;
                                  // });
                                  //     },
                                  //
                                  //
                                  //   ),
                                  //   ),
                                  SizedBox(height: 15,),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "اختصاص الشركة او المحل",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_type,
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
                                            labelText: "رقم الموبايل الخاص بالمتجر",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        keyboardType: TextInputType.phone,
                                        controller: tujar_number,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "الايميل التجاري الخاص بالمتجر",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_email,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "يرجى كتابة المحافظة والمواقع المشمولة في التوصيل",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_delivery,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "اسم شركتك او نشاطك التجاري",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_name,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "منتجات حصرية لديك",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_ex_product,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "عنوان شركتك او نشاطك",
                                            labelStyle: blue_s
                                            ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        )
                                        ),
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: tujar_address,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "اقل مبلغ للبيع",
                                          labelStyle: blue_s
                                          ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        ),

                                        ),
                                        keyboardType:TextInputType.number ,
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: _mini_money,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height/9,
                                    width: size.width,
                                    child:     Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "ايام العطل",
                                          labelStyle: blue_s
                                          ,border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        ),

                                        ),
                                        keyboardType:TextInputType.number ,
                                        validator: (v){
                                          if(v.isEmpty){
                                            return "هذا الحقل مطلوب";
                                          }

                                        },
                                        controller: holiday,
                                        cursorColor: Colors.black,

                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            child:     Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Time_picker_start
                                            ),
                                          ),
                                        ),
                                        Flexible(child:Container(

                                          child:     Padding(
                                              padding: const EdgeInsets.all(3),
                                              child:Time_picker
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _isUploading==true?Container():  images.length==0?Container():       RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),

                                          ),
                                          child: Text('رفع الصورة الآن',style: TextStyle(color: Colors.white),),
                                          color: Colors.black87,
                                          onPressed: ()async{

                                            setState(() {
                                              _isUploading=true;
                                            });
                                            File image= await Utils.getImageFileFromAssets(
                                                images[0], RoyalBoardConfig.profileImageAize);

                                            var a=   await Market_helper.Upload_tajer_image(image, RoyalBoardConst.PLATFORM, widget.userid, widget.data.id, 0);
                                            setState(() {
                                              images=[];
                                              _isUploading=false;
                                            });
                                            Fluttertoast.showToast(
                                                msg:
                                                'تم رفع الصورة بنجاح',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white);
                                            },
                                        ),
                                        _isUploading==true?Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ):     Flexible(
                                          child: Container(
                                            child:     Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25),

                                                  ),
                                                  color: images.length==0? Colors.teal:Colors.lightGreen,
                                                  child: images.length==0?Text('اختر صورة الغلاف',style: TextStyle(color: Colors.white),):Text('تم تحديد الصورة',style: TextStyle(color: Colors.white),),
                                                  onPressed: ()async{


                                                    if (await Utils.checkInternetConnectivity()) {
                                                      requestGalleryPermission().then((bool status) async {
                                                        if (status) {
                                                          await _PickImage();
                                                        }
                                                      });
                                                      print('fdhlkdfjghsdfghsf');
                                                      File image= await Utils.getImageFileFromAssets(
                                                          images[0], RoyalBoardConfig.profileImageAize);


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
                                        // Flexible(child:Container(
                                        //
                                        //   child:     Padding(
                                        //       padding: const EdgeInsets.all(3),
                                        //       child:RaisedButton(
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius: BorderRadius.circular(25),
                                        //
                                        //         ),
                                        //         color: Colors.teal,
                                        //         child: Text('اختر ايقونة المتجر',style: TextStyle(color: Colors.white),),
                                        //         onPressed: (){},
                                        //       )
                                        //   ),
                                        // ),)
                                      ],
                                    ),
                                  ),


                                  _isloading==true?Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ):   RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    color: Colors.blue,
                                    child: Text('تعديل متجرك الآن',style: TextStyle(color: Colors.white),),
                                    onPressed: ()async{



                                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(tujar_email.text);
                                      if(emailValid!=true){
                                        Fluttertoast.showToast(
                                            msg:
                                            'يجب ادخال بريد الكتروني صالح',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:Colors.red,
                                            textColor:Colors.white);
                                        return;
                                      }

                                      if(_formkey.currentState.validate()){
                                        setState(() {
                                          _isloading=true;
                                        });
                                        if(await Time_picker.a!=null&&await Time_picker_start.a!=null){


                                          var data={
                                            "user_id":widget.userid,
                                            "name":tujar_name.text,
                                            "tujar_type":tujar_type.text,
                                            "tujar_phone":tujar_number.text,
                                            "tujar_email":tujar_email.text,
                                            "tujar_delivery":tujar_delivery.text,
                                            "tujar_ex_products":tujar_ex_product.text,
                                            "tujar_minimum":tujar_minimum_selling.text,
                                            "mini_money":_mini_money.text,
                                            "start_time":Time_picker_start.a,
                                            "holiday":holiday.text,
                                            "closing_time":Time_picker.a,
                                            "address1":tujar_address.text,
                                            "is_new":'0'
                                            ,'id':widget.data.id



                                          };
                                          // await Market_helper.Upload(image);
                                          var sub=await Market_helper.Edit_Shop( RoyalBoardConst.PLATFORM, data);


                                          if(sub['status']=='success') {
                                            Fluttertoast.showToast(
                                                msg:
                                                'تم تعديل المتجر بنجاح',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white);
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (ctx)=>Vendor_Dashboard(widget.userid)
                                            ));
                                          }





                                        }
                                        else{
                                          Fluttertoast.showToast(
                                              msg:
                                              'يجب اختيار اوقات الدوام',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:Colors.red,
                                              textColor:Colors.white);
                                        }
                                      }
                                      setState(() {
                                        _isloading=false;
                                      });
                                    },
                                  )


                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              );
            }
            else{
              return Container(child: Center(child: CircularProgressIndicator()));
            }

          }
        ),
      ),
    );
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
  _PickImage()async{
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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
}
