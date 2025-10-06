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
        // 전체 화면 이벤트 커버 이미지
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.network(
            event.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
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
                  Expanded(
                    child: Text(
                      event.title,
                      style: AppFont.size24.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: 이벤트 편집 기능
                    },
                    child: const Text('✏️', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${event.photoCount}장',
                style: AppFont.size16.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
