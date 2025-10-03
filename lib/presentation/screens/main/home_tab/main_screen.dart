import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/ad_banner_placeholder.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/album_section.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/components/album_option_menu.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MainViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showAlbumOptions(BuildContext context) async {
    final result = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: AlbumOptionMenu(
              onDismiss: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );

    // 앨범 추가 성공 시 (result == true) 새로고침
    if (result == true) {
      _viewModel.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
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
              // 검색창
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
                        suffixIcon: Icon(
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
            width: 85,
            height: 45,
            child: TextButton(
              onPressed: () => _showAlbumOptions(context),
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
                    '앨범',
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
