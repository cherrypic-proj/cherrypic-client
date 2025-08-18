import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;
  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlbumHeaderViewModel(albumId),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AlbumHeaderViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            top: true, // 상단 세이프에리어 보호
            bottom: false, // 하단은 필요시 true로
            sliver: SliverToBoxAdapter(child: MainAlbumHeader(data: vm.header)),
          ),
          // TODO: 이후 body 섹션은 여기 아래에 SliverGrid/List로 추가
        ],
      ),
    );
  }
}
