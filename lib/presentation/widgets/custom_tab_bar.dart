import 'package:flutter/material.dart';

import '../../core/constants/font.dart';

class CustomTabBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomTabBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 12, 30, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: AppFont.size20.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
