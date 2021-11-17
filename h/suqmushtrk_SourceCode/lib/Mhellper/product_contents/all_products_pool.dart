import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_pool.dart';

class Products_pool extends StatefulWidget {
  String Shop_id;
  String User_id;
  String cat_id;

  Products_pool(this.Shop_id,this.cat_id,this.User_id);

  @override
  _all_vendor_productsState createState() => _all_vendor_productsState();
}

class _all_vendor_productsState extends State<Products_pool> {
  Markets_repo MH=Markets_repo();
  Products_repo products_st=Products_repo();
  String product_pool_file=Files_Names.all_products_pool_file;
  ScrollController _scrollController=ScrollController();
  int snapshot=0;
  int data_count=20;
  int maxcount;

  bool switcher=false;
  bool smalSwitcher=false;
  int servercount;


  @override

  initState() {
    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent-5){
        setState(() {
          data_count+10;
        });
      }
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    final updater=products_st.get_all_products_right_now(widget.Shop_id);
    var size=MediaQuery.of(context).size;
    return Scaffold(

      body:Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Container(
                height: size.height/20,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.black87,
                  child: Text('رجوع',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              FutureBuilder(
                  future: switcher==true?getproducts_tow():getproducts(),
                  builder: (context, snapshot) {

                    if(snapshot.hasData){

                      // int items=snapshot.data.length<=data_count?snapshot.data.length+1:data_count+1;


                      return Container(
                        height: size.height/1.1,

                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                            itemCount: snapshot.data.length+1,
                            itemBuilder: (BuildContext ctx, index) {
                              if(index==snapshot.data.length){
                                if(servercount!=null&&index==servercount){
                                  return Container(

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text('لا يوجد مزيد')),
                                    ),
                                  );
                                }

                                    return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25)
                                      ),
                                      child:smalSwitcher==true?Text('يرجى الانتظار جاري تحميل المزيد ',  style: TextStyle(color: Colors.white),): Text('تحميل المزيد',
                                        style: TextStyle(color: Colors.white),),
                                      color: Colors.blue,
                                      onPressed: () {
                                        setState(() {
                                          smalSwitcher=true;
                                          if(servercount!=null&&data_count+20<servercount){
                                            data_count += 20;
                                          }
                                          else{
                                            data_count=servercount;
                                          }

                                          if (switcher == false) {
                                            switcher = true;
                                          }
                                          else {
                                            switcher = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }

                              else {
                                return InkWell(
                                  onTap: (){

                                    Navigator.push(context,MaterialPageRoute(
                                        builder: (context)=>Edit_Pool(shop_id: widget.Shop_id,user_id: widget.User_id,product_id: snapshot.data[index]['prod_data']['id'],)
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [

                                        Positioned(
                                          right:1,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                  width: size.width/2,
                                                  color: Colors.black54,
                                                  child: Text('${snapshot.data[index]['prod_data']['name']} ',style: TextStyle(color: Colors.white),)),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          child: Container(
                                              color: Colors.red[400],
                                              child:snapshot.data[index]['prod_data']['shop_id']==widget.Shop_id?Text('هذا المنتج موجود في متجرك')


                                                  : Text(' السعر: ${snapshot.data[index]['prod_data']['unit_price']} دينار عراقي',style: TextStyle(color: Colors.white),)),
                                        ),

                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)
                                      ,image: DecorationImage(
                                        image:  CachedNetworkImageProvider( 'https://suqmshtrk.com/dashboardpanel/testing/controller/uploads/${snapshot.data[index]['img']}'),
                                        fit: BoxFit.fill
                                    ),

                                    ),

                                  ),
                                );
                              } }),
                      );

                    }
                    else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(

                              width: size.width / 2,
                              height: size.width / 2.5,
                              child: Image.asset('assets/images/noti_product.png'),
                            ),

                          )
                          ,
                          SizedBox(height: 10,),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),

                          ), SizedBox(height: 10,),

                          Center(
                            child: Text('جاري تحضير البيانات من خوادم الشركة ...'),
                          )
                          , Center(
                            child: Text(
                                'وسيتم تزويد جهازك بنظام الاستجابة السريع الآن '),
                          ),

                        ],
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  getproducts()async{
  var s=await products_st.products_pool_geter(widget.cat_id,data_count);

  smalSwitcher=false;
  servercount=s['count'];
return s['data'];

  }
  getproducts_tow()async{
    var s=await products_st.products_pool_geter(widget.cat_id,data_count);

        smalSwitcher=false;
        servercount=s['count'];


    return s['data'];

  }
}
