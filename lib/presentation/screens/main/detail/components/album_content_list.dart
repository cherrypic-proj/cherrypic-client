import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/%20create/create_event_sheet.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_album_cover.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_tab_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:cherrypic/presentation/widgets/album/image_full_screen_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../album_detail_view_model.dart';

class AlbumContentList extends StatelessWidget {
  final int tabIndex;

  const AlbumContentList({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    if (tabIndex == 0) {
      return _buildAllTab();
    } else {
      return _buildEventsTab(context);
    }
  }

  Widget _buildAllTab() {
    return Consumer<AlbumDetailViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.groups.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.groups.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('이미지가 없습니다')),
          );
        }

        return SliverList.builder(
          itemCount: vm.groups.length,
          itemBuilder: (context, index) {
            final g = vm.groups[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AlbumGroupSection(
                date: g.date,
                isAllSelected: g.isAllSelected,
                onToggleAll: () => vm.toggleAll(index),
                imageUrls: g.imageUrls,
                selectedIndexes: g.selectedIndexes,
                isSelectionMode: vm.isSelectionMode,

                // 짧게 클릭
                onImageTap: (imgIdx) {
                  if (vm.isSelectionMode) {
                    // 선택 모드: 선택/해제
                    vm.toggleImage(index, imgIdx);
                  } else {
                    // 일반 모드: 전체화면
                    _openFullScreen(context, vm, index, imgIdx);
                  }
                },

                // 롱프레스: 선택 모드 진입 + 해당 이미지 선택
                onImageLongPress: (imgIdx) {
                  if (!vm.isSelectionMode) {
                    vm.enterSelectionMode();
                  }
                  vm.toggleImage(index, imgIdx);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// 전체화면 이미지 뷰어 열기
  void _openFullScreen(
    BuildContext context,
    AlbumDetailViewModel vm,
    int groupIndex,
    int imageIndex,
  ) {
    // 전체 이미지 URL 리스트 생성
    final allImageUrls = <String>[];
    int initialIndex = 0;
    int currentCount = 0;

    for (int i = 0; i < vm.groups.length; i++) {
      if (i < groupIndex) {
        currentCount += vm.groups[i].imageUrls.length;
      } else if (i == groupIndex) {
        initialIndex = currentCount + imageIndex;
      }
      allImageUrls.addAll(vm.groups[i].imageUrls);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageFullScreenViewer(
          imageUrls: allImageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildEventsTab(BuildContext context) {
    return Consumer<EventTabViewModel>(
      builder: (context, vm, _) {
        return SliverList(
          delegate: SliverChildListDelegate.fixed([
            _buildCreateEventButton(context),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: vm.albums.length,
                itemBuilder: (context, index) {
                  final album = vm.albums[index];
                  return EventAlbumCover(album: album);
                },
              ),
            ),
            const SizedBox(height: 120),
          ]),
        );
      },
    );
  }

  Widget _buildCreateEventButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (_) => const CreateEventSheet(),
          );
        },
        child: Container(
          width: 125,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.mainRed,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(45),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '새 이벤트 생성',
              style: AppFont.size18.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
