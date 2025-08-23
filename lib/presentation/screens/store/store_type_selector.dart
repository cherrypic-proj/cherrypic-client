import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

/// 앨범 타입
enum StoreType { basic, pro, premium }

class StoreTypeSelector extends StatefulWidget {
  final ValueChanged<StoreType> type;

  const StoreTypeSelector({
    super.key,
    required this.type,
  });

  @override
  State<StoreTypeSelector> createState() => _StoreTypeSelectorState();
}

class _StoreTypeSelectorState extends State<StoreTypeSelector> {
  final PageController _pageController = PageController(
    viewportFraction: 1.0,
    initialPage: 0,
  );

  final List<String> selectedImages = const [
    'assets/images/basic_album_unselected.png',
    'assets/images/pro_album_unselected.png',
    'assets/images/premium_album_unselected.png',
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapCard(int index) {
    setState(() {
    });
    widget.type(StoreType.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 화면 크기에 따라 비율에 맞게 크기 조정
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            const horizontalPadding = 30.0;
            final availableWidth = screenWidth - 2 * horizontalPadding;
            final aspectRatio = 333 / 420;
            final calculatedHeight = availableWidth / aspectRatio;

            return SizedBox(
              width: availableWidth,
              height: calculatedHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final String asset = selectedImages[index];

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTapCard(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          asset,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        /// 인디케이터
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final active = i == _currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: 12,
              height: 12,
              alignment: Alignment.center,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 160),
                scale: active ? 1.0 : 0.6,
                child: Container(
                  width: active ? 12 : 8,
                  height: active ? 12 : 8,
                  decoration: BoxDecoration(
                    color: active ? AppColor.mainRed : AppColor.mainLightRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}