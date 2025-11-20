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
  @override
  void initState() {
    super.initState();
    // 첫 프레임 빌드가 완료된 후, 안전하게 ViewModel의 메소드를 호출합니다.
    // 이렇게 하면 위젯 빌드 중에 상태가 변경되는 것을 방지할 수 있습니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MainViewModel>().loadAlbums(refresh: true);
      }
    });
  }

  void _showAlbumOptions(BuildContext context) async {
    final result = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.5),
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
      // context.read를 사용하여 콜백 내에서 ViewModel의 메소드를 호출합니다.
      context.read<MainViewModel>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.watch를 사용하여 ViewModel의 상태 변화를 감지하고 UI를 다시 빌드합니다.
    // 이 위젯 자체에서 viewModel 변수를 직접 사용하지는 않지만,
    // 상태 변경 시 재빌드를 위해 watch는 필요합니다.
    context.watch<MainViewModel>();

    return Scaffold(
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
            Container(
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
                    // context.read를 사용하여 콜백 내에서 ViewModel의 메소드를 호출합니다.
                    context.read<MainViewModel>().clearSearch();
                  }
                },
                onSubmitted: (value) {
                  // context.read를 사용하여 콜백 내에서 ViewModel의 메소드를 호출합니다.
                  context.read<MainViewModel>().searchAlbums(value);
                },
              ),
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
    );
  }
}

