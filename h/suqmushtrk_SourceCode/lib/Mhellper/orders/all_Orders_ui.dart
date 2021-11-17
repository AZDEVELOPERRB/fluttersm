import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/Single_Order.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/vendor_dashboard.dart';
class All_Orders_Ui extends StatefulWidget {
  String Shop_id;
  String User_id;
  bool is_notification;
  String order_id;

  All_Orders_Ui(this.Shop_id, this.User_id,{this.is_notification,this.order_id});

  @override
  _All_Orders_UiState createState() => _All_Orders_UiState();
}

class _All_Orders_UiState extends State<All_Orders_Ui> {

  Markets_repo MH=Markets_repo();
  Products_repo PH=Products_repo();

int _dataCounter=10;
bool switcher=false;
  bool is_load=false;

  @override
  getAll_Orders()async{
    var data=await PH.All_Orders_for_vendor(widget.Shop_id,'${_dataCounter}',widget.is_notification,widget.order_id);

    return data;
  }
  getAll_Orders_tow()async{
    var data=await PH.All_Orders_for_vendor(widget.Shop_id,'${_dataCounter}',widget.is_notification,widget.order_id);
    return data;
  }
  check_data_count(int _inside ,int outside){
    if(_inside<=outside){
      return true;
    }
    return false;
  }
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: switcher?getAll_Orders():getAll_Orders_tow(),
        builder: (ctx,snap){
          if(snap.hasData){
            var Orders_Data=snap.data['message']['data'];
            if(snap.data['message']['msg']=='no_orders'){
              return Container(
               child:  Center(
                 child: Text('لا توجد طلبات في الوقت الحالي'),
               ),
              );
            }
            else{

              return Container(
                child: ListView.builder(
                    itemCount: Orders_Data.length+1,
                    itemBuilder: (context ,item){
                 if(item==Orders_Data.length){
                   if(widget.is_notification==false) {
                     return Center(
                       child: RaisedButton(
                         color: Colors.black87,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(15)
                         ),
                         child: is_load == true ? Text(
                           'يرجى الانتظار جاري تحميل المزيد',
                           style: TextStyle(color: Colors.white),) : Text(
                           'تحميل المزيد',
                           style: TextStyle(color: Colors.white),),
                         onPressed: () {
                           Fluttertoast.showToast(
                               msg:
                               'جاري تحميل المزيد',
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.BOTTOM,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.green,
                               textColor: Colors.white);

                           var checker = check_data_count(_dataCounter,
                               int.parse(
                                   '${snap.data['message']['data_count']}'));

                           if (checker == true) {
                             setState(() {
                               _dataCounter += 20;
                               if (switcher == false) {
                                 switcher = true;
                               }
                               else {
                                 switcher = false;
                               }
                             });
                           }
                           else {
                             Fluttertoast.showToast(
                                 msg:
                                 'لا يوجد المزيد فهذه كل البيانات',
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: Colors.red,
                                 textColor: Colors.white);
                           }
                         },
                       ),
                     );
                   }else{
                     return Container();
                   }
                   }
                      return Column(

                        children: [

                          if(item==0) RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                              ,
                            ),
                            color: Colors.black87,
                            child:Text('رجوع',style: TextStyle(color: Colors.white),) ,
                            onPressed: (){
                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: (ctx)=>Vendor_Dashboard(widget.User_id)
                              // ));

                              Navigator.pop(context);

                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),

                                  border: Border.all(color: Colors.blueAccent)                          ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [

                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                            ,
                                      ),
                                      color: Colors.blue,
                                      child:Text('تفاصيل',style: TextStyle(color: Colors.white),) ,
                                      onPressed: (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(
                                          builder: (ctx)=>Single_Order(widget.User_id,widget.Shop_id,Orders_Data[item])
                                        ));

                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(child: Text('الزبون :  ${Orders_Data[item]['headers']['contact_name']}',style: TextStyle(color: Colors.black87),),),
                                          Container(child: Text('رقمه :  ${Orders_Data[item]['headers']['contact_phone']}',style: TextStyle(color: Colors.black87),),),

                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(child: Text('عنوانه :  ${Orders_Data[item]['headers']['contact_address']}',style: TextStyle(color: Colors.brown),),),

                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [

                                            Container(child: Text('المنتج :  ${Orders_Data[item]['details']['product_name']}',style: TextStyle(color: Colors.indigoAccent),),),

                                          ],
                                        ),
                                      ),
                                    ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Text('حالة الطلب :'),
                                     ),
                                     Container(
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(10),
                                         color: Orders_Data[item]['state']['final_stage']=='1'?Colors.green:Orders_Data[item]['state']['start_stage']=='1'?Colors.red:Colors.black87,

                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text('${Orders_Data[item]['state']['title']}',style: TextStyle(color: Colors.white),),
                                       ),

                                     ),

                                   ],
                                 )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })
              );
            }
          }
          else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  Text('جاري تحضير جميع الطلبات')

                ],
              ),
            );
          }
        },
      )
    );
  }
}
