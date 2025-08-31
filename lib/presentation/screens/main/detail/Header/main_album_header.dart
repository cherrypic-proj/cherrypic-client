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
  final AlbumHeaderData data;
  const MainAlbumHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            CustomAlbumAppBar(
              title: data.title,
              profileImagePath: 'assets/images/albumCover.png',
              badgeType: AlbumBadgeType.pro,
              onSettings: () {
                final path = RoutePath.albumSetting.replaceFirst(
                  ':albumId',
                  data.albumId.toString(),
                );
                context.push(path);
              },
            ),
            Stack(
              children: [
                Container(
                  height: 370,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/sample_photo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  right: 5,
                  child: CustomGaugeBar(usedGB: 9, totalGB: 15),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: const CustomAlbumBadge(
                      userName: '홍길동',
                      memberCountText: '6',
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
}
