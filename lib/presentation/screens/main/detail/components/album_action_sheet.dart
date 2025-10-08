import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/widgets/custom_action_menu.dart'; // 이전에 만든 공통 메뉴 위젯
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumActionSheet extends StatelessWidget {
  const AlbumActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel에 접근
    final vm = context.read<AlbumDetailViewModel>();

    // 메뉴 아이템 리스트 정의
    final List<ActionMenuItem> menuItems = [
      ActionMenuItem(
        title: '공유',
        icon: const Icon(Icons.share_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          // TODO: 공유 기능 구현
        },
      ),
      ActionMenuItem(
        title: '삭제',
        icon: const Icon(Icons.delete_outline, size: 18),
        onTap: () {
          // 1. 바텀 시트를 먼저 닫고
          Navigator.pop(context);
          // 2. ViewModel의 삭제 함수를 호출
          vm.deleteSelectedImages();
        },
      ),
      ActionMenuItem(
        title: '다운로드',
        icon: const Icon(Icons.download_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          // TODO: 다운로드 기능 구현
        },
      ),
      ActionMenuItem(
        title: 'AI 정리',
        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          // TODO: AI 정리 기능 구현
        },
      ),
    ];

    return Padding(
      // SafeArea와 Padding을 주어 화면 하단과 옆면에 여유 공간을 둡니다.
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: CustomActionMenu(items: menuItems),
    );
  }
}
