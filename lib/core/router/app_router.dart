import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/core/network/navigation_service.dart';
import 'package:cherrypic/data/login/repositories/auth_repository.dart';
import 'package:cherrypic/data/login/services/apple_auth_data_source.dart';
import 'package:cherrypic/data/login/services/auth_remote_data_source.dart';
import 'package:cherrypic/data/login/services/kakao_auth_data_source.dart';
import 'package:cherrypic/presentation/screens/event/event_list_detail/event_list_screen.dart';
import 'package:cherrypic/presentation/screens/event/event_main_screen.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/add_address_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/address_management_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/info/payment_info_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_subscription_history/album_subscription_history_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/delete_account/delete_account_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/my_page_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/notice/notice_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/settings/setting_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/album_payment_info_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/photo_printing_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/change_address/change_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/select_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_album/select_album_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_image/select_image_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_option/select_option_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/select_payment_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/payment_complete_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/payment_method_screen.dart';
import 'package:cherrypic/presentation/screens/store/store_main_screen.dart';
import 'package:cherrypic/presentation/screens/store/subscription/store_subs_info.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/screens/my_page/album_payment_info/album_payment_info_model.dart';
import '../../presentation/screens/my_page/album_payment_info/info/payment_info_view_model.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/login/login_view_model.dart';
import '../../presentation/screens/store/components/store_type_selector.dart';

// 앱바 고정 UI 레퍼
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(), body: child);
  }
}

// 경로별 화면 빌더 매핑 -> 여기 작성 필수!
final Map<String, GoRouterWidgetBuilder> routeBuilders = {
  RoutePath.login: (context, state) => ChangeNotifierProvider(
    create: (_) => LoginViewModel(
      AuthRepository(
        remoteDataSource: AuthRemoteDataSource(),
        kakaoDataSource: KakaoAuthDataSource(),
        appleDataSource: AppleAuthDataSource(),
      ),
    ),
    child: const LoginScreen(),
  ),

  RoutePath.home: (context, state) => const MainScreen(),
  RoutePath.albumAdd: (context, state) => const AlbumAddScreen(),

  // album
  RoutePath.albumDetail: (context, state) {
    final idStr =
        state.pathParameters['albumId'] ??
        state.uri.queryParameters['albumId'] ??
        '-1';
    final albumId = int.tryParse(idStr) ?? -1;
    return AlbumDetailScreen(albumId: albumId);
  },

  RoutePath.albumSetting: (context, state) {
    final idStr =
        state.pathParameters['albumId'] ??
        state.uri.queryParameters['albumId'] ??
        '-1';
    final albumId = int.tryParse(idStr) ?? -1;
    return AlbumEditScreen(albumId: albumId);
  },

  /// myPage
  RoutePath.myPage: (context, state) => const MyPageScreen(),
  RoutePath.myPage_notice: (context, state) => const NoticeScreen(),
  RoutePath.myPage_album_payment_info: (context, state) =>
      const AlbumPaymentInfoScreen(),
  RoutePath.myPage_payment_info: (context, state) {
    final item = state.extra as AlbumPaymentInfoModel;
    // final viewModel = state.extra as PaymentInfoViewModel;
    return PaymentInfoScreen(item: item, viewModel: PaymentInfoViewModel());
  },
  RoutePath.myPage_address_management: (context, state) =>
      const AddressManagementScreen(),
  RoutePath.myPage_add_address: (context, state) => const AddAddressScreen(),
  RoutePath.myPage_subscription_history: (context, state) =>
      AlbumSubscriptionHistoryScreen(),
  RoutePath.myPage_setting: (context, state) => const SettingScreen(),
  RoutePath.myPage_delete_account: (context, state) =>
      const DeleteAccountScreen(),

  /// event
  RoutePath.event: (context, state) => const EventMainScreen(),
  RoutePath.eventList: (context, state) {
    final qp = state.uri.queryParameters;
    final date = qp['date'] ?? '';
    final title = qp['title'] ?? '';
    final image = qp['image'] ?? '';
    return EventListScreen(eventImage: image, date: date, title: title);
  },

  /// store
  RoutePath.store: (context, state) => const StoreMainScreen(),
  RoutePath.store_subs_info: (context, state) {
    final typeParam = state.uri.queryParameters['type'];
    final storeType = StoreType.values.firstWhere(
      (e) => e.name == typeParam,
      orElse: () => StoreType.basic,
    );
    return StoreSubsInfo(storeType: storeType);
  },
  RoutePath.payment_method: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return PaymentMethodScreen(
      subscriptionType: extra?['subscriptionType'],
      albumData: extra?['albumData'],
    );
  },
  RoutePath.payment_complete: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return PaymentCompleteScreen(
      subscriptionType: extra?['subscriptionType'],
      albumData: extra?['albumData'],
      impUid: extra?['impUid'],
      isSuccess: extra?['isSuccess'] ?? false,
    );
  },
  RoutePath.photo_printing: (context, state) => const PhotoPrintingScreen(),
  RoutePath.select_album: (context, state) => const SelectAlbumScreen(),
  RoutePath.select_image: (context, state) {
    final albumId = state.extra as int;
    return SelectImageScreen(albumId: albumId);
  },
  RoutePath.select_option: (context, state) => const SelectOptionScreen(),
  RoutePath.select_address: (context, state) => const SelectAddressScreen(),
  RoutePath.change_address: (context, state) => const ChangeAddressScreen(),
  RoutePath.select_payment: (context, state) => const SelectPaymentScreen(),

  RoutePath.eventDetail: (context, state) {
    final idStr = state.pathParameters['eventId'] ?? '-1';
    final eventId = int.tryParse(idStr) ?? -1;
    final event = state.extra as EventAlbum;
    return EventDetailScreen(event: event);
  },
};

// 앱바 고정 경로 목록 -> 여기 적으면 앱바 고정됨.
final List<String> shellRoutes = [
  RoutePath.home,
  // RoutePath.albumAdd,
  // 필요시 추가
  RoutePath.albumDetail,

  /// myPage
  RoutePath.myPage,

  /// event
  RoutePath.event,
  RoutePath.eventList,

  /// store
  RoutePath.store,
];

// GoRouter
GoRouter createAppRouter(String initialRoute) {
  final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      // 앱바 없는 개별 라우트들
      ...routeBuilders.keys
          .where((path) => !shellRoutes.contains(path))
          .map((path) => GoRoute(path: path, builder: routeBuilders[path]!)),

      // 앱바 고정 ShellRoute
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: shellRoutes.map((path) {
          return GoRoute(path: path, builder: routeBuilders[path]!);
        }).toList(),
      ),
    ],
  );

  // NavigationService에 라우터 등록
  NavigationService.initialize(router);

  return router;
}
