import 'package:RoyalBoard_Common_sooq/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_constants.dart';
import 'package:RoyalBoard_Common_sooq/furjt_secttion/furjt_list.dart';
import 'package:RoyalBoard_Common_sooq/ui/category/item/category_vertical_list_item.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_admob_banner_widget.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/firm_prices.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rollet_switch.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/home/new_afrad_section.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/chose_your_heading.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/category_parameter_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/provider/category/category_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/category_repository.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_ui_widget.dart';
import 'package:RoyalBoard_Common_sooq/provider/user/user_provider.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/DPr/get_m.dart';
import 'package:flutter/services.dart';
import 'package:RoyalBoard_Common_sooq/api/ENC_RoyalServices.dart';

class CategoryListMarkets extends StatefulWidget {
  String userid;
  CategoryListMarkets(this.userid);

  @override
  _CategoryListViewState createState() {


    return _CategoryListViewState(userid);
  }
}

class _CategoryListViewState extends State<CategoryListMarkets>
    with TickerProviderStateMixin {
  String userid;
  _CategoryListViewState(this.userid);
  final ScrollController _scrollController = ScrollController();
  CategoryProvider _categoryProvider;
  CategoryProvider _categoryProvider_mufrad;
  final CategoryParameterHolder categoryParameterHolder =
      CategoryParameterHolder().getLatestParameterHolder();
  final CategoryParameterHolder categoryParameterHolder_mufrad =
  CategoryParameterHolder().getLatestParameterHolder();


  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }
  ScrollController    _scrollControllerse;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider.nextCategoryList(categoryParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: RoyalBoardConfig.animation_duration, vsync: this);

    super.initState();
    _scrollControllerse = ScrollController();

  }

  CategoryRepository repo1;
  CategoryRepository repo2;
  PsValueHolder psValueHolder;
  dynamic data;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && RoyalBoardConfig.showAdMob) {
        setState(() {});
      }
    });
  }
  ScrollController  _sc=ScrollController();

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);

  final UserProvider userprovid=provider;


    if (!isConnectedToInternet && RoyalBoardConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() async{

      return showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'home__quit_dialog_description'),
                leftButtonText: Utils.getString(
                    context, 'app_info__cancel_button_name'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () {
                  SystemNavigator.pop();
                });
          })
          ??
          false;

       ConfirmDialogView(
          description: Utils.getString(
              context, 'home__quit_dialog_description'),
          leftButtonText: Utils.getString(
              context, 'app_info__cancel_button_name'),
          rightButtonText: Utils.getString(context, 'dialog__ok'),
          onAgreeTap: () {
            SystemNavigator.pop();
          });
      // animationController.reverse().then<dynamic>(
      //   (void data) {
      //     if (!mounted) {
      //       return Future<bool>.value(false);
      //     }
      //     Navigator.pop(context, true);
      //     return Future<bool>.value(true);
      //   },
      // );
      // return Future<bool>.value(false);
    }

    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<CategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              final CategoryProvider provider =
                  CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
              provider.loadCategoryList(categoryParameterHolder);
              _categoryProvider = provider;
              return _categoryProvider;
            },
            child:ChangeNotifierProvider<UserProvider>(
              lazy: false,
              create: (BuildContext context) {
                print(provider.getCurrentFirebaseUser());
                if (provider.psValueHolder.loginUserId == null ||
                    provider.psValueHolder.loginUserId == '') {
                  provider.getUser(provider.psValueHolder.loginUserId);
                } else {
                  provider.getUser(provider.psValueHolder.loginUserId);
                }
                return provider;
              },
            child:



            Consumer<CategoryProvider>(builder: (BuildContext context,
                CategoryProvider provider, Widget child) {
              return Stack(children: <Widget>[
                Column(children: <Widget>[

                  const PsAdMobBannerWidget(),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[



                                SliverPadding(
                                    padding: EdgeInsets.all(0),
                                    sliver :SliverList(
                                      delegate: SliverChildListDelegate(
                                          [
                                        Column(
                                          children: [
                                            Container(
                                                height: 50,


                                                padding:EdgeInsets.only(right: 25, ),
                                                child:Consumer<UserProvider>(builder:
                                                    (BuildContext context, UserProvider userprovid, Widget child) {
                                                  if(userprovid.user !=null && userprovid.user.data!=null){
                                                    return ListView(
                                                      itemExtent: 80.0,


                                                      scrollDirection: Axis.horizontal,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Row(children: <Widget>[
                                                              Text('بطاقاتي:'),Container(height: 15,child: Text('${  userprovid.user.data.cross_card}'))
                                                            ],), SizedBox(width: 4,),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 4,),
                                                            Container(width: 20,
                                                              child: Image.asset('assets/images/jawhara.png'),),
                                                            userprovid.user.data.rolletua!=null? Text(' : ${userprovid.user.data.rolletua}'):Text(''),

                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 4,),
                                                            Container(width: 20,
                                                              child: Image.asset('assets/images/pers.png'),),Text(':'),
                                                            //         userprovid.user.data.ua!=null?    Container(height: 30,
                                                            // child: Image.asset('assets/images/silver_m.png'),):Text(''),
                                                            Container(height: 25,
                                                                child: userprovid.user.data.all_ua!=null?double.parse('${userprovid.user.data.all_ua}')>=50000&&double.parse('${userprovid.user.data.all_ua}')<100000?Image.asset('assets/images/bronze_m.png')
                                                                    :double.parse('${userprovid.user.data.all_ua}')>=100000&&double.parse('${userprovid.user.data.all_ua}')<250000?Image.asset('assets/images/silver_m.png'):double.parse('${userprovid.user.data.all_ua}')
                                                                    >=250000?Image.asset('assets/images/golden_m.png'):Text(''):Text('')



                                                            )
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [

                                                            Row(
                                                              children: [
                                                                SizedBox(width: 4,),
                                                                Container(width: 20,
                                                                  child: Image.asset('assets/images/gifgift.png'),),Text(':'),SizedBox(width: 2,),
                                                                //         userprovid.user.data.ua!=null?    Container(height: 30,
                                                                // child: Image.asset('assets/images/silver_m.png'),):Text(''),
                                                                // userprovid.user.data.all_ua!=null?  Text('${NumberFormat.compact().format(double.parse('${userprovid.user.data.all_ua}'))}'):Text('')
                                                                userprovid.user.data.all_ua!=null?  Text('${userprovid.user.data.all_ua.toString().replaceAll(RegExp(r"000"), "")}'):Text('')
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  else{
                                                    return ListView(
                                                      itemExtent: 87.0,


                                                      scrollDirection: Axis.horizontal,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Row(children: <Widget>[
                                                              Text('بطاقاتي:'),Container(height: 15,child: Text('0'),)
                                                            ],), SizedBox(width: 4,),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 4,),
                                                            Container(width: 20,
                                                              child: Image.asset('assets/images/jawhara.png'),),Text(':'),
                                                            Text('0'),

                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 4,),
                                                            Container(width: 20,
                                                              child: Image.asset('assets/images/pers.png'),),Text(':'),
                                                            //         userprovid.user.data.ua!=null?    Container(height: 30,
                                                            // child: Image.asset('assets/images/silver_m.png'),):Text(''),
                                                            Container(height: 16,
                                                                child:Text('0'))
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [

                                                            Row(
                                                              children: [
                                                                SizedBox(width: 4,),
                                                                Container(width: 20,
                                                                  child: Image.asset('assets/images/gifgift.png'),),Text(':'),SizedBox(width: 2,),
                                                                //         userprovid.user.data.ua!=null?    Container(height: 30,
                                                                // child: Image.asset('assets/images/silver_m.png'),):Text(''),
                                                                Text('0')
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                }


                                                )
                                            ),
                                            Consumer<UserProvider>(builder:
                                                (BuildContext context, UserProvider userprovid, Widget child) {
                                              if(userprovid.user !=null && userprovid.user.data!=null&&userprovid.timenow!=null){
                                                DateTime permis=userprovid.timenow.subtract(const Duration(hours: 4));
                                                DateTime Hour_clicked;
                                                if(userprovid.user.data.hour_clicked!=0&&userprovid.user.data.hour_clicked!=null&&userprovid.user.data.hour_clicked!='0'&&userprovid.user.data.hour_clicked!=''&&userprovid.user.data.hour_clicked!='null'){
                                                  Hour_clicked  =DateTime.parse('${userprovid.user.data.hour_clicked}');
                                                }
                                                else {
                                                  Hour_clicked=userprovid.timenow.subtract(Duration(hours: 5));
                                                }

                                                return   Container(
                                                  height: 82,

                                                  child:  ListView(
                                                    shrinkWrap: false,

                                                    itemExtent: 122.0,
                                                    controller: _sc,


                                                    scrollDirection: Axis.horizontal,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: (){

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => RoSwitch(userid)),
                                                          );
                                                        },
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(

                                                                height: 50,
                                                                width: MediaQuery.of(context).size.width / 2.2,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child:Image.asset('assets/images/giphy.gif'),
                                                                  /* Image.asset(
                "$img",
                fit: BoxFit.cover,
              ),*/
                                                                ),
                                                              ),
                                                              SizedBox(height: 4,),


                                                              Text('عجلة الحظ')
                                                            ],


                                                          ),
                                                        ),
                                                      ),


                                                      GestureDetector(
                                                        onTap: (){
                                                          print('safsafgdsgsad');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => RoGame(userid,userid)),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(0.1),
                                                          child: GestureDetector(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> GetMoney(userid)));
                                                            },
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: <Widget>[
                                                                  SizedBox(height: 4,),

                                                                  Stack(
                                                                    children:<Widget>[
                                                                      Container(

                                                                        height: 35,
                                                                        width: MediaQuery.of(context).size.width / 2.2,
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child:Image.asset('assets/images/waa.png'),
                                                                          /* Image.asset(
                "$img",
                fit: BoxFit.cover,
              ),*/
                                                                        ),
                                                                      ),

                                                                      if ( permis.isAfter(Hour_clicked))
                                                                        Container(
                                                                          height: 35,
                                                                          child: Center(child:
                                                                          InkWell(
                                                                              onTap:(){

                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => GetMoney(userid)),
                                                                                );
                                                                              },

                                                                              child: Image.asset('assets/images/notball.gif'))
                                                                          ),
                                                                        ),
                                                                      // if ( DateTime.now().hour>=0&&DateTime.now().hour<4&&permis.isAfter(Hour_clicked))             Container(
                                                                      //   height: 40,
                                                                      //   child: Center(child:
                                                                      //   InkWell(
                                                                      //       onTap:(){
                                                                      //
                                                                      //         Navigator.push(
                                                                      //           context,
                                                                      //           MaterialPageRoute(builder: (context) => GetMoney(userid)),
                                                                      //         );
                                                                      //       },
                                                                      //
                                                                      //       child: Image.asset('assets/images/notball.gif'))
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                  Text('رصيدك '),
                                                                  userprovid.user.data.ua!=null?  Text(
                                                                      '${NumberFormat.compact().format(double.parse('${userprovid.user.data.ua}'))}'):Text('سحل دخول'),
                                                                  // Container(
                                                                  //   width: 65,
                                                                  //   height: 25,
                                                                  //   child: DecoratedBox(
                                                                  //     decoration: const BoxDecoration(color: Color(0xfff9a825)
                                                                  //     ,borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  //
                                                                  //
                                                                  //     child: Container(
                                                                  //       margin: EdgeInsets.all(3),
                                                                  //       child: Text(
                                                                  //         '500 دينار',
                                                                  //         textAlign: TextAlign.start,
                                                                  //         style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                  //             color: Colors.white, fontWeight: FontWeight.bold,
                                                                  //         fontSize: 15),
                                                                  //       ),
                                                                  //     )
                                                                  //   ),
                                                                  // ),






                                                                ],


                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      ,
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => checkpoiint(userid
                                                            )),
                                                          );
                                                        },
                                                        child:  Padding(
                                                          padding: const EdgeInsets.all(0.1),
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(

                                                                  height: 50,
                                                                  width: MediaQuery.of(context).size.width / 2.2,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: DecorationImage(
                                                                          image: AssetImage('assets/images/fgif.gif')
                                                                      )

                                                                  ),
                                                                ),



                                                                Text(' فرم الاسعار')
                                                              ],


                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      ,
                                                    ],
                                                  ),
                                                );}
                                              else {
                                                return  Container(
                                                  height: 100,

                                                  child: ListView(
                                                    itemExtent: 122.0,


                                                    scrollDirection: Axis.horizontal,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: (){

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => RoSwitch(userid)),
                                                          );
                                                        },
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(

                                                                height: 65,
                                                                width: MediaQuery.of(context).size.width / 2.2,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child:Image.asset('assets/images/giphy.gif'),
                                                                  /* Image.asset(
                "$img",
                fit: BoxFit.cover,
              ),*/
                                                                ),
                                                              ),
                                                              SizedBox(height: 4,),


                                                              Text('عجلة الحظ')
                                                            ],


                                                          ),
                                                        ),
                                                      ),
              //                                         GestureDetector(
              //                                           onTap: (){
              //
              //                                             Navigator.push(
              //                                               context,
              //                                               MaterialPageRoute(builder: (context) => Furjt_List()),
              //                                             );
              //                                           },
              //                                           child: SingleChildScrollView(
              //                                             child: Column(
              //                                               children: <Widget>[
              //                                                 Container(
              //
              //                                                   height: 65,
              //                                                   width: MediaQuery.of(context).size.width / 2.2,
              //                                                   child: ClipRRect(
              //                                                     borderRadius: BorderRadius.circular(8.0),
              //                                                     child:Image.asset('assets/images/furjt.png'),
              //                                                     /* Image.asset(
              //   "$img",
              //   fit: BoxFit.cover,
              // ),*/
              //                                                   ),
              //                                                 ),
              //                                                 SizedBox(height: 4,),
              //
              //
              //                                                 Text('فرجت')
              //                                               ],
              //
              //
              //                                             ),
              //                                           ),
              //                                         ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          print('safsafgdsgsad');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => RoGame(userid,userid)),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(0.1),
                                                          child: GestureDetector(
                                                            onTap: (){
                                                              Fluttertoast.showToast(
                                                                  msg: '   يجب تسجيل الدخول  ',
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.BOTTOM,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white

                                                              );
                                                            },
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: <Widget>[
                                                                  SizedBox(height: 10,),
                                                                  Container(

                                                                    height: 40,
                                                                    width: MediaQuery.of(context).size.width / 2.2,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                      child:Image.asset('assets/images/waa.png'),
                                                                      /* Image.asset(
                "$img",
                fit: BoxFit.cover,
              ),*/
                                                                    ),
                                                                  ),
                                                                  Text('رصيدك '),
                                                                  Text('0'),
                                                                  // Container(
                                                                  //   width: 65,
                                                                  //   height: 25,
                                                                  //   child: DecoratedBox(
                                                                  //     decoration: const BoxDecoration(color: Color(0xfff9a825)
                                                                  //     ,borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  //
                                                                  //
                                                                  //     child: Container(
                                                                  //       margin: EdgeInsets.all(3),
                                                                  //       child: Text(
                                                                  //         '500 دينار',
                                                                  //         textAlign: TextAlign.start,
                                                                  //         style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                  //             color: Colors.white, fontWeight: FontWeight.bold,
                                                                  //         fontSize: 15),
                                                                  //       ),
                                                                  //     )
                                                                  //   ),
                                                                  // ),






                                                                ],


                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      ,
                                                      GestureDetector(
                                                        onTap: (){
                                                          Fluttertoast.showToast(
                                                              msg: '   يجب تسجيل الدخول  ',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                              backgroundColor: Colors.red,
                                                              textColor: Colors.white

                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(0.1),
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(

                                                                  height: 50,
                                                                  width: MediaQuery.of(context).size.width / 2.2,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: DecorationImage(
                                                                          image: AssetImage('assets/images/fgif.gif')
                                                                      )

                                                                  ),
                                                                ),



                                                                Text(' فرم الاسعار')
                                                              ],


                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      ,
                                                    ],
                                                  ),
                                                );
                                              }}),
                                            Container(
                                            height: 85,
                                            child: ListView(

                                            itemExtent: 122.0,
                                              controller: _sc,

                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ChangeNotifierProvider<CategoryProvider>(
                                                lazy: true,
                                                create: (BuildContext context) {
                                                  final CategoryProvider provider =
                                                  CategoryProvider(repo: repo2, psValueHolder: psValueHolder);
                                                  categoryParameterHolder_mufrad.isjomla='0';
                                                  provider.loadCategoryList(categoryParameterHolder_mufrad);
                                                  _categoryProvider_mufrad = provider;
                                                  return _categoryProvider_mufrad;
                                                },
                                              child: Consumer<CategoryProvider>(builder: (BuildContext context,
    CategoryProvider _secondProvider, Widget child) {

                                              return  GestureDetector(
                                                  onTap: (){
                                                    print('sfdlkgjsdlkgjdsgsalkdsagj${_secondProvider.categoryList.data.length}');

                                                    Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => NewAfradSection(

                                                        shopId: 'widget.shopId',
                                                        shopName:'قسم الافراد',
                                                        categoryList: _secondProvider.categoryList.data, //categoryProvider.categoryList.data,

                                                        valueHolder: psValueHolder,
                                                        key: Key('${_secondProvider.categoryList.data.length}')
                                                    )),
                                                    );
                                                  },
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(

                                                          height: 50,
                                                          width: MediaQuery.of(context).size.width / 2.2,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            child:Image.asset('assets/images/afrad.png'),
                                                            /* Image.asset(
                                                  "$img",
                                                  fit: BoxFit.cover,
                                                ),*/
                                                          ),
                                                        ),
                                                        SizedBox(height: 4,),


                                                        Text(' قسم الافراد')
                                                      ],


                                                    ),
                                                  ),
                                                );

              }

                                              ),
                                            ),
                                              GestureDetector(
                                                onTap: (){

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Furjt_List()),
                                                  );
                                                },
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(

                                                        height: 50,
                                                        width: MediaQuery.of(context).size.width / 2.2,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          child:Image.asset('assets/images/furjt.png'),
                                                          /* Image.asset(
                "$img",
                fit: BoxFit.cover,
              ),*/
                                                        ),
                                                      ),
                                                      SizedBox(height: 4,),


                                                      Text('فرجت')
                                                    ],


                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){


                                                },
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            image: AssetImage('assets/images/csoon.gif')
                                                          )

                                                        ),

                                                        height: 52,
                                                        width: MediaQuery.of(context).size.width / 2.2,
              //                                           child: ClipRRect(
              //                                             borderRadius: BorderRadius.circular(8.0),
              //                                             child:Image.asset('assets/images/csoon.gif'),
              //                                             /* Image.asset(
              //   "$img",
              //   fit: BoxFit.cover,
              // ),*/
              //                                           ),
                                                      ),
                                                      SizedBox(height: 4,),


                                                      Text('قريبا')
                                                    ],


                                                  ),
                                                ),
                                              ),

                                            ],),
                                            ),
                                            ChangeNotifierProvider<CategoryProvider>(
                                            lazy: true,
    create: (BuildContext context) {
    final CategoryProvider provider =
    CategoryProvider(repo: repo2, psValueHolder: psValueHolder);
    categoryParameterHolder_mufrad.isjomla='0';
    provider.loadCategoryList(categoryParameterHolder_mufrad);
    _categoryProvider_mufrad = provider;
    return _categoryProvider_mufrad;
    },
    child: Consumer<CategoryProvider>(builder: (BuildContext context,
    CategoryProvider _secondProvider, Widget child) {

     if(_secondProvider.categoryList.data!=null&&_secondProvider.categoryList.data.isNotEmpty){
       return   Container(
         width: MediaQuery.of(context).size.width,
         child: RaisedButton(
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(3)
           ),


           color: Colors.blue,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,

             children: [
               Text('التسوق للمواطنين , مرحباً بكم ',style: TextStyle(color: Colors.white),),
               SizedBox(width:20 ,),
               Icon(Icons.shopping_cart_outlined,color: Colors.white,)

             ],
           ),
           onPressed: (){
             Navigator.push(context, MaterialPageRoute(
                 builder: (ctx)=> NewAfradSection(

                     shopId: 'widget.shopId',
                     shopName:'قسم الافراد',
                     categoryList: _secondProvider.categoryList.data, //categoryProvider.categoryList.data,

                     valueHolder: psValueHolder,
                     key: Key('${_secondProvider.categoryList.data.length}')
                 )),
             );
           },
         ),
       );
     }
     else{
       return Container();
     }
    })),
                                          ],
                                        ),
                                      ]),
                                    )
                                ),
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.categoryList.data != null ||
                                          provider
                                              .categoryList.data.isNotEmpty) {
                                        final int count =
                                            provider.categoryList.data.length;
                                        return CategoryVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          category:
                                              provider.categoryList.data[index],
                                          onTap: () {


                                              final String loginUserId =
                                                  Utils.checkUserLoginId(
                                                      psValueHolder);
                                              final TouchCountParameterHolder
                                                  touchCountParameterHolder =
                                                  TouchCountParameterHolder(
                                                      typeId: provider
                                                          .categoryList
                                                          .data[index]
                                                          .id,
                                                      typeName: RoyalBoardConst
                                                          .FILTERING_TYPE_NAME_CATEGORY,
                                                      userId: loginUserId,
                                                      shopId: '');

                                              provider.postTouchCount(
                                                  touchCountParameterHolder
                                                      .toMap());
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder.catId =
                                                  provider.categoryList
                                                      .data[index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductmarkets,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .categoryList
                                                        .data[index]
                                                        .name,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                            }
                                          // },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:  provider.categoryList.data.length,
                                  )),]), onRefresh: () {return  provider.resetCategoryList(categoryParameterHolder);},)),),
                ]),
                Positioned(
                  bottom: 5,
                    left: 15,

                    child:
                    Container(


                      child: Consumer<UserProvider>(builder:
                          (BuildContext context, UserProvider userprovid, Widget child) {
                        if(userprovid.user !=null && userprovid.user.data!=null){
                          if(userprovid.user.data.shad=='0') {
                              return  ElevatedButton(
                                child: Text(
                                    "اضف متجرك مجاناً".toUpperCase(),
                                    style: TextStyle(fontSize: 14)
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(color: Colors.black)))),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChoseYourHeading(userprovid.user.data.userId)));
                                }
                            );
                          }
                          else{
                            return  ElevatedButton(
                                child: Text(
                                    "انشاء متجرك مجاناً".toUpperCase(),
                                    style: TextStyle(fontSize: 14)
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(color: Colors.black)
                                        )
                                    )
                                ),
                                onPressed: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChoseYourHeading(userprovid.user.data.userId)));
                                }
                            );
                          }
                        }
                        else{
                          return Container();
                        }
                      }),
                    ),

                  ),
                PSProgressIndicator(provider.categoryList.status)
              ]);
            }))));
  }
}
