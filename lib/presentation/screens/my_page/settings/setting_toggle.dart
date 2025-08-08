import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 설정 토글
class SettingToggle extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final TextStyle? textStyle;

  const SettingToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.textStyle,
  });

  @override
  State<SettingToggle> createState() => _SettingToggleState();
}

class _SettingToggleState extends State<SettingToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
          style:
              widget.textStyle ??
              AppFont.size16.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
        Transform.scale(
          scale: 0.78,
          child: CupertinoSwitch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeTrackColor: AppColor.mainRed,
            inactiveTrackColor: AppColor.subLightGrey,
          ),
        ),
      ],
    );
  }
}
