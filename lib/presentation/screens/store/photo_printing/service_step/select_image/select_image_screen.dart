import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/font.dart';
import '../../../../../../core/router/route_path.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_sub_app_bar.dart';
import 'image/image_list_view_model.dart';

class SelectImageScreen extends StatefulWidget {
  final int albumId;
  const SelectImageScreen({super.key, required this.albumId});

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  bool isChecked = true;
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageListViewModel(albumId: widget.albumId),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
        body: Stack(
          children: [
            /// 스크롤 가능한 영역
            Consumer<ImageListViewModel>(
              builder: (context, viewModel, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 46),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/circle_two.png',
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '인화할 사진을 선택하세요.',
                              style: AppFont.size18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 53.5),

                      /// 날짜별 이미지 그룹 리스트
                      ListView.builder(
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
                                  final itemSize = (screenWidth) / 3; // 3열

                                  return Wrap(
                                    children: group.imageUrls.map((url) {
                                      final isSelected = viewModel.isSelected(url);
                                      return GestureDetector(
                                        onTap: () {
                                          viewModel.toggleImageSelection(url);
                                        },
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              url,
                                              width: itemSize,
                                              height: itemSize,
                                              fit: BoxFit.cover,
                                            ),

                                            /// 테두리
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

                                            /// 선택 시 체크 아이콘
                                            if (isSelected)
                                              Positioned(
                                                top: 6,
                                                right: 6,
                                                child: CircleAvatar(
                                                  backgroundColor: AppColor.mainRed,
                                                  radius: 12,
                                                  child: Icon(
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
                      ),

                      const SizedBox(height: 150), // 버튼과 겹치지 않도록 여유 공간
                    ],
                  ),
                );
              },
            ),

            /// 선택 수 배너 + 고정 버튼
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 선택 수 배너
                  Consumer<ImageListViewModel>(
                    builder: (context, viewModel, _) {
                      final count = viewModel.selectedImages.length;
                      if (count == 0) return const SizedBox.shrink();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColor.mainLightRed,
                          border: Border.all(color: AppColor.mainRed, width: 1.5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$count장 선택됨',
                          style: AppFont.size14.copyWith(
                            color: AppColor.mainRed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),

                  /// 고정 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 126, left: 30, right: 30),
                    child: GestureDetector(
                      onTapDown: (_) {
                        if (isChecked) setState(() => _buttonPressed = true);
                      },
                      onTapUp: (_) {
                        if (isChecked) setState(() => _buttonPressed = false);
                      },
                      onTapCancel: () {
                        if (isChecked) setState(() => _buttonPressed = false);
                      },
                      child: CustomButton(
                        variant: isChecked
                            ? (_buttonPressed
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlinedStatic)
                            : AppButtonVariant.disabled,
                        text: '다음',
                        onPressed: isChecked
                            ? () {
                          context.push(RoutePath.select_option);
                        }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}