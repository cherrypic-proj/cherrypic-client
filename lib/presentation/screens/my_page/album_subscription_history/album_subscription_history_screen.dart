import 'package:flutter/material.dart';

import '../../../widgets/custom_sub_app_bar.dart';
import 'album_subscription_history_list.dart';

/// 앨범 가입 이력 리스트 Model
class NoticeItem {
  final String date;
  final String title;
  final NoticeIconType iconType;

  NoticeItem({required this.date, required this.title, required this.iconType});
}

class AlbumSubscriptionHistoryScreen extends StatelessWidget {
  AlbumSubscriptionHistoryScreen({super.key});

  /// 앨범 가입 이력 리스트 예시
  final List<NoticeItem> noticeItems = [
    NoticeItem(
      date: '2025.08.04',
      title: '서비스 점검 안내',
      iconType: NoticeIconType.subscribeIn,
    ),
    NoticeItem(
      date: '2025.08.04',
      title: '서비스 점검 안내',
      iconType: NoticeIconType.subscribeOut,
    ),
    NoticeItem(
      date: '2025.08.04',
      title: '서비스 점검 안내',
      iconType: NoticeIconType.subscribeIn,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '앨범 가입 이력'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),

              /// 앨범 가입 이력 리스트 출력
              child: _buildNoticeList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 공지 리스트 위젯
  Widget _buildNoticeList() {
    return ListView.builder(
      itemCount: noticeItems.length,
      itemBuilder: (context, index) {
        final item = noticeItems[index];
        return AlbumSubscriptionHistoryList(
          date: item.date,
          title: item.title,
          iconType: item.iconType,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const Scaffold(body: Center(child: Text('공지 상세 페이지'))),
              ),
            );
          },
        );
      },
    );
  }
}
