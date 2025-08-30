import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/event/event_list_detail/event_list_screen.dart';
import 'package:cherrypic/presentation/screens/event/event_main_screen.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/add_address_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/address_management_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_subscription_history/album_subscription_history_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/delete_account/delete_account_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/my_page_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/notice/notice_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/settings/setting_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/album_payment_info_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/photo_printing_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/change_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_album_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_image_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_option_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment_screen.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment_complete_screen.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment_method_screen.dart';
import 'package:cherrypic/presentation/screens/store/store_main_screen.dart';
import 'package:cherrypic/presentation/screens/store/subscription/store_subs_info.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  /// myPage
  RoutePath.myPage: (context, state) => const MyPageScreen(),
  RoutePath.myPage_notice: (context, state) => const NoticeScreen(),
  RoutePath.myPage_album_payment_info: (context, state) =>
      const AlbumPaymentInfoScreen(),
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
  RoutePath.payment_method: (context, state) => const PaymentMethodScreen(),
  RoutePath.payment_complete: (context, state) => const PaymentCompleteScreen(),

  RoutePath.photo_printing: (context, state) => const PhotoPrintingScreen(),
  RoutePath.select_album: (context, state) => const SelectAlbumScreen(),
  RoutePath.select_image: (context, state) => const SelectImageScreen(),
  RoutePath.select_option: (context, state) => const SelectOptionScreen(),
  RoutePath.select_address: (context, state) => const SelectAddressScreen(),
  RoutePath.change_address: (context, state) => const ChangeAddressScreen(),
  RoutePath.select_payment: (context, state) => const SelectPaymentScreen(),
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
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePath.home,
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
