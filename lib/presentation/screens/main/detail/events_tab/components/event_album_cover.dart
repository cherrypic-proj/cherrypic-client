import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/font.dart';

class EventAlbumCover extends StatelessWidget {
  final EventAlbum album;
  final VoidCallback? onTap;
  // [추가] 선택 모드를 위한 파라미터
  final bool isSelectable; // 선택 가능한 상태인지 여부
  final bool isSelected; // 현재 이 앨범이 선택되었는지 여부

  const EventAlbumCover({
    super.key,
    required this.album,
    this.onTap,
    this.isSelectable = false, // 기본값은 false (보기 모드)
    this.isSelected = false, // 기본값은 false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // --- 배경 이미지 (기존과 동일) ---
              CachedNetworkImage(
                imageUrl: album.imageUrl,
                fit: BoxFit.cover,
                // ... (기존 placeholder, errorWidget 코드는 생략) ...
              ),

              // --- 하단 정보 영역 (기존과 동일) ---
              Positioned(
                bottom: 3,
                left: 3,
                right: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                      color: Colors.black.withAlpha(45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            album.title,
                            style: AppFont.size18.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${album.photoCount}장',
                            style: AppFont.size14.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- [추가] 선택 모드 UI ---
              // isSelectable이 true일 때만 보이는 UI 요소들
              if (isSelectable)
                Container(
                  // isSelected가 true이면 핑크색 테두리 표시
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.mainRed.withOpacity(0.3)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColor.mainRed : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.mainRed,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
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
