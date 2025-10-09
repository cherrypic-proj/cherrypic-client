import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_sub_app_bar.dart';
import 'album_subscription_history_view_model.dart';
import 'album_subscription_history_list.dart';

class AlbumSubscriptionHistoryScreen extends StatelessWidget {
  const AlbumSubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlbumSubscriptionHistoryViewModel()..fetchSubscriptionHistory(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '앨범 가입 이력'),
        backgroundColor: Colors.white,
        body: Consumer<AlbumSubscriptionHistoryViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = viewModel.items;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AlbumSubscriptionHistoryList(
                    date: item.date,
                    title: item.title,
                    iconType: item.iconType,
                    onTap: () {
                      viewModel.selectItem(item);
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