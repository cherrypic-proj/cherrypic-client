import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class ButtonTestScreen extends StatelessWidget {
  const ButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('버튼 테스트'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: () {},
              variant: AppButtonVariant.disabled,
              type: CustomButtonType.createAlbum,
            ),
            const SizedBox(height: 16),

            CustomButton(
              onPressed: () {},
              variant: AppButtonVariant.outlined,
              type: CustomButtonType.createAlbum,
            ),
            const SizedBox(height: 16),

            CustomButton(
              type: CustomButtonType.createAlbum,
              onPressed: () {},
            ),

            CustomButton(
              type: CustomButtonType.share,
              onPressed: () {},
              shape: AppButtonShape.squared,
            ),

            CustomButton(
              type: CustomButtonType.download,
              onPressed: () {},
              shape: AppButtonShape.squared,
            ),

            CustomButton(
              type: CustomButtonType.delete,
              onPressed: () {},
              shape: AppButtonShape.squared,
            ),

            CustomButton(
              type: CustomButtonType.ai,
              onPressed: () {},
              shape: AppButtonShape.squared,
            ),

            CustomButton(
              type: CustomButtonType.similarGroup,
              onPressed: () {},
              shape: AppButtonShape.capsule,
            ),

            CustomButton(
              type: CustomButtonType.deleteBlurryImage,
              onPressed: () {},
              shape: AppButtonShape.capsule,
            ),

            CustomButton(
              type: CustomButtonType.deleteClosedEyeImage,
              onPressed: () {},
              shape: AppButtonShape.capsule,
            ),

            CustomButton(
              type: CustomButtonType.exitAlbum,
              onPressed: () {},
              variant: AppButtonVariant.outlined,
              iconPath: 'assets/images/door_open.png',
            ),

            const SizedBox(height: 8),

            CustomButton(
              type: CustomButtonType.unSubscribeAlbum,
              onPressed: () {},
              iconPath: 'assets/images/trash_icon.png',
            ),
          ],
        ),
      ),
    );
  }
}