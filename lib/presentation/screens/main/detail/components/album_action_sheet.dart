import 'package:cherrypic/presentation/widgets/custom_action_menu.dart';
import 'package:cherrypic/presentation/widgets/dialogs/photo_delete_dialog.dart';
import 'package:flutter/material.dart';

class AlbumActionSheet extends StatelessWidget {
  // [추가] 실행할 함수들을 외부에서 전달받기 위한 파라미터
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onDownload;
  final VoidCallback onAiSort; // AI 정리 기능도 콜백으로 변경

  const AlbumActionSheet({
    super.key,
    required this.onShare,
    required this.onDelete,
    required this.onDownload,
    required this.onAiSort,
  });

  @override
  Widget build(BuildContext context) {
    // [삭제] ViewModel을 직접 읽어오던 코드를 제거합니다.
    // final vm = context.read<AlbumDetailViewModel>();

    final List<ActionMenuItem> menuItems = [
      ActionMenuItem(
        title: '공유',
        icon: const Icon(Icons.share_outlined, size: 18),
        onTap: () {
          Navigator.pop(context); // 메뉴 닫기
          onShare(); // 외부에서 전달받은 onShare 함수 실행
        },
      ),
      ActionMenuItem(
        title: '삭제',
        icon: const Icon(Icons.delete_outline, size: 18),
        onTap: () {
          Navigator.pop(context); // 메뉴 닫기
          showDialog(
            context: context,
            // onDelete 콜백을 PhotoDeleteDialog의 onConfirm으로 전달
            builder: (dialogContext) => PhotoDeleteDialog(onConfirm: onDelete),
          );
        },
      ),
      ActionMenuItem(
        title: '다운로드',
        icon: const Icon(Icons.download_outlined, size: 18),
        onTap: () {
          Navigator.pop(context); // 메뉴 닫기
          onDownload(); // 외부에서 전달받은 onDownload 함수 실행
        },
      ),
      ActionMenuItem(
        title: 'AI 정리',
        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
        onTap: () {
          Navigator.pop(context); // 메뉴 닫기
          onAiSort(); // 외부에서 전달받은 onAiSort 함수 실행
        },
      ),
    ];

    return CustomActionMenu(items: menuItems);
  }
}
