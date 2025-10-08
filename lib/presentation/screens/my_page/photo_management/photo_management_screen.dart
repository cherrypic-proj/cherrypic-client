import 'package:cherrypic/presentation/widgets/custom_sub_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'photo_management_view_model.dart';

class PhotoManagementScreen extends StatelessWidget {
  const PhotoManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhotoManagementViewModel(),
      child: Scaffold(
        appBar: CustomSubAppBar(title: '실물사진 관리'),
        body: Consumer<PhotoManagementViewModel>(
          builder: (context, viewModel, _) {
            return ListView.builder(
              itemCount: viewModel.menuItems.length,
              itemBuilder: (context, index) {
                final item = viewModel.menuItems[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => item.onTap(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 30),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}