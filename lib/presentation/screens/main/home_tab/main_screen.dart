import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/ad_banner_placeholder.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/album_section.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      // appBar: const CustomAppBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            SizedBox(height: 16),
            AdBannerPlaceholder(),
            Expanded(child: AlbumSection()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: SizedBox(
          width: 120,
          height: 45,
          child: TextButton(
            onPressed: () {
              context.push(RoutePath.albumAdd);
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColor.mainRed,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '앨범추가',
                  style: AppFont.size18.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset('assets/images/plus_bt.png', width: 20, height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
