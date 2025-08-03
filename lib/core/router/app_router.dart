import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_path.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.home,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: RoutePath.albumAdd,
      builder: (context, state) => const AlbumAddScreen(),
    ),
  ],
);
