import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

/// 메인 이벤트 카드 배너 디자인
class EventCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;

  const EventCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 13.7, 10, 9.04),
            child: Text(
              title,
              style: AppFont.size20.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            imagePath,
            width: 120,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
