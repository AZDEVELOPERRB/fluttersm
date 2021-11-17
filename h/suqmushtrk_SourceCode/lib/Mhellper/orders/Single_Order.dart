import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/all_Orders_ui.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Single_Order extends StatefulWidget {
  String User_id;
  String Shop_id;
  var Order_Data;

  Single_Order(this.User_id, this.Shop_id, this.Order_Data);

  @override
  _Single_OrderState createState() => _Single_OrderState(Order_Data['state']['id']);
}

class _Single_OrderState extends State<Single_Order> {


  _Single_OrderState(this._selectedValue);
  String _selectedValue;

  getOrders_access()async{
  var Or=                            PH.SingleOrderDetails(widget.Order_Data['details']['product_id'],widget.Order_Data['headers']['contact_area_id']);
;
return Or;
}
  Markets_repo MH=Markets_repo();
  Products_repo PH=Products_repo();

  List images=[];
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (ctx)=>All_Orders_Ui(widget.Shop_id,widget.User_id)
          ));
        },
        child: Container(
          child: Center(
            child: FutureBuilder(
              future: getOrders_access(),
              builder: (context, snapshot) {

                if(snapshot.hasData){

                  var subd=snapshot.data['message'];
                  double tax=double.parse('${widget.Order_Data['headers']['tax_percent']}');
                  double prod_price=double.parse('${widget.Order_Data['details']['price']}');
                  double before_hundered=tax*prod_price;
                  double hundered=before_hundered/100;
                  double last_Single_price=hundered+prod_price;
                  double price_with_qty=last_Single_price*double.parse('${widget.Order_Data['details']['qty']}');
                  double final_price=price_with_qty+double.parse('${subd['shipping_price']}');

                  for(var img in subd['img']){
                    images.add(
                        NetworkImage('https://suqmshtrk.com/dashboardpanel/controller/uploads/${img['img_path']}')
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 40,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black87
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('تفاصيل الطلب',style: TextStyle(color: Colors.white),),
                          ),

                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(right: 15,left: 15),
                          child: Container(

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15,left: 15),
                              child: DropdownButtonFormField(

                                  hint: Text('اختر حالة الطلبية الآن' ,style: TextStyle(color: Colors.blue),),
                                  items:
                                  [
                                    for (var name in subd['coring'])
                                      if(int.parse(name['ordering'])>=int.parse(widget.Order_Data
                                      ['state']['ordering']))
                                      DropdownMenuItem(
                                        value: '${name['id']}',
                                        child: Text(
                                          name['title'],
                                        ),
                                      )
                                  ],
                                  value: _selectedValue,
                                  onChanged: (newVal) {
                                    setState(() {
                                      _selectedValue = newVal;
                                    });
                                  }),
                            ),
                          ),
                        ),
                     _isLoading==true?Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(child: Center(child: CircularProgressIndicator())),
                     ):   RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          color: Colors.blue,
                          onPressed: ()async{
                            if(widget.Order_Data['state']['final_stage']=='1'){
                              Fluttertoast.showToast(
                                  msg: 'لا يمكن تحديث الحالة فقد تم تسليم الطلب االى الزبون',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white
                              );
                              return;

                            }
                            setState(() {
                              _isLoading=true;
                            });

                            if(_selectedValue==null){
                              Fluttertoast.showToast(
                                  msg: 'يجب اختيار حالة  للطلبية حتى يتسنى لك التحديث',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white
                              );
                              return;
                            }
                            var res=await PH.UpdateOrderDetails(widget.Order_Data['headers']['id'],_selectedValue);

                            if(res['message']['msg']=='error'){

                              Fluttertoast.showToast(
                                  msg: 'لقد حصل خطا في الاتصال',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white
                              );
                            }
                            else{

                              Fluttertoast.showToast(
                                  msg: "لقد تم تحديث الطلبية بنجاح",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white
                              );
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (ctx)=>All_Orders_Ui(widget.Shop_id,widget.User_id)
                              ));

                            }

                            setState(() {
                              _isLoading=false;
                            });

                          },
                          child: Text('تحديث حالة الطلبية الآن',style: TextStyle(color: Colors.white),),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.purpleAccent)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('تفاصيل المنتج'),
                                  Container(
                                    width: size.width-40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    height: size.height/4,
                                    child:    Carousel(
                                      images: images,
                                      dotSize: 4.0,
                                      dotSpacing: 15.0,
                                      showIndicator: false,
                                      dotColor: Colors.white,
                                      indicatorBgPadding: 5.0,
                                      autoplay: false,
                                      dotBgColor: Colors.yellow.withOpacity(0.5),
                                      borderRadius: false,

                                    ),
                                  ),
                                  Text('اسم المنتج : ${widget.Order_Data['details']['product_name']}',style: TextStyle(color: Colors.black),),



                                ],
                              ),
                            ),
                          ),
                        ), Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('تفاصيل الطلبية'),
                                  Text(' سعر المنتج : ${widget.Order_Data['details']['price']}',style: TextStyle(color: Colors.teal),),
                                  Text(' نسبة ربح التطبيق : ${tax} % = ${hundered}',style: TextStyle(color: Colors.teal),),
                                  Text('   سعر المنتج مع نسبة التطبيق : ${last_Single_price}',style: TextStyle(color: Colors.teal),),
                                  Text('  كمية المنتج المطلوبة : ${widget.Order_Data['details']['qty']}',style: TextStyle(color: Colors.brown),),
                                  Text('  سعر المنتج لكل الكمية : ${widget.Order_Data['details']['qty']}*${last_Single_price}=${last_Single_price*double.parse('${widget.Order_Data['details']['qty']}')}',style: TextStyle(color: Colors.brown),),
                                  Text(' اسم منطقة الشحن : ${subd['shipping_name']}',style: TextStyle(color: Colors.teal),),
                                  Text(' سعر منطقة الشحن : ${subd['shipping_price']}',style: TextStyle(color: Colors.teal),),
                                  Text(' سعر الطلبية مع سعر الشحن : ${price_with_qty}+${subd['shipping_price']}=${final_price}',style: TextStyle(color: Colors.teal),),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.blue)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(' سعر المنتج النهائي : ${final_price}',style: TextStyle(color: Colors.red),),
                                      )),




                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blueAccent)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('تفاصيل الزبون'),
                                  Text('اسم الزبون : ${widget.Order_Data['headers']['contact_name']}',style: TextStyle(color: Colors.black),),
                                  Text('عنوان الزبون : ${widget.Order_Data['headers']['contact_address']}',style: TextStyle(color: Colors.teal),),
                                  Text('رقم هاتف الزبون : ${widget.Order_Data['headers']['contact_phone']}',style: TextStyle(color: Colors.brown),),
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  );

                }
                else{
                  return Container(
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
                            child: Text('جاري تجهيز الطلبية وصورها اليك'),
                          )
                        ],
                      ),
                    ),
                  );
                }

              }
            ),
          ),
        ),
      ),
    );
  }
}
