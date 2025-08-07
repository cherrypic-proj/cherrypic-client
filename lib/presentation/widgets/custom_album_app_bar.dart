import 'package:flutter/material.dart';

class CustomAlbumHeader extends StatelessWidget {
  final String title;
  final String profileImagePath;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSettingsPressed;

  const CustomAlbumHeader({
    super.key,
    required this.title,
    required this.profileImagePath,
    this.onBackPressed,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 76),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              profileImagePath,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: onSettingsPressed,
          ),
        ],
      ),
    );
  }
}