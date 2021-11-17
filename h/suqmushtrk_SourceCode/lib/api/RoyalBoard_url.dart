import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';

class PsUrl {
  PsUrl._();

  ///
  /// APIs Url
  ///
  static const String ps_product_detail_url = 'rest/products/get';

  static const String ps_shipping_method_url =
      'rest/shippings/get/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}/';

  static const String ps_shipping_area_url = 'rest/shipping_areas/get';

  static const String ps_category_url = 'rest/categories/search_cat';

  static const String ps_about_app_url = 'rest/abouts/get';

  static const String ps_contact_us_url =
      'rest/contacts/add/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_image_upload_url =
      'rest/images/upload/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String Create_Shop_url =
      'rest/users/Create_newShop/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String shop_exist =
      'rest/users/check_shop_exist/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String shop_image_getter =
      'rest/users/shop_image_getter/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String dollar_and_pro =
      'rest/users/dollar_and_pro/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String categories_list_url =
      'rest/users/categories_list_url/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String update_vendor_info =
      'rest/users/update_vendor_info/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getVendorFirstScreen =
      'rest/users/getVendorFirstScreen/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getProducts_for_first_time =
      'rest/users/getProducts_for_first_time/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String delete_products_url =
      'rest/images/delete_product/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getProducts_for_pool =
      'rest/users/getProducts_for_pool/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getProducts_Detail_url =
      'rest/users/getProducts_Detail_url/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Update_Order_detail_url =
      'rest/users/Update_Detail_url/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getOrdersForVendor =
      'rest/users/getOrdersForVendor/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String ShippingArea_url =
      'rest/users/ShippingArea_all/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String delete_ship_area =
      'rest/users/deleteShippingArea/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Create_shipping_area =
      'rest/users/Create_shipping_area/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Single_Order_url =
      'rest/users/Single_OrderDetails/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String getAll_vendor_products =
      'rest/users/getAll_vendor_products/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Shipping_detail_single =
      'rest/users/Shipping_detail_single/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Create_product__now =
      'rest/users/Create_product_now/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Shop_products_list_limitted =
      'rest/users/Shop_products_list_limitted/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Create_Shop_Image_url =
      'rest/images/Create_new_Shop/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String Insert_new_product_images_url =
      'rest/images/Insert_new_product_images/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_collection_url = 'rest/collections/get';

  static const String ps_all_collection_url =
      'rest/products/all_collection_products';

  static const String ps_shop_url = 'rest/shops/search';
  static const String shops_of_cats_shop_url = 'rest/shops/getShopsforCats';

  static const String ps_post_ps_app_info_url =
      'rest/appinfo/get_delete_history/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_register_url =
      'rest/users/add/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_apple_login_url =
      'rest/users/apple_register/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_email_verify_url =
      'rest/users/verify/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_zone_shipping_method_url =
      'rest/shipping_zones/get_shipping_cost/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_login_url =
      'rest/users/login/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_forgot_password_url =
      'rest/users/reset/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_change_password_url =
      'rest/users/password_update/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String ps_postua =
      'rest/users/ua_update/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';
  static const String ua_change_post =
      'rest/users/ua_change/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_user_update_profile_url =
      'rest/users/profile_update/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_phone_login_url =
      'rest/users/phone_register/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_fb_login_url =
      'rest/users/facebook_register/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_google_login_url =
      'rest/users/google_register/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_resend_code_url =
      'rest/users/request_code/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_post_ps_touch_count_url =
      'rest/touches/add_touch/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_product_url = 'rest/products/search';

  static const String ps_products_search_url =
      'rest/products/search/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_subCategory_url = 'rest/subcategories/get';

  static const String ps_user_url = 'rest/users/get';

  static const String ps_noti_url = 'rest/notis/all_notis';

  static const String ps_shop_info_url = 'rest/shops/get/';

  static const String ps_bloglist_url = 'rest/feeds/get';

  static const String ps_transactionList_url = 'rest/transactionheaders/get';

  static const String ps_transactionDetail_url = 'rest/transactiondetails/get';

  static const String ps_transactionStatus_url = 'rest/transaction_status/get';

  static const String ps_shipping_country_url =
      'rest/shipping_zones/get_shipping_country';

  static const String ps_shipping_city_url =
      'rest/shipping_zones/get_shipping_city';

  static const String ps_relatedProduct_url =
      'rest/products/related_product_trending';

  static const String ps_commentList_url = 'rest/commentheaders/get';

  static const String ps_commentDetail_url = 'rest/commentdetails/get';

  static const String ps_commentHeaderPost_url =
      'rest/commentheaders/press/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_commentDetailPost_url =
      'rest/commentdetails/press/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_downloadProductPost_url =
      'rest/downloads/download_product/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_noti_register_url =
      'rest/notis/register/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_noti_post_url =
      'rest/notis/is_read/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_noti_unregister_url =
      'rest/notis/unregister/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_ratingPost_url =
      'rest/rates/add_rating/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_shop_ratingPost_url =
      'rest/shop_rates/add_shop_rating/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_ratingList_url = 'rest/rates/get';

  static const String ps_shop_ratinglist_url = 'rest/shop_rates/get';

  static const String ps_favouritePost_url =
      'rest/favourites/press/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_favouriteList_url = 'rest/products/get_favourite';

  static const String ps_gallery_url = 'rest/images/get';

  static const String ps_couponDiscount_url =
      'rest/coupons/check/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_token_url = 'rest/paypal/get_token';

  static const String ps_transaction_submit_url =
      'rest/transactionheaders/submit/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';

  static const String ps_collection_product_url =
      'rest/products/all_collection_products';
}
