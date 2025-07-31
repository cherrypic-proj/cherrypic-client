import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class AlbumCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final AlbumBadgeType badgeType;
  final bool isLiked;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLikeToggle;

  const AlbumCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.badgeType,
    required this.isLiked,
    required this.isSelected,
    required this.onTap,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 210,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? badgeType.borderColor : Colors.transparent,
              width: 2,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: badgeType.shadowColor,
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이미지 영역
              SizedBox(
                width: 150,
                height: 160,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 150,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 150,
                              height: 160,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                    // 뱃지
                    if (badgeType != AlbumBadgeType.none)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeType.backgroundColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeType.label,
                            style: AppFont.size10.copyWith(
                              color: badgeType.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // 하트
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: onLikeToggle,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isLiked ? AppColor.mainRed : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 45,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFont.size14.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
