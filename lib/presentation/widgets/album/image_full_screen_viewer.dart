import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageFullScreenViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageFullScreenViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<ImageFullScreenViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showUI = true; // UI 표시 여부 (하단 버튼, 상단 바)

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showUI ? Colors.white : Colors.black,
      body: Stack(
        children: [
          // 이미지 갤러리
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
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: _showUI ? Colors.white : Colors.black,
              ),
            ),
          ),

          // 상단 바 (닫기 버튼 + 카운터)
          if (_showUI)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
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

          // 하단 버튼 3개 (공유, 이벤트 추가, 삭제)
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: '공유',
                        onTap: () {
                          // TODO: 공유 기능 구현
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.add_circle_outline,
                        label: '이벤트 추가',
                        onTap: () {
                          // TODO: 이벤트 추가 기능 구현
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.delete_outline,
                        label: '삭제',
                        onTap: () {
                          // TODO: 삭제 기능 구현
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
