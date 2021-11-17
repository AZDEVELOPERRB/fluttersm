import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/all_Orders_ui.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'Shipping_All.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
class Editing_Shipping extends StatefulWidget {
  String Shop_id;
  String User_id;
  String oldtv;
  var Shipping_data;

  Editing_Shipping(this.Shop_id, this.User_id, this.Shipping_data,this.oldtv);

  @override
  _Editing_ShippingState createState() => _Editing_ShippingState();
}

class _Editing_ShippingState extends State<Editing_Shipping> {


  Markets_repo MH=Markets_repo();
  Products_repo PH=Products_repo();
  bool _isLoading=false;
  TextEditingController _name=new TextEditingController();
  TextEditingController _price=new TextEditingController();

@override
  void initState() {
  print('hdfshshdshg${widget.oldtv}');
  var finalprice=double.parse('${widget.Shipping_data['price']}')/double.parse('${widget.oldtv}');
  _name=new TextEditingController(text: widget.Shipping_data['area_name']);
  _price=new TextEditingController(text:'${finalprice}' );
  setState(() {

  });
  // await PH.bringShipping(widget.Shipping_data['id']);
    super.initState();
  }
checkdata()async{
  var d=await PH.bringShipping(widget.Shipping_data['id']);
  return d;
}
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center
          ,children: [
          InkWell(
            onTap: (){

              Fluttertoast.showToast(
                  msg:'يمكنك تغيير فقط سعر التوصيل',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:Colors.blue,
                  textColor:Colors.white);

              },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height/11,
                width: size.width/1,
                child:     Padding(
                  padding: const EdgeInsets.all(5.0),

                  child: TextFormField(
                    controller: _name,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: "اسم المدينة",
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
                    cursorColor: Colors.black,

                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right:8.0,left: 8,bottom: 8),
            child: Container(
              height: size.height/11,
              width: size.width/1,
              child:     Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _price,
                  decoration: InputDecoration(

                      labelText: "سعر التوصيل بالدولار",
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
                  cursorColor: Colors.black,

                ),
              ),
            ),
          ),

          _isLoading==true?Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ):      RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),

            ),
            color: Colors.blue,
            child: Text('تعديل منطقة الشحن',style: TextStyle(color: Colors.white),),
            onPressed: ()async{
              setState(() {
                _isLoading=true;
              });
              if(_price.text!=''&&_name.text!=''){
                var d=await PH.Create_ShippingArea(widget.User_id, widget.Shop_id,_name.text,_price.text,0,widget.Shipping_data['id']);
                if(d['message']['msg']=='success'){

                  Fluttertoast.showToast(
                      msg:'تم تعديل منطقة الشحن بنجاح',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:Colors.green,
                      textColor:Colors.white);

                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (ctx)=>Shipping_All(widget.User_id,widget.Shop_id,from_Single: true,)
                  ));


                }
                else{
                  Fluttertoast.showToast(
                      msg:'لقد حصل خطأ في الاتصال',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:Colors.red,
                      textColor:Colors.white);

                }


              }
              else{
                Fluttertoast.showToast(
                    msg:'لا يمكن ترك الحقول فارغة',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor:Colors.red,
                    textColor:Colors.white);
              }

              setState(() {
                _isLoading=false;
              });

            },
          )

        ],
        )
      ),
    );
  }

  bringShippingDetail()async{
    print('hsdfhsdh${widget.Shipping_data['id']}');

    var d=await PH.bringShipping(widget.Shipping_data['id']);

    return d;
  }
}

