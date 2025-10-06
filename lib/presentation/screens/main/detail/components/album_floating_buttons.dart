import 'package:cherrypic/data/album/services/album_images_upload_service.dart';
import 'package:cherrypic/presentation/screens/main/detail/parts/album_detail_segmented.dart';
import 'package:cherrypic/presentation/screens/main/detail/parts/album_detail_selecting_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../album_detail_view_model.dart';

class AlbumFloatingButtons extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  const AlbumFloatingButtons({
    super.key,
    required this.tabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return Selector<AlbumDetailViewModel, (bool, int)>(
      selector: (_, vm) => (vm.isSelectionMode, vm.selectedCount),
      builder: (context, data, _) {
        final (isSelectionMode, selectedCount) = data;

        return Stack(
          children: [
            // 하단 좌측: 전체/이벤트 토글
            if (!isSelectionMode)
              Positioned(
                bottom: 24 + bottomSafe,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingSegmented(
                    value: tabIndex,
                    onChanged: onTabChanged,
                  ),
                ),
              ),

            // 하단 우측: 사진 추가 버튼 (이벤트 탭일 때는 숨김)
            if (!isSelectionMode && tabIndex != 1)
              Positioned(
                right: 45,
                bottom: 24 + bottomSafe,
                child: _AddPhotoButton(onTap: () => _handleAddPhoto(context)),
              ),

            // 선택 바 - 선택 모드일 때 항상 표시
            if (isSelectionMode)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: SelectingBar(
                      count: selectedCount,
                      onMore: () => _openMoreSheet(context),
                      onCancel: () {
                        final vm = context.read<AlbumDetailViewModel>();
                        vm.exitSelectionMode();
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _handleAddPhoto(BuildContext context) async {
    final vm = context.read<AlbumDetailViewModel>();
    final uploadService = AlbumImageUploadService();

    final assets = await uploadService.pickImages(context);
    if (assets == null || assets.isEmpty) return;
    if (!context.mounted) return;

    final success = await vm.uploadImages(assets);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${assets.length}장의 사진이 추가되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (vm.uploadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('업로드 실패: ${vm.uploadError}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openMoreSheet(BuildContext context) {
    final vm = context.read<AlbumDetailViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('다운로드'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 구현
                  // 다운로드 완료 후 선택 모드 종료하려면:
                  // vm.exitSelectionMode();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('삭제'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 구현
                  // 삭제 완료 후 선택 모드 종료하려면:
                  // vm.exitSelectionMode();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add_a_photo, color: Colors.black),
    );
  }
}
