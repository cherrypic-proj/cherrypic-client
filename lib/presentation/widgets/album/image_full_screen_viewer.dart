import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/album_detail_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/add_to_event_sheet.dart';
import 'package:cherrypic/presentation/widgets/dialogs/photo_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ImageFullScreenViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final List<AlbumImage> allAlbumImages;
  final int albumId;

  const ImageFullScreenViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    required this.allAlbumImages,
    required this.albumId,
  });

  @override
  State<ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<ImageFullScreenViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showUI = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  // ... (dispose, _toggleUI, _getCurrentImageId 함수는 변경 없음) ...
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  int? _getCurrentImageId() {
    if (_currentIndex >= widget.allAlbumImages.length) return null;
    return widget.allAlbumImages[_currentIndex].imageId;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AlbumDetailViewModel>();

    return Scaffold(
      backgroundColor: _showUI ? Colors.white : Colors.black,
      body: Stack(
        children: [
          // ... (이미지 갤러리, 상단 바 UI는 변경 없음) ...
          GestureDetector(
            onTap: _toggleUI,
            child: PhotoViewGallery.builder(
              pageController: _pageController,
              itemCount: widget.imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    widget.imageUrls[index],
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.imageUrls[index],
                  ),
                );
              },
              onPageChanged: (index) => setState(() => _currentIndex = index),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                            (event.expectedTotalBytes ?? 1),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: _showUI ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (_showUI)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_showUI)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: '공유',
                        onTap: () {
                          final currentImageUrl =
                              widget.imageUrls[_currentIndex];
                          vm.shareSingleImage(context, currentImageUrl);
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.add_circle_outline,
                        label: '이벤트 추가',
                        // [수정] '이벤트 추가' 버튼 기능 구현
                        onTap: () {
                          final imageId = _getCurrentImageId();
                          if (imageId == null) return;

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // DraggableScrollableSheet를 위해 필수
                            backgroundColor: Colors.transparent,
                            builder: (_) => AddToEventSheet(
                              albumId: widget.albumId,
                              imageId: imageId,
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.delete_outline,
                        label: '삭제',
                        onTap: () {
                          final imageId = _getCurrentImageId();
                          if (imageId == null) return;

                          showDialog(
                            context: context,
                            builder: (_) => PhotoDeleteDialog(
                              onConfirm: () async {
                                final success = await vm.deleteSingleImage(
                                  imageId,
                                );
                                if (success && context.mounted) {
                                  context.pop();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // ... (이 위젯은 변경 없음) ...
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.mainLightRed),
          color: AppColor.mainLightRed.withAlpha(60),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppFont.size16.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 15, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}
