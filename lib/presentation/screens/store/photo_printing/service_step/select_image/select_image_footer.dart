import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../../core/constants/font.dart';
import '../../../../../../core/router/route_path.dart';
import '../../../../../widgets/custom_button.dart';
import 'image/image_list_view_model.dart';

/// 고정 위치 버튼(몇장 선택했는지 알림 창 + 다음 버튼)
class SelectImageFooter extends StatefulWidget {
  const SelectImageFooter({super.key});

  @override
  State<SelectImageFooter> createState() => _SelectImageFooterState();
}

class _SelectImageFooterState extends State<SelectImageFooter> {
  bool isChecked = true;
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageListViewModel>();
    final count = viewModel.selectedImages.length;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 0)
            Container(
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
                    ? () => context.push(RoutePath.select_option)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}