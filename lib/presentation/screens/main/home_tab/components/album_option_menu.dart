import 'package:flutter/material.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/components/album_option_button.dart';
import 'package:go_router/go_router.dart';

class AlbumOptionMenu extends StatelessWidget {
  final VoidCallback onDismiss;

  const AlbumOptionMenu({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 24,
          bottom: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 앨범 관리 버튼
              AlbumOptionButton(
                text: '앨범 관리',
                iconPath: 'assets/images/subtitles_gear.png',
                onTap: () {
                  onDismiss();
                  // TODO: 앨범 관리 화면으로 이동
                  // context.push(RoutePath.albumManagement);
                },
              ),
              const SizedBox(height: 15),
              // 앨범 추가 버튼
              AlbumOptionButton(
                text: '앨범 추가',
                iconPath: 'assets/images/add_img.png',
                onTap: () {
                  onDismiss();
                  context.push(RoutePath.albumAdd);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
