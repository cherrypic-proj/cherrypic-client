import 'package:cherrypic/core/router/route_path.dart';
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
  late final List<String> titles;
  late final List<AlbumBadgeType> badges;
  late List<bool> likedList;
  final List<Map<String, dynamic>> albums = [
    {
      'id': 1,
      'title': '가족여행',
      'badgeType': AlbumBadgeType.basic,
      'isLiked': false,
    },
    {
      'id': 2,
      'title': '맛집탐방',
      'badgeType': AlbumBadgeType.pro,
      'isLiked': true,
    },
    {
      'id': 3,
      'title': '반려동물',
      'badgeType': AlbumBadgeType.premium,
      'isLiked': false,
    },
    {
      'id': 4,
      'title': '운동기록',
      'badgeType': AlbumBadgeType.basic,
      'isLiked': true,
    },
    {
      'id': 5,
      'title': '데일리룩',
      'badgeType': AlbumBadgeType.pro,
      'isLiked': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // 12개 예시 데이터
    titles = [
      '일반 앨범',
      'Basic 앨범 두줄로 바뀌면 이렇게 된다.',
      'Pro 앨범',
      '체리픽 프리미엄 앨범 두 줄 이상일 경우에는 이렇게 된다.',
      '스냅샷',
      '여행 앨범',
      '추억 보관함',
      '프로젝트 폴더',
      '포토북 기획안',
      '졸업 사진 모음',
      '커플 앨범',
      '웨딩 샘플',
    ];

    badges = [
      AlbumBadgeType.none,
      AlbumBadgeType.basic,
      AlbumBadgeType.pro,
      AlbumBadgeType.premium,
      AlbumBadgeType.none,
      AlbumBadgeType.pro,
      AlbumBadgeType.basic,
      AlbumBadgeType.none,
      AlbumBadgeType.premium,
      AlbumBadgeType.pro,
      AlbumBadgeType.basic,
      AlbumBadgeType.none,
    ];

    likedList = List.generate(titles.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    // [수정] 각 앨범의 고유 ID를 사용하여 경로를 동적으로 생성
                    final albumId = album['id'].toString();
                    final path = RoutePath.albumDetail.replaceFirst(
                      ':albumId',
                      albumId,
                    );
                    context.push(path);
                  },
                  onLikeToggle: () {
                    // 좋아요 상태를 변경
                    setState(() {
                      album['isLiked'] = !album['isLiked'];
                    });
                  },
                  // isSelected는 필요에 따라 사용 (현재는 true로 고정)
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
