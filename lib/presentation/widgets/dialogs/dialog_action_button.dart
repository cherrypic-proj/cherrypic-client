import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class DialogActionButton extends StatelessWidget {
  final String text;
  final bool isConfirm;
  final VoidCallback onPressed;

  const DialogActionButton({
    super.key,
    required this.text,
    required this.isConfirm,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConfirm ? AppColor.mainRed : Colors.white,
          foregroundColor: isConfirm ? Colors.white : AppColor.mainRed,
          side: isConfirm
              ? BorderSide.none
              : const BorderSide(color: AppColor.mainRed, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppFont.size16.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
