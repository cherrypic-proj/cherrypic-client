import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/color.dart';
import '../../../../../../../core/constants/font.dart';
import 'image_list_view_model.dart';

class ImageListScreen extends StatelessWidget {
  const ImageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageListViewModel>();

    return ListView.builder(
      itemCount: viewModel.photoGroups.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final group = viewModel.photoGroups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.date,
              style: AppFont.size18.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final itemSize = (screenWidth) / 3;

                return Wrap(
                  children: group.imageUrls.map((url) {
                    final isSelected = viewModel.isSelected(url);
                    return GestureDetector(
                      onTap: () => viewModel.toggleImageSelection(url),
                      child: Stack(
                        children: [
                          Image.network(
                            url,
                            width: itemSize,
                            height: itemSize,
                            fit: BoxFit.cover,
                          ),
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.mainRed,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          if (isSelected)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: CircleAvatar(
                                backgroundColor: AppColor.mainRed,
                                radius: 12,
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 60),
          ],
        );
      },
    );
  }
}