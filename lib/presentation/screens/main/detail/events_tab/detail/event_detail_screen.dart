import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/album_action_sheet.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_sort_buttons.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:cherrypic/presentation/screens/main/detail/parts/album_detail_selecting_bar.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
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
              onPressed: () => context.pop(),
            ),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: EventHeader(event: widget.event)),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  const EventSortButtons(),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  if (vm.isLoading && vm.groups.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (!vm.isLoading && vm.groups.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('이미지가 없습니다')),
                    ),
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
                  SliverToBoxAdapter(child: SizedBox(height: 120 + bottomSafe)),
                ],
              ),
              if (!vm.isSelectionMode)
                Positioned(
                  right: 45,
                  bottom: 24 + bottomSafe,
                  child: _AddPhotoButton(onTap: () => _handleAddPhoto(context)),
                ),
              if (vm.isSelectionMode)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24 + bottomSafe,
                  child: Center(
                    child: Builder(
                      builder: (barContext) {
                        return SelectingBar(
                          count: vm.selectedCount,
                          onMore: () => _openMoreMenu(context, vm, barContext),
                          onCancel: () => vm.exitSelectionMode(),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAddPhoto(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사진 추가 기능을 구현해주세요'),
        backgroundColor: Colors.blue,
      ),
    );
  }

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
      final groupImages = vm.groups[i].imageUrls;
      if (i < groupIndex) {
        currentCount += groupImages.length;
      } else if (i == groupIndex) {
        initialIndex = currentCount + imageIndex;
      }
      allImageUrls.addAll(groupImages);
    }
    context.push(
      RoutePath.imageViewer,
      extra: {'imageUrls': allImageUrls, 'initialIndex': initialIndex},
    );
  }

  void _openMoreMenu(
    BuildContext context,
    EventDetailViewModel vm,
    BuildContext barContext,
  ) {
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
              child: AlbumActionSheet(
                onShare: () => vm.shareSelectedImages(context),
                onDelete: () => vm.deleteSelectedImages(context),
                onDownload: () => vm.downloadSelectedImages(context),
                onAiSort: () {
                  // TODO: AI 정리 기능 구현
                },
              ),
            ),
          ],
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
