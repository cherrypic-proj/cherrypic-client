import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/edit/event_edit_dialog.dart';

class EventHeader extends StatelessWidget {
  final EventAlbum event;
  final Function(EventAlbum) onEventUpdated;

  const EventHeader({
    super.key,
    required this.event,
    required this.onEventUpdated,
  });

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
                      // 1. 반환 타입을 <Object?>로 변경하여 여러 타입을 받을 수 있도록 합니다.
                      final result = await showDialog<Object?>(
                        context: context,
                        builder: (_) => EventEditDialog(event: event),
                        barrierDismissible: false,
                      );

                      if (!context.mounted) return;

                      // 2. 돌아온 결과(result)의 타입에 따라 다른 동작을 수행합니다.
                      if (result is EventAlbum) {
                        // [수정 성공] 결과가 EventAlbum 타입이면, onEventUpdated 콜백을 호출합니다.
                        onEventUpdated(result);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이벤트 정보가 수정되었습니다.')),
                        );
                      } else if (result == 'deleted') {
                        // [삭제 성공] 결과가 'deleted' 문자열이면,
                        // 상세 화면을 닫고 이전 화면(이벤트 목록)으로 돌아가 변경이 있었음을 알립니다.
                        Navigator.pop(context, true);
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
