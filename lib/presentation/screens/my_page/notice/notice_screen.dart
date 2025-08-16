import 'package:cherrypic/presentation/screens/my_page/notice/notice_list.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_sub_app_bar.dart';

/// 공지 사항
class NoticeItem {
  final String date;
  final String title;

  const NoticeItem({required this.date, required this.title});
}

/// 공지 사항 리스트
const List<NoticeItem> noticeItems = [
  NoticeItem(date: '2025.08.04', title: '서비스 점검 안내'),
  NoticeItem(date: '2025.07.20', title: '신규 기능 업데이트'),
  NoticeItem(date: '2025.07.01', title: '이용약관 변경 안내'),
];

/// 공지 사항 페이지
class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  /// 공지 사항 리스트 선택 시 이동 동작(동작 방식 수정 예정)
  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('공지 상세 페이지'))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '공지사항'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                    onTap: () => _navigateToDetail(context),
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
