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
                onTap: () async {
                  // 앨범 추가 화면으로 이동하고 결과 기다리기
                  final result = await context.push(RoutePath.albumAdd);

                  // context가 여전히 유효한지 확인
                  if (context.mounted) {
                    // 다이얼로그를 닫으면서 결과를 전달
                    Navigator.pop(context, result);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
