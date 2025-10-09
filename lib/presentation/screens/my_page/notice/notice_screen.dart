import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import 'notice_list.dart';
import 'notice_view_model.dart';
import 'notice_model.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticeViewModel()..fetchNoticeItems(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '공지사항'),
        backgroundColor: Colors.white,
        body: Consumer<NoticeViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final notices = viewModel.noticeItems;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final item = notices[index];
                  return NoticeList(
                    date: item.date,
                    title: item.title,
                    onTap: () {
                      viewModel.selectNotice(item);
                      _navigateToDetail(context, item);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 공지 상세 페이지 이동
  void _navigateToDetail(BuildContext context, NoticeModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('공지 상세')),
          body: Center(
            child: Text(
              '📢 ${item.title}\n\n게시일: ${item.date}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}