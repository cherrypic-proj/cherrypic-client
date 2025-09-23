import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_card.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';
import 'package:go_router/go_router.dart';

class AlbumSection extends StatefulWidget {
  const AlbumSection({super.key});

  @override
  State<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  // API 연결 전까지 빈 리스트로 설정
  final List<Map<String, dynamic>> albums = [];

  // TODO: API 연결 시 실제 데이터로 대체할 예정
  // final List<Map<String, dynamic>> albums = [
  //   {
  //     'id': 1,
  //     'title': '가족여행',
  //     'badgeType': AlbumBadgeType.basic,
  //     'isLiked': false,
  //   },
  //   // ... 더 많은 앨범 데이터
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: albums.isEmpty ? _buildEmptyState() : _buildAlbumGrid(),
    );
  }

  // 빈 상태일 때 보여줄 위젯
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 80), // 위쪽 여백 추가
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
  Widget _buildAlbumGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          spacing: 20, // 가로 아이템 간의 간격
          runSpacing: 35, // 세로 아이템 간의 간격
          children: List.generate(albums.length, (index) {
            final album = albums[index];
            return SizedBox(
              width: 150,
              child: AlbumCard(
                imageUrl: '', // TODO: 실제 앨범 커버 이미지 URL로 변경
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
                  setState(() {
                    album['isLiked'] = !album['isLiked'];
                  });
                },
                isSelected: true,
              ),
            );
          }),
        ),
      ),
    );
  }
}
