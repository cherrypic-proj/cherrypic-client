import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';

class EventHeader extends StatelessWidget {
  final EventAlbum event;

  const EventHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 전체 화면 이벤트 커버 이미지 - CachedNetworkImage로 교체
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: CachedNetworkImage(
            imageUrl: event.imageUrl,
            fit: BoxFit.cover,
            // 메모리 캐시 최적화 (화면의 절반 크기)
            memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
            memCacheHeight: (MediaQuery.of(context).size.height).toInt(),
            // 디스크 캐시
            maxWidthDiskCache: 1200,
            maxHeightDiskCache: 1600,
            // 로딩 중
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            // 에러 시
            errorWidget: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        // 그라데이션 오버레이 (하단 텍스트 가독성 향상)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),

        // 하단 텍스트 정보
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    event.title,
                    style: AppFont.size24.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: 이벤트 편집 기능
                    },
                    child: Image.asset(
                      'assets/images/event_name_setting.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${event.photoCount}장',
                style: AppFont.size16.copyWith(
                  color: Colors.white.withAlpha(230),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
