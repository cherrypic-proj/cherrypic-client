import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';

class AlbumListItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const AlbumListItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppFont.size16.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
