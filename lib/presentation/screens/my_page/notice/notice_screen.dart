import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import 'notice_list.dart';
import 'notice_view_model.dart';

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
}