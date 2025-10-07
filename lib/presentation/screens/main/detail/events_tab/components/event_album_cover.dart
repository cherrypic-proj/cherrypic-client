import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart'; // 추가
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/font.dart';

class EventAlbumCover extends StatelessWidget {
  final EventAlbum album;

  const EventAlbumCover({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          RoutePath.eventDetail.replaceAll(
            ':eventId',
            album.eventId.toString(),
          ),
          extra: album,
        );
      },
      child: SizedBox(
        width: 120,
        height: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지 - CachedNetworkImage로 교체
              CachedNetworkImage(
                imageUrl: album.imageUrl,
                fit: BoxFit.cover,
                // 메모리 캐시 최적화 (이벤트 커버는 작은 사이즈)
                memCacheWidth: 240,
                memCacheHeight: 240,
                // 디스크 캐시
                maxWidthDiskCache: 480,
                maxHeightDiskCache: 480,
                // 로딩 중
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // 에러 시
                errorWidget: (context, url, error) {
                  return Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              ),

              Positioned(
                bottom: 3,
                left: 3,
                right: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                      color: Colors.black.withAlpha(45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            album.title,
                            style: AppFont.size18.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${album.photoCount}장',
                            style: AppFont.size14.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
