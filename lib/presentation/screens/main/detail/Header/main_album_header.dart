// main_album_header.dart
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';
import 'package:cherrypic/presentation/widgets/custom_album_app_bar.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/components/custom_album_badge.dart';
import 'package:cherrypic/presentation/widgets/custom_gauge_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'album_header_model.dart';

class MainAlbumHeader extends StatelessWidget {
  final AlbumHeaderData? data;
  final bool isLoading;
  final String? error;

  const MainAlbumHeader({
    super.key,
    required this.data,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때
    if (isLoading) {
      return SizedBox(
        height: 450,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 에러가 있을 때
    if (error != null) {
      return SizedBox(
        height: 450,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('앨범 정보를 불러올 수 없습니다', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text(error!, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    // 데이터가 없을 때
    if (data == null) {
      return SizedBox(height: 450, child: Center(child: Text('앨범 정보가 없습니다')));
    }

    // 정상적으로 데이터가 있을 때
    return SizedBox(
      height: 450,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            CustomAlbumAppBar(
              title: data!.title,
              profileImagePath: 'assets/images/albumCover.png',
              badgeType: _getBadgeType(data!.badgeText),
              onSettings: () {
                final path = RoutePath.albumSetting.replaceFirst(
                  ':albumId',
                  data!.albumId.toString(),
                );
                context.push(path);
              },
            ),
            Stack(
              children: [
                Container(
                  height: 370,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: data!.coverUrl.startsWith('http')
                          ? NetworkImage(data!.coverUrl)
                          : AssetImage(data!.coverUrl) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  right: 5,
                  child: CustomGaugeBar(
                    usedGB: data!.capacityUsed.toDouble(),
                    totalGB: data!.totalCapacity.toDouble(),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: CustomAlbumBadge(
                      userName: data!.hostName,
                      memberCountText: data!.numOfParticipants.toString(),
                      showBadgeType: true,
                      showAddMemberButton: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 배지 텍스트를 AlbumBadgeType으로 변환
  AlbumBadgeType _getBadgeType(String badgeText) {
    switch (badgeText.toUpperCase()) {
      case 'PRO':
        return AlbumBadgeType.pro;
      case 'BASIC':
        return AlbumBadgeType.basic;
      default:
        return AlbumBadgeType.basic;
    }
  }
}
