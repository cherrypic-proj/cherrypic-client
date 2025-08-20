import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

class StoreTypeSelector extends StatefulWidget {
  const StoreTypeSelector({super.key});

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
  int? _selectedIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapCard(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardW = 333;
    final double cardH = 420;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: cardW,
          height: cardH,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final String asset = selectedImages[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onTapCard(index),
                  child: SizedBox(
                    width: cardW,
                    height: cardH,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 333 / 420,
                        child: Image.asset(
                          asset,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        /// 인디케이터
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final active = i == _currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 10,
              height: 10,
              alignment: Alignment.center,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 160),
                scale: active ? 1.0 : 0.6,
                child: Container(
                  width: 10,
                  height: 10,
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
