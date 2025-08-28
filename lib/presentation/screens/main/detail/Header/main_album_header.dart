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
              // data 모델에서 제목, 뱃지 타입 등을 가져오도록 수정
              title: data.title,
              profileImagePath: 'assets/images/albumCover.png',
              badgeType: AlbumBadgeType.pro,
              // [이 부분 추가] 설정 버튼을 눌렀을 때의 동작 정의
              onSettings: () {
                // 현재 앨범의 ID를 가지고 앨범 설정 페이지로 이동합니다.
                final path = RoutePath.albumSetting.replaceFirst(
                  ':albumId',
                  data.albumId.toString(), // data 모델에서 현재 앨범 ID를 가져옴
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
