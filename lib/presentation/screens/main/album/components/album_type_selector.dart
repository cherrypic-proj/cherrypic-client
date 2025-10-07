import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

enum AlbumType {
  basic('BASIC', 'Basic 앨범', 0),
  pro('PRO', 'Cherrypic Pro 앨범', 3900),
  premium('PREMIUM', 'CherryPic Premium 앨범', 5900);

  const AlbumType(this.apiValue, this.displayName, this.price);
  final String apiValue;
  final String displayName;
  final int price;
}

class AlbumTypeSelector extends StatefulWidget {
  final ValueChanged<AlbumType?>? onTypeSelected;
  final AlbumType? initialSelectedType;
  final bool enabled;

  const AlbumTypeSelector({
    super.key,
    this.onTypeSelected,
    this.initialSelectedType,
    this.enabled = true,
  });

  @override
  State<AlbumTypeSelector> createState() => _AlbumTypeSelectorState();
}

class _AlbumTypeSelectorState extends State<AlbumTypeSelector> {
  late final PageController _pageController;

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
  void initState() {
    super.initState();

    // 초기 선택 상태 설정
    if (widget.initialSelectedType != null) {
      _selectedIndex = AlbumType.values.indexOf(widget.initialSelectedType!);
      _currentPage = _selectedIndex!;
    }

    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapCard(int index) {
    if (!widget.enabled) return; // 비활성화 상태면 클릭 무시

    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        widget.onTypeSelected?.call(null);
      } else {
        _selectedIndex = index;
        widget.onTypeSelected?.call(AlbumType.values[index]);
      }
    });
  }

  // 외부에서 선택된 타입을 가져올 수 있는 메서드
  AlbumType? getSelectedType() {
    return _selectedIndex != null ? AlbumType.values[_selectedIndex!] : null;
  }

  @override
  Widget build(BuildContext context) {
    const double cardW = 333;
    const double cardH = 420;

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
            physics: widget.enabled
                ? null
                : const NeverScrollableScrollPhysics(), // 비활성화시 스와이프 차단
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
                  onTap: widget.enabled ? () => _onTapCard(index) : null,
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
                          text: AlbumType.values[_selectedIndex!].displayName,
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
                if (widget.enabled) // 비활성화 상태면 취소 버튼 숨김
                  GestureDetector(
                    onTap: () => _onTapCard(_selectedIndex!),
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
