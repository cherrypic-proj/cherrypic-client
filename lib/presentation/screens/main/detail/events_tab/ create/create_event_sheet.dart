import 'package:cherrypic/presentation/screens/main/detail/events_tab/%20create/create_event_sort_buttons.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'create_event_view_model.dart';

class CreateEventSheet extends StatelessWidget {
  final int albumId;

  const CreateEventSheet({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateEventViewModel(albumId: albumId),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9, // 초기 사이즈를 조금 늘려 더 많은 사진이 보이도록 함
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
    final vm = context.watch<CreateEventViewModel>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // 로딩 중일 때 UI
    if (vm.isLoading && vm.groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러 발생 시 UI
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
            // --- 메인 스크롤 영역 ---
            ListView(
              controller: scrollController,
              padding: EdgeInsets.only(
                // 선택된 항목이 있을 때 하단 액션바에 가려지지 않도록 패딩 추가
                bottom: bottomPadding + (vm.isAnythingSelected ? 120 : 20),
              ),
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildCoverSection(context, vm),
                const SizedBox(height: 30),

                // --- 사진 목록 섹션 (완전히 새로 구성) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '사진 추가',
                    style: AppFont.size18.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const CreateEventSortButtons(), //   정렬 버튼 위젯
                const SizedBox(height: 10),

                //   날짜별 그룹 리스트
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
                        // 이벤트 생성 시에는 항상 선택모드
                        isSelectionMode: true,
                        onImageTap: (imageIndex) =>
                            vm.togglePhotoSelection(groupIndex, imageIndex),
                        // 롱프레스도 일반 탭과 동일하게 토글 기능으로 연결
                        onImageLongPress: (imageIndex) =>
                            vm.togglePhotoSelection(groupIndex, imageIndex),
                      ),
                    );
                  },
                ),
              ],
            ),

            // --- 하단 액션바 ---
            if (vm.isAnythingSelected)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActionBar(context, vm),
              ),

            // --- 업로드 중 오버레이 ---
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

  // --- 기존 위젯 빌더 함수들 (변경 없음) ---

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
            '새 이벤트 생성',
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

  Widget _buildCoverSection(BuildContext context, CreateEventViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              image: vm.coverImage != null
                  ? DecorationImage(
                      image: FileImage(vm.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: vm.coverImage == null
                ? Icon(
                    Icons.photo_library_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: 175,
                  height: 40,
                  child: TextField(
                    controller: vm.titleController,
                    style: AppFont.size14,
                    decoration: InputDecoration(
                      hintText: '이벤트 제목',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColor.mainRed,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: vm.isUploading
                      ? null
                      : () => vm.pickCoverImage(context),
                  child: Container(
                    width: 115,
                    height: 30,
                    decoration: BoxDecoration(
                      color: vm.isUploading ? Colors.grey : AppColor.mainRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        vm.isUploading ? '업로드 중...' : '커버사진 업로드',
                        style: AppFont.size14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CreateEventViewModel vm) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      //   배경색과 그림자 제거
      color: Colors.transparent, // 배경을 투명하게 설정
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
              final success = await vm.createEvent();
              if (success && context.mounted) {
                Navigator.pop(context, true); // true 반환하여 새로고침 트리거
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
                  '이벤트 생성',
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
