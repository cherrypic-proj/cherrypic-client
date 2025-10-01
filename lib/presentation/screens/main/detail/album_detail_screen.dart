import 'package:cherrypic/data/album/services/album_image_upload_service.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/%20create/create_event_sheet.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_album_cover.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_tab_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'album_detail_view_model.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
part 'parts/album_detail_segmented.dart';
part 'parts/album_detail_selecting_bar.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;
  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlbumHeaderViewModel(albumId)),
        ChangeNotifierProvider(
          create: (_) => AlbumDetailViewModel(albumId: albumId),
        ),
        ChangeNotifierProvider(create: (_) => EventTabViewModel()),
      ],
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  // 0=전체, 1=이벤트
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 상단 헤더 - Consumer로 감싸서 상태 변화 감지
              SliverSafeArea(
                top: true,
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: Consumer<AlbumHeaderViewModel>(
                    builder: (context, headerVm, _) {
                      return MainAlbumHeader(
                        data: headerVm.header,
                        isLoading: headerVm.isLoading,
                        error: headerVm.error,
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 탭별 본문
              if (_tabIndex == 0)
                Consumer<AlbumDetailViewModel>(
                  builder: (context, vm, _) {
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
                            onImageTap: (imgIdx) =>
                                vm.toggleImage(index, imgIdx),
                          ),
                        );
                      },
                    );
                  },
                )
              else
                Consumer<EventTabViewModel>(
                  builder: (context, vm, _) {
                    return SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _buildCreateEventButton(),
                        const SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
            ],
          ),

          // 하단 좌측: 전체/이벤트 토글
          Selector<AlbumDetailViewModel, bool>(
            selector: (_, vm) => vm.isSelecting,
            builder: (context, isSelecting, _) {
              if (isSelecting) return const SizedBox.shrink();
              return Positioned(
                bottom: 24 + bottomSafe,
                left: 0,
                right: 0,
                child: Center(
                  child: _FloatingSegmented(
                    value: _tabIndex,
                    onChanged: (i) => setState(() => _tabIndex = i),
                  ),
                ),
              );
            },
          ),

          // 하단 우측: 사진 추가 버튼
          Selector<AlbumDetailViewModel, bool>(
            selector: (_, vm) => vm.isSelecting,
            builder: (context, isSelecting, _) {
              if (isSelecting) return const SizedBox.shrink();
              return Positioned(
                right: 45,
                bottom: 24 + bottomSafe,
                child: _AddPhotoButton(
                  onTap: () async {
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
                  },
                ),
              );
            },
          ),

          // 선택 바
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Selector<AlbumDetailViewModel, int>(
                selector: (_, vm) => vm.selectedCount,
                builder: (context, count, _) {
                  if (count == 0) return const SizedBox.shrink();
                  return Center(
                    child: _SelectingBar(
                      count: count,
                      onMore: () => _openMoreSheet(context),
                    ),
                  );
                },
              ),
            ),
          ),

          // 업로드 로딩 오버레이 (맨 마지막)
          Consumer<AlbumDetailViewModel>(
            builder: (context, vm, _) {
              if (!vm.isUploading) return const SizedBox.shrink();

              return Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Card(
                      margin: const EdgeInsets.all(40),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              vm.uploadProgress,
                              style: AppFont.size16,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateEventButton() {
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

// 간단한 액션 시트
void _openMoreSheet(BuildContext context) {
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
