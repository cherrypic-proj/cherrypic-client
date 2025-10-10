import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:intl/intl.dart';

class AlbumDeleteDialog extends StatelessWidget {
  final AlbumDetailDto albumData;
  final VoidCallback onConfirm;

  const AlbumDeleteDialog({
    super.key,
    required this.albumData,
    required this.onConfirm,
  });

  String _getDeleteDate() {
    final now = DateTime.now();
    final deleteDate = now.add(const Duration(days: 14));
    return DateFormat('yyyy. MM. dd').format(deleteDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 340,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '앨범 삭제 안내',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.mainRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColor.mainRed,
                      size: 20,
                    ),
                  ],
                ),
                IconButton(
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 앨범 커버 미리보기
            _buildAlbumPreview(albumData.coverUrl, albumData.title),
            const SizedBox(height: 12),

            // 방장 및 삭제일 정보
            Text(
              '방장 ${albumData.hostName}',
              style: AppFont.size14.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              '삭제일 ${_getDeleteDate()}',
              style: AppFont.size14.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 24),

            // 안내 문구
            Text.rich(
              TextSpan(
                style: AppFont.size14.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: albumData.hostName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: '님이\n'),
                  TextSpan(
                    text: albumData.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: ' 앨범을\n삭제하려고 합니다.\n중요한 사진은 미리 다운로드 받은 뒤\n앨범에서 나가주세요.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context: context,
                  text: '취소',
                  isConfirm: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                _buildButton(
                  context: context,
                  text: '앨범 나가기',
                  isConfirm: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumPreview(String? coverUrl, String albumName) {
    return Container(
      width: 150,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(35),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // 이미지 부분
          Container(
            width: 160,
            height: 170,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: (coverUrl != null && coverUrl.isNotEmpty)
                  ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey.shade200),
                    )
                  : Container(color: Colors.grey.shade200),
            ),
          ),
          // 텍스트 부분
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Text(
                albumName,
                style: AppFont.size14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required bool isConfirm,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 130,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConfirm ? AppColor.mainRed : Colors.white,
          foregroundColor: isConfirm ? Colors.white : AppColor.mainRed,
          side: isConfirm
              ? BorderSide.none
              : const BorderSide(color: AppColor.mainRed, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppFont.size16.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
