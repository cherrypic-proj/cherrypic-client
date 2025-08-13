// lib/presentation/screens/album/components/album_type_selector.dart
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

class AlbumTypeSelector extends StatefulWidget {
  const AlbumTypeSelector({super.key});

  @override
  State<AlbumTypeSelector> createState() => _AlbumTypeSelectorState();
}

class _AlbumTypeSelectorState extends State<AlbumTypeSelector> {
  final PageController _pageController = PageController(
    viewportFraction: 1.0,
    initialPage: 0,
  );

  // 표시 순서: Basic → Pro → Premium
  final List<String> _titles = const [
    'Basic 앨범',
    'Cherrypic Pro 앨범',
    'CherryPic Premium 앨범',
  ];

  final List<String> _unselectedImages = const [
    'assets/images/basic_album_unselected.png',
    'assets/images/pro_album_unselected.png',
    'assets/images/premium_album_unselected.png',
  ];
  final List<String> _selectedImages = const [
    'assets/images/basic_album_selected.png',
    'assets/images/pro_album_selected.png',
    'assets/images/premium_album_selected.png',
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
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '앨범 유형',
            style: AppFont.size18.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: cardW,
          height: cardH,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final bool isSelected = _selectedIndex == index;
              final String asset = isSelected
                  ? _selectedImages[index]
                  : _unselectedImages[index];

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

        // 인디케이터
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
                    color: active ? AppColor.mainRed : Colors.black26,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        if (_selectedIndex != null)
          Container(
            width: 333,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColor.mainLightRed,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.mainRed, width: 1),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '선택) ',
                          style: AppFont.size14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.mainRed,
                          ),
                        ),
                        TextSpan(
                          text: _titles[_selectedIndex!],
                          style: AppFont.size14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = null),
                  child: Text(
                    '취소',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColor.mainRed,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
