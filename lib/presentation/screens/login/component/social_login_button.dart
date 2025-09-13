import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final Color backgroundColor;
  final Widget image;
  final String text;
  final Color textColor;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.text,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 36,
              child: image,
            ),
            Center(
              child: Text(
                text,
                style: AppFont.size16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}