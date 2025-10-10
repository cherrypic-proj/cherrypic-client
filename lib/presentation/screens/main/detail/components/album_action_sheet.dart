import 'package:cherrypic/presentation/widgets/custom_action_menu.dart';
import 'package:flutter/material.dart';

class AlbumActionSheet extends StatelessWidget {
  final VoidCallback onShare;
  //   onDelete는 이제 '삭제 버튼을 눌렀을 때의 동작' 전체를 담당합니다.
  final VoidCallback onDelete;
  final VoidCallback onDownload;
  final VoidCallback onAiSort;

  const AlbumActionSheet({
    super.key,
    required this.onShare,
    required this.onDelete,
    required this.onDownload,
    required this.onAiSort,
  });

  @override
  Widget build(BuildContext context) {
    final List<ActionMenuItem> menuItems = [
      // ... (공유, 다운로드, AI 정리 메뉴는 동일) ...
      ActionMenuItem(
        title: '공유',
        icon: const Icon(Icons.share_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          onShare();
        },
      ),
      ActionMenuItem(
        title: '삭제',
        icon: const Icon(Icons.delete_outline, size: 18),
        onTap: () {
          Navigator.pop(context); // 메뉴 닫기
          onDelete(); //   외부에서 주입받은 onDelete 함수를 그대로 호출
        },
      ),
      ActionMenuItem(
        title: '다운로드',
        icon: const Icon(Icons.download_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          onDownload();
        },
      ),
      ActionMenuItem(
        title: 'AI 정리',
        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          onAiSort();
        },
      ),
    ];

    return CustomActionMenu(items: menuItems);
  }
}
