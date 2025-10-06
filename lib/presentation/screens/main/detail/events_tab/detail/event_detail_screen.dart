import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_sort_buttons.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:cherrypic/presentation/screens/main/detail/parts/album_detail_selecting_bar.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:cherrypic/presentation/widgets/album/image_full_screen_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventAlbum event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventDetailViewModel(eventId: event.eventId),
      child: _Body(event: event),
    );
  }
}

class _Body extends StatefulWidget {
  final EventAlbum event;

  const _Body({required this.event});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailViewModel>(
      builder: (context, vm, _) {
        final double bottomSafe = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // 이벤트 헤더
                  SliverToBoxAdapter(child: EventHeader(event: widget.event)),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 정렬 버튼
                  const EventSortButtons(),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // 로딩 상태
                  if (vm.isLoading && vm.groups.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // 빈 상태
                  if (!vm.isLoading && vm.groups.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('이미지가 없습니다')),
                    ),

                  // 이미지 그룹 목록
                  if (vm.groups.isNotEmpty)
                    SliverList.builder(
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
                    ),

                  // 하단 여백 (선택 바 공간 확보)
                  SliverToBoxAdapter(child: SizedBox(height: 120 + bottomSafe)),
                ],
              ),

              // 선택 바 - 선택 모드일 때만 표시
              if (vm.isSelectionMode)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24 + bottomSafe,
                  child: Center(
                    child: SelectingBar(
                      count: vm.selectedCount,
                      onMore: () => _openMoreSheet(context, vm),
                      onCancel: () => vm.exitSelectionMode(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 전체화면 이미지 뷰어 열기
  void _openFullScreen(
    BuildContext context,
    EventDetailViewModel vm,
    int groupIndex,
    int imageIndex,
  ) {
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

  /// 더보기 시트 열기
  void _openMoreSheet(BuildContext context, EventDetailViewModel vm) {
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('삭제'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 구현
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
