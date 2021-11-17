import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_product.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
class all_vendor_products extends StatefulWidget {
  String Shop_id;
  String User_id;

  all_vendor_products(this.Shop_id,this.User_id);

  @override
  _all_vendor_productsState createState() => _all_vendor_productsState();
}

class _all_vendor_productsState extends State<all_vendor_products> {
  Markets_repo MH = Markets_repo();
  Products_repo products_st = Products_repo();
  String product_file = Files_Names.all_products_file;
  ScrollController _scrollController = ScrollController();
  int snapshot = 0;
  int data_count = 19;
  int maxcount;

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final updater = products_st.get_all_products_right_now(widget.Shop_id);
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(

      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Container(
                height: size.height / 20,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.black87,
                  child: Text('رجوع', style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              FutureBuilder(
                  future: getproducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Container(
                          width: size.width,
                          height: size.height,
                          child: Center(
                            child: Text('لا توجد اي منتجات'),
                          ),
                        );
                      }

                      return Container(
                        height: size.height / 1.1,

                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                            controller: _scrollController,
                            itemCount: data_count <= snapshot.data.length
                                ? data_count + 1
                                : snapshot.data.length + 1,
                            itemBuilder: (BuildContext ctx, index) {
                              if (index == snapshot.data.length) {
                                return RaisedButton(
                                  child: Text('لايوجد مزيد',
                                    style: TextStyle(color: Colors.white),),
                                  color: Colors.red,
                                  onPressed: () {
                                    print('dfhfdkslgjgj${snapshot
                                        .data[0]['prod_data']['id']}');
                                    setState(() {

                                    });
                                  },
                                );
                              } else if (index == data_count) {
                                return RaisedButton(
                                  color: Colors.teal,
                                  child: Text('تحميل المزيد'),
                                  onPressed: () {
                                    setState(() {
                                      int count_rest = snapshot.data.length -
                                          data_count;
                                      if (count_rest >= 10) {
                                        data_count += 10;
                                      }
                                      else {
                                        data_count += count_rest;
                                      }
                                    });
                                  },
                                );
                              }
                              else {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            Edit_product(
                                              shop_id: widget.Shop_id,
                                              user_id: widget.User_id,
                                              product_id: snapshot
                                                  .data[index]['prod_data']['id'],)
                                    ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [

                                        Positioned(
                                          right: 1,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                  width: size.width / 2,
                                                  color: Colors.black54,
                                                  child: Text('${snapshot
                                                      .data[index]['prod_data']['name']} ',
                                                    style: TextStyle(
                                                        color: Colors.white),)),
                                            ],
                                          ),
                                        ),
                                        if(snapshot
                                            .data[index]['prod_data']['is_offer'] ==
                                            '1') Positioned(
                                          left: 1,

                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(


                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(8.0),
                                                    child: Text('عرض ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white),),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          child: Container(
                                              color: snapshot
                                                  .data[index]['prod_data']['is_offer'] ==
                                                  '1' ? Colors.red : Colors
                                                  .green[400],
                                              child: Text(' السعر: ${snapshot
                                                  .data[index]['prod_data']['unit_price']} دينار عراقي',
                                                style: TextStyle(
                                                    color: Colors.white),)),
                                        ),

                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)
                                      , image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            '${RoyalBoardConfig
                                                .RoyalBoardImagesUrl}${snapshot
                                                .data[index]['img']}'),
                                        fit: BoxFit.fill
                                    ),

                                    ),

                                  ),
                                );
                              }
                            }),
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
                              child: Image.asset(
                                  'assets/images/noti_product.png'),
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
                            child: Text(
                                'جاري تحضير البيانات من خوادم الشركة ...'),
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

  getProductsforfirsttime() async {
    var fd = await products_st.getproductforfirsttime(widget.Shop_id);
    if (fd['message']['msg'] == 'no_products') {
      return [];
    }
    return fd['message']['data'];
  }

  getproducts() async {
    var check_insider_data = await MH.read_all_data_model(product_file);

    if (check_insider_data is String || check_insider_data == null) {
      return await getProductsforfirsttime();
    }
    else {
      if (check_insider_data is List) {
        if (check_insider_data.length == 0) {
          return await getProductsforfirsttime();
        }

        return check_insider_data;
      }
      else {
        return await getProductsforfirsttime();
      }
    }
  }
}
