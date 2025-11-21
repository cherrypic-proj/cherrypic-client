import 'package:cherrypic/presentation/screens/main/home_tab/main_view_model.dart';
import 'package:cherrypic/presentation/screens/main/mini_add_menu.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/route_path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          icon: const Icon(Icons.menu, color: AppColor.mainRed),
          iconSize: 40,
          onPressed: () => showMiniAddMenu(context),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          final viewModel = Provider.of<MainViewModel?>(context, listen: false);
          viewModel?.refresh();
          context.go(RoutePath.home);
        },
        child: Image.asset('assets/images/CherryPic_logo.png', height: 50),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
            ),
            iconSize: 40,
            onPressed: () {
              context.push(RoutePath.myPage);
            },
          ),
        ),
      ],
    );
  }
}
