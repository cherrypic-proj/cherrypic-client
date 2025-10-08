import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/widgets/custom_action_menu.dart'; // 이전에 만든 공통 메뉴 위젯
import 'package:cherrypic/presentation/widgets/dialogs/photo_delete_dialog.dart';
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
      // [수정] '삭제' 버튼의 onTap 로직을 변경합니다.
      ActionMenuItem(
        title: '삭제',
        icon: const Icon(Icons.delete_outline, size: 18),
        onTap: () {
          // 1. 현재 떠 있는 액션 시트(메뉴)를 먼저 닫습니다.
          Navigator.pop(context);

          // 2. 중앙에 사진 삭제 확인 다이얼로그를 띄웁니다.
          showDialog(
            context: context,
            builder: (dialogContext) => PhotoDeleteDialog(
              // 3. 사용자가 다이얼로그의 '삭제' 버튼을 누르면
              //    ViewModel의 실제 삭제 함수가 실행되도록 연결합니다.
              onConfirm: () {
                vm.deleteSelectedImages();
              },
            ),
          );
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

    // [수정] 불필요한 Padding을 제거하여 메뉴 UI가 깨끗하게 보이도록 합니다.
    return CustomActionMenu(items: menuItems);
  }
}
