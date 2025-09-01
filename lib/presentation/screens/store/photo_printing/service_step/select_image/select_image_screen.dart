import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_image/image/image_list_screen.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_image/select_image_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/font.dart';
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
                      const ImageListScreen(),

                      const SizedBox(height: 150), /// 버튼과 겹치지 않도록 여유 공간
                    ],
                  ),
                );
              },
            ),

            /// 선택 수 배너 + 고정 버튼
            const SelectImageFooter(),
          ],
        ),
      ),
    );
  }
}