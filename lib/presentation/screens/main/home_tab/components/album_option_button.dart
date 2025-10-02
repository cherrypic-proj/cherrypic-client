import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class AlbumOptionButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  const AlbumOptionButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 145,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppFont.size14.copyWith(
                color: AppColor.mainRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(iconPath, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
