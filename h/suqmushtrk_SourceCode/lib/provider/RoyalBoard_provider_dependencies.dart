import 'package:RoyalBoard_Common_sooq/db/about_app_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/shipping_area_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/shop_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/shop_map_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/shop_rating_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/transaction_status_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/about_app_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/delete_task_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/shipping_area_repository.dart';
import 'package:RoyalBoard_Common_sooq/db/basket_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/category_map_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/comment_detail_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/comment_header_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/favourite_product_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/gallery_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/history_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/product_collection_header_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/rating_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/user_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/user_login_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/notification_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/basket_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/clear_all_data_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/comment_detail_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/comment_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/contact_us_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/coupon_discount_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/gallery_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/history_repsitory.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_collection_repository.dart';
import 'package:RoyalBoard_Common_sooq/db/blog_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/shop_info_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/transaction_detail_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/transaction_header_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/blog_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/rating_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_info_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_rating_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/shop_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/tansaction_detail_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/token_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_header_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/transaction_status_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/user_repository.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/common/ps_value_holder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_api_service.dart';
import 'package:RoyalBoard_Common_sooq/db/cateogry_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/common/ps_shared_preferences.dart';
import 'package:RoyalBoard_Common_sooq/db/noti_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/sub_category_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/product_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/product_map_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/app_info_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/category_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/language_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/noti_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/product_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/ps_theme_repository.dart';
import 'package:RoyalBoard_Common_sooq/repository/sub_category_repository.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<RoyalBoardApiService>.value(value: RoyalBoardApiService()),
  Provider<CategoryDao>.value(value: CategoryDao()),
  Provider<CategoryMapDao>.value(value: CategoryMapDao.instance),
  Provider<SubCategoryDao>.value(
      value: SubCategoryDao()), //wrong type not contain instance
  Provider<ProductDao>.value(
      value: ProductDao.instance), //correct type with instance
  Provider<ProductMapDao>.value(value: ProductMapDao.instance),
  Provider<NotiDao>.value(value: NotiDao.instance),
  Provider<ProductCollectionDao>.value(value: ProductCollectionDao.instance),
  Provider<ShopInfoDao>.value(value: ShopInfoDao.instance),
  Provider<BlogDao>.value(value: BlogDao.instance),
  Provider<TransactionHeaderDao>.value(value: TransactionHeaderDao.instance),
  Provider<TransactionDetailDao>.value(value: TransactionDetailDao.instance),
  Provider<TransactionStatusDao>.value(value: TransactionStatusDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<UserLoginDao>.value(value: UserLoginDao.instance),
  Provider<CommentHeaderDao>.value(value: CommentHeaderDao.instance),
  Provider<CommentDetailDao>.value(value: CommentDetailDao.instance),
  Provider<RatingDao>.value(value: RatingDao.instance),
  Provider<ShopRatingDao>.value(value: ShopRatingDao.instance),
  Provider<HistoryDao>.value(value: HistoryDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<ShippingAreaDao>.value(value: ShippingAreaDao.instance),
  Provider<BasketDao>.value(value: BasketDao.instance),
  Provider<ShopDao>.value(value: ShopDao.instance),
  Provider<AboutAppDao>.value(value: AboutAppDao.instance),
  Provider<ShopMapDao>.value(value: ShopMapDao.instance),
  Provider<FavouriteProductDao>.value(value: FavouriteProductDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<RoyalBoardApiService, AppInfoRepository>(
    update:
        (_, RoyalBoardApiService _RoyalBoardApiService, AppInfoRepository appInfoRepository) =>
            AppInfoRepository(RoyalBoardApiService: _RoyalBoardApiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider2<RoyalBoardApiService, CategoryDao, CategoryRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, CategoryDao categoryDao,
            CategoryRepository categoryRepository2) =>
        CategoryRepository(
            RoyalBoardApiService: RoyalBoardApiService, categoryDao: categoryDao),
  ),
  ProxyProvider2<RoyalBoardApiService, AboutAppDao, AboutAppRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, AboutAppDao aboutUsDao,
            AboutAppRepository aboutUsRepository) =>
        AboutAppRepository(RoyalBoardApiService: RoyalBoardApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider2<RoyalBoardApiService, SubCategoryDao, SubCategoryRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, SubCategoryDao subCategoryDao,
            SubCategoryRepository subCategoryRepository) =>
        SubCategoryRepository(
            RoyalBoardApiService: RoyalBoardApiService, subCategoryDao: subCategoryDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ProductCollectionDao,
      ProductCollectionRepository>(
    update: (_,
            RoyalBoardApiService RoyalBoardApiService,
            ProductCollectionDao productCollectionDao,
            ProductCollectionRepository productCollectionRepository) =>
        ProductCollectionRepository(
            RoyalBoardApiService: RoyalBoardApiService,
            productCollectionDao: productCollectionDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ShopDao, ShopRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, ShopDao shopDao,
            ShopRepository shopRepository) =>
        ShopRepository(RoyalBoardApiService: RoyalBoardApiService, shopDao: shopDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ProductDao, ProductRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, ProductDao productDao,
            ProductRepository categoryRepository2) =>
        ProductRepository(RoyalBoardApiService: RoyalBoardApiService, productDao: productDao),
  ),
  ProxyProvider2<RoyalBoardApiService, NotiDao, NotiRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, NotiDao notiDao,
            NotiRepository notiRepository) =>
        NotiRepository(RoyalBoardApiService: RoyalBoardApiService, notiDao: notiDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ShopInfoDao, ShopInfoRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, ShopInfoDao shopInfoDao,
            ShopInfoRepository shopInfoRepository) =>
        ShopInfoRepository(
            RoyalBoardApiService: RoyalBoardApiService, shopInfoDao: shopInfoDao),
  ),
  ProxyProvider<RoyalBoardApiService, NotificationRepository>(
    update:
        (_, RoyalBoardApiService RoyalBoardApiService, NotificationRepository userRepository) =>
            NotificationRepository(
      RoyalBoardApiService: RoyalBoardApiService,
    ),
  ),
  ProxyProvider3<RoyalBoardApiService, UserDao, UserLoginDao, UserRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, UserDao userDao,
            UserLoginDao userLoginDao, UserRepository userRepository) =>
        UserRepository(
            RoyalBoardApiService: RoyalBoardApiService,
            userDao: userDao,
            userLoginDao: userLoginDao),
  ),
  ProxyProvider<RoyalBoardApiService, ClearAllDataRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService,
            ClearAllDataRepository clearAllDataRepository) =>
        ClearAllDataRepository(),
  ),
  ProxyProvider<RoyalBoardApiService, DeleteTaskRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService,
            DeleteTaskRepository deleteTaskRepository) =>
        DeleteTaskRepository(),
  ),
  ProxyProvider2<RoyalBoardApiService, BlogDao, BlogRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, BlogDao blogDao,
            BlogRepository blogRepository) =>
        BlogRepository(RoyalBoardApiService: RoyalBoardApiService, blogDao: blogDao),
  ),
  ProxyProvider2<RoyalBoardApiService, TransactionHeaderDao,
      TransactionHeaderRepository>(
    update: (_,
            RoyalBoardApiService RoyalBoardApiService,
            TransactionHeaderDao transactionHeaderDao,
            TransactionHeaderRepository transactionRepository) =>
        TransactionHeaderRepository(
            RoyalBoardApiService: RoyalBoardApiService,
            transactionHeaderDao: transactionHeaderDao),
  ),
  ProxyProvider2<RoyalBoardApiService, TransactionDetailDao,
      TransactionDetailRepository>(
    update: (_,
            RoyalBoardApiService RoyalBoardApiService,
            TransactionDetailDao transactionDetailDao,
            TransactionDetailRepository transactionDetailRepository) =>
        TransactionDetailRepository(
            RoyalBoardApiService: RoyalBoardApiService,
            transactionDetailDao: transactionDetailDao),
  ),
  ProxyProvider2<RoyalBoardApiService, TransactionStatusDao,
      TransactionStatusRepository>(
    update: (_,
            RoyalBoardApiService RoyalBoardApiService,
            TransactionStatusDao transactionStatusDao,
            TransactionStatusRepository transactionStatusRepository) =>
        TransactionStatusRepository(
            RoyalBoardApiService: RoyalBoardApiService,
            transactionStatusDao: transactionStatusDao),
  ),
  ProxyProvider2<RoyalBoardApiService, CommentHeaderDao, CommentHeaderRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, CommentHeaderDao commentHeaderDao,
            CommentHeaderRepository commentHeaderRepository) =>
        CommentHeaderRepository(
            RoyalBoardApiService: RoyalBoardApiService, commentHeaderDao: commentHeaderDao),
  ),
  ProxyProvider2<RoyalBoardApiService, CommentDetailDao, CommentDetailRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, CommentDetailDao commentDetailDao,
            CommentDetailRepository commentHeaderRepository) =>
        CommentDetailRepository(
            RoyalBoardApiService: RoyalBoardApiService, commentDetailDao: commentDetailDao),
  ),
  ProxyProvider2<RoyalBoardApiService, RatingDao, RatingRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, RatingDao ratingDao,
            RatingRepository ratingRepository) =>
        RatingRepository(RoyalBoardApiService: RoyalBoardApiService, ratingDao: ratingDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ShopRatingDao, ShopRatingRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, ShopRatingDao shopRatingDao,
            ShopRatingRepository shopRatingRepository) =>
        ShopRatingRepository(
            RoyalBoardApiService: RoyalBoardApiService, shopRatingDao: shopRatingDao),
  ),
  ProxyProvider2<RoyalBoardApiService, HistoryDao, HistoryRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, HistoryDao historyDao,
            HistoryRepository historyRepository) =>
        HistoryRepository(historyDao: historyDao),
  ),
  ProxyProvider2<RoyalBoardApiService, GalleryDao, GalleryRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, RoyalBoardApiService: RoyalBoardApiService),
  ),
  ProxyProvider<RoyalBoardApiService, ContactUsRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(RoyalBoardApiService: RoyalBoardApiService),
  ),
  ProxyProvider2<RoyalBoardApiService, BasketDao, BasketRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, BasketDao basketDao,
            BasketRepository historyRepository) =>
        BasketRepository(basketDao: basketDao),
  ),
  ProxyProvider2<RoyalBoardApiService, ShippingAreaDao, ShippingAreaRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, ShippingAreaDao shippingAreaDao,
            ShippingAreaRepository shippingAreaRepository) =>
        ShippingAreaRepository(
            RoyalBoardApiService: RoyalBoardApiService, shippingAreaDao: shippingAreaDao),
  ),
  ProxyProvider<RoyalBoardApiService, CouponDiscountRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService,
            CouponDiscountRepository couponDiscountRepository) =>
        CouponDiscountRepository(RoyalBoardApiService: RoyalBoardApiService),
  ),
  ProxyProvider<RoyalBoardApiService, TokenRepository>(
    update: (_, RoyalBoardApiService RoyalBoardApiService, TokenRepository tokenRepository) =>
        TokenRepository(RoyalBoardApiService: RoyalBoardApiService),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<PsValueHolder>(
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).psValueHolder,
  )
];
