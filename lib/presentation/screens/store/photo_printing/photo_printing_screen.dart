import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_path.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';

class PhotoPrintingScreen extends StatelessWidget {
  const PhotoPrintingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 52),

            Center(
              child: Column(
                children: [
                  /// 사진 인화 서비스 이미지
                  Image.asset(
                    'assets/images/printing_banner_image.png',
                    width: 77,
                    height: 100,
                  ),
                  const SizedBox(height: 23.8),

                  /// 서비스 Title
                  Text(
                    '사진 인화 서비스',
                    style: AppFont.size22.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// 서비스 subTitle
                  Text(
                    '서비스 홍보 멘트가 들어갈 자리입니다.',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 75.5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '가격 안내표',
                      style: AppFont.size20.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.48),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '사진',
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.02),
                  /// 화면 크기 별 비율 조정을 위해 AspectRatio 사용
                  AspectRatio(
                    aspectRatio: 330 / 138,
                    child: Image.asset(
                      'assets/images/image_price.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 57.81),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '프레임',
                      style: AppFont.size20.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.02),
                  AspectRatio(
                    aspectRatio: 330 / 162,
                    child: Image.asset(
                      'assets/images/frame_size.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 36),

                  CustomButton(
                    variant: AppButtonVariant.outlinedStatic,
                    text: '인화하러 가기',
                    onPressed: () {
                      context.push(RoutePath.select_album);
                    },
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
