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
    // 좌/우 너비를 동일하게 맞춰 타이틀을 정확히 중앙에 배치
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
            if (showBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeType.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  // 필요 시 shortLabel로 교체
                  badgeType.shortLabel,
                  style: AppFont.size10.copyWith(
                    color: badgeType.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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

      // 우측 영역도 left와 동일 너비로 고정 → 타이틀 정확한 중앙 보장
      actions: [
        SizedBox(
          width: sideWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (profileImagePath != null) ...[
                _ProfileThumb(path: profileImagePath!), // 24x24로 변경
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
