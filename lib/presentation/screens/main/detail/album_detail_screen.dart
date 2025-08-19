import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
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
        ChangeNotifierProvider(create: (_) => AlbumDetailViewModel()),
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
    final headerVm = context.watch<AlbumHeaderViewModel>();
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 상단 헤더
              SliverSafeArea(
                top: true,
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: MainAlbumHeader(data: headerVm.header),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 탭 별 본문
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
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ColoredBox(color: Colors.white),
                ),

              // 하단 고정 버튼들과 겹침 방지
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
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

          // 하단 우측: 사진 추가 버튼(선택 중이면 숨김)
          Selector<AlbumDetailViewModel, bool>(
            selector: (_, vm) => vm.isSelecting,
            builder: (context, isSelecting, _) {
              if (isSelecting) return const SizedBox.shrink();
              return Positioned(
                right: 45,
                bottom: 24 + bottomSafe,
                child: _AddPhotoButton(
                  onTap: () {
                    // TODO: 사진 추가 기능 연결
                  },
                ),
              );
            },
          ),

          // 선택 바: 선택 중일 때만 노출
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
        ],
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
