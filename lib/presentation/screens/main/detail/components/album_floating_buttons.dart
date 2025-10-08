import 'package:cherrypic/data/album/services/album_images_upload_service.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/album_action_sheet.dart';
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
            // ... (사진 추가, 탭 전환 버튼 코드는 변경 없음) ...
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
            if (!isSelectionMode && tabIndex != 1)
              Positioned(
                right: 45,
                bottom: 24 + bottomSafe,
                child: _AddPhotoButton(onTap: () => _handleAddPhoto(context)),
              ),
            if (isSelectionMode)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: SafeArea(
                  top: false,
                  child: Center(
                    // [수정] Builder로 감싸서 barContext를 가져옵니다.
                    child: Builder(
                      builder: (barContext) {
                        return SelectingBar(
                          count: selectedCount,
                          onMore: () => _openMoreMenu(context, barContext),
                          onCancel: () {
                            final vm = context.read<AlbumDetailViewModel>();
                            vm.exitSelectionMode();
                          },
                        );
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
    // ... (이 함수는 변경 없음) ...
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

  // [수정] 위치 계산 로직을 barContext 기준으로 변경
  void _openMoreMenu(BuildContext context, BuildContext barContext) {
    final viewModel = context.read<AlbumDetailViewModel>();
    final RenderBox renderBox = barContext.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(25),
      builder: (dialogContext) {
        return Stack(
          children: [
            Positioned(
              left: position.dx + (size.width / 2) - (130 / 2),
              top: position.dy - 180 - 40,
              child: ChangeNotifierProvider.value(
                value: viewModel,
                // [수정] AlbumActionSheet에 각 기능에 맞는 함수를 전달합니다.
                child: AlbumActionSheet(
                  onShare: () => viewModel.shareSelectedImages(context),
                  onDelete: () => viewModel.deleteSelectedImages(),
                  onDownload: () => viewModel.downloadSelectedImages(context),
                  onAiSort: () {
                    // TODO: AI 정리 기능 구현
                    debugPrint('AI 정리 탭');
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  // ... (이 위젯은 변경 없음) ...
  final VoidCallback onTap;
  const _AddPhotoButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        child: Image.asset('assets/images/add_img.png', fit: BoxFit.contain),
      ),
    );
  }
}
