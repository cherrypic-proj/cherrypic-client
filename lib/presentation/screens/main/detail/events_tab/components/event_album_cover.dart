import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/font.dart';

class EventAlbumCover extends StatelessWidget {
  final EventAlbum album;
  final VoidCallback? onTap;

  // 생성자에 onTap 추가
  const EventAlbumCover({super.key, required this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              CachedNetworkImage(
                imageUrl: album.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 240,
                memCacheHeight: 240,
                maxWidthDiskCache: 480,
                maxHeightDiskCache: 480,
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
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              ),

              // 하단 정보 영역
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
