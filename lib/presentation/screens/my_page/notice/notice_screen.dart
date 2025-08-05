import 'package:cherrypic/presentation/screens/my_page/notice/notice_list.dart';
import 'package:cherrypic/presentation/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../widgets/custom_app_bar.dart';

class NoticeItem {
  final String date;
  final String title;

  NoticeItem({required this.date, required this.title});
}

class NoticeScreen extends StatelessWidget {
  NoticeScreen({super.key});

  final List<NoticeItem> noticeItems = [
    NoticeItem(date: '2025.08.04', title: '서비스 점검 안내'),
    NoticeItem(date: '2025.07.20', title: '신규 기능 업데이트'),
    NoticeItem(date: '2025.07.01', title: '이용약관 변경 안내'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomTabBar(
              title: '공지사항',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView.builder(
                itemCount: noticeItems.length,
                itemBuilder: (context, index) {
                  final item = noticeItems[index];
                  return NoticeList(
                    date: item.date,
                    title: item.title,
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
