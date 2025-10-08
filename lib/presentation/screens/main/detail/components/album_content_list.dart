import 'package:go_router/go_router.dart';
import 'package:cherrypic/core/router/route_path.dart';

import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/%20create/create_event_sheet.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_album_cover.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_tab_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
// import 'package:cherrypic/presentation/widgets/album/image_full_screen_viewer.dart'; // 사용 안 함
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../album_detail_view_model.dart';

class AlbumContentList extends StatelessWidget {
  final int tabIndex;
  final int albumId;

  const AlbumContentList({
    super.key,
    required this.tabIndex,
    required this.albumId,
  });

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
                imageUrls: g.images.map((img) => img.imageUrl).toList(),
                selectedIndexes: g.selectedIndexes,
                isSelectionMode: vm.isSelectionMode,
                onImageTap: (imgIdx) {
                  if (vm.isSelectionMode) {
                    vm.toggleImage(index, imgIdx);
                  } else {
                    _openFullScreen(context, vm, index, imgIdx);
                  }
                },
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
    // ... (기존 url, index 계산 로직은 동일) ...
    final allImageUrls = <String>[];
    int initialIndex = 0;
    int currentCount = 0;
    final List<AlbumImage> allAlbumImages = [];

    for (int i = 0; i < vm.groups.length; i++) {
      final groupImages = vm.groups[i].images;
      if (i < groupIndex) {
        currentCount += groupImages.length;
      } else if (i == groupIndex) {
        initialIndex = currentCount + imageIndex;
      }
      allImageUrls.addAll(groupImages.map((img) => img.imageUrl));
      allAlbumImages.addAll(groupImages);
    }

    // [수정] context.push의 extra 맵 키를 문자열로 명시하고, 필요한 모든 데이터를 전달합니다.
    context.push(
      RoutePath.imageViewer,
      extra: {
        'imageUrls': allImageUrls,
        'initialIndex': initialIndex,
        'allAlbumImages': allAlbumImages, // 삭제 기능을 위해 전체 이미지 정보 전달
        'albumId': vm.albumId, // 삭제 기능을 위해 앨범 ID 전달
        'viewModel': vm, // 새 화면에서 Provider를 통해 ViewModel을 사용하기 위해 전달
      },
    );
  }

  Widget _buildEventsTab(BuildContext context) {
    return Consumer<EventTabViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.albums.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate.fixed([
            _buildCreateEventButton(context),
            const SizedBox(height: 35),
            if (vm.albums.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: Text('이벤트가 없습니다.\n새 이벤트를 생성해보세요!')),
              )
            else
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
                    return EventAlbumCover(
                      album: album,
                      // [수정] onTap을 async로 바꾸고 결과를 기다립니다.
                      onTap: () async {
                        final result = await context.push<bool>(
                          RoutePath.eventDetail.replaceFirst(
                            ':eventId',
                            album.eventId.toString(),
                          ),
                          extra: album,
                        );

                        // EventDetailScreen에서 업데이트가 있었다고 true를 반환하면,
                        // EventTabViewModel의 refresh를 호출합니다.
                        if (result == true && context.mounted) {
                          context.read<EventTabViewModel>().refresh();
                        }
                      },
                    );
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
        onTap: () async {
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (_) => CreateEventSheet(albumId: albumId),
          );

          // 이벤트 생성 성공 시 목록 새로고침
          if (result == true && context.mounted) {
            context.read<EventTabViewModel>().refresh();
          }
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
