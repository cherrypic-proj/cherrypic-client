import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/edit/event_edit_dialog.dart';

class EventHeader extends StatelessWidget {
  final EventAlbum event;

  const EventHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: CachedNetworkImage(
            imageUrl: event.imageUrl,
            fit: BoxFit.cover,
            memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
            memCacheHeight: (MediaQuery.of(context).size.height).toInt(),
            maxWidthDiskCache: 1200,
            maxHeightDiskCache: 1600,
            placeholder: (context, url) => Container(color: Colors.grey[800]),
            errorWidget: (context, error, stackTrace) =>
                Container(color: Colors.grey[800]),
          ),
        ),
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
                    onTap: () async {
                      // [수정] showModalBottomSheet -> showDialog
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) => EventEditDialog(event: event),
                      );

                      // 만약 수정이 성공적으로 완료되었다면 (true 반환)
                      if (result == true && context.mounted) {
                        // TODO: 헤더 정보(제목, 커버)를 갱신하려면 EventDetailScreen의 구조 변경 필요
                        // 현재는 이미지 목록만 새로고침합니다.
                        context.read<EventDetailViewModel>().loadImages();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이벤트 정보가 수정되었습니다.')),
                        );
                      }
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
