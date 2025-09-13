class RoutePath {
  static const String login = '/login/login_screen';

  static const String home = '/';
  static const String albumAdd = '/album/add';
  static const String albumSetting = '/album/:albumId/setting';

  static const String myPage = '/my_page/my_page_screen';
  static const String myPage_notice = '/my_page/notice/notice_screen';
  static const String myPage_subscription_payment_info =
      '/my_page/subscription_payment_info/subscription_payment_info_screen';
  static const String myPage_address_management =
      '/my_page/address_management/address_management_screen';
  static const String myPage_add_address =
      '/my_page/address_management/add_address_screen';
  static const String myPage_subscription_history =
      '/my_page/album_subscription_history/album_subscription_history_screen';
  static const String myPage_album_payment_info =
      '/my_page/album_payment_info/album_payment_info_screen';
  static const String myPage_payment_info = '/my_page/album_payment_info/info/payment_info_screen';
  static const String myPage_setting = '/my_page/settings/setting_screen';
  static const String myPage_delete_account =
      '/my_page/delete_account/delete_account_screen';

  static const String event = '/event/event_main_screen';
  static const String eventList = '/event/event_list_screen';

  static const String store = '/store/store_main_screen';
  static const String store_subs_info = '/store/subscription/store_subs_info';
  static const String payment_method = '/store/subscription/payment_method_screen';
  static const String payment_complete = '/store/subscription/payment_complete_screen';

  static const String photo_printing = '/store/photo_printing/photo_printing_screen';
  static const String select_album = '/store/photo_printing/service_step/select_album/select_album_screen';
  static const String select_image = '/store/photo_printing/service_step/select_image/select_image_screen';
  static const String select_option = '/store/photo_printing/service_step/select_option/select_option_screen';
  static const String select_address = '/store/photo_printing/service_step/select_address/select_address_screen';
  static const String change_address = '/store/photo_printing/service_step/change_address/change_address_screen';
  static const String select_payment = '/store/photo_printing/service_step/select_payment/select_payment_screen';

  static const albumDetail = '/album/:albumId';
}
