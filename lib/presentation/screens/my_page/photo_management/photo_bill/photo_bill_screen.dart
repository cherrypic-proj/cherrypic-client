import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';
import 'package:cherrypic/presentation/widgets/custom_sub_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'photo_bill_view_model.dart';

class PhotoBillScreen extends StatelessWidget {
  const PhotoBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhotoBillViewModel(),
      child: Scaffold(
        appBar: CustomSubAppBar(title: '실물사진 결제 내역'),
        body: Consumer<PhotoBillViewModel>(
          builder: (context, viewModel, _) {
            final albums = viewModel.albums;

            return ListView.builder(
              padding: const EdgeInsets.all(30),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final item = albums[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration: BoxDecoration(
                    color: item.badgeType.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppFont.size14.copyWith(
                          fontWeight: FontWeight.w500,
                          color: item.badgeType.textColor
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              '앨범 생성일',
                              style: AppFont.size12.copyWith(
                                fontWeight: FontWeight.w500,
                                color: item.badgeType.textColor
                              ),
                            ),
                          ),
                          Text(
                            item.date,
                            style: AppFont.size12.copyWith(
                              fontWeight: FontWeight.w500,
                              color: item.badgeType.textColor
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}