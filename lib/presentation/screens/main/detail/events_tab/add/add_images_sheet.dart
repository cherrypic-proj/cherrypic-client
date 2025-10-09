import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/%20create/create_event_sort_buttons.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/add/add_images_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddImagesSheet extends StatelessWidget {
  final int albumId;
  final int eventId;

  const AddImagesSheet({
    super.key,
    required this.albumId,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // [수정] AddImagesViewModel을 주입합니다.
      create: (_) => AddImagesViewModel(albumId: albumId, eventId: eventId),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _SheetContent(scrollController: scrollController),
          );
        },
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  final ScrollController scrollController;
  const _SheetContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddImagesViewModel>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (vm.isLoading && vm.groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null && vm.groups.isEmpty) {
      return Center(
        child: Text('이미지를 불러올 수 없습니다: ${vm.error}', style: AppFont.size16),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: EdgeInsets.only(
                bottom: bottomPadding + (vm.isAnythingSelected ? 120 : 20),
              ),
              children: [
                const SizedBox(height: 20),
                // [수정] 헤더 텍스트 변경
                _buildHeader(context),
                const SizedBox(height: 24),
                // [제거] 커버 및 제목 입력 섹션 제거

                // --- 사진 목록 섹션 ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '사진 추가',
                    style: AppFont.size18.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const CreateEventSortButtons(), // 정렬 버튼 재사용
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.groups.length,
                  itemBuilder: (context, groupIndex) {
                    final group = vm.groups[groupIndex];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: AlbumGroupSection(
                        date: group.date,
                        isAllSelected: group.isAllSelected,
                        onToggleAll: () => vm.toggleAll(groupIndex),
                        imageUrls: group.images
                            .map((img) => img.imageUrl)
                            .toList(),
                        selectedIndexes: group.selectedIndexes,
                        isSelectionMode: true,
                        onImageTap: (imageIndex) =>
                            vm.togglePhotoSelection(groupIndex, imageIndex),
                        onImageLongPress: (imageIndex) =>
                            vm.togglePhotoSelection(groupIndex, imageIndex),
                      ),
                    );
                  },
                ),
              ],
            ),

            if (vm.isAnythingSelected)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActionBar(context, vm),
              ),

            if (vm.isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.mainRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '이미지 추가', // [수정] 헤더 텍스트
            style: AppFont.size18.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  '이전',
                  style: AppFont.size14.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, AddImagesViewModel vm) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColor.mainLightRed,
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(color: AppColor.mainRed, width: 1),
                ),
                child: Center(
                  child: Text(
                    '${vm.selectedPhotosCount}장 선택됨',
                    style: AppFont.size14.copyWith(
                      color: AppColor.mainRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              // [수정] ViewModel의 addImagesToEvent 함수 호출
              final success = await vm.addImagesToEvent();
              if (success && context.mounted) {
                // 성공 시 true를 반환하며 시트를 닫음
                Navigator.pop(context, true);
              } else if (vm.error != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(vm.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              width: 260,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.mainRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '추가하기', // [수정] 버튼 텍스트
                  style: AppFont.size16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
