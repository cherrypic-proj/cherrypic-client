import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_card.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class AlbumCardTestScreen extends StatefulWidget {
  const AlbumCardTestScreen({super.key});

  @override
  State<AlbumCardTestScreen> createState() => _AlbumCardTestScreenState();
}

class _AlbumCardTestScreenState extends State<AlbumCardTestScreen> {
  final List<bool> likedList = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlbumCard 예시')),
      body: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(4, (index) {
            final titles = [
              '일반 앨범',
              'Basic 앨범 두줄로 바뀌면 이렇게 된다.',
              'Pro 앨범',
              '체리픽 프리미엄 앨범 두 줄 이상일 경우에는 이렇게 된다.',
            ];
            final badges = [
              AlbumBadgeType.none,
              AlbumBadgeType.basic,
              AlbumBadgeType.pro,
              AlbumBadgeType.premium,
            ];

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
    );
  }
}
