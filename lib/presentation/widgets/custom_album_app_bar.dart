import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class CustomAlbumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImagePath;
  final AlbumBadgeType badgeType;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  const CustomAlbumAppBar({
    super.key,
    required this.title,
    this.profileImagePath,
    this.badgeType = AlbumBadgeType.none,
    this.onBack,
    this.onSettings,
  });

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    final bool showBadge = badgeType != AlbumBadgeType.none;
    final double sideWidth = showBadge ? 120 : 56;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 54,

      leadingWidth: sideWidth,
      leading: SizedBox(
        width: sideWidth,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 24,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 40),
            ),
            if (showBadge) _buildBadge(),
          ],
        ),
      ),

      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppFont.size18.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),

      actions: [
        SizedBox(
          width: sideWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (profileImagePath != null) ...[
                _ProfileThumb(path: profileImagePath!),
                const SizedBox(width: 8),
              ],
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: onSettings,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                constraints: const BoxConstraints(minWidth: 40),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: badgeType.backgroundColor,
        border: Border.all(color: badgeType.borderColor, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: badgeType.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          badgeType.shortLabel,
          style: AppFont.size10.copyWith(
            fontWeight: FontWeight.w600,
            color: badgeType.textColor,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _ProfileThumb extends StatelessWidget {
  const _ProfileThumb({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');
    final image = isNetwork
        ? Image.network(path, width: 24, height: 24, fit: BoxFit.cover)
        : Image.asset(path, width: 24, height: 24, fit: BoxFit.cover);

    return ClipRRect(borderRadius: BorderRadius.circular(6), child: image);
  }
}
