import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/color.dart';
import '../../core/constants/font.dart';

/// CustomAppBar 고정이 아닌 화면의 AppBar
class CustomSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomSubAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  Widget _buildCustomDivider(double thickness) {
    return Divider(
      color: AppColor.subSlicer,
      thickness: thickness,
      height: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 30),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            title,
            style: AppFont.size20.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _buildCustomDivider(1),
      ],
    );
  }
}