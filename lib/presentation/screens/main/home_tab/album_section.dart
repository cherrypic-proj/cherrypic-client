import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_card.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class AlbumSection extends StatefulWidget {
  const AlbumSection({super.key});

  @override
  State<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  late final List<String> titles;
  late final List<AlbumBadgeType> badges;
  late List<bool> likedList;

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
            spacing: 20,
            runSpacing: 35,
            children: List.generate(titles.length, (index) {
              return SizedBox(
                width: 150,
                child: AlbumCard(
                  imageUrl: '',
                  title: titles[index],
                  badgeType: badges[index],
                  isLiked: likedList[index],
                  onTap: () {
                    debugPrint('${titles[index]} 탭');
                  },
                  onLikeToggle: () {
                    setState(() {
                      likedList[index] = !likedList[index];
                    });
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
