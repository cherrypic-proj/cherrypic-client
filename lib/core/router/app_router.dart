import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/core/network/navigation_service.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/login/repositories/auth_repository.dart';
import 'package:cherrypic/data/login/services/apple_auth_data_source.dart';
import 'package:cherrypic/data/login/services/auth_remote_data_source.dart';
import 'package:cherrypic/data/login/services/kakao_auth_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// --- [Screens: Auth] ---
import 'package:cherrypic/presentation/screens/login/login_screen.dart';
import 'package:cherrypic/presentation/screens/login/login_view_model.dart';

// --- [Screens: Main & Album] ---
import 'package:cherrypic/presentation/screens/main/home_tab/main_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_view_model.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/image_full_screen_viewer.dart';

// --- [Screens: Event] ---
import 'package:cherrypic/presentation/screens/event/event_main_screen.dart';
import 'package:cherrypic/presentation/screens/event/event_list_detail/event_list_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_screen.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';

// --- [Screens: MyPage] ---
import 'package:cherrypic/presentation/screens/my_page/my_page_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/notice/notice_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_management/album_management_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/album_payment_info_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/info/payment_info_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/album_payment_info_model.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/info/payment_info_view_model.dart';
import 'package:cherrypic/presentation/screens/my_page/photo_management/photo_management_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/photo_management/photo_bill/photo_bill_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/address_management_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/add_address_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/album_subscription_history/album_subscription_history_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/settings/setting_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/delete_account/delete_account_screen.dart';

// --- [Screens: Store & Payment] ---
import 'package:cherrypic/presentation/screens/store/store_main_screen.dart';
import 'package:cherrypic/presentation/screens/store/subscription/store_subs_info.dart';
import 'package:cherrypic/presentation/screens/store/components/store_type_selector.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/payment_method_screen.dart'; // 결제 화면만 유지

// --- [Screens: Photo Printing] ---
import 'package:cherrypic/presentation/screens/store/photo_printing/photo_printing_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_album/select_album_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_image/select_image_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_option/select_option_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/select_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/change_address/change_address_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/select_payment_screen.dart';

// --- [Widgets] ---
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// 앱바 고정 UI Wrapper
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(), body: child);
  }
}

// --- [Route Builders] ---
final Map<String, GoRouterWidgetBuilder> routeBuilders = {
  // --------------------------------------------------------------------------
  // Feature: Authentication
  // --------------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // Feature: Main & Album
  // --------------------------------------------------------------------------
  RoutePath.home: (context, state) => const MainScreen(),
  RoutePath.albumAdd: (context, state) => const AlbumAddScreen(),

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
    final albumData = state.extra as AlbumDetailDto;
    return AlbumEditScreen(albumId: albumId, albumData: albumData);
  },

  RoutePath.imageViewer: (context, state) {
    final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
    final List<String> imageUrls = args['imageUrls'];
    final int initialIndex = args['initialIndex'];
    final List<AlbumImage> allAlbumImages = args['allAlbumImages'];
    final int albumId = args['albumId'];
    final AlbumDetailViewModel viewModel = args['viewModel'];

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: ImageFullScreenViewer(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
        allAlbumImages: allAlbumImages,
        albumId: albumId,
      ),
    );
  },

  // --------------------------------------------------------------------------
  // Feature: Event
  // --------------------------------------------------------------------------
  RoutePath.event: (context, state) => const EventMainScreen(),
  RoutePath.eventList: (context, state) {
    final qp = state.uri.queryParameters;
    final date = qp['date'] ?? '';
    final title = qp['title'] ?? '';
    final image = qp['image'] ?? '';
    return EventListScreen(eventImage: image, date: date, title: title);
  },
  RoutePath.eventDetail: (context, state) {
    // ignore: unused_local_variable
    final idStr = state.pathParameters['eventId'] ?? '-1';
    // ignore: unused_local_variable
    final eventId = int.tryParse(idStr) ?? -1;
    final event = state.extra as EventAlbum;
    return EventDetailScreen(event: event);
  },

  // --------------------------------------------------------------------------
  // Feature: Store & Payment
  // --------------------------------------------------------------------------
  RoutePath.store: (context, state) => const StoreMainScreen(),
  RoutePath.store_subs_info: (context, state) {
    final typeParam = state.uri.queryParameters['type'];
    final storeType = StoreType.values.firstWhere(
      (e) => e.name == typeParam,
      orElse: () => StoreType.basic,
    );
    return StoreSubsInfo(storeType: storeType);
  },

  // [Payment] 결제 수단 선택 화면 (모든 결제 로직이 여기서 수행됨)
  RoutePath.payment_method: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return PaymentMethodScreen(
      subscriptionType: extra?['subscriptionType'],
      albumData: extra?['albumData'],
    );
  },

  // [Photo Printing Service]
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

  // --------------------------------------------------------------------------
  // Feature: MyPage
  // --------------------------------------------------------------------------
  RoutePath.myPage: (context, state) => const MyPageScreen(),
  RoutePath.myPage_notice: (context, state) => const NoticeScreen(),
  RoutePath.myPage_album_management: (context, state) =>
      const AlbumManagementScreen(),
  RoutePath.myPage_album_payment_info: (context, state) =>
      const AlbumPaymentInfoScreen(),
  RoutePath.myPage_payment_info: (context, state) {
    final item = state.extra as AlbumPaymentInfoModel;
    final idStr = state.uri.queryParameters['albumId'] ?? '-1';
    final albumId = int.tryParse(idStr) ?? -1;

    return PaymentInfoScreen(
      item: item,
      viewModel: PaymentInfoViewModel(),
      albumId: albumId,
    );
  },
  RoutePath.myPage_photo_management: (context, state) =>
      const PhotoManagementScreen(),
  RoutePath.myPage_photo_bill: (context, state) => const PhotoBillScreen(),
  RoutePath.myPage_address_management: (context, state) =>
      const AddressManagementScreen(),
  RoutePath.myPage_add_address: (context, state) => const AddAddressScreen(),
  RoutePath.myPage_subscription_history: (context, state) =>
      AlbumSubscriptionHistoryScreen(),
  RoutePath.myPage_setting: (context, state) => const SettingScreen(),
  RoutePath.myPage_delete_account: (context, state) =>
      const DeleteAccountScreen(),
};

// 하단 탭바가 유지되어야 하는 경로들
final List<String> shellRoutes = [
  RoutePath.home,
  RoutePath.albumDetail,
  RoutePath.myPage,
  RoutePath.event,
  RoutePath.eventList,
  RoutePath.store,
];

GoRouter createAppRouter(String initialRoute) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialRoute,
    errorBuilder: (context, state) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    },
    routes: [
      // 1. 탭바가 없는 화면들
      ...routeBuilders.keys
          .where((path) => !shellRoutes.contains(path))
          .map((path) => GoRoute(path: path, builder: routeBuilders[path]!)),

      // 2. 탭바가 있는 화면들 (ShellRoute)
      ShellRoute(
        builder: (context, state, child) {
          return ChangeNotifierProvider(
            create: (_) => MainViewModel(),
            child: ScaffoldWithNavBar(child: child),
          );
        },
        routes: shellRoutes.map((path) {
          return GoRoute(path: path, builder: routeBuilders[path]!);
        }).toList(),
      ),
    ],
  );

  NavigationService.initialize(router);
  return router;
}
