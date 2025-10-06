import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';

class EventHeader extends StatelessWidget {
  final EventAlbum event;

  const EventHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이벤트 커버 이미지
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 제목과 편집 버튼
        Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: AppFont.size24.copyWith(fontWeight: FontWeight.bold),
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

        // 사진 개수
        Text(
          '${event.photoCount}장',
          style: AppFont.size16.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
