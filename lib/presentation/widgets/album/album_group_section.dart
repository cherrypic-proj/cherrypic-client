import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumGroupSection extends StatefulWidget {
  final String date;
  final bool isAllSelected;
  final VoidCallback onToggleAll;
  final List<String> imageUrls;
  final Set<int> selectedIndexes;
  final void Function(int index) onImageTap;
  final void Function(int index) onImageLongPress;
  final bool isSelectionMode;

  const AlbumGroupSection({
    super.key,
    required this.date,
    required this.isAllSelected,
    required this.onToggleAll,
    required this.imageUrls,
    required this.selectedIndexes,
    required this.onImageTap,
    required this.onImageLongPress,
    required this.isSelectionMode,
  });

  @override
  State<AlbumGroupSection> createState() => _AlbumGroupSectionState();
}

class _AlbumGroupSectionState extends State<AlbumGroupSection> {
  final GlobalKey _gridKey = GlobalKey();
  bool _isDragging = false;
  final Set<int> _draggedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.date,
                style: AppFont.size18.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: widget.onToggleAll,
                style: TextButton.styleFrom(
                  minimumSize: const Size(74, 22),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: widget.isAllSelected
                      ? AppColor.mainRed
                      : Colors.transparent,
                  side: const BorderSide(color: AppColor.mainRed),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '전체선택',
                      style: AppFont.size12.copyWith(
                        color: widget.isAllSelected
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      widget.isAllSelected
                          ? 'assets/images/check_circle.png'
                          : 'assets/images/uncheck_circle.png',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 선택 모드일 때만 드래그 제스처 활성화
        widget.isSelectionMode
            ? GestureDetector(
                onPanStart: _onDragStart,
                onPanUpdate: _onDragUpdate,
                onPanEnd: _onDragEnd,
                child: _buildGrid(),
              )
            : _buildGrid(),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      key: _gridKey,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1,
      ),
      // 성능 최적화 설정
      cacheExtent: 500, // 화면 밖 500px까지 미리 렌더링
      addAutomaticKeepAlives: true, // 스크롤 시 위젯 상태 유지
      addRepaintBoundaries: true, // 리페인트 최적화

      itemBuilder: (context, index) {
        final imageUrl = widget.imageUrls[index];
        final isSelected = widget.selectedIndexes.contains(index);

        return GestureDetector(
          onTap: () {
            if (!_isDragging) {
              widget.onImageTap(index);
            }
          },
          onLongPress: () {
            if (!_isDragging) {
              widget.onImageLongPress(index);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 이미지 (크기 변화 없음)
              CachedNetworkImage(
                imageUrl: imageUrl,
                memCacheWidth: 400,
                memCacheHeight: 400,
                maxWidthDiskCache: 400,
                maxHeightDiskCache: 400,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 20),
                ),
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 100),
              ),

              // 테두리 오버레이 (선택 시에만)
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.mainRed, width: 2),
                    ),
                  ),
                ),

              // 체크 아이콘
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.mainRed,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onDragStart(DragStartDetails details) {
    if (!widget.isSelectionMode) return;

    setState(() {
      _isDragging = true;
      _draggedIndexes.clear();
    });

    _updateDragSelection(details.localPosition);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.isSelectionMode || !_isDragging) return;

    _updateDragSelection(details.localPosition);
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.isSelectionMode) return;

    setState(() {
      _isDragging = false;
      _draggedIndexes.clear();
    });
  }

  void _updateDragSelection(Offset position) {
    final RenderBox? renderBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // 그리드 내 로컬 좌표
    final localPosition = position;

    // 그리드 크기
    final gridWidth = renderBox.size.width;
    final itemWidth = gridWidth / 3; // crossAxisCount = 3
    final itemHeight = itemWidth; // childAspectRatio = 1

    // 터치한 위치의 행, 열 계산
    final col = (localPosition.dx / itemWidth).floor();
    final row = (localPosition.dy / itemHeight).floor();

    // 범위 체크
    if (col < 0 || col >= 3) return;
    if (row < 0) return;

    final index = row * 3 + col;

    // 이미지 개수 범위 체크
    if (index >= widget.imageUrls.length) return;

    // 이미 드래그로 처리한 항목이면 무시
    if (_draggedIndexes.contains(index)) return;

    // 드래그로 처리한 항목 추가
    _draggedIndexes.add(index);

    // 선택 토글
    widget.onImageTap(index);
  }
}
