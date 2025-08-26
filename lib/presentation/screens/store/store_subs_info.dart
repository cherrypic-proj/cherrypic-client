import 'package:cherrypic/presentation/screens/store/components/store_type_selector.dart';
import 'package:cherrypic/presentation/widgets/custom_sub_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_path.dart';
import '../../widgets/custom_button.dart';

class StoreSubsInfo extends StatelessWidget {
  final StoreType storeType;

  const StoreSubsInfo({
    super.key,
    required this.storeType,
  });

  @override
  Widget build(BuildContext context) {
    String imageAsset;

    switch (storeType) {
      case StoreType.basic:
        imageAsset = 'assets/images/basic_album_unselected.png';
        break;
      case StoreType.pro:
        imageAsset = 'assets/images/pro_album_unselected.png';
        break;
      case StoreType.premium:
        imageAsset = 'assets/images/premium_album_unselected.png';
        break;
    }

    return Scaffold(
      appBar: const CustomSubAppBar(title: 'CherryPic 정기 구독'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              /// 화면 크기에 따라 비율에 맞게 크기 조정
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final horizontalPadding = 30.0;
                  final availableWidth = screenWidth - 2 * horizontalPadding;
                  final aspectRatio = 333 / 420;
                  final calculatedHeight = availableWidth / aspectRatio;

                  /// 해당 Type에 따른 이미지
                  return Image.asset(
                    imageAsset,
                    width: availableWidth,
                    height: calculatedHeight,
                    fit: BoxFit.contain,
                  );
                },
              ),

              const SizedBox(height: 37),

              /// 버튼
              CustomButton(
                onPressed: () {
                  if (storeType == StoreType.basic) {
                    /// 앨범 생성하기 페이지로 로직 추가
                  } else {
                    context.push(RoutePath.payment_method);
                  }
                },
                variant: AppButtonVariant.filled,
                type: CustomButtonType.createAlbum,
                text: storeType == StoreType.basic ? '앨범 생성하기' : '구독하기',
              ),
              const SizedBox(height: 40)
            ]
          ),
        ),
      ),
    );
  }
}