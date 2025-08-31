import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_sub_app_bar.dart';

class SelectAlbumScreen extends StatefulWidget {
  const SelectAlbumScreen({super.key});

  @override
  State<SelectAlbumScreen> createState() => _SelectAlbumScreenState();
}

class _SelectAlbumScreenState extends State<SelectAlbumScreen> {
  bool isChecked = true;
  bool _buttonPressed = false;

  int selectedAlbumId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 46),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/circle_one.png',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '인화할 사진이 있는 앨범을 선택하세요.',
                        style: AppFont.size18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 53.5),

                /// 테스트용
                Container(
                  height: 2000,
                  color: Colors.red,
                ),

                const SizedBox(height: 150), // 버튼과 겹치지 않도록 여유 공간
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
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
                    context.push(
                      RoutePath.select_image,
                      extra: selectedAlbumId,
                    );
                  }
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}