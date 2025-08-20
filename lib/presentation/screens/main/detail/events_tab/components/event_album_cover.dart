import 'dart:ui';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart'; // event_album.dart 경로 확인 필요
import 'package:flutter/material.dart';
import '../../../../../../core/constants/font.dart';

class EventAlbumCover extends StatelessWidget {
  final EventAlbum album;

  const EventAlbumCover({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지
            Image.network(
              album.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                // 에러 시 아이콘 크기 조절
                return const Center(
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
                    // 이미지와 어울리도록 배경색 수정
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
    );
  }
}
