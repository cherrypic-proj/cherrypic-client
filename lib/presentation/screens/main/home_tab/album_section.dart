import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/main/home_tab/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AlbumSection extends StatefulWidget {
  const AlbumSection({super.key});

  @override
  State<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 앨범 데이터 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainViewModel>().loadAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.albums.isEmpty) {
          return _buildEmptyState();
        }

        return _buildAlbumGrid(viewModel.albums);
      },
    );
  }

  // 빈 상태일 때 보여줄 위젯
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 80),
        Center(
          child: Image.asset(
            'assets/images/main_empty.png',
            width: 250,
            height: 250,
          ),
        ),
      ],
    );
  }

  // 앨범이 있을 때 보여줄 그리드
  Widget _buildAlbumGrid(List<Map<String, dynamic>> albums) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // 스크롤이 끝에 도달했을 때 추가 로드
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          final viewModel = context.read<MainViewModel>();
          if (!viewModel.isLoading) {
            viewModel.loadMoreAlbums();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 20,
            runSpacing: 35,
            children: List.generate(albums.length, (index) {
              final album = albums[index];
              return SizedBox(
                width: 150,
                child: AlbumCard(
                  imageUrl: album['imageUrl'] ?? '',
                  title: album['title'],
                  badgeType: album['badgeType'],
                  isLiked: album['isLiked'],
                  onTap: () {
                    final albumId = album['id'].toString();
                    final path = RoutePath.albumDetail.replaceFirst(
                      ':albumId',
                      albumId,
                    );
                    context.push(path);
                  },
                  onLikeToggle: () {
                    context.read<MainViewModel>().toggleAlbumLike(album['id']);
                  },
                  isSelected: true,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
