import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';

class AlbumPermissionToggle extends StatefulWidget {
  final bool showLockSetting;
  const AlbumPermissionToggle({super.key, this.showLockSetting = false});

  @override
  State<AlbumPermissionToggle> createState() => _AlbumPermissionToggleState();
}

class _AlbumPermissionToggleState extends State<AlbumPermissionToggle> {
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 toggle row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '멤버별 권한 부여',
                  style: AppFont.size16.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, size: 16, color: AppColor.mainRed),
              ],
            ),
            Switch(
              value: _isToggled,
              onChanged: (value) {
                setState(() {
                  _isToggled = value;
                });
              },
              activeColor: AppColor.mainRed,
            ),
          ],
        ),
        if (widget.showLockSetting) ...[
          const SizedBox(height: 12),
          const CustomLabeledTextField(
            title: '앨범 잠금 설정',
            hintText: '사용할 비밀번호를 작성해주세요',
          ),
        ],
        const SizedBox(height: 100),
        CustomButton(
          text: '앨범 생성',
          variant: AppButtonVariant.disabled,
          onPressed: () {},
        ),
      ],
    );
  }
}
