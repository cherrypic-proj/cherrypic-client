import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:provider/provider.dart';
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
              onSettings: () async {
                final headerVm = context.read<AlbumHeaderViewModel>();

                // 원본 DTO가 있을 때만 설정 화면으로 이동
                if (headerVm.originalDto != null) {
                  final path = RoutePath.albumSetting.replaceFirst(
                    ':albumId',
                    data!.albumId.toString(),
                  );

                  final result = await context.push(
                    path,
                    extra: headerVm.originalDto,
                  );

                  // 수정 성공 시 새로고침
                  if (result == true && context.mounted) {
                    await headerVm.loadAlbumDetail();
                  }
                }
              },
            ),
            Stack(
              children: [
                // 커버 이미지
                Container(
                  height: 370,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // 로딩 중 배경색
                  ),
                  child: data!.coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: data!.coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          // 메모리 캐시 최적화
                          memCacheWidth: 800,
                          memCacheHeight: 800,
                          // 디스크 캐시
                          maxWidthDiskCache: 1200,
                          maxHeightDiskCache: 1200,
                          // 로딩 중 표시
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          // 에러 시 표시
                          errorWidget: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  right: 5,
                  child: CustomGaugeBar(
                    usedGB: data!.capacityUsed,
                    totalGB: data!.totalCapacity,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: Consumer<AlbumHeaderViewModel>(
                      builder: (context, vm, _) {
                        return CustomAlbumBadge(
                          albumId: data!.albumId, // 추가
                          userName: data!.hostName,
                          memberCountText: data!.numOfParticipants.toString(),
                          showBadgeType: true,
                          showAddMemberButton: true,
                          members: vm.participants,
                        );
                      },
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
      case 'PREMIUM':
        return AlbumBadgeType.premium;
      default:
        return AlbumBadgeType.basic;
    }
  }
}
