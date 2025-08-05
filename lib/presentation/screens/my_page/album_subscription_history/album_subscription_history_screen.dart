import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_tab_bar.dart';
import 'album_subscription_history_list.dart';

class NoticeItem {
  final String date;
  final String title;
  final NoticeIconType iconType;

  NoticeItem({required this.date, required this.title, required this.iconType,});
}


class AlbumSubscriptionHistoryScreen extends StatelessWidget {
  AlbumSubscriptionHistoryScreen({super.key});

  final List<NoticeItem> noticeItems = [
    NoticeItem(date: '2025.08.04', title: '서비스 점검 안내', iconType: NoticeIconType.subscribeIn),
    NoticeItem(date: '2025.08.04', title: '서비스 점검 안내', iconType: NoticeIconType.subscribeOut),
    NoticeItem(date: '2025.08.04', title: '서비스 점검 안내', iconType: NoticeIconType.subscribeIn),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomTabBar(
            title: '앨범 가입 이력',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView.builder(
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
                          builder: (context) => const Scaffold(
                            body: Center(child: Text('공지 상세 페이지')),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
