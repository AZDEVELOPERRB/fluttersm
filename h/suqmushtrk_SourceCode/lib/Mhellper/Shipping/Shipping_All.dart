import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/all_Orders_ui.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Edit_Shipping.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';

class Shipping_All extends StatefulWidget {
  String User_id;
  String Shop_id;
  bool from_Single;

  Shipping_All(this.User_id, this.Shop_id,{this.from_Single});

  @override
  _Shipping_AllState createState() => _Shipping_AllState();
}

class _Shipping_AllState extends State<Shipping_All> {
  Markets_repo MH=Markets_repo();
  Products_repo PH=Products_repo();

  TextEditingController _name=new TextEditingController();
  TextEditingController _price=new TextEditingController();
  bool _isLoading=false;
  String moh;
  List<String> mohav=RoyalBoardConst.mohav.map((e) =>"$e" ).toList();
  initState(){
    Injection_of_data();
    checkourstate();
    super.initState();
  }
  var data;
  checkourstate()async{
    await Future.delayed(Duration(seconds: 10)).then((value) {
      if(data==null){
        Injection_of_data();

      }
    });
  }
  Injection_of_data()async{
    var d=await PH.getAllShippingArea(widget.User_id,widget.Shop_id);

    setState(() {
      data=d['message'];
    });
    setdroplist();

    return d;
  }
setdroplist(){
    if(data==null){
      Future.delayed(Duration(seconds: 5)).then((value) => setdroplist());
      return;
    }

    for (var i in data['data']){
      String nameexist=i['area_name'];
      print('dfhdfhdfh${i['status']}');
      if(mohav.contains(nameexist)&&i['status']=="1"){

        mohav.remove(nameexist);
      }

    }
    setState(() {
    });




}
  bool delete_loading=false;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          child:


             data!=null


                ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top:40.0),
                    child: Container(
                      width:size.width ,
                      height: size.height*0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green)
                      ),
                      child: Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DropdownButton(
                                hint: Text("اختر المحافظة"),
                                items: mohav.map((String value) {


                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(

                                        child: new Text(value,style: TextStyle(color: Colors.blue),)),

                                  );
                                }).toList(),
                                value: moh,
                                onChanged: (value){
                                  setState(() {
                                    moh=value;
                                  });


                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:8.0,left: 8,bottom: 8),
                              child: Container(
                                height: size.height/14,
                                width: size.width/1.3,
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
                              child: Text('انشاء منطقة شحن',style: TextStyle(color: Colors.white),),
                              onPressed: ()async{
                                if(moh==null&&moh==""){

                                  Fluttertoast.showToast(
                                      msg:'يجب اختيار المحافظة',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:Colors.red,
                                      textColor:Colors.white);
                                  return;
                                }


                                if(_price.text!=''){
                                  setState(() {
                                    _isLoading=true;
                                  });
                                  var d=await PH.Create_ShippingArea(widget.User_id, widget.Shop_id,moh,_price.text,1,'');
                                  if(d['message']['msg']=='success'){

                                    Fluttertoast.showToast(
                                        msg:'تم اضافة منطقة شحن بنجاح',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:Colors.green,
                                        textColor:Colors.white);
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (ctx)=>Shipping_All(widget.User_id,widget.Shop_id,)
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
                                  setState(() {
                                    _isLoading=false;
                                  });


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

                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),


              data['msg']=='success'?
               Container(
                 height: size.height-size.height/4-100,
                 child: ListView.builder(
              itemCount: data['data'].length,
              itemBuilder: (context ,item){


              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height*0.25,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('اسم مدينة التوصيل : ${data['data'][item]['area_name']}',style: TextStyle(color: Colors.black87,fontSize: 11),),
                            Text('سعر التوصيل   : ${data['data'][item]['price']}',style: TextStyle(color: Colors.black87,fontSize: 11)),


                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: size.width/5,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),

                                ),
                                color: Colors.blue,
                                child: Text('تعديل',style: TextStyle(color: Colors.white,fontSize: 11),),
                                onPressed: (){

                                  Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                    builder: (context)=>Editing_Shipping(widget.Shop_id,widget.User_id,data['data'][item],'${data['c']}')
                                  )
                                  );
                                }

                                ,),
                            ),
                            Container(
                              width: size.width/5,

                              child:delete_loading==true?Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: CircularProgressIndicator(),
                              ): RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),

                                ),
                                color: Colors.red,
                                child: Text('حذف',style: TextStyle(color: Colors.white,fontSize: 11),),
                                onPressed: ()async{
                                  setState(() {
                                    delete_loading=true;
                                  });
                            await delete_area(item);

                                  setState(() {
                                    delete_loading=false;
                                  });

                                }

                                ,),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              }),
               ):
              Center(
              child: Text('لا توجد اي مناطق شحن حتى الآن'),
              )



              ]







             )



                : Container(
                  height: size.height,
                  width: size.width,
                  child: Center(child: CircularProgressIndicator()),
                )



        ),
      ),
    );
  }
  delete_area(int index)async{
    var ss=await PH.deleteShip_area(data['data'][index]['id']);
    if(ss['message']['msg']=='success'){


      Fluttertoast.showToast(
          msg:'تم حذف المنطقة بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.green,
          textColor:Colors.white);
      setState(() {
        if(widget.from_Single==null) {
          widget.from_Single = true;
        }
        else{
          widget.from_Single=null;
        }
      });
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (ctx)=>Shipping_All(widget.User_id,widget.Shop_id,)
      ));

    }
    else{

      Fluttertoast.showToast(
          msg:'يوجد خطا في الاتصالا',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);

    }
  }
}
