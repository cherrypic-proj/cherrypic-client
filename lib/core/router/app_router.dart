import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_screen.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  // 필요시 추가
};

// 앱바 고정 경로 목록 -> 여기 적으면 앱바 고정됨.
final List<String> shellRoutes = [
  RoutePath.home,
  // RoutePath.albumAdd,
  // 필요시 추가
];

// GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePath.home,
  routes: [
    // 앱바 고정 ShellRoute
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: shellRoutes.map((path) {
        return GoRoute(path: path, builder: routeBuilders[path]!);
      }).toList(),
    ),

    // 앱바 없는 개별 라우트들
    ...routeBuilders.keys
        .where((path) => !shellRoutes.contains(path))
        .map((path) => GoRoute(path: path, builder: routeBuilders[path]!)),
  ],
);
