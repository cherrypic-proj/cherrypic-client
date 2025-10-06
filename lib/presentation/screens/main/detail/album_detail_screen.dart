import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'album_detail_view_model.dart';
import 'components/album_sort_buttons.dart';
import 'components/album_content_list.dart';
import 'components/album_floating_buttons.dart';
import 'components/album_upload_overlay.dart';

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
        ChangeNotifierProvider(
          create: (_) => EventTabViewModel(albumId: albumId),
        ),
      ],
      child: _Body(albumId: albumId), // albumId 전달
    );
  }
}

class _Body extends StatefulWidget {
  final int albumId; // albumId 추가

  const _Body({required this.albumId}); // 생성자 수정

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
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

              // 정렬 버튼 (전체 탭일 때만)
              if (_tabIndex == 0) const AlbumSortButtons(),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // 탭별 본문
              AlbumContentList(
                tabIndex: _tabIndex,
                albumId: widget.albumId,
              ), // 수정
            ],
          ),

          // 하단 플로팅 버튼들
          AlbumFloatingButtons(
            tabIndex: _tabIndex,
            onTabChanged: (index) => setState(() => _tabIndex = index),
          ),

          // 업로드 로딩 오버레이 (이벤트 탭일 때는 숨김)
          if (_tabIndex != 1) const AlbumUploadOverlay(),
        ],
      ),
    );
  }
}
