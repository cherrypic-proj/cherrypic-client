import 'package:cherrypic/core/router/route_path.dart';
// import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart'; // 👈 사용하지 않으므로 주석 처리 또는 삭제
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_sort_buttons.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:cherrypic/presentation/screens/main/detail/parts/album_detail_selecting_bar.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
// import 'package:cherrypic/presentation/widgets/album/image_full_screen_viewer.dart'; // 👈 사용하지 않으므로 주석 처리 또는 삭제
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              onPressed: () => context
                  .pop(), // 👈 Navigator.pop(context) 대신 context.pop() 사용
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
              // 하단 우측: 사진 추가 버튼 (선택 모드가 아닐 때만)
              if (!vm.isSelectionMode)
                Positioned(
                  right: 45,
                  bottom: 24 + bottomSafe,
                  child: _AddPhotoButton(onTap: () => _handleAddPhoto(context)),
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

  /// 사진 추가 처리
  Future<void> _handleAddPhoto(BuildContext context) async {
    // TODO: 이벤트에 사진 추가 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사진 추가 기능을 구현해주세요'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// 전체화면 이미지 뷰어 열기
  void _openFullScreen(
    BuildContext context,
    EventDetailViewModel vm, // 👈 1. ViewModel 타입을 EventDetailViewModel로 변경
    int groupIndex,
    int imageIndex,
  ) {
    // 전체 이미지 URL 리스트 생성
    final allImageUrls = <String>[];
    int initialIndex = 0;
    int currentCount = 0;

    for (int i = 0; i < vm.groups.length; i++) {
      // 👇 2. 그룹에서 imageUrls 리스트를 직접 가져오도록 수정
      final groupImages = vm.groups[i].imageUrls;
      if (i < groupIndex) {
        currentCount += groupImages.length;
      } else if (i == groupIndex) {
        initialIndex = currentCount + imageIndex;
      }
      // 👇 3. 이미 imageUrl 리스트이므로 .map() 없이 바로 추가
      allImageUrls.addAll(groupImages);
    }

    // go_router를 사용하여 전체 화면 뷰어 실행
    context.push(
      RoutePath.imageViewer,
      extra: {'imageUrls': allImageUrls, 'initialIndex': initialIndex},
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

/// 사진 추가 버튼 위젯
class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/add_img.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
