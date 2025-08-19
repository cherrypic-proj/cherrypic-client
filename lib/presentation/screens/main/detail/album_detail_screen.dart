import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_models.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;
  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlbumHeaderViewModel(albumId)),
        ChangeNotifierProvider(create: (_) => AlbumDetailViewModel(albumId)),
      ],
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final headerVm = context.watch<AlbumHeaderViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 상단 헤더
          SliverSafeArea(
            top: true,
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: MainAlbumHeader(data: headerVm.header),
            ),
          ),

          // 날짜별 이미지 그룹 리스트
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
                      onImageTap: (imgIdx) => vm.toggleImage(index, imgIdx),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
