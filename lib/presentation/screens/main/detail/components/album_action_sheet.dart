import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/widgets/custom_action_menu.dart';
import 'package:cherrypic/presentation/widgets/dialogs/photo_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumActionSheet extends StatelessWidget {
  const AlbumActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AlbumDetailViewModel>();

    final List<ActionMenuItem> menuItems = [
      ActionMenuItem(
        title: '공유',
        icon: const Icon(Icons.share_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          // [수정] ViewModel의 공유 메소드 호출
          vm.shareSelectedImages(context);
        },
      ),
      ActionMenuItem(
        title: '삭제',
        icon: const Icon(Icons.delete_outline, size: 18),
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (dialogContext) =>
                PhotoDeleteDialog(onConfirm: () => vm.deleteSelectedImages()),
          );
        },
      ),
      ActionMenuItem(
        title: '다운로드',
        icon: const Icon(Icons.download_outlined, size: 18),
        onTap: () {
          Navigator.pop(context);
          // [수정] ViewModel의 다운로드 메소드 호출
          vm.downloadSelectedImages(context);
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

    return CustomActionMenu(items: menuItems);
  }
}
