import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/ad_banner_placeholder.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/album_section.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const AdBannerPlaceholder(),
              const SizedBox(height: 16),
              // 검색창 추가
              Consumer<MainViewModel>(
                builder: (context, viewModel, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 36.5),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      style: AppFont.size14,
                      decoration: InputDecoration(
                        hintText: '앨범을 검색하세요',
                        hintStyle: AppFont.size14.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          viewModel.clearSearch();
                        }
                      },
                      onSubmitted: (value) {
                        viewModel.searchAlbums(value);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Expanded(child: AlbumSection()),
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
                  Image.asset(
                    'assets/images/plus_bt.png',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
